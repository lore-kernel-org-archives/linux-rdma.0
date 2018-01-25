From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH] IB/mthca: Fix how mthca_map_user_db() calls gup
Date: Thu, 25 Jan 2018 11:53:30 -0700
Message-ID: <20180125185330.GH10706@ziepe.ca>
References: <20180123205459.432-1-dave@stgolabs.net>
 <1516898063.27592.136.camel@redhat.com>
 <20180125175048.GG10706@ziepe.ca>
 <1516903584.27592.183.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516903584.27592.183.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Davidlohr Bueso <dbueso-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 25, 2018 at 01:06:24PM -0500, Doug Ledford wrote:
> On Thu, 2018-01-25 at 10:50 -0700, Jason Gunthorpe wrote:
> > On Thu, Jan 25, 2018 at 11:34:23AM -0500, Doug Ledford wrote:
> > > > - Should I be wrong about no callers already holding mmap_sem,
> > > >   I still think calling gup without the mutex makes sense for
> > > >   improved paralellism. Now, if callers can hold the mmap_sem,
> > > >   it's wrong to do copy_from_user right before calling mthca_map_user_db.
> > > 
> > > So, if I understand you correctly, we (well, you and Al would be more
> > > correct, we haven't looked into the situation yet, so Mellanox people
> > > that worked on this in the day might now, or someone taking the time to
> > > research it could find out) don't have a clear understanding of all the
> > > conditions this function is called under, and so we actually don't know
> > > what the best way forward is to fix it?
> > 
> > I looked at it enough to be confident that mthca_map_user_db is never
> > called with mmap_sem held.
> > 
> > Also pretty confident that mthca_unmap_user_db is never called with
> > mmap_sem.
> > 
> > So how about just grabbing mmap_sem around the call to get_user_pages
> > and no other changes?
> 
> Since the original post was referred to an ABBA deadlock, wouldn't we
> have to drop db_tab->mutex, then grab both in the proper order?

I had understood that was only a concern because Davidlohr was having
trouble proving the callchain didn't include mmap_sem already..

I can see the call chain all ends on verbs ops, and I know verbs ops
with ucontext's are never called under mmap_sem by the core code..

Jason


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
