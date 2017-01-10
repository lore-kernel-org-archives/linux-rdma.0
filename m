From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/4] Minimize the places where infiniband/arch.h
 is included
Date: Tue, 10 Jan 2017 14:49:14 -0500
Message-ID: <f4051fa1-29ba-cfc5-1deb-680dfdfbc53a@dev.mellanox.co.il>
References: <1484074931-3847-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1484074931-3847-2-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1484074931-3847-2-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/10/2017 2:02 PM, Jason Gunthorpe wrote:
> We never want to use it for htonll as this header can only be
> compiled on architectures that define the PCI memory barriers.
> Instead use byteswap.h directly.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  ibacm/linux/osd.h                 | 1 -
>  ibacm/src/libacm.c                | 6 +++---
>  libibumad/sysfs.c                 | 3 +--
>  libibverbs/device.c               | 4 +---
>  libibverbs/examples/device_list.c | 3 +--
>  libibverbs/examples/devinfo.c     | 3 +--
>  librdmacm/addrinfo.c              | 6 +++---
>  librdmacm/cma.c                   | 6 +++---
>  librdmacm/cma.h                   | 1 -
>  librdmacm/examples/rping.c        | 7 +++----
>  librdmacm/rsocket.c               | 8 ++++----
>  srp_daemon/srp_daemon.h           | 1 -
>  12 files changed, 20 insertions(+), 29 deletions(-)

>From the libibumad piece

Reviewed-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
