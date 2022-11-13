import os
import pathlib
import shutil

from invoke import task


PROJECT_ROOT = pathlib.Path(__file__).parent
OUTPUT_FOLDER = str(PROJECT_ROOT / 'locales')

@task
def build(ctx):
    with ctx.cd(str(PROJECT_ROOT)):
        ctx.run('xcodebuild')

@task
def clean(ctx):
    try:
        shutil.rmtree(OUTPUT_FOLDER)
    except FileNotFoundError:
        pass

@task(pre=[build, clean])
def make(ctx):
    with ctx.cd(str(PROJECT_ROOT / 'build' / 'Release')):
        ctx.run(f'./NSLocaleNames {OUTPUT_FOLDER}')
