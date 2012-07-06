From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: linux-next: build failure after merge of the infiniband tree
Date: Thu, 5 Jul 2012 20:58:38 -0700
Message-ID: <CAL1RGDW+3Q86QUp-aaWajT8nLK_7hQuCbxeE4q9He=aGdAMX6Q@mail.gmail.com>
References: <20120706123555.949d8efb4de5c4df18fb1ec0@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120706123555.949d8efb4de5c4df18fb1ec0-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 5, 2012 at 7:35 PM, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org> wrote:
> drivers/infiniband/core/cma.c: In function 'rdma_bind_addr':
> drivers/infiniband/core/cma.c:2411:30: error: 'struct net' has no member named 'ipv6'

Thanks, fixed with a "#if IS_ENABLED(CONFIG_IPV6)" around the code
that touches ipv6... Sean, let me know if more is required.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
