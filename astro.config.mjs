import { defineConfig } from 'astro/config';

// https://astro.build/config
import { astroImageTools } from "astro-imagetools";

export default defineConfig({
    integrations: [astroImageTools],
});
