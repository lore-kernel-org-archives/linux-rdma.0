From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Wed, 6 Feb 2019 22:00:28 -0800
Message-ID: <CAPcyv4jd4gxvt3faYYRbv5gkc6NGOKjY_Z-P0Ph=ss=gWZw7sA@mail.gmail.com>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
 <20190206095000.GA12006@quack2.suse.cz> <20190206173114.GB12227@ziepe.ca>
 <20190206175233.GN21860@bombadil.infradead.org> <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
 <20190206210356.GZ6173@dastard> <20190206220828.GJ12227@ziepe.ca>
 <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
 <20190207035258.GD6173@dastard> <20190207052310.GA22726@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190207052310.GA22726@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dave Chinner <david@fromorbit.com>, Doug Ledford <dledford@redhat.com>, Christopher Lameter <cl@linux.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 6, 2019 at 9:23 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Thu, Feb 07, 2019 at 02:52:58PM +1100, Dave Chinner wrote:
> > On Wed, Feb 06, 2019 at 05:24:50PM -0500, Doug Ledford wrote:
> > > On Wed, 2019-02-06 at 15:08 -0700, Jason Gunthorpe wrote:
> > > > On Thu, Feb 07, 2019 at 08:03:56AM +1100, Dave Chinner wrote:
> > > > > On Wed, Feb 06, 2019 at 07:16:21PM +0000, Christopher Lameter wrote:
> > > > > > On Wed, 6 Feb 2019, Doug Ledford wrote:
> > > > > >
> > > > > > > > Most of the cases we want revoke for are things like truncate().
> > > > > > > > Shouldn't happen with a sane system, but we're trying to avoid users
> > > > > > > > doing awful things like being able to DMA to pages that are now part of
> > > > > > > > a different file.
> > > > > > >
> > > > > > > Why is the solution revoke then?  Is there something besides truncate
> > > > > > > that we have to worry about?  I ask because EBUSY is not currently
> > > > > > > listed as a return value of truncate, so extending the API to include
> > > > > > > EBUSY to mean "this file has pinned pages that can not be freed" is not
> > > > > > > (or should not be) totally out of the question.
> > > > > > >
> > > > > > > Admittedly, I'm coming in late to this conversation, but did I miss the
> > > > > > > portion where that alternative was ruled out?
> > > > > >
> > > > > > Coming in late here too but isnt the only DAX case that we are concerned
> > > > > > about where there was an mmap with the O_DAX option to do direct write
> > > > > > though? If we only allow this use case then we may not have to worry about
> > > > > > long term GUP because DAX mapped files will stay in the physical location
> > > > > > regardless.
> > > > >
> > > > > No, that is not guaranteed. Soon as we have reflink support on XFS,
> > > > > writes will physically move the data to a new physical location.
> > > > > This is non-negotiatiable, and cannot be blocked forever by a gup
> > > > > pin.
> > > > >
> > > > > IOWs, DAX on RDMA requires a) page fault capable hardware so that
> > > > > the filesystem can move data physically on write access, and b)
> > > > > revokable file leases so that the filesystem can kick userspace out
> > > > > of the way when it needs to.
> > > >
> > > > Why do we need both? You want to have leases for normal CPU mmaps too?
> >
> > We don't need them for normal CPU mmaps because that's locally
> > addressable page fault capable hardware. i.e. if we need to
> > serialise something, we just use kernel locks, etc. When it's a
> > remote entity (such as RDMA) we have to get that remote entity to
> > release it's reference/access so the kernel has exclusive access
> > to the resource it needs to act on.
>
> Why can't DAX follow the path of GPU? Jerome has been working on
> patches that let GPU do page migrations and other activities and
> maintain full sync with ODP MRs.
>
> I don't know of a reason why DAX migration would be different from GPU
> migration.

I don't think we need leases in the ODP case.

> The ODP RDMA HW does support halting RDMA access and interrupting the
> CPU to re-establish access, so you can get your locks/etc as. With
> today's implemetnation DAX has to trigger all the needed MM notifier
> call backs to make this work. Tomorrow it will have to interact with
> the HMM mirror API.
>
> Jerome is already demoing this for the GPU case, so the RDMA ODP HW is
> fine.
>
> Is DAX migration different in some way from GPU's migration that it
> can't use this flow and needs a lease to??? This would be a big
> surprise to me.

Agree, I see no need for leases in the ODP case the mmu_notifier is
already fulfilling the same role as a lease notification.

> > If your argument is that "existing RDMA apps don't have a recall
> > mechanism" then that's what they are going to need to implement to
> > work with DAX+RDMA. Reliable remote access arbitration is required
> > for DAX+RDMA, regardless of what filesysetm the data is hosted on.
>
> My argument is that is a toy configuration that no production user
> would use. It either has the ability to wait for the lease to revoke
> 'forever' without consequence or the application will be critically
> de-stablized by the kernel's escalation to time bound the response.
> (or production systems never get revoke)

I think we're off track on the need for leases for anything other than
non-ODP hardware.

Otherwise this argument seems to be saying there is absolutely no safe
way to recall a memory registration from hardware, which does not make
sense because SIGKILL needs to work as a last resort.

> > Anything less is a potential security hole.
>
> How does it get to a security hole? Obviously the pages under DMA
> can't be re-used for anything..

Writes to storage outside the security domain they were intended due
to the filesystem reallocating the physical blocks.

> > Once we have reflink on DAX, somebody is going to ask for
> > no-compromise RDMA support on these filesystems (e.g. NFSv4 file
> > server on pmem/FS-DAX that allows server side clones and clients use
> > RDMA access) and we're going to have to work out how to support it.
> > Rather than shouting at the messenger (XFS) that reports the hard
> > problems we have to solve, how about we work out exactly what we
> > need to do to support this functionality because it is coming and
> > people want it.
>
> I've thought this was basically solved - use ODP and you get full
> functionality.  Until you just now brought up the idea that ODP is
> not enough..

I think that was a misunderstanding, I struggle to see how a driver
that agrees to be bound by mmu notifications (ODP) has any problems
with anything the filesystem wants to do with the mapping. My
assumption is that ODP == filesystem can invalidate mappings at will
and all is good.

> The arguing here is that there is certainly a subset of people that
> don't want to use ODP. If we tell them a hard 'no' then the
> conversation is done.

Again, SIGKILL must work the RDMA target can't survive that, so it's
not impossible, or are you saying not even SIGKILL can guarantee an
RDMA registration goes idle? Then I can see that "hard no" having real
teeth otherwise it's a matter of software.

> Otherwise, I like the idea of telling them to use a less featureful
> XFS configuration that is 'safe' for non-ODP cases. The kernel has a
> long history of catering to certain configurations by limiting
> functionality or performance.

That's an unsustainable maintenance burden for the filesystem, just
keep the status quo of failing the registration at that point or
requiring a filesystem to not be used.

> I don't like the idea of building toy leases just for this one,
> arguably baroque, case.

What makes it a toy and baroque? Outside of RDMA registrations being
irretrievable I have a gap in my understanding of what makes this
pointless to even attempt?

> > Requiring ODP capable hardware and applications that control RDMA
> > access to use file leases and be able to cancel/recall client side
> > delegations (like NFS is already able to do!) seems like a pretty
>
> So, what happens on NFS if the revoke takes too long?
>
> Jason
