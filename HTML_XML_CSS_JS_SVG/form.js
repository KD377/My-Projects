const fileInput = document.getElementById('plik');
const loadButton = document.getElementById('loadButton');
let fileContent = null;
const saveButton = document.getElementById("saveButton");
const addButton = document.querySelector('[name="addButton"]');
const addRunButton = document.getElementById('addRun');
let nazwa = document.getElementById('nazwa');
let imie = document.getElementById('imie');
let wiek = document.getElementById('wiek');
let waga = document.getElementById('waga');
let data = document.getElementById('data');
let sektor = document.getElementById('sektor');
let powierzchnia = document.getElementById('powierzchnia');
let typ = document.getElementById('typ');
let gatunek = document.getElementById('gatunek');
let wybieg = document.getElementById('wybieg');
const deleteAnimalButton = document.getElementById('deleteAnimalButton');
const deleteRunButton = document.getElementById('deleteRunButton');
const modifyAnimalButton = document.getElementById('modifyAnimalButton');
const modifyRunButton = document.getElementById('modifyRunButton');
const warning1 = document.getElementById('warning1');
const warning2 = document.getElementById('warning2');
const warning3 = document.getElementById('warning3');
const warning4 = document.getElementById('warning4');
const warning5 = document.getElementById('warning5');
const warning6 = document.getElementById('warning6');
const warning7 = document.getElementById('warning7');
const warning8 = document.getElementById('warning8');
const runWarning = document.getElementById('runWarning');
const runModifyWarning = document.getElementById('runModifyWarning');
var isLoaded = false;
var isAnimalValid = false;
var isRunValid = false;
var isModifyAnimalValid = false;
var isModifyRunValid = false;

function loadFile() {
    const [file] = fileInput.files;

    const url = URL.createObjectURL(file);
    const resp = new XMLHttpRequest();
    resp.open("GET", url, false);
    resp.setRequestHeader("Content-Type", "text/xml");
    resp.send(null);

    const xmlDoc = resp.responseXML;
    fileContent = xmlDoc;
    addDeleteOptions();
    isLoaded = true;
}

function handleSaveButton() {
    if (fileContent === null) {
        return alert("Nie wczytano pliku XML.");
    }

    const serializer = new XMLSerializer();
    const serializedString = serializer.serializeToString(fileContent);

    const blob = new Blob([serializedString], { type: "text/xml" });
    const link = document.createElement("a");
    link.href = URL.createObjectURL(blob);
    link.download = "zoo.xml";
    link.click();
}

function addDeleteOptions() {
  removeOptions();
  var wybiegi = fileContent.querySelector('wybiegi');
  for(const wybieg of wybiegi.children) {
    var option = document.createElement("option");
    option.text = wybieg.getAttribute('idWybiegu');
    document.getElementById('wybieg').add(option);
  }

  const select = document.getElementById('deleteAnimal');
  var animals = fileContent.querySelector('zwierzeta');
  var i = 1;
  for(const animal of animals.children){
    var option = document.createElement("option");
    option.setAttribute('value',i);
    i++;
    option.text = animal.children[1].textContent + ' '+  animal.getAttribute('idWybiegu');
    select.add(option);
  }

  const select1 = document.getElementById('deleteRun');
  var runs = fileContent.querySelector('wybiegi');
  i = 1;
  for(const run of runs.children){
    var option1 = document.createElement("option");
    option1.setAttribute('value',i);
    i++;
    option1.text = run.getAttribute('idWybiegu');
    select1.add(option1);
  }

  const select2 = document.getElementById('pickAnimal');
  i = 1;
  for(const animal of animals.children){
    var option = document.createElement("option");
    option.setAttribute('value',i);
    i++;
    option.text = animal.children[1].textContent + ' '+  animal.getAttribute('idWybiegu');
    select2.add(option);
  }

  const select3 = document.getElementById('pickRun');
  i = 1;
  for(const run of runs.children){
    var option1 = document.createElement("option");
    option1.setAttribute('value',i);
    i++;
    option1.text = run.getAttribute('idWybiegu');
    select3.add(option1);
  }

  const select4 = document.getElementById('nowyWybieg');
  i = 1;
  for(const run of runs.children){
    var option1 = document.createElement("option");
    option1.setAttribute('value',i);
    i++;
    option1.text = run.getAttribute('idWybiegu');
    select4.add(option1);
  }
  var eOption = document.createElement('option');
  eOption.setAttribute('value','00');
  eOption.setAttribute('selected','selected');
  eOption.text = "don't change";
  select4.add(eOption);

}

