From: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Subject: Re: [PATCH v6 0/3] linux: address broken PAT drivers
Date: Mon, 8 Jun 2015 21:57:12 -0300
Message-ID: <20150608215712.3c9c0548@recife.lan>
References: <1433809222-28261-1-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433809222-28261-1-git-send-email-mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org>
Cc: bp-l3A5Bk7waGM@public.gmane.org, tomi.valkeinen-l0cyMroinI0@public.gmane.org, bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Em Mon, 08 Jun 2015 17:20:19 -0700
"Luis R. Rodriguez" <mcgrof-3uybbJdB1yH774rrrx3eTA@public.gmane.org> escreveu:

> From: "Luis R. Rodriguez" <mcgrof-IBi9RG/b67k@public.gmane.org>
> 
> Mauro,
> 
> since the ivtv patch is already acked by the driver maintainer
> and depends on an x86 symbol that went through Boris' tree are you
> OK in it going through Boris' tree?

Sure. I just find a minor issues there. After they got solved, feel
free to submit to Boris with my ack.

> 
> Boris,
> 
> provided the outcome of the above maintainer's preference for you
> to merge these please consider these patches for your tree. The
> maintainer path is the only thing pending for the 1 ivtv patch.
> The Infiniband subsystem maintainer, Doug, already provided his
> ACK for the ipath driver and for this to go through you.
> 
> Luis R. Rodriguez (3):
>   ivtv: use arch_phys_wc_add() and require PAT disabled
>   IB/ipath: add counting for MTRR
>   IB/ipath: use arch_phys_wc_add() and require PAT disabled
> 
>  drivers/infiniband/hw/ipath/Kconfig           |  3 ++
>  drivers/infiniband/hw/ipath/ipath_driver.c    | 18 ++++++---
>  drivers/infiniband/hw/ipath/ipath_kernel.h    |  4 +-
>  drivers/infiniband/hw/ipath/ipath_wc_x86_64.c | 43 +++++---------------
>  drivers/media/pci/ivtv/Kconfig                |  3 ++
>  drivers/media/pci/ivtv/ivtvfb.c               | 58 +++++++++++----------------
>  6 files changed, 52 insertions(+), 77 deletions(-)
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
