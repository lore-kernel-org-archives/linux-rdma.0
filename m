From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/mthca: Fix how mthca_map_user_db() calls gup
Date: Thu, 25 Jan 2018 10:50:48 -0700
Message-ID: <20180125175048.GG10706@ziepe.ca>
References: <20180123205459.432-1-dave@stgolabs.net>
 <1516898063.27592.136.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1516898063.27592.136.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>, roland@purestorage.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 25, 2018 at 11:34:23AM -0500, Doug Ledford wrote:
> > - Should I be wrong about no callers already holding mmap_sem,
> >   I still think calling gup without the mutex makes sense for
> >   improved paralellism. Now, if callers can hold the mmap_sem,
> >   it's wrong to do copy_from_user right before calling mthca_map_user_db.
> 
> So, if I understand you correctly, we (well, you and Al would be more
> correct, we haven't looked into the situation yet, so Mellanox people
> that worked on this in the day might now, or someone taking the time to
> research it could find out) don't have a clear understanding of all the
> conditions this function is called under, and so we actually don't know
> what the best way forward is to fix it?

I looked at it enough to be confident that mthca_map_user_db is never
called with mmap_sem held.

Also pretty confident that mthca_unmap_user_db is never called with
mmap_sem.

So how about just grabbing mmap_sem around the call to get_user_pages
and no other changes?

Jason
