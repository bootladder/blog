#!/bin/bash
echo vim _posts/$(ls -t _posts | head -1)
vim _posts/$(ls -t _posts | head -1)
