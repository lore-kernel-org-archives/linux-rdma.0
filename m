From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] opensm/configure.in: Remove Default-Start from opensmd
 init script
Date: Wed, 30 Jan 2013 09:59:34 +0100
Message-ID: <5108E0F6.3060602@acm.org>
References: <20130129171850.GB2961@calypso.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130129171850.GB2961-iQai9MGU/dze+A/uUDamNg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/29/13 18:18, Alex Netes wrote:
> During opensm RPM packaging, `chkconfig --add opensmd` is called.
> `chkconfig --add` creates the appropriate entry as specified by the
> default values in the init script. Having opensmd run by default on boot
> isn't desired.
>
> Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   configure.in | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/configure.in b/configure.in
> index 4515ae2..f798be2 100644
> --- a/configure.in
> +++ b/configure.in
> @@ -18,12 +18,13 @@ AC_ARG_WITH([rdma_service],
>   AC_SUBST(RDMA_SERVICE, ${with_rdma_service:-${default_rdma_service}})
>
>   if { rpm -q sles-release || rpm -q openSUSE-release; } >/dev/null 2>&1; then
> -   default_start="2 3 5"
>      default_stop="0 1 4 6"
>   else
> -   default_start="2 3 4 5"
>      default_stop="0 1 6"
>   fi
> +
> +default_start="null"
> +
>   AC_SUBST(DEFAULT_START, $default_start)
>   AC_SUBST(DEFAULT_STOP, $default_stop)

Sorry but this patch doesn't make sense to me. This patch will prevent 
anyone to enable opensm to run during boot via chkconfig. How about 
replacing the above by the (untested) patch below ?

iff --git a/opensm.spec.in b/opensm.spec.in
index 6ae525b..2325b70 100644
--- a/opensm.spec.in
+++ b/opensm.spec.in
@@ -107,13 +107,6 @@ rm -rf $RPM_BUILD_ROOT

  %post
  if [ $1 = 1 ]; then
-    if [ -e /sbin/chkconfig ]; then
-        /sbin/chkconfig --add opensmd
-    elif [ -e /usr/sbin/update-rc.d ]; then
-        /usr/sbin/update-rc.d opensmd defaults
-    else
-        /usr/lib/lsb/install_initd /etc/init.d/opensmd
-    fi
      if type systemctl >/dev/null 2>&1; then
          systemctl --system daemon-reload
      fi

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