function addAnimal() {
  validateAnimal();
  if(isAnimalValid){
    var zwierze = fileContent.createElement("z:zwierze");
    var newNazwa = fileContent.createElement("z:nazwaZwierzecia");
    var newImie = fileContent.createElement("z:imie");
    var newWiek = fileContent.createElement("z:wiek");
    var newWaga = fileContent.createElement("z:waga");
    var newData = fileContent.createElement("z:dataUrodzenia");
    newNazwa.textContent = nazwa.value;
    newImie.textContent = imie.value;
    newWiek.textContent = wiek.value;
    newWaga.textContent = waga.value;
    newWaga.setAttribute("jednostka","kg");
    newData.textContent = data.value.replace("-",".");
    zwierze.appendChild(newNazwa);
    zwierze.appendChild(newImie);
    zwierze.appendChild(newWiek);
    zwierze.appendChild(newWaga);
    zwierze.appendChild(newData);
    zwierze.setAttribute("idG",gatunek.value);
    zwierze.setAttribute("idWybiegu",wybieg.options[wybieg.selectedIndex].text);
    fileContent.querySelector("zwierzeta").appendChild(zwierze);
  }
}

function addRun() {
  validateRun();
  if(isRunValid){
    var newWybieg = fileContent.createElement('z:wybieg');
    var newSektor = fileContent.createElement("z:sektor");
    var newPowierzchnia = fileContent.createElement('z:powierzchnia');
    var newType = fileContent.createElement('z:typ');
    newSektor.textContent = sektor.options[sektor.selectedIndex].text;
    newPowierzchnia.setAttribute("jednostka","m^2");
    newPowierzchnia.textContent = powierzchnia.value;
    newType.textContent = typ.options[typ.selectedIndex].text;
    newWybieg.appendChild(newSektor);
    newWybieg.appendChild(newPowierzchnia);
    newWybieg.appendChild(newType);

    var sum =0;
    var wybiegi = fileContent.querySelector('wybiegi');
    for(const i of wybiegi.children) {
      sum+=1;
    }
    if(sum<10){
      sum+=1;
      newWybieg.setAttribute('idWybiegu',"W0"+ sum);
    }
    else{
      sum+=1;
      newWybieg.setAttribute('idWybiegu',"W"+ sum);
    }

    fileContent.querySelector("wybiegi").appendChild(newWybieg);
  }
}

function deleteAnimal() {
  var id = document.getElementById('deleteAnimal').value;
  var animals = fileContent.querySelector('zwierzeta');
  animals.removeChild(animals.children[id-1]);
  addDeleteOptions();
}

function deleteRun() {
  var id = document.getElementById('deleteRun').value;
  var runs = fileContent.querySelector('wybiegi');
  runs.removeChild(runs.children[id-1]);
  addDeleteOptions();
}

function removeOptions() {
  const select1 = document.getElementById('wybieg');
  const select2 = document.getElementById('deleteAnimal');
  const select3 = document.getElementById('deleteRun');
  const select4 = document.getElementById('pickAnimal');
  const select5 = document.getElementById('pickRun');
  var selects = [select1,select2,select3,select4,select5];
  for(var i=0; i<5;i++){
    while(selects[i].firstChild){
      selects[i].removeChild(selects[i].firstChild);
    }
  }
}

function modifyAnimal() {
  validateModifyAnimal();
  if(isModifyAnimalValid){
    var id = document.getElementById('pickAnimal').value;
    var animal = fileContent.querySelector('zwierzeta').children[id-1];
    var nowaNazwa = document.getElementById('nowaNazwa');
    var noweImie = document.getElementById('noweImie');
    var nowyWiek = document.getElementById('nowyWiek');
    var nowaWaga = document.getElementById('nowaWaga');
    var nowaData = document.getElementById('nowaData');
    var nowyWybieg = document.getElementById('nowyWybieg');
    var nowyGatunek = document.getElementById('nowyGatunek');
    var features = [nowaNazwa,noweImie,nowyWiek,nowaWaga,null,nowaData];
    var i=0;
    nowaData.value
    for(const feature of animal.children){
      if(i!=4){
        if(features[i].value != '00' && features[i].value !=''){
          feature.textContent = features[i].value;
        }
      }
      i++;
    }
    if(nowyWybieg != '00'){
      animal.setAttribute('idWybiegu',nowyWybieg.options[nowyWybieg.selectedIndex].text);
    }
    if(nowyGatunek != '00'){
      animal.setAttribute('idG',nowyGatunek.value);
    }
  }

}

