From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH RFC 00/10] RDMA/FS DAX truncate proposal
Date: Thu, 13 Jun 2019 10:55:52 +1000
Message-ID: <20190613005552.GI14363@dread.disaster.area>
References: <20190606014544.8339-1-ira.weiny@intel.com>
 <20190606104203.GF7433@quack2.suse.cz>
 <20190606220329.GA11698@iweiny-DESK2.sc.intel.com>
 <20190607110426.GB12765@quack2.suse.cz>
 <20190607182534.GC14559@iweiny-DESK2.sc.intel.com>
 <20190608001036.GF14308@dread.disaster.area>
 <20190612123751.GD32656@bombadil.infradead.org>
 <20190612233024.GD14336@iweiny-DESK2.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20190612233024.GD14336-J5EW/p2F9lUlb2qzJQmr9q2pdiUAq4bhAL8bYrjMMd8@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 12, 2019 at 04:30:24PM -0700, Ira Weiny wrote:
> On Wed, Jun 12, 2019 at 05:37:53AM -0700, Matthew Wilcox wrote:
> > On Sat, Jun 08, 2019 at 10:10:36AM +1000, Dave Chinner wrote:
> > > On Fri, Jun 07, 2019 at 11:25:35AM -0700, Ira Weiny wrote:
> > > > Are you suggesting that we have something like this from user space?
> > > > 
> > > > 	fcntl(fd, F_SETLEASE, F_LAYOUT | F_UNBREAKABLE);
> > > 
> > > Rather than "unbreakable", perhaps a clearer description of the
> > > policy it entails is "exclusive"?
> > > 
> > > i.e. what we are talking about here is an exclusive lease that
> > > prevents other processes from changing the layout. i.e. the
> > > mechanism used to guarantee a lease is exclusive is that the layout
> > > becomes "unbreakable" at the filesystem level, but the policy we are
> > > actually presenting to uses is "exclusive access"...
> > 
> > That's rather different from the normal meaning of 'exclusive' in the
> > context of locks, which is "only one user can have access to this at
> > a time".  As I understand it, this is rather more like a 'shared' or
> > 'read' lock.  The filesystem would be the one which wants an exclusive
> > lock, so it can modify the mapping of logical to physical blocks.
> > 
> > The complication being that by default the filesystem has an exclusive
> > lock on the mapping, and what we're trying to add is the ability for
> > readers to ask the filesystem to give up its exclusive lock.
> 
> This is an interesting view...
> 
> And after some more thought, exclusive does not seem like a good name for this
> because technically F_WRLCK _is_ an exclusive lease...
> 
> In addition, the user does not need to take the "exclusive" write lease to be
> notified of (broken by) an unexpected truncate.  A "read" lease is broken by
> truncate.  (And "write" leases really don't do anything different WRT the
> interaction of the FS and the user app.  Write leases control "exclusive"
> access between other file descriptors.)

I've been assuming that there is only one type of layout lease -
there is no use case I've heard of for read/write layout leases, and
like you say there is zero difference in behaviour at the filesystem
level - they all have to be broken to allow a non-lease truncate to
proceed.

IMO, taking a "read lease" to be able to modify and write to the
underlying mapping of a file makes absolutely no sense at all.
IOWs, we're talking exaclty about a revokable layout lease vs an
exclusive layout lease here, and so read/write really doesn't match
the policy or semantics we are trying to provide.

> Another thing to consider is that this patch set _allows_ a truncate/hole punch
> to proceed _if_ the pages being affected are not actually pinned.  So the
> unbreakable/exclusive nature of the lease is not absolute.

If you're talking about the process that owns the layout lease
running the truncate, then that is fine.

However, if you are talking about a process that does not own the
layout lease being allowed to truncate a file without first breaking
the layout lease, then that is fundamentally broken.

i.e. If you don't own a layout lease, the layout leases must be
broken before the truncate can proceed. If it's an exclusive lease,
then you cannot break the lease and the truncate *must fail before
it is started*. i.e.  the layout lease state must be correctly
resolved before we start an operation that may modify a file layout.

Determining if we can actually do the truncate based on page state
occurs /after/ the lease says the truncate can proceed....

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
