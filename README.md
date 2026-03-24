# BashAssignment
# Employee Id: TSV-921

This assignment contains a Bash script that updates a configuration file `sig.conf` based on user input. The script asks for Component Name, Scale, View, and Count, and validates each input to ensure only allowed values are used. It maps the View input such that “Auction” becomes `vdopiasample` and “Bid” becomes `vdopiasample-bid`, as required by the file format.

Once validated, the script searches for the specified component in the file and updates only the first matching line with the new values. Before making any changes, it creates a backup file (`sig.conf.bak`) for safety. The script also provides clear success or error messages depending on the outcome, ensuring a simple and reliable way to manage configuration updates.
