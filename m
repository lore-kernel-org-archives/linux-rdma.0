From: Randy Dunlap <randy.dunlap-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] [RFC] ummunotify: Userspace support for MMU
 notifications
Date: Wed, 7 Apr 2010 10:38:13 -0700
Message-ID: <20100407103813.74b54a87.randy.dunlap@oracle.com>
References: <1270643429-20688-1-git-send-email-ebmunson@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1270643429-20688-1-git-send-email-ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed,  7 Apr 2010 13:30:29 +0100 Eric B Munson wrote:

> Signed-off-by: Roland Dreier <rolandd <at> cisco.com>

Use unobfuscated @.

> Signed-off-by: Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> 
> ---
> 
> Changes since v3:
>  - Fixed replaced [get|put] user with copy_[from|to]_user to fix x86
>    builds
> ---
>  Documentation/Makefile    |    3 +-
>  drivers/char/Kconfig      |   12 +
>  drivers/char/Makefile     |    1 +
>  drivers/char/ummunotify.c |  567 +++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 582 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/char/ummunotify.c
> 
> diff --git a/Documentation/Makefile b/Documentation/Makefile
> index 6fc7ea1..27ba76a 100644
> --- a/Documentation/Makefile
> +++ b/Documentation/Makefile
> @@ -1,3 +1,4 @@
>  obj-m := DocBook/ accounting/ auxdisplay/ connector/ \
>  	filesystems/ filesystems/configfs/ ia64/ laptops/ networking/ \
> -	pcmcia/ spi/ timers/ video4linux/ vm/ watchdog/src/
> +	pcmcia/ spi/ timers/ video4linux/ vm/ ummunotify/ \
> +	watchdog/src/

What is this change to Documentation/Makefile for?
Is there some file that should be added in Documentation/ummunotify/ ?


> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index 3141dd3..cf26019 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -1111,6 +1111,18 @@ config DEVPORT
>  	depends on ISA || PCI
>  	default y
>  
> +config UMMUNOTIFY
> +       tristate "Userspace MMU notifications"
> +       select MMU_NOTIFIER
> +       help
> +         The ummunotify (userspace MMU notification) driver creates a
> +         character device that can be used by userspace libraries to
> +         get notifications when an application's memory mapping
> +         changed.  This is used, for example, by RDMA libraries to
> +         improve the reliability of memory registration caching, since
> +         the kernel's MMU notifications can be used to know precisely
> +         when to shoot down a cached registration.
> +
>  source "drivers/s390/char/Kconfig"
>  
>  endmenu
> diff --git a/drivers/char/Makefile b/drivers/char/Makefile
> index f957edf..521e5de 100644
> --- a/drivers/char/Makefile
> +++ b/drivers/char/Makefile
> @@ -97,6 +97,7 @@ obj-$(CONFIG_NSC_GPIO)		+= nsc_gpio.o
>  obj-$(CONFIG_CS5535_GPIO)	+= cs5535_gpio.o
>  obj-$(CONFIG_GPIO_TB0219)	+= tb0219.o
>  obj-$(CONFIG_TELCLOCK)		+= tlclk.o
> +obj-$(CONFIG_UMMUNOTIFY)	+= ummunotify.o
>  
>  obj-$(CONFIG_MWAVE)		+= mwave/
>  obj-$(CONFIG_AGP)		+= agp/


---
~Randy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
