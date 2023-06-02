/**
 * MIT License
 * Copyright (c) 2022 Krzysztof Deka & Jakub Olejniczak
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

package pl.comp.model;

import java.util.List;
import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;


public abstract class SudokuVerify implements Cloneable {
    private List<SudokuField> table;

    public SudokuVerify(List<SudokuField> table) {
        this.table = table;
    }


    public int getTableValue(int x) {
        return table.get(x).getFieldValue();
    }

    public boolean verify() {
        for (int i = 0; i < 9; i++) {
            for (int j = i + 1; j < 9; j++) {
                if (table.get(i).getFieldValue() == table.get(j).getFieldValue()) {
                    return false;
                }
            }
        }
        return true;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }

        if (o == null || getClass() != o.getClass()) {
            return false;
        }

        SudokuVerify that = (SudokuVerify) o;

        return new EqualsBuilder().append(table, that.table).isEquals();
    }

    @Override
    public int hashCode() {
        return new HashCodeBuilder(17, 37).append(table).toHashCode();
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this)
                .append("table", table)
                .toString();
    }

    @Override
    public SudokuVerify clone() {
        try {
            SudokuVerify clone = (SudokuVerify) super.clone();
            int i = 0;
            for (SudokuField obj: table) {
                clone.table.set(i,obj.clone());
                i++;
            }
            return clone;
        } catch (CloneNotSupportedException e) {
            throw new AssertionError();
        }
    }
}
