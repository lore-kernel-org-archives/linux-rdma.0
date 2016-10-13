From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 3/5] rxe_cfg: Do not suppress stderr
Date: Thu, 13 Oct 2016 14:00:15 +0300
Message-ID: <1b0f729d-d23f-5ffe-f0eb-ba987773da71@mellanox.com>
References: <bf5dba39-7e14-23ee-4aa1-2a276d629fe9@sandisk.com>
 <b97aebd2-37fc-c526-0bf6-438c194111a1@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b97aebd2-37fc-c526-0bf6-438c194111a1-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/7/2016 9:39 PM, Bart Van Assche wrote:
> Suppressing stderr if stdout is already redirected is wrong. Hence
> do not suppress stderr. If e.g. the ib_uverbs kernel module is not
> loaded, without this patch no error messages are printed. With this
> patch applied the following is printed:
>
> Failed to get IB devices list: Function not implemented
>
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> ---
>  providers/rxe/rxe_cfg | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/providers/rxe/rxe_cfg b/providers/rxe/rxe_cfg
> index 1e6a5db2f2b8..a4e9c0407a8b 100755
> --- a/providers/rxe/rxe_cfg
> +++ b/providers/rxe/rxe_cfg
> @@ -39,7 +39,6 @@ use File::Basename;
>  use Getopt::Long;
>  use Switch;
>
> -my $z = "2>/dev/null";
>  my $help = 0;
>  my $no_persist = 0;
>  my $debug = 0;
> @@ -150,7 +149,7 @@ sub get_dev_info {
>
>  	$eth_list[$i++] = $eth;
>
> -	@lines = `ethtool -i $eth $z`;
> +	@lines = `ethtool -i $eth`;
>  	foreach $line (@lines) {
>  	    chomp($line);
>
> @@ -171,7 +170,7 @@ sub get_dev_info {
>  	$link_state{$eth} = "";
>  	$link_speed{$eth} = "";
>
> -	@lines = `ethtool $eth $z`;
> +	@lines = `ethtool $eth`;
>  	foreach $line (@lines) {
>  	    chomp($line);
>
> @@ -190,7 +189,7 @@ sub get_dev_info {
>  	$ipv4_addr{$eth} = "            ";
>  	$eth_mtu{$eth} = "";
>
> -	@lines = `ifconfig $eth $z`;
> +	@lines = `ifconfig $eth`;
>  	foreach $line (@lines) {
>  	    # get IP address
>  	    if ($line =~ /inet addr/) {
> @@ -211,7 +210,7 @@ sub get_dev_info {
>      # get rxe mtu
>      foreach my $rxe (@rxe_array) {
>  	
> -	@lines  = `ibv_devinfo -d $rxe $z`;
> +	@lines = `ibv_devinfo -d $rxe`;
>  	foreach $line (@lines) {
>  	    if ($line =~ "active_mtu") {
>  		$line =~ s/^\s+active_mtu:\s+//g;
> @@ -494,7 +493,7 @@ sub get_devinfo {
>      my $rxe = $_[0];
>
>      my $cmd = "ibv_devinfo -d $rxe";
> -    return `$cmd $z`;
> +    return `$cmd`;
>  }
>
>  # allow unsupported modules to load in SLES11 if allowed
> @@ -679,7 +678,7 @@ sub main {
>      # create persistence file if necessary
>      mkdir -p $persistence_path;
>      if (!(-e $persistence_file)) {
> -        `touch $persistence_file $z`;
> +        `touch $persistence_file`;
>      }
>
>      # Get full context of the configuration
>
Ack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
