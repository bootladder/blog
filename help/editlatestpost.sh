#!/bin/bash
echo vi _posts/$(ls -t _posts | head -1)
vi _posts/$(ls -t _posts | head -1)
