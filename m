From: Dave Chinner <david@fromorbit.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Thu, 7 Feb 2019 08:31:47 +1100
Message-ID: <20190206213147.GA6173@dastard>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
 <20190205180120.GC21617@iweiny-DESK2.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190205180120.GC21617@iweiny-DESK2.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ira Weiny <ira.weiny@intel.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>, Jerome Glisse <jglisse@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Matthew Wilcox <willy@infradead.org>, Doug Ledford <dledford@redhat.com>, Michal Hocko <mhocko@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 05, 2019 at 10:01:20AM -0800, Ira Weiny wrote:
> I had an old invalid address for Jason Gunthorpe in my address book...  
> 
> Correcting his email in the thread.

Probably should have cc'd linux-fsdevel, too, but it's too late for
that now....

> On Tue, Feb 05, 2019 at 09:50:59AM -0800, 'Ira Weiny' wrote:
> > 
> > The problem: Once we have pages marked as GUP-pinned how should various
> > subsystems work with those markings.
> > 
> > The current work for John Hubbards proposed solutions (part 1 and 2) is
> > progressing.[1]  But the final part (3) of his solution is also going to take
> > some work.
> > 
> > In Johns presentation he lists 3 alternatives for gup-pinned pages:
> > 
> > 1) Hold off try_to_unmap
> > 2) Allow writeback while pinned (via bounce buffers)
> > 	[Note this will not work for DAX]
> > 3) Use a "revocable reservation" (or lease) on those pages
> > 4) Pin the blocks as busy in the FS allocator
> > 
> > The problem with lease's on pages used by RDMA is that the references to
> > these pages is not local to the machine.  Once the user has been given access
> > to the page they, through the use of a remote tokens, give a reference to that
> > page to remote nodes.  This is the core essence of RDMA, and like it or not,
> > something which is increasingly used by major Linux users.
> > 
> > Therefore we need to discuss the extent by which leases are appropriate and
> > what happens should a lease be revoked which a user does not respond to.
> > 
> > As John Hubbard put it:
> > 
> > "Other filesystem features that need to replace the page with a new one can
> > be inhibited for pages that are GUP-pinned. This will, however, alter and
> > limit some of those filesystem features. The only fix for that would be to
> > require GUP users monitor and respond to CPU page table updates. Subsystems
> > such as ODP and HMM do this, for example. This aspect of the problem is
> > still under discussion."
> > 
> > 	-- John Hubbard[2]
> > 
> > The following people have been involved in previous conversations and would be key to
> > the face to face discussion.
> > 
> > John Hubbard
> > Jan Kara
> > Dave Chinner

Just FYI, I won't be at LSFMM.

Puerto Rico is about as physically far away from me as you can get
on this planet. There's 40 hours in transit from airport to airport,
and that doesn't include the 5 hours of travel the day before (and
hence overnight stay) to be able to get to the first airport in time
for the first flight. I'm looking at a transit time - if all goes
well - of over 60 hours just to get to the conference.

And it's looks like it will be just as bad on the way back.

6 days travel for a 2 day conference makes no sense at all.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
