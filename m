From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V1 25/29] net/mlx4_core: Adjustments to SET_PORT
 for SRIOV-IB
Date: Fri, 6 Jul 2012 05:43:59 +0300
Message-ID: <CAJZOPZKhV=rcGF0duJLkGFBhD3_tG-JgW+hkVH51KX6uokVEiA@mail.gmail.com>
References: <1340094121-14858-1-git-send-email-jackm@dev.mellanox.co.il>
	<1340094121-14858-26-git-send-email-jackm@dev.mellanox.co.il>
	<CAL1RGDW093B0p1caO2CHKQiAGtxLGR97h1tFd7W4QY8_31MfTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDW093B0p1caO2CHKQiAGtxLGR97h1tFd7W4QY8_31MfTg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 6, 2012 at 3:09 AM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Tue, Jun 19, 2012 at 1:21 AM, Jack Morgenstein
> <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

>> 1. Slave may not set the IS_SM capability for the port.

> So I can't run a SM in a guest?

nope, guests are untrusted and we don't let them send nor recv SMPs

>> 2. No DEV_MGR in multifunc mode.

> I can't run an SRP target in a guest?

nope

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
