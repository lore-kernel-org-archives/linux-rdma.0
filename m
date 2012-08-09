From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] [trivial] infiniband: Fix typo in infiniband driver
Date: Thu, 9 Aug 2012 23:51:02 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A7D419@ORSMSX101.amr.corp.intel.com>
References: <1344555100-3992-1-git-send-email-standby24x7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344555100-3992-1-git-send-email-standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> diff --git a/drivers/infiniband/hw/amso1100/c2_rnic.c
> b/drivers/infiniband/hw/amso1100/c2_rnic.c
> index 8c81992..b80867e 100644
> --- a/drivers/infiniband/hw/amso1100/c2_rnic.c
> +++ b/drivers/infiniband/hw/amso1100/c2_rnic.c
> @@ -439,7 +439,7 @@ static int c2_rnic_close(struct c2_dev *c2dev)
> 
>  /*
>   * Called by c2_probe to initialize the RNIC. This principally
> - * involves initalizing the various limits and resouce pools that
> + * involves initalizing the various limits and resource pools that

while we're here, can we fix initializing too?  thanks

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
