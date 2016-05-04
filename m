From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/4] IB/core: Remove unnecessary check in
 ibnl_rcv_msg
Date: Wed, 4 May 2016 17:35:11 -0400
Message-ID: <20160504213511.GC10115@rhel.ra.intel.com>
References: <1462340165-16067-1-git-send-email-leon@kernel.org>
 <1462340165-16067-3-git-send-email-leon@kernel.org>
 <019a01d1a61a$d29cffc0$77d6ff40$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <019a01d1a61a$d29cffc0$77d6ff40$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 04, 2016 at 10:37:10AM -0500, Steve Wise wrote:
> 
> 
> > 
> > From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > 
> > RDMA_NL_GET_OP is defined like this: (type & ((1 << 10) - 1))
> > which means op (defined as an int) can never be a negative number.
> > 
> > Fixes: b2cbae2c2487 ('RDMA: Add netlink infrastructure')
> > Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/infiniband/core/netlink.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff --git a/drivers/infiniband/core/netlink.c
> b/drivers/infiniband/core/netlink.c
> > index d47df93..aa491f7 100644
> > --- a/drivers/infiniband/core/netlink.c
> > +++ b/drivers/infiniband/core/netlink.c
> > @@ -155,8 +155,7 @@ static int ibnl_rcv_msg(struct sk_buff *skb, struct
> nlmsghdr
> > *nlh)
> > 
> >  	list_for_each_entry(client, &client_list, list) {
> >  		if (client->index == index) {
> > -			if (op < 0 || op >= client->nops ||
> > -			    !client->cb_table[op].dump)
> > +			if (op >= client->nops || !client->cb_table[op].dump)
> >  				return -EINVAL;
> > 
> >  			/*
> 
> Should op be made unsigned as well?  That would make it clearer.

I was going to make the same comment.

Ira

> 
> Steve.
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
