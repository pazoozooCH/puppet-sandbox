# == Class: helloworld::hiera
#
# Test hiera property evaluation
#
# === Parameters
#
# === Actions
#
# === Requires
#
# === Sample Usage
#
# class { 'helloworld::hiera': }
#
class helloworld::hiera(
  $hieraMsg1 = "Default Value",
  $hieraMsg2, # No default value, must be set...
  # No hieraMsg3 specified, so it cannot be specified on the class. It will be interpolated as empty string.
  $hieraMsg4, # We'll specify this in hiera common file
  $myHieraMsg5 = hiera('hieraMsg5'), #Getting top level hiera parameter
  $hieraMsg6, # Getting overloaded hiera message
) {

  file { '/tmp/hello.hiera':
    owner   => 'root',
    group   => 'root',
    mode    => '0666',
    content => 
	# msg1: Class parameter, default value set
	# msg2: Mandatory parameter
	# msg3: Unknown parameter, will be empty
	# msg4: Will be defined in the yaml common file
	# msg5, msg5Root: Couldn't get it working...
	# myMsg5: Using hiera lookup function to get top level value...
"
hieraMsg1: $hieraMsg1
hieraMsg2: $hieraMsg2
hieraMsg3: $hieraMsg3
hieraMsg4: $hieraMsg4
hieraMsg5: $hieraMsg5
hieraMsg5Root: $::hieraMsg5
myHieraMsg5: $myHieraMsg5
hieraMsg6: $hieraMsg6
	\n",
  }

}
