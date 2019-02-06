From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Wed, 6 Feb 2019 15:08:28 -0700
Message-ID: <20190206220828.GJ12227@ziepe.ca>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
 <20190206095000.GA12006@quack2.suse.cz>
 <20190206173114.GB12227@ziepe.ca>
 <20190206175233.GN21860@bombadil.infradead.org>
 <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
 <20190206210356.GZ6173@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190206210356.GZ6173@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Christopher Lameter <cl@linux.com>, Doug Ledford <dledford@redhat.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 07, 2019 at 08:03:56AM +1100, Dave Chinner wrote:
> On Wed, Feb 06, 2019 at 07:16:21PM +0000, Christopher Lameter wrote:
> > On Wed, 6 Feb 2019, Doug Ledford wrote:
> > 
> > > > Most of the cases we want revoke for are things like truncate().
> > > > Shouldn't happen with a sane system, but we're trying to avoid users
> > > > doing awful things like being able to DMA to pages that are now part of
> > > > a different file.
> > >
> > > Why is the solution revoke then?  Is there something besides truncate
> > > that we have to worry about?  I ask because EBUSY is not currently
> > > listed as a return value of truncate, so extending the API to include
> > > EBUSY to mean "this file has pinned pages that can not be freed" is not
> > > (or should not be) totally out of the question.
> > >
> > > Admittedly, I'm coming in late to this conversation, but did I miss the
> > > portion where that alternative was ruled out?
> > 
> > Coming in late here too but isnt the only DAX case that we are concerned
> > about where there was an mmap with the O_DAX option to do direct write
> > though? If we only allow this use case then we may not have to worry about
> > long term GUP because DAX mapped files will stay in the physical location
> > regardless.
> 
> No, that is not guaranteed. Soon as we have reflink support on XFS,
> writes will physically move the data to a new physical location.
> This is non-negotiatiable, and cannot be blocked forever by a gup
> pin.
> 
> IOWs, DAX on RDMA requires a) page fault capable hardware so that
> the filesystem can move data physically on write access, and b)
> revokable file leases so that the filesystem can kick userspace out
> of the way when it needs to.

Why do we need both? You want to have leases for normal CPU mmaps too?

> Truncate is a red herring. It's definitely a case for revokable
> leases, but it's the rare case rather than the one we actually care
> about. We really care about making copy-on-write capable filesystems like
> XFS work with DAX (we've got people asking for it to be supported
> yesterday!), and that means DAX+RDMA needs to work with storage that
> can change physical location at any time.

Then we must continue to ban longterm pin with DAX..

Nobody is going to want to deploy a system where revoke can happen at
any time and if you don't respond fast enough your system either locks
with some kind of FS meltdown or your process gets SIGKILL. 

I don't really see a reason to invest so much design work into
something that isn't production worthy.

It *almost* made sense with ftruncate, because you could architect to
avoid ftruncate.. But just any FS op might reallocate? Naw.

Dave, you said the FS is responsible to arbitrate access to the
physical pages..

Is it possible to have a filesystem for DAX that is more suited to
this environment? Ie designed to not require block reallocation (no
COW, no reflinks, different approach to ftruncate, etc)

> And that's the real problem we need to solve here. RDMA has no trust
> model other than "I'm userspace, I pinned you, trust me!". That's
> not good enough for FS-DAX+RDMA....

It is baked into the silicon, and I don't see much motion on this
front right now. My best hope is that IOMMU PASID will get widely
deployed and RDMA silicon will arrive that can use it. Seems to be
years away, if at all.

At least we have one chip design that can work in a page faulting mode
..

Jason
