From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 3/4 for opensm] /etc/init.d/opensmd: Improve systemd
 integration
Date: Wed, 24 Oct 2012 18:13:53 +0200
Message-ID: <20121024161353.GC18591@calypso>
References: <505C7D44.9060500@acm.org>
 <20121024132726.GB18591@calypso>
 <5087FDE5.30603@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5087FDE5.30603-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

On 16:40 Wed 24 Oct     , Bart Van Assche wrote:
> On 10/24/12 15:27, Alex Netes wrote:
> > On 16:44 Fri 21 Sep     , Bart Van Assche wrote:
> >> +default_rdma_service=openibd
> >> +AC_ARG_WITH([rdma_service],
> >> +    AC_HELP_STRING([--with-rdma-service=name],
> >> +                   [name of the RDMA service: "rdma" when using /etc/init.d/rdma to start RDMA services; "openibd" when using /etc/init.d/openibd to start RDMA services [default=${default_rdma_service}]]))
> >> +AC_SUBST(RDMA_SERVICE, ${with_rdma_service:-${default_rdma_service}})
> >> +
> > 
> > There is also an option to run opensm with ibsim. In that case neither rdma
> > nor openibd should run.
> 
> Does running opensm with ibsim require to preload libumad2sim ? If so, that's
> something that's not supported by the current opensm init script, isn't it ?
> If that is correct then it looks fine to me to make the dependence on the
> openibd/rdma service explicit in the opensm startup script.

Theoretically, a user can export LD_PRELOAD=libumad2sim.so prior to executing
the script. But I agree with you that it can be out of the scope of opensmd
script.

> 
> >>   start () {
> >> +    if [ -e $pidfile ]; then
> > 
> > On opensm segfault (happens one in a while :), pidfile won't be removed, so
> > you won't be able to start the opensm again. I guess that same thing can
> > happen on warm reboot.
> > 
> >> +	echo Already started
> >> +	return 1
> >> +    fi
> 
> Good catch. I'll start testing the additional changes below:

Sounds as a good direction.

> 
> diff --git a/scripts/opensm.init.in b/scripts/opensm.init.in
> index ddd1d6b..c169974 100644
> --- a/scripts/opensm.init.in
> +++ b/scripts/opensm.init.in
> @@ -68,12 +68,18 @@ if [[ -s $CONFIG ]]; then
>      . $CONFIG
>  fi
>  
> +running () {
> +    test -e $pidfile &&
> +        test "$(readlink "/proc/$(cat $pidfile)/exe")" = "@sbindir@/opensm"
> +}
> +
>  start () {
> -    if [ -e $pidfile ]; then
> +    if running; then
>  	echo Already started
>  	return 1
>      fi
>      echo -n "Starting opensm: "
> +    rm -f $pidfile
>      @sbindir@/opensm --daemon --pidfile $pidfile $OPTIONS > /dev/null
>      if [[ $RETVAL -eq 0 ]]; then
>          success
> @@ -124,7 +130,7 @@ case "$1" in
>  	restart
>  	;;
>      try-restart | condrestart)
> -	[ -e $pidfile ] && restart
> +	running && restart
>  	;;
>      resweep)
>  	killall -HUP opensm
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
