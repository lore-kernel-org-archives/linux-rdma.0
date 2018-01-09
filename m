From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next v2 0/7] RDMA resource tracking
Date: Tue, 9 Jan 2018 09:24:53 -0600
Message-ID: <00e001d3895d$ffb85270$ff28f750$@opengridcomputing.com>
References: <20180102081832.5264-1-leon@kernel.org> <0bdd01d388c2$c1d79380$4586ba80$@opengridcomputing.com> <20180109075344.GD6823@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180109075344.GD6823-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Jason Gunthorpe' <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Mark Bloch' <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Mon, Jan 08, 2018 at 02:53:38PM -0600, Steve Wise wrote:
> > >
> > > Changelog:
> > > v1->v2:
> > >  * Rebased on latest rdma/for-next
> > >  * Replaced mutex lock which protect linked lists to be RW semaphore.
> > >    It has no impact on current implementation, because there is only
one
> > >    reader (nldev) and it is serialized. However better to be prepared
> > >    for multiple readers from the beginning.
> > >  * Added reinitialization next QP entry logic to ensure that it exists
> > >    and didn't vanish during fill_req_qp() work.
> > > v0->v1:
> > >  * Dropped RFC
> > >  * Separated to thre series, one for for-rc, and two for-next.
> >
> > Hey Leon,
> >
> > This series looks good to me.
> >
> > Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> >
> 
> Thanks a lot.>

You're welcome!  I'm planning on using this as a starting point for
qp/cq/connection state dumps for iw_cxgb4 objects.  This allows gathering
key state when debugging stalls/hangs/etc.  So I'm hoping this can get
integrated soon, so we can add to it going forward.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