function modifyRun() {
  validateModifyRun();
  if(isModifyRunValid){
    var id = document.getElementById('pickRun').value;
    var run = fileContent.querySelector('wybiegi').children[id-1];
    var nowySektor = document.getElementById('nowySektor');
    var nowaPowierzchnia = document.getElementById('nowaPowierzchnia');
    var nowyTyp = document.getElementById('nowyTyp');

    if(nowySektor.value != '0'){
      run.children[0].textContent = nowySektor.options[nowySektor.selectedIndex].text;
    }
    if(nowaPowierzchnia.value != ''){
      run.children[1].textContent = nowaPowierzchnia.value;
    }
    if(nowyTyp.value != '0'){
      run.children[2].textContent = nowyTyp.options[nowySektor.selectedIndex].text;
    }
  }
}

function validateAnimal() {
  isAnimalValid = true;
    if(!(/^[A-Z]{1}[a-z]{0,19}$/).test(nazwa.value) || nazwa.value ==""){
      warning1.textContent ="nazwa doesnt match [A-Z]{1}[a-z]{0,19} ";
      warning1.style.cssText=  "display: block;width: 100%;background-color: #FF2734;text-align: center;padding-top: 10px;padding-bottom: 10px;margin-bottom: 20px;border-radius: 10px;box-shadow: 2px 2px #000;";
      isAnimalValid= false;
    }
    else{
      warning1.textContent ="";
      warning1.style.cssText="";
    }
    if(!(/^[A-Z]{1}[a-z]{0,14}$/).test(imie.value) || imie.value==''){
      warning2.textContent ="imie doesnt match [A-Z]{1}[a-z]{0,14} ";
      warning2.style.cssText=  "display: block;width: 100%;background-color: #FF2734;text-align: center;padding-top: 10px;padding-bottom: 10px;margin-bottom: 20px;border-radius: 10px;box-shadow: 2px 2px #000;";
      isAnimalValid= false;
    }
    else{
      warning2.textContent ="";
      warning2.style.cssText="";
    }

    if(!(/^[0-9]{1,3}$/).test(wiek.value) || wiek.value==''){
      warning3.textContent ="wiek doesnt match [0-9]{1,3} ";
      warning3.style.cssText=  "display: block;width: 100%;background-color: #FF2734;text-align: center;padding-top: 10px;padding-bottom: 10px;margin-bottom: 20px;border-radius: 10px;box-shadow: 2px 2px #000;";
      isAnimalValid= false;
    }
    else{
      warning3.textContent ="";
      warning3.style.cssText="";
    }

    if(!(/^[0-9]{1,4}$/).test(waga.value) || waga.value ==''){
      warning4.textContent ="waga doesnt match [0-9]{1,4} ";
      warning4.style.cssText=  "display: block;width: 100%;background-color: #FF2734;text-align: center;padding-top: 10px;padding-bottom: 10px;margin-bottom: 20px;border-radius: 10px;box-shadow: 2px 2px #000;";
      isAnimalValid= false;
    }
    else{
      warning4.textContent ="";
      warning4.style.cssText="";
    }
}

function validateRun(){
  isRunValid = true;
  if(powierzchnia.value == "" || !(/^[0-9]{1,4}$/).test(powierzchnia.value)){
    isRunValid = false;
    runWarning.textContent ="powierzchnia doesnt match [0-9]{1,4} or is null ";
    runWarning.style.cssText=  "display: block;width: 100%;background-color: #FF2734;text-align: center;padding-top: 10px;padding-bottom: 10px;margin-bottom: 20px;border-radius: 10px;box-shadow: 2px 2px #000;";
  }
  else{
    runWarning.textContent ="";
    runWarning.style.cssText="";
  }
}

