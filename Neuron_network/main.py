import tensorflow as tf
import pandas as pd
import numpy as np
from pandas import DataFrame

reference_x = []
reference_y = []
measured_x = []
measured_y = []



def load_file(filename):

    input_data = pd.read_excel(filename)
    output = DataFrame()

    output['reference__x'] = input_data['reference__x']
    output['reference__y'] = input_data['reference__y']

    for index, row in input_data.iterrows():
        if row['success'] is False:
            input_data = input_data.drop(index)
            output = output.drop(index)

    input_data_x = input_data.pop('data__coordinates__x')
    input_data_y = input_data.pop('data__coordinates__y')

    input_data = pd.concat([input_data_x, input_data_y], axis=1)

    output.to_excel('output1.xlsx', index=False)
    input_data.to_excel('output2.xlsx', index=False)

    return input_data, DataFrame(output)


def load_training_data(room_number):
    room_files = {
        8: './pomiary/F8/f8_stat_{}.xlsx',
        10: './pomiary/F10/f10_stat_{}.xlsx'
    }
    training_input_data = []
    training_output_data = []

    file_pattern = room_files.get(room_number)
    if file_pattern is None:
        return pd.DataFrame(), pd.DataFrame()

    for index in range(1, 226):
        data = load_file(file_pattern.format(index))
        training_input_data.append(data[0])
        training_output_data.append(data[1])

    training_input_data = pd.concat(training_input_data)
    training_output_data = pd.concat(training_output_data)
    training_input_data.fillna(0, inplace=True)
    training_output_data.fillna(0, inplace=True)

    return training_input_data, training_output_data


def load_testing_data(room_number):
    global reference_x, reference_y, measured_x, measured_y
    room_files = {
        8: './pomiary/F8/f8_{}p.xlsx',
        10: './pomiary/F10/f10_{}p.xlsx'
    }
    testing_input_data = []
    testing_output_data = []

    file_pattern = room_files.get(room_number)
    if file_pattern is None:
        return pd.DataFrame(), pd.DataFrame()

    for index in range(1, 4):
        data = load_file(file_pattern.format(index))
        testing_input_data.append(data[0])
        testing_output_data.append(data[1])

    testing_input_data = pd.concat(testing_input_data)
    measured_x = testing_input_data['data__coordinates__x'].to_list()
    measured_y = testing_input_data['data__coordinates__y'].to_list()
    testing_output_data = pd.concat(testing_output_data)
    reference_x = testing_output_data['reference__x'].to_list()
    reference_y = testing_output_data['reference__y'].to_list()
    return testing_input_data, testing_output_data

def load_prediction_data():
    data = pd.read_excel("./pomiary/F8/f8_random_1p.xlsx")
    input_data_x = data.pop('data__coordinates__x')
    input_data_y = data.pop('data__coordinates__y')
    output_data_x = data.pop('reference__x')
    output_data_y = data.pop('reference__y')
    input_data = pd.concat([input_data_x, input_data_y], axis=1)
    output_data = pd.concat([output_data_x, output_data_y], axis=1)
    return input_data,output_data


def solve(training_input, training_output, testing_input, testing_output, val_data_in, val_data_out):

    training_input_tensor = tf.convert_to_tensor((training_input.astype('float32')) / 10000)
    training_output_tensor = tf.convert_to_tensor((training_output.astype('float32')) / 10000)
    testing_input_tensor = tf.convert_to_tensor((testing_input.astype('float32')) / 10000)
    testing_output_tensor = tf.convert_to_tensor((testing_output.astype('float32')) / 10000)
    predict_in_tensor = tf.convert_to_tensor((val_data_in.astype('float32')) / 10000)
    predict_out_tensor = tf.convert_to_tensor((val_data_out.astype('float32')) / 10000)
    val_in_tensor = tf.convert_to_tensor((load_prediction_data()[0].astype('float32')) / 10000)
    val_out_tensor = tf.convert_to_tensor((load_prediction_data()[1].astype('float32')) / 10000)

    model = tf.keras.models.Sequential()
    model.add(tf.keras.layers.Dense(64, activation='relu'))
    model.add(tf.keras.layers.Dense(32, activation='relu'))
    model.add(tf.keras.layers.Dense(16, activation='relu'))
    model.add(tf.keras.layers.Dense(8, activation='relu'))
    model.add(tf.keras.layers.Dense(2, activation='sigmoid'))

    model.compile(optimizer=tf.keras.optimizers.legacy.Adam(), loss=tf.losses.MeanSquaredError(), metrics=['accuracy'])

    model.fit(training_input_tensor, training_output_tensor, epochs=150, batch_size=512,
                validation_data=(val_in_tensor, val_out_tensor))
    model.evaluate(predict_in_tensor, predict_out_tensor,batch_size=512)
    weights = model.layers[0].get_weights()[0]
    print("Wagi: ")
    print(weights)
    result = model.predict(testing_input_tensor)
    print("\n%%%%%%%%%%%%%%%%%% WYNIK %%%%%%%%%%%%%%%%%%\n")
    print(len(result))
    result = (result * 10000)
    result_df = pd.DataFrame(result, columns=['result_x', 'result_y'])

    result_df.to_excel('corected_coordinates.xlsx', index=False)

    # start
    result_x_array = []
    result_y_array = []
    for x, y in result:
        result_x_array.append(x)
        result_y_array.append(y)
    print(len(result_x_array))
    error_arr_filtered = []
    error_arr_unfiltered = []
    for i in range(len(result_x_array)):
        buff_filtered = (np.sqrt(
            np.power(result_x_array[i] - reference_x[i], 2) + np.power(result_y_array[i] - reference_y[i],
                                                                             2)))
        buff_unfiltered = (np.sqrt(np.power(measured_x[i] - reference_x[i], 2) + np.power(
            measured_y[i] - reference_y[i], 2)))
        error_arr_filtered.append(buff_filtered)
        error_arr_unfiltered.append(buff_unfiltered)
    result1 = DataFrame()
    result1['error_arr_filtered'] = error_arr_filtered
    result1['error_arr_unfiltered'] = error_arr_unfiltered

    result1.to_excel('result.xlsx', index=False)

    print("\n%%%%%%%%%%%%%%%%%% WYNIK %%%%%%%%%%%%%%%%%%\n")
    print(result)
    print(testing_output_tensor)


# Room F8
training_input, training_output = load_training_data(8)
testing_input, testing_output = load_testing_data(8)
row_numbers = int(len(training_input))
train_data_length = int(0.9 * row_numbers)

training_in = training_input[:train_data_length]
training_out = training_output[:train_data_length]
val_data_in = training_input[train_data_length:]
val_data_out = training_output[train_data_length:]

solve(training_in, training_out, testing_input, testing_output, val_data_in, val_data_out)




