/* =========================================================
   〇〇仏壇店  共通スクリプト（外部ライブラリなし）
   ========================================================= */
(function () {
  "use strict";

  var root = document.documentElement;
  var body = document.body;
  var reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  /* ---------- 読み込み時のフェードイン ---------- */
  function showPage() {
    body.classList.remove("is-leaving");
    // 次のフレームで付けないと transition が効かない
    requestAnimationFrame(function () { body.classList.add("is-loaded"); });
  }
  if (document.readyState === "complete") showPage();
  else window.addEventListener("load", showPage);
  // 戻るボタンでキャッシュから復帰したときに白いまま残らないように
  window.addEventListener("pageshow", function (e) { if (e.persisted) showPage(); });
  // フォントや画像が遅い回線でも、最長2秒で必ず表示する
  setTimeout(showPage, 2000);

  /* ---------- ページ遷移：フェードアウトしてから移動 ---------- */
  document.addEventListener("click", function (e) {
    var a = e.target.closest("a");
    if (!a || reduceMotion) return;
    var href = a.getAttribute("href");
    if (!href || href.charAt(0) === "#" || a.target === "_blank" || a.hasAttribute("download")) return;
    if (/^(tel|mailto):/.test(href)) return;
    if (e.metaKey || e.ctrlKey || e.shiftKey || e.button !== 0) return;
    var url = new URL(a.href, location.href);
    if (url.origin !== location.origin && location.protocol !== "file:") return;
    // 同じページ内のアンカーならフェードしない
    if (url.pathname === location.pathname && url.hash) return;

    e.preventDefault();
    closeMenu();
    body.classList.add("is-leaving");
    setTimeout(function () { location.href = a.href; }, 600);
  });

  /* ---------- ハンバーガーメニュー ---------- */
  var menuBtn = document.querySelector(".menu-btn");
  function closeMenu() {
    body.classList.remove("menu-open");
    if (menuBtn) {
      menuBtn.setAttribute("aria-expanded", "false");
      menuBtn.setAttribute("aria-label", "メニューを開く");
    }
  }
  if (menuBtn) {
    menuBtn.addEventListener("click", function () {
      var open = body.classList.toggle("menu-open");
      menuBtn.setAttribute("aria-expanded", String(open));
      menuBtn.setAttribute("aria-label", open ? "メニューを閉じる" : "メニューを開く");
    });
    document.addEventListener("keydown", function (e) { if (e.key === "Escape") closeMenu(); });
  }

  /* ---------- スクロールで固定ヘッダー・ページトップを表示 ---------- */
  var header = document.querySelector(".header");
  var toTop = document.querySelector(".to-top");
  var isTop = body.classList.contains("is-home");
  function onScroll() {
    var y = window.scrollY;
    if (header && isTop) header.classList.toggle("is-show", y > 500);
    if (toTop) toTop.classList.toggle("is-show", y > 600);
  }
  window.addEventListener("scroll", onScroll, { passive: true });
  onScroll();

  /* ---------- 要素が画面に入ったらふわっと表示 ---------- */
  var fades = document.querySelectorAll(".fade-up");
  if ("IntersectionObserver" in window && !reduceMotion) {
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (en) {
        if (en.isIntersecting) {
          en.target.classList.add("is-in");
          io.unobserve(en.target);
        }
      });
    }, { rootMargin: "0px 0px -12% 0px" });
    fades.forEach(function (el) { io.observe(el); });
  } else {
    fades.forEach(function (el) { el.classList.add("is-in"); });
  }

  /* ---------- メインビジュアルのスライド（クロスフェード＋ズーム） ---------- */
  var slides = document.querySelectorAll(".mv__slide");
  var bars = document.querySelectorAll(".mv__bar span");
  if (slides.length) {
    var interval = 6000;
    var current = 0;
    root.style.setProperty("--slide-ms", interval + "ms");
    function show(i) {
      slides.forEach(function (s, n) {
        s.classList.toggle("is-show", n === i);
        // 表示中の1枚だけゆっくり拡大させ、前の1枚はフェード後に戻す
        if (n === i) s.classList.add("is-zoom");
        else setTimeout(function () { if (!s.classList.contains("is-show")) s.classList.remove("is-zoom"); }, 2000);
      });
      bars.forEach(function (b, n) {
        b.classList.remove("is-active");
        if (n === i) { void b.offsetWidth; b.classList.add("is-active"); }
      });
    }
    show(0);
    if (!reduceMotion && slides.length > 1) {
      setInterval(function () {
        current = (current + 1) % slides.length;
        show(current);
      }, interval);
    }
  }

  /* ---------- お問い合わせフォーム（見本：送信はしない） ---------- */
  var form = document.querySelector(".js-demo-form");
  if (form) {
    form.addEventListener("submit", function (e) {
      e.preventDefault();
      alert("見本のフォームのため、送信は行われません。\n公開時に送信先を設定してください。");
    });
  }
})();