function validateModifyRun(){
  isModifyRunValid = true;
  var nowaPowierzchnia = document.getElementById('nowaPowierzchnia');
  if(nowaPowierzchnia.value != ''){
    if(!(/^[0-9]{1,4}$/).test(nowaPowierzchnia.value)){
      runModifyWarning.textContent ="powierzchnia doesnt match [0-9]{1,4} ";
      runModifyWarning.style.cssText=  "display: block;width: 100%;background-color: #FF2734;text-align: center;padding-top: 10px;padding-bottom: 10px;margin-bottom: 20px;border-radius: 10px;box-shadow: 2px 2px #000;";
      isModifyRunValid= false;
    }
    else{
      runModifyWarning.textContent ="";
      runModifyWarning.style.cssText="";
    }
  }else{
    runModifyWarning.textContent ="";
    runModifyWarning.style.cssText="";
  }
}

function validateModifyAnimal()
{
  var nowaNazwa = document.getElementById('nowaNazwa');
  var noweImie = document.getElementById('noweImie');
  var nowyWiek = document.getElementById('nowyWiek');
  var nowaWaga = document.getElementById('nowaWaga');
  isModifyAnimalValid = true;
  if(nowaNazwa.value != ''){
    if(!(/^[A-Z]{1}[a-z]{0,19}$/).test(nowaNazwa.value)){
      warning5.textContent ="nazwa doesnt match [A-Z]{1}[a-z]{0,19} ";
      warning5.style.cssText=  "display: block;width: 100%;background-color: #FF2734;text-align: center;padding-top: 10px;padding-bottom: 10px;margin-bottom: 20px;border-radius: 10px;box-shadow: 2px 2px #000;";
      isModifyAnimalValid= false;
    }
    else{
      warning5.textContent ="";
      warning5.style.cssText="";
    }
  }else{
    warning5.textContent ="";
    warning5.style.cssText="";
  }
  if(noweImie.value != ''){
    if(!(/^[A-Z]{1}[a-z]{0,14}$/).test(noweImie.value)){
      warning6.textContent ="imie doesnt match [A-Z]{1}[a-z]{0,14} ";
      warning6.style.cssText=  "display: block;width: 100%;background-color: #FF2734;text-align: center;padding-top: 10px;padding-bottom: 10px;margin-bottom: 20px;border-radius: 10px;box-shadow: 2px 2px #000;";
      isModifyAnimalValid= false;
    }
    else{
      warning6.textContent ="";
      warning6.style.cssText="";
    }
  }else{
    warning6.textContent ="";
    warning6.style.cssText="";
  }

  if(nowyWiek.value != ''){
    if(!(/^[0-9]{1,3}$/).test(nowyWiek.value)){
      warning7.textContent ="wiek doesnt match [0-9]{1,3} ";
      warning7.style.cssText=  "display: block;width: 100%;background-color: #FF2734;text-align: center;padding-top: 10px;padding-bottom: 10px;margin-bottom: 20px;border-radius: 10px;box-shadow: 2px 2px #000;";
      isModifyAnimalValid= false;
    }
    else{
      warning7.textContent ="";
      warning7.style.cssText="";
    }
  }else{
    warning7.textContent ="";
    warning7.style.cssText="";
  }

  if(nowaWaga.value != ''){
    if(!(/^[0-9]{1,4}$/).test(nowaWaga.value)){
      warning8.textContent ="waga doesnt match [0-9]{1,4} ";
      warning8.style.cssText=  "display: block;width: 100%;background-color: #FF2734;text-align: center;padding-top: 10px;padding-bottom: 10px;margin-bottom: 20px;border-radius: 10px;box-shadow: 2px 2px #000;";
      isModifyAnimalValid= false;
    }
    else{
      warning8.textContent ="";
      warning8.style.cssText="";
    }
  }else{
    warning8.textContent ="";
    warning8.style.cssText="";
  }

}

document.addEventListener("DOMContentLoaded", () => {
    loadButton.addEventListener("click", loadFile);
    saveButton.addEventListener("click", handleSaveButton);
    addButton.addEventListener('click',addAnimal);
    addButton.addEventListener('click',addDeleteOptions);
    addRunButton.addEventListener('click',addRun);
    addRunButton.addEventListener('click',addDeleteOptions);
    deleteAnimalButton.addEventListener('click',deleteAnimal);
    deleteRunButton.addEventListener('click',deleteRun);
    modifyAnimalButton.addEventListener('click',modifyAnimal);
    modifyRunButton.addEventListener('click',modifyRun);
});
