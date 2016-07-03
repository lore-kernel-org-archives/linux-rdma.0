From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 2/3] IB/core: Fix ib_resolve_eth_dmac for Raw
 Packet QP
Date: Sun, 3 Jul 2016 16:52:45 +0300
Message-ID: <CAJ3xEMg+kqmEQ7B_JAKGnu3ubwu5f-40jbeL4Wg9udUeoxEZJw@mail.gmail.com>
References: <1467549727-23479-1-git-send-email-leon@kernel.org> <1467549727-23479-3-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467549727-23479-3-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 3, 2016 at 3:42 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> From: Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> For Raw Packet QP, the AV attribute is passed in INIT to RTR in order
> to set the Ethernet Priority using the SL. The rest of the fields
> aren't necessarily valid, which causes the ib_resolve_eth_dmac to fail.
>
> Since no release address resolution is needed, don't do anything in
> ib_resolve_eth_dmac for Raw Packet QP.

What "release address resolution" means?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
