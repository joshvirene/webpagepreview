// script.js
window.addEventListener("scroll", () => {
    const sections = document.querySelectorAll(".page-section");
    const navLinks = document.querySelectorAll(".nav-links a");
  
    let current = "";
  
    sections.forEach((section) => {
      const sectionTop = section.offsetTop - 120;
      if (pageYOffset >= sectionTop) {
        current = section.getAttribute("id");
      }
    });
  
    navLinks.forEach((link) => {
      link.classList.remove("active");
      if (link.getAttribute("href") === `#${current}`) {
        link.classList.add("active");
      }
    });
  });
  