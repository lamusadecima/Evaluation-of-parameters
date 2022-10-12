#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Aug 19 14:09:58 2019

@author: jose
"""

import pandas as pd
import os
import glob 

metadatos_df = pd.read_csv("/home/jose/Dropbox/MTB/investigacion/estudio_parametros/corpora/novelas-hispanoamericanas/metadata.csv", sep=",", index_col=0)

for doc in glob.glob("/home/jose/Dropbox/MTB/investigacion/estudio_parametros/corpora/novelas-hispanoamericanas/txt_id/*.txt"):
    input_name  = os.path.splitext(os.path.split(doc)[1])[0]
    with open(doc, "r", errors="replace", encoding="utf-8") as fin:
        content = fin.read()
        with open ("/home/jose/Dropbox/MTB/investigacion/estudio_parametros/corpora/novelas-hispanoamericanas/original_corpus/" + metadatos_df.loc[input_name]["author-name"] + "_" + metadatos_df.loc[input_name]["title"] + "-" + input_name + ".txt", "w", encoding="utf-8") as fout:
                fout.write(content)
                
        