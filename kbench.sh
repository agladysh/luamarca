#! /bin/bash

if [[ -z "$KBENCH_SCRIPT" ]]; then
  KBENCH_SCRIPT=$1;
fi

if [[ -z "$KBENCH_NUM_ITER" ]]; then
  KBENCH_NUM_ITER=$2;
fi

if [[ -z "$KBENCH_SCRIPT" ]]; then
  KBENCH_SCRIPT=kbench.lua;
fi

if [[ -z "$KBENCH_NUM_ITER" ]]; then
  KBENCH_NUM_ITER=10000000 # 10M
fi

TIME="/usr/bin/time -p"

KBENCH_INTERPRETERS=( 'lua' 'luajit -O' 'luajit2' )
KBENCH_METHODS=( $(${KBENCH_INTERPRETERS[0]} $KBENCH_SCRIPT | grep -e '^\* \(.*\)$' | awk '{ print $2 }') )
for interpreter in "${KBENCH_INTERPRETERS[@]}"; do
  for method in "${KBENCH_METHODS[@]}"; do
    echo interpreter "'"$interpreter"'" command "'"$KBENCH_SCRIPT"'" method "'"$method"'" num_iter "'"$KBENCH_NUM_ITER"'"
    ${TIME} $interpreter $KBENCH_SCRIPT $method $KBENCH_NUM_ITER
  done
done
