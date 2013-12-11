From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V5 7/8] IB/uverbs: Resolve Ethernet L2 addresses when
 modifying QP
Date: Wed, 11 Dec 2013 22:41:57 +0200
Message-ID: <CAJZOPZ+d9xsCQ4nKq5iEaR6tenqvG7spBXKiJBcHjL22c3ePRw@mail.gmail.com>
References: <CAG4TOxMgHuC=rzB+8stotaeKqwxipz06s_B2zogMMqNn3ZWTOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxMgHuC=rzB+8stotaeKqwxipz06s_B2zogMMqNn3ZWTOA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Devesh Sharma <Devesh.Sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, monis <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 11, 2013 at 7:59 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> OK, I guess I'm still confused.  Do we have two ways of resolving
> addresses, one way for consumers that use the RDMA CM and another way
> for consumers that don't?  Does that mean we end up having two
> different paths through core verbs?  Even if we put address resolution
> in uverbs, how do user apps that *do* use librdmacm work?

Let me clarify -- with V5 it doesn't matter how the application does
address resolution in the 1st place. The kernel uverbs layer is
provided with local/remote GIDs in the modify qp uverb entry and for
Ethernet ports issues address resolution through the relevant
netdevice etc. This is works the same for applications that use
librdmacm and for applications who don't.

With your comment/insight, we will move that small logic within the
ib_core module from uverbs to verbs.c which means this step will be
applied when needed on kernel non rdma-cm consumers too such as SRP
which you referred too below.

When needed means when the relevant qp attributes (== L2 ethernet
construcsts, source/destination MACs, and vlan ID) are missing. Kernel
rdma-cm consumers would have these fill in their qp attr since its
filled by the rdma-cm / ib-addr module throughout the ARP address
resolution, non rdma-cm consumers will not and the rest follows.

> Also the statement that there are no non-rdma-cm consumers in the
> kernel is definitely false -- the SRP initiator does not use IP
> addressing, and it does seem like a legitimate and useful application
> to run SRP over ethernet.

fair-enough, so with the change you proposed, this will be supported!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
