#check if MEME suite is already installed and tomtom is added to enviromental path

{
	echo -n "The version of tomtom is " 
	tomtom --version
} || {
	echo "tomtom is not installed or not added to enviromental path"
	exit 1 
}

{
	python -c "import networkx"
	echo "The required package networkx is installed"
} || {
	echo "Required python package networkx is not installed properply "
	exit 1
}
