import os
import re
import base64


class HTMLTagExtractor:
    #Clase responsable de extraer las etiquetas <img> de un HTML 

    def extract_img_tags(self, html_content):
        #Extrae las fuentes de las imágenes de un contenido HTML dado 
        return re.findall(r'<img\s+[^>]*src="([^"]+)"', html_content)


class ImageEncoder:
    #Clase responsable de codificar imágenes a formato Base64 

    def encode_to_base64(self, img_path):
        #Convierte una imagen a formato Base64 
        try:
            with open(img_path, 'rb') as img_file:
                encoded_img = base64.b64encode(img_file.read()).decode('utf-8')
            return encoded_img
        except Exception as e:
            raise ValueError(f"Error al codificar la imagen {img_path}: {e}")


class FileProcessor:
    #Clase responsable de procesar archivos HTML 

    def __init__(self, extractor, encoder, logger):
        self.extractor = extractor
        self.encoder = encoder
        self.logger = logger

    def process_html_files(self, input_paths):
        html_files = self._get_html_files(input_paths)

        for html_file in html_files:
            try:
                html_content = self._read_html(html_file)
                img_tags = self.extractor.extract_img_tags(html_content)

                for img_src in img_tags:
                    self._process_image(html_file, img_src, html_content)

                self._save_processed_html(html_file, html_content)

            except Exception as e:
                print(f"Error al procesar {html_file}: {e}")
        return self.logger.get_results()

    def _get_html_files(self, input_paths):
        #Obtiene todos los archivos HTML desde una lista de rutas (archivos o directorios) 
        html_files = []
        for path in input_paths:
            if os.path.isfile(path) and path.endswith('.html'):
                html_files.append(path)
            elif os.path.isdir(path):
                for root, _, files in os.walk(path):
                    for file in files:
                        if file.endswith('.html'):
                            html_files.append(os.path.join(root, file))
        return html_files

    def _read_html(self, html_file):
        #Lee el contenido de un archivo HTML 
        with open(html_file, 'r', encoding='utf-8') as file:
            return file.read()

    def _process_image(self, html_file, img_src, html_content):
        #Procesa la imagen: la convierte a base64 y reemplaza el src en el HTML 
        if os.path.exists(img_src):
            try:
                encoded_img = self.encoder.encode_to_base64(img_src)
                ext = os.path.splitext(img_src)[-1][1:]
                base64_src = f'data:image/{ext};base64,{encoded_img}'

                html_content = html_content.replace(img_src, base64_src)
                self.logger.log_success(html_file, img_src)
            except Exception as e:
                self.logger.log_failure(html_file, img_src, str(e))
        else:
            self.logger.log_failure(html_file, img_src, "File not found")

    def _save_processed_html(self, html_file, html_content):
        #Guarda el contenido HTML procesado en un nuevo archivo 
        new_file = html_file.replace('.html', '.processed.html')
        with open(new_file, 'w', encoding='utf-8') as file:
            file.write(html_content)


class ResultsLogger:
    #Clase responsable de registrar los resultados de éxito y fallo 

    def __init__(self):
        self.results = {'success': {}, 'fail': {}}

    def log_success(self, html_file, img_src):
        #Registra una imagen procesada con éxito.
        self.results['success'].setdefault(html_file, []).append(img_src)

    def log_failure(self, html_file, img_src, error_message):
        #Registra una imagen que no pudo ser procesada.
        self.results['fail'].setdefault(html_file, []).append((img_src, error_message))

    def get_results(self):
        #Obtiene los resultados de éxito y fallo.
        return self.results


if __name__ == "__main__":
    extractor = HTMLTagExtractor()
    encoder = ImageEncoder()
    logger = ResultsLogger()
    processor = FileProcessor(extractor, encoder, logger)

    input_paths = ["html"]  # Directorio o archivos a procesar
    results = processor.process_html_files(input_paths)

    print("Procesamiento completo:")
    print("Éxitos:", results['success'])
    print("Fallos:", results['fail'])
