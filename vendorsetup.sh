for combo in $(cat vendor/cos/jenkins-build-targets)
do
    add_lunch_combo $combo
done
