shader_type canvas_item;

// Parametri per controllare l'effetto CAPTCHA
uniform float wave_strength : hint_range(0.0, 0.1) = 0.03;
uniform float wave_frequency : hint_range(1.0, 20.0) = 8.0;
uniform float noise_strength : hint_range(0.0, 0.1) = 0.02;
uniform float distortion_speed : hint_range(0.0, 5.0) = 2.0;
uniform float skew_amount : hint_range(-0.5, 0.5) = 0.1;
uniform vec4 outline_color : source_color = vec4(0.2, 0.2, 0.8, 1.0);
uniform float outline_width : hint_range(0.0, 0.01) = 0.003;
uniform bool enable_chromatic_aberration = true;
uniform float aberration_strength : hint_range(0.0, 0.01) = 0.002;

// Funzione per generare rumore pseudo-casuale
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Funzione per rumore di Perlin semplificato
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void fragment() {
    vec2 uv = UV;
    float time = TIME * distortion_speed;

    // Applica skew (inclinazione) come nei CAPTCHA
    uv.x += uv.y * skew_amount;

    // Ondulazioni verticali e orizzontali
    float wave_x = sin(uv.y * wave_frequency + time) * wave_strength;
    float wave_y = cos(uv.x * wave_frequency * 0.7 + time * 1.3) * wave_strength * 0.5;

    // Rumore per distorsione irregolare
    float noise_offset_x = noise(uv * 20.0 + time * 0.5) * noise_strength;
    float noise_offset_y = noise(uv * 15.0 + time * 0.3) * noise_strength;

    // Combina tutte le distorsioni
    vec2 distorted_uv = uv + vec2(wave_x + noise_offset_x, wave_y + noise_offset_y);

    // Campiona il testo con le distorsioni applicate
    vec4 text_color = texture(TEXTURE, distorted_uv);

    // Effetto di aberrazione cromatica (separa leggermente i canali RGB)
    if (enable_chromatic_aberration) {
        float r = texture(TEXTURE, distorted_uv + vec2(aberration_strength, 0.0)).r;
        float g = texture(TEXTURE, distorted_uv).g;
        float b = texture(TEXTURE, distorted_uv - vec2(aberration_strength, 0.0)).b;
        text_color = vec4(r, g, b, text_color.a);
    }

    // Crea un effetto outline/bordo
    vec4 outline = vec4(0.0);
    if (outline_width > 0.0) {
        for (float x = -1.0; x <= 1.0; x += 1.0) {
            for (float y = -1.0; y <= 1.0; y += 1.0) {
                if (x == 0.0 && y == 0.0) continue;
                vec2 offset = vec2(x, y) * outline_width;
                outline += texture(TEXTURE, distorted_uv + offset);
            }
        }
        outline = outline_color * sign(outline.a);
    }

    // Combina testo e outline
    COLOR = mix(outline, text_color, text_color.a);

    // Aggiungi un leggero effetto di "sporcizia" tipico dei CAPTCHA
    float dirt = noise(uv * 50.0 + time * 0.1) * 0.1;
    COLOR.rgb = mix(COLOR.rgb, COLOR.rgb * 0.8, dirt);
}