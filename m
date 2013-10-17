From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] IB/netlink: remove superfluous RDMA_NL_GET_OP() masking
Date: Thu, 17 Oct 2013 21:18:44 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237388CE2B58@ORSMSX109.amr.corp.intel.com>
References: <1380571434-15391-1-git-send-email-minipli@googlemail.com>
 <CA+rthh87D+yLE-nTQwVG-LGar_e8sYUKievWUnmk30RH-q7=GA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+rthh87D+yLE-nTQwVG-LGar_e8sYUKievWUnmk30RH-q7=GA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > 'op' is the already RDMA_NL_GET_OP() masked 'type'. No need to mask it
> > again.
> >
> > Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>

Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> > ---
> >  drivers/infiniband/core/netlink.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/core/netlink.c
> b/drivers/infiniband/core/netlink.c
> > index da06abd..a1e9cba 100644
> > --- a/drivers/infiniband/core/netlink.c
> > +++ b/drivers/infiniband/core/netlink.c
> > @@ -148,7 +148,7 @@ static int ibnl_rcv_msg(struct sk_buff *skb, struct
> nlmsghdr *nlh)
> >         list_for_each_entry(client, &client_list, list) {
> >                 if (client->index == index) {
> >                         if (op < 0 || op >= client->nops ||
> > -                           !client->cb_table[RDMA_NL_GET_OP(op)].dump)
> > +                           !client->cb_table[op].dump)
> >                                 return -EINVAL;
> >
> >                         {
> > --
> > 1.7.10.4
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
