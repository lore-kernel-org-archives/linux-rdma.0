From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] Isolate common list remove code
Date: Mon, 21 Dec 2015 09:08:39 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1512210907220.18345@east.gentwo.org>
References: <20151221144252.575119561@linux.com> <20151221144303.357400814@linux.com> <20151221145712.GA11603@leon.nu>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151221145712.GA11603-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 21 Dec 2015, Leon Romanovsky wrote:

> On Mon, Dec 21, 2015 at 08:42:53AM -0600, Christoph Lameter wrote:
> > Code cleanup to remove multicast specific code from ipoib_main.c
> >
> > The removal of a list of multicast groups occurs in three places.
> > Create a new function ipoib_mcast_remove_list(). Use this new
> > function in ipoib_main.c too.
> > That in turn allows the dropping of two functions that were
> > exported from ipoib_multicast.c for expiration of mc groups.
> >
> > Reviewed-by: Iraq Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Iraq Weiny --> Ira Weiny

Ohh.. Bad typo.

> > +void ipoib_mcast_remove_list(struct net_device *dev, struct list_head *remove_list)
> Will it be beneficial to inline this function?

As far as I know it is not run in a latency critical context and the code
is too heavy for that. In particular we are calling other functions that
are not inlined.

> > +{
> > +	struct ipoib_mcast *mcast, *tmcast;
> > +
> > +	list_for_each_entry_safe(mcast, tmcast, remove_list, list) {
> > +		ipoib_mcast_leave(dev, mcast);
> > +		ipoib_mcast_free(mcast);
> > +	}
> > +}
> > +
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
