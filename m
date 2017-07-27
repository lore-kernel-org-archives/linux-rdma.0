From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH rdma-core 20/21] Move rxe_cfg to the rdma-core package
Date: Thu, 27 Jul 2017 15:57:47 +0200
Message-ID: <1501163867.4572.27.camel@profitbricks.com>
References: <1500926429-31822-1-git-send-email-jgunthorpe@obsidianresearch.com>
         <1500926429-31822-21-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500926429-31822-21-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Am Montag, den 24.07.2017, 14:00 -0600 schrieb Jason Gunthorpe:
> rx_cfg is used to setup the kernel rxe device, it belongs with the
> rest of the kernel support items.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  debian/ibverbs-providers.install | 4 ----
>  debian/rdma-core.install         | 4 ++++
>  redhat/rdma-core.spec            | 8 ++++----
>  3 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/debian/ibverbs-providers.install b/debian/ibverbs-
> providers.install
> index 93144527be04ef..73088d82f6e0e8 100644
> --- a/debian/ibverbs-providers.install
> +++ b/debian/ibverbs-providers.install
> @@ -1,8 +1,4 @@
>  etc/libibverbs.d/
> -usr/bin/rxe_cfg
>  usr/lib/*/libibverbs/lib*-rdmav2.so
>  usr/lib/*/libmlx4.so.*
>  usr/lib/*/libmlx5.so.*
> -usr/share/doc/rdma-core/rxe.md usr/share/doc/ibverbs-providers/
> -usr/share/man/man7/rxe.7
> -usr/share/man/man8/rxe_cfg.8
> diff --git a/debian/rdma-core.install b/debian/rdma-core.install
> index 4bab264208b691..3d8cddab9297a5 100644
> --- a/debian/rdma-core.install
> +++ b/debian/rdma-core.install
> @@ -1,8 +1,12 @@
>  etc/modprobe.d/truescale.conf
>  lib/systemd/system/rdma-ndd.service
>  lib/udev/rules.d/60-rdma-ndd.rules
> +usr/bin/rxe_cfg
>  usr/lib/truescale-serdes.cmds
>  usr/sbin/rdma-ndd
>  usr/share/doc/rdma-core/MAINTAINERS
>  usr/share/doc/rdma-core/README.md
> +usr/share/doc/rdma-core/rxe.md usr/share/doc/ibverbs-providers/
> +usr/share/man/man7/rxe.7
>  usr/share/man/man8/rdma-ndd.8
> +usr/share/man/man8/rxe_cfg.8

If you place rxe.md into rdma-core, then please keep it in
/usr/share/doc/rdma-core instead of moving it to
/usr/share/doc/ibverbs-providers/

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web: https://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Geschäftsführer: Achim Weiss.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
