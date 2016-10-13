From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/5] rxe_cfg: Use Perl functions instead of parsing the
 output of shell commands
Date: Thu, 13 Oct 2016 13:53:21 +0300
Message-ID: <c8c6f9e8-3c85-b956-dba3-91191f72974a@mellanox.com>
References: <bf5dba39-7e14-23ee-4aa1-2a276d629fe9@sandisk.com>
 <51c02d54-9189-2993-a9cb-a6f6452e9ff3@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51c02d54-9189-2993-a9cb-a6f6452e9ff3-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/7/2016 9:38 PM, Bart Van Assche wrote:
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> ---
>  providers/rxe/rxe_cfg | 67 ++++++++++++++++++++++++---------------------------
>  1 file changed, 31 insertions(+), 36 deletions(-)
>
> diff --git a/providers/rxe/rxe_cfg b/providers/rxe/rxe_cfg
> index 6783dc78c340..0310d25bad91 100755
> --- a/providers/rxe/rxe_cfg
> +++ b/providers/rxe/rxe_cfg
> @@ -35,6 +35,7 @@
>  use warnings;
>  use strict;
>
> +use File::Basename;
>  use Getopt::Long;
>  use Switch;
>
> @@ -67,20 +68,25 @@ my @mlx4_port;
>  my @mlx4_ether;
>  my @roce_list;
>
> +# Read a file and return its contents as a string.
> +sub read_file {
> +    my $filename = shift;
> +    my $result = "";
> +
> +    if (open(FILE, $filename)) {
> +	$result = <FILE>;
> +	close FILE;
> +    }
> +    return $result;
> +}
> +
>  #get mapping between rxe and eth devices
>  sub get_names {
> -    return if (!(-e "/sys/class/infiniband"));
> -
> -    my @list;
> -    my $rxe;
> -    my $eth;
>      my $i = 0;
>
> -    @list = `ls /sys/class/infiniband | grep rxe $z`;
> -    foreach $rxe (@list) {
> -	chomp($rxe);
> -
> -	$eth = `cat /sys/class/infiniband/$rxe/parent $z`;
> +    foreach my $rxe (glob("/sys/class/infiniband/rxe*")) {
> +	$rxe = basename($rxe);
> +	my $eth = read_file("/sys/class/infiniband/$rxe/parent");
>  	chomp($eth);
>  	
>  	if (($eth =~ /[\w]+[\d]/)
> @@ -98,25 +104,13 @@ sub get_names {
>
>  # get list of Mellanox RoCE ports
>  sub get_mlx4_list {
> -    return if (!(-e "/sys/class/infiniband"));
> -
> -    my @list;
> -    my $mlx4;
> -    my @ports;
> -    my $port;
> -    my $link;
>      my $i = 0;
>
> -    @list = `ls /sys/class/infiniband | grep mlx4_ $z`;
> -    foreach $mlx4 (@list) {
> -	chomp($mlx4);
> -	chdir("/sys/class/infiniband/$mlx4/ports");
> -
> -	@ports = `ls $z`;
> -	foreach $port (@ports) {
> -	    chomp($port);
> -
> -	    $link= `cat $port/link_layer $z`;
> +    foreach my $mlx4 (glob("/sys/class/infiniband/mlx4_*")) {
> +	$mlx4 = basename($mlx4);
> +	foreach my $port (glob("/sys/class/infiniband/$mlx4/ports/*")) {
> +	    $port = basename($port);
> +	    my $link = read_file("$port/link_layer");
>  	    chomp($link);
>
>  	    if ($link =~ "Ethernet") {
> @@ -141,10 +135,10 @@ sub get_dev_info {
>      get_mlx4_list();
>
>      my @my_eth_list = ();
> -    my @my_eth_devs = `ls /sys/class/net`;
> -    foreach my $my_eth_dev (@my_eth_devs) {
> -        chomp($my_eth_dev);
> -        my $my_dev_type = `cat /sys/class/net/${my_eth_dev}/type`;
> +    foreach my $my_eth_dev (glob("/sys/class/net/*")) {
> +	$my_eth_dev = basename($my_eth_dev);
> +        my $my_dev_type = read_file("/sys/class/net/${my_eth_dev}/type");
> +	chomp($my_dev_type);
>          if ($my_dev_type == "1") {
>              push(@my_eth_list, "$my_eth_dev");
>          }
> @@ -378,11 +372,11 @@ sub do_status {
>
>  # read file containing list of ethernet devices into a list
>  sub populate_persistence {
> -    my @lines = `cat $persistence_file $z`;
> -    my $line;
>      my $i = 0;
>
> -    foreach $line (@lines) {
> +    open FILE, $persistence_file;
> +    while(<FILE>) {
> +	my $line = $_;
>  	chomp($line);
>  	$line =~ s/^\s+//g;
>  	if ($line =~ /[\w]+[\d]/) {
> @@ -394,6 +388,7 @@ sub populate_persistence {
>  	    }
>  	}
>      }
> +    close FILE;
>
>      $num_persistent = $i;
>  }
> @@ -604,7 +599,7 @@ sub do_debug {
>  	}
>      }
>
> -    my $current = `cat $debugfile $z`;
> +    my $current = read_file($debugfile);
>      chomp($current);
>      if ($current > 0) {
>  	print "Debug is ON ($current)\n";
> @@ -681,7 +676,7 @@ sub main {
>      }
>
>      # create persistence file if necessary
> -    `mkdir -p $persistence_path $z`;
> +    mkdir -p $persistence_path;
>      if (!(-e $persistence_file)) {
>          `touch $persistence_file $z`;
>      }
>
ack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
