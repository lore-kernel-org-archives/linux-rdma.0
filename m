From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC ABI V2 1/8] RDMA/core: Export RDMA IOCTL declarations
Date: Thu, 21 Jul 2016 01:07:19 -0700
Message-ID: <20160721080719.GB21060@infradead.org>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com>
 <1468941812-32286-2-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468941812-32286-2-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 19, 2016 at 06:23:25PM +0300, Matan Barak wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Place all external RDMA IOCTL declarations into one UAPI exported
> header file and move all legacy MAD commands to that file.

FYI, we also need to have all the structures used for the UAPI in
a uapi header.  I started on that a while ago, but it needs to be
resurrected.  Given that you're busy in this area it might be a good
idea if you pick this work up:

http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma-uapi

> +#ifndef RDMA_IOCTL_H
> +#define RDMA_IOCTL_H
> +
> +#include <rdma/rdma_user_ioctl.h>
> +
> +#endif /* RDMA_IOCTL_H */

What's the point of this wrappers?  Either way no need to include
guards for a no-op header if it will be kept around for some reason.

> +/*
> + * For hfi1 driver
> + */
> +#define IB_IOCTL_MAGIC			RDMA_IOCTL_MAGIC
> +
> +/* Legacy part
> + * !!!! NOTE: It uses the same command index as VERBS
> + */

In that case it should be in the same header just to avoid confusion.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
