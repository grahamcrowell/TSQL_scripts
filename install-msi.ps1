$install_dir=$PSScriptRoot
foreach($msi_file in Get-ChildItem -Path $PSScriptRoot -File -Filter "*.msi")
{
    $msi_path=Join-Path -Path $PSScriptRoot -ChildPath $msi_file
    Write-Host ("installing: {0}" -f $msi_path)
    msiexec /a "$msi_path" /log "msi_log.txt" /passive
}
#msiexec /package /log "msi_log.txt"
# numpy
# Cffi: Requires pycparser
# CVXPY: Requires scipy, cvxopt, scs, and ecos 
# Jupyter: setuptools, pyzmq, tornado, pygments, markupsafe, jinja2, mistune, rpy2, pycairo, matplotlib, pyqt4 or pyside, *pandoc, and *whatnot
# GuiQwt 3.x requires pythonqwt and guidata 1.7. 
# Matplotlib: Requires numpy, dateutil, pytz, pyparsing, cycler, setuptools, and optionally pillow, pycairo, tornado, wxpython, pyside, pyqt4, ghostscript, miktex, ffmpeg, mencoder, avconv, or imagemagick. 
# Pandas: Requires numpy, dateutil, pytz, setuptools, and optionally numexpr, bottleneck, scipy, matplotlib, pytables, lxml, xarray, blosc, backports.lzma, statsmodels, sqlalchemy and other dependencies. 
# PyQwt: Requires pyqt4. 
# Python-igraph: Requires pycairo. 