From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/4 for opensm] Make it possible to enable opensm with
 chkconfig
Date: Wed, 24 Oct 2012 15:19:40 +0200
Message-ID: <20121024131940.GA18591@calypso>
References: <505C7CF7.8010804@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <505C7CF7.8010804-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

On 16:43 Fri 21 Sep     , Bart Van Assche wrote:
> "chkconfig $service on" enables a service in the runlevels mentioned
> next to "Default-Start" and only in those runlevels.
> 
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  configure.in                  |   10 ++++++++++
>  scripts/opensm.init.in        |    4 ++--
>  scripts/redhat-opensm.init.in |    3 +++
>  3 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/configure.in b/configure.in
> index eb252ff..f660a5b 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -11,6 +11,16 @@ AM_INIT_AUTOMAKE
>  AC_SUBST(RELEASE, ${RELEASE:-unknown})
>  AC_SUBST(TARBALL, ${TARBALL:-${PACKAGE}-${VERSION}.tar.gz})
>  
> +if { rpm -q sles-release || rpm -q openSUSE-release; } >/dev/null 2>&1; then
> +   default_start="2 3 5"
> +   default_stop="0 1 4 6"
> +else
> +   default_start="2 3 4 5"
> +   default_stop="0 1 6"
> +fi
> +AC_SUBST(DEFAULT_START, $default_start)
> +AC_SUBST(DEFAULT_STOP, $default_stop)
> +

Can you please elaborate more why there is a difference with runlevels
selection between SUSE and RH?

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
