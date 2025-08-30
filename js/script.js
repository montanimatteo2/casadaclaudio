document.addEventListener('DOMContentLoaded', () => {
    const langButtons = {
        it: document.getElementById('lang-it'),
        en: document.getElementById('lang-en'),
    };

    let currentLang = localStorage.getItem('lang') || 'it';
    let translations = {};

    async function loadTranslations(lang) {
        try {
            const response = await fetch(`lang/${lang}.json`);
            if (!response.ok) throw new Error('Network response was not ok');
            translations = await response.json();
            updateContent();
        } catch (error) {
            console.error('Failed to load translations:', error);
        }
    }

    function updateContent() {
        document.querySelectorAll('[data-lang-key]').forEach(element => {
            const key = element.getAttribute('data-lang-key');
            if (translations[key]) {
                if (element.tagName === 'META' || element.tagName === 'TITLE') {
                    element.content = translations[key];
                    if (element.tagName === 'TITLE') document.title = translations[key];
                } else if (element.hasAttribute('aria-label')) {
                     element.setAttribute('aria-label', translations[key]);
                }
                else {
                    element.innerHTML = translations[key];
                }
            }
        });
        document.documentElement.lang = currentLang;
        updateActiveButton();
    }
    
    function updateActiveButton() {
        Object.values(langButtons).forEach(btn => btn.classList.remove('active'));
        if(langButtons[currentLang]) {
            langButtons[currentLang].classList.add('active');
        }
    }

    function setLanguage(lang) {
        currentLang = lang;
        localStorage.setItem('lang', lang);
        loadTranslations(lang);
    }

    Object.entries(langButtons).forEach(([lang, button]) => {
        button.addEventListener('click', () => setLanguage(lang));
    });

    async function setupCarousel() {
        const carouselInner = document.querySelector('.carousel-inner');
        if (!carouselInner) return;

        try {
            const response = await fetch('gallery.json');
            if (!response.ok) throw new Error('Failed to load gallery data');
            const galleryData = await response.json();
            
            if (galleryData.images.length === 0) return;

            carouselInner.innerHTML = galleryData.images.map(src => `
                <div class="carousel-item">
                    <a href="${src}">
                        <img src="${src}" alt="Foto della camera">
                    </a>
                </div>
            `).join('');
            
            const items = document.querySelectorAll('.carousel-item');
            const prevButton = document.querySelector('.carousel-control.prev');
            const nextButton = document.querySelector('.carousel-control.next');
            let currentIndex = 0;

            function updateCarousel() {
                const offset = -currentIndex * 100;
                carouselInner.style.transform = `translateX(${offset}%)`;
            }

            nextButton.addEventListener('click', () => {
                currentIndex = (currentIndex + 1) % items.length;
                updateCarousel();
            });

            prevButton.addEventListener('click', () => {
                currentIndex = (currentIndex - 1 + items.length) % items.length;
                updateCarousel();
            });
            
            updateCarousel();
            new SimpleLightbox('.carousel-inner a');

        } catch (error) {
            console.error('Could not setup carousel:', error);
            carouselInner.innerHTML = '<p>Impossibile caricare le immagini.</p>';
        }
    }

    // ESECUZIONE
    loadTranslations(currentLang);
    setupCarousel();
});