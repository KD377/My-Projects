window.addEventListener('scroll',function() {
var navbar = document.getElementById("menubar");
if (window.scrollY > 56) {
  navbar.classList.add("scrolled");
} else {
  navbar.classList.remove("scrolled");
}
});

function scrollTo1(){
  var element = document.getElementById("element1");

// Calculate the target position, taking into account the element's height
  var targetPosition = element.offsetTop - 60;

// Scroll the element into view, with a smooth transition
  window.scrollTo({
    top: targetPosition,
    behavior: "smooth"
});
}

function scrollTo3(){
  var element = document.getElementById("element3");

  var targetPosition = element.offsetTop - 60;

// Scroll the element into view, with a smooth transition
  window.scrollTo({
    top: targetPosition,
    behavior: "smooth"
});
}

function scrollTo4(){
  var element = document.getElementById("element4");

  var targetPosition = element.offsetTop - 60;

// Scroll the element into view, with a smooth transition
  window.scrollTo({
    top: targetPosition,
    behavior: "smooth"
});
}

function scrollTo5(){
  var element = document.getElementById("element5");

  var targetPosition = element.offsetTop - 60;

// Scroll the element into view, with a smooth transition
  window.scrollTo({
    top: targetPosition,
    behavior: "smooth"
});
}

let input = document.getElementById("fileInput");
let textArea = document.getElementById("file-content");

input.addEventListener("change",() => {
  let files = input.files;

  if(files.length == 0) return;

  const file = files[0];

  let reader = new FileReader();

  reader.onload = (e) => {
    const file = e.target.result;
    const lines = file.split(/\r\n|\n/);
    textArea.textContent = lines.join('\n');
    };
    reader.onerror = (e) => alert(e.target.error.name);
    reader.readAsText(file);

});
