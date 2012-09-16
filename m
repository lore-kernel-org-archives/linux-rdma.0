From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] /etc/init.d/opensmd: Improve systemd integration
Date: Sun, 16 Sep 2012 12:31:59 +0300
Message-ID: <20120916093159.GB8243@calypso>
References: <50535650.6050306@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50535650.6050306-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

On 18:07 Fri 14 Sep     , Bart Van Assche wrote:
> On recent SLES and openSUSE systems it is necessary to read the
> file /lib/lsb/init-functions instead of /etc/rc.status for proper
> integration with systemd. Also, prevent that the opensm process is
> started twice and drop /var/lock/subsys/opensm.

There could be a problem (which also persists in the original script), that in
theory you can run two OpenSM instances (on different ports) which is not
being supported by the init script. Any thoughts how this can be addressed?

> 
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> ---
>  scripts/opensm.init.in |   21 +++++++++++++++------
>  1 files changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/scripts/opensm.init.in b/scripts/opensm.init.in
> index 01d2bb9..7a9f8ec 100644
> --- a/scripts/opensm.init.in
> +++ b/scripts/opensm.init.in
> @@ -45,11 +45,18 @@ exec_prefix=@exec_prefix@
>  
>  # Source function library.
>  if [[ -s /etc/init.d/functions ]]; then
> +    # RHEL / CentOS / SL / Fedora.
>      . /etc/init.d/functions
>      rc_status() { :; }
>      rc_exit() { exit $RETVAL; }
> -fi
> -if [[ -s /etc/rc.status ]]; then
> +elif [[ -s /lib/lsb/init-functions ]]; then
> +    # SLES / openSuSE / Debian.
> +    . /lib/lsb/init-functions
> +    rc_exit() { exit $RETVAL; }
> +    success() { log_success_msg; }
> +    failure() { log_failure_msg; }
> +elif [[ -s /etc/rc.status ]]; then
> +    # Older SuSE systems.
>      . /etc/rc.status
>      failure() { rc_status -v; }
>      success() { rc_status -v; }
> @@ -61,10 +68,13 @@ if [[ -s $CONFIG ]]; then
>  fi
>  
>  start () {
> +    if [ -e /var/run/opensm.pid ]; then
> +	echo Already started
> +	return 1
> +    fi
>      echo -n "Starting opensm: "
> -    @sbindir@/opensm --daemon $OPTIONS > /dev/null
> +    @sbindir@/opensm --daemon --pidfile /var/run/opensm.pid $OPTIONS > /dev/null
>      if [[ $RETVAL -eq 0 ]]; then
> -        touch /var/lock/subsys/opensm
>          success
>      else
>          failure
> @@ -76,7 +86,6 @@ stop () {
>      echo -n "Shutting down opensm: "
>      killproc opensm
>      if [[ $RETVAL -eq 0 ]]; then
> -        rm -f /var/lock/subsys/opensm
>          success
>      else
>          failure
> @@ -114,7 +123,7 @@ case "$1" in
>  	restart
>  	;;
>      try-restart | condrestart)
> -	[ -e /var/lock/subsys/opensm ] && restart
> +	[ -e /var/run/opensm.pid ] && restart
>  	;;
>      resweep)
>  	killall -HUP opensm
> -- 
> 1.7.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
