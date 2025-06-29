FROM rbgcsail/diffdock:v1.1.3

RUN groupadd users
RUN chgrp -R users /home/appuser/

