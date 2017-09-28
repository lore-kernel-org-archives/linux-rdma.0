From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-4.14-rc] RDMA/netlink: Restore nlmsg_len calculation
 in ibnl_put_attr
Date: Thu, 28 Sep 2017 14:00:33 -0500
Message-ID: <20170928190033.GA12760@ssaleem-MOBL4.amr.corp.intel.com>
References: <20170928114953.9600-1-shiraz.saleem@intel.com>
 <20170928132457.GW2297@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170928132457.GW2297-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 28, 2017 at 04:24:57PM +0300, Leon Romanovsky wrote:
> On Thu, Sep 28, 2017 at 06:49:53AM -0500, Shiraz Saleem wrote:
> > Commit 1a1c116f3dcf removes nlmsg_len calculation in
> > ibnl_put_attr causing netlink messages to be rejected due
> > to incorrect length.
> >
> > Restore the netlink message header length calculation
> > to include the added attribute.
> >
> > Fixes: 1a1c116f3dcf ("RDMA/netlink: Simplify the put_msg and put_attr")
> > Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/infiniband/core/netlink.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> 
> The length supposed to be updated in ibnl_put_msg, where you should
> supply correct length from the beginning. The suggested way to supply
> length for unknown data is to provide NLMSG_DEFAULT_SIZE while allocating
> new netlink message.
> 
> NLMSG_DEFAULT_SIZE ensures that netlink fits into one page.
> 
> It is better to avoid messing with message length after allocations,
> especially for the attributes.
> 

Hi Leon -

It is not neccessary that the length is passed in ibnl_put_msg.

See drivers/infiniband/core/addr.c/ib_nl_ip_send_msg().  

In ib_nl_ip_send_msg() nlmsg_len is corrected using nlmsg_end,
which is typically called after attributes are added to calculate
the correct length.

The _original_ ibnl_put_attr wrapper in netlink.c achieves the same
by calculating the nlmsg_len.

One can argue that it is undesirable to calculate nlmsg_len on 
every ibnl_put_attr call. An alternate fix we could do is instead of
recalculating the length with every ibnl_put_attr call is to
add a nlmsg_end after the last ibnl_put_attr call.

Do you agree this is a reasonable solution to fix your commit?

Shiraz

 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
