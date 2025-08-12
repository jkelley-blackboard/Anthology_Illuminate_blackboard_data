// jeff.kelley@anthology.com  2025-08-12
// assisted by AI tools
// no support or warranty
// this code will create tool tip popups with the value of the 
// data-analytics-id or analytics-id tags

javascript:(function () {

    function highlightTags(doc) {
        // Create tooltip
        const tooltip = doc.createElement('div');
        tooltip.style.position = 'fixed';
        tooltip.style.background = 'lightgreen';
        tooltip.style.color = 'black';
        tooltip.style.padding = '6px 10px';
        tooltip.style.borderRadius = '4px';
        tooltip.style.fontSize = '12px';
        tooltip.style.pointerEvents = 'none';
        tooltip.style.zIndex = '9999';
        tooltip.style.display = 'none';
        doc.body.appendChild(tooltip);

        // Find and highlight elements
        doc.querySelectorAll('[data-analytics-id],[analytics-id]').forEach(el => {
            el.style.outline = '2px dashed lightgreen';

            el.addEventListener('mouseenter', () => {
                const dataId = el.getAttribute('data-analytics-id');
                const analyticsId = el.getAttribute('analytics-id');
                tooltip.textContent = dataId || analyticsId || 'No ID';
                tooltip.style.display = 'block';
            });

            el.addEventListener('mousemove', e => {
                const offset = 12;
                let left = e.clientX + offset;
                let top = e.clientY + offset;

                // Adjust if tooltip would run off the right edge
                const tooltipWidth = tooltip.offsetWidth;
                if (left + tooltipWidth > window.innerWidth) {
                    left = e.clientX - tooltipWidth - offset;
                }

                // Adjust if tooltip would run off the bottom edge
                const tooltipHeight = tooltip.offsetHeight;
                if (top + tooltipHeight > window.innerHeight) {
                    top = e.clientY - tooltipHeight - offset;
                }

                tooltip.style.left = `${left}px`;
                tooltip.style.top = `${top}px`;
            });

            el.addEventListener('mouseleave', () => {
                tooltip.style.display = 'none';
            });
        });
    }

    function processDocument(doc) {
        try {
            highlightTags(doc);

            // Recursively check frames
            doc.querySelectorAll('iframe,frame').forEach(frame => {
                try {
                    if (frame.contentDocument) {
                        processDocument(frame.contentDocument);
                    }
                } catch (e) {
                    // Ignore cross-origin frames
                }
            });

        } catch (err) {
            console.error('Error processing document:', err);
        }
    }

    // Start with the main document
    processDocument(document);

})();




// this is the minimized code to be used as a bookmarklet.

javascript:(function(){function h(d){const t=d.createElement('div');t.style.position='fixed';t.style.background='lightgreen';t.style.color='black';t.style.padding='6px 10px';t.style.borderRadius='4px';t.style.fontSize='12px';t.style.pointerEvents='none';t.style.zIndex='9999';t.style.display='none';d.body.appendChild(t);d.querySelectorAll('[data-analytics-id],[analytics-id]').forEach(e=>{e.style.outline='2px dashed lightgreen';e.addEventListener('mouseenter',()=>{const a=e.getAttribute('data-analytics-id'),n=e.getAttribute('analytics-id');t.textContent=a||n||'No ID';t.style.display='block'});e.addEventListener('mousemove',n=>{const o=12;let l=n.clientX+o,c=n.clientY+o,i=t.offsetWidth,r=t.offsetHeight;l+i>window.innerWidth&&(l=n.clientX-i-o);c+r>window.innerHeight&&(c=n.clientY-r-o);t.style.left=`${l}px`;t.style.top=`${c}px`});e.addEventListener('mouseleave',()=>{t.style.display='none'})})}function p(d){try{h(d);d.querySelectorAll('iframe,frame').forEach(f=>{try{if(f.contentDocument)p(f.contentDocument)}catch(e){}})}catch(e){console.error('Error processing document:',e)}}p(document)})();


