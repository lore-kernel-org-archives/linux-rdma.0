From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Thu, 7 Feb 2019 23:20:37 -0800
Message-ID: <CAPcyv4jWnkHxBcU2_Pz99wM02RYab4y25hu_qUE8KCVArYxCeg@mail.gmail.com>
References: <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
 <20190206210356.GZ6173@dastard> <20190206220828.GJ12227@ziepe.ca>
 <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
 <20190207035258.GD6173@dastard> <20190207052310.GA22726@ziepe.ca>
 <CAPcyv4jd4gxvt3faYYRbv5gkc6NGOKjY_Z-P0Ph=ss=gWZw7sA@mail.gmail.com>
 <20190207171736.GD22726@ziepe.ca> <CAPcyv4hsHeCGjcJNEmMg_6FYEsQ_8Z=bvx+WmO1v_LmoXbJrxA@mail.gmail.com>
 <20190208051950.GA4283@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190208051950.GA4283@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dave Chinner <david@fromorbit.com>, Doug Ledford <dledford@redhat.com>, Christopher Lameter <cl@linux.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 7, 2019 at 9:19 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Thu, Feb 07, 2019 at 03:54:58PM -0800, Dan Williams wrote:
>
> > > The only production worthy way is to have the FS be a partner in
> > > making this work without requiring revoke, so the critical RDMA
> > > traffic can operate safely.
> >
> > ...belies a path forward. Just swap out "FS be a partner" with "system
> > administrator be a partner". In other words, If the RDMA stack can't
> > tolerate an MR being disabled then the administrator needs to actively
> > disable the paths that would trigger it. Turn off reflink, don't
> > truncate, avoid any future FS feature that might generate unwanted
> > lease breaks.
>
> This is what I suggested already, except with explicit kernel aid, not
> left as some gordian riddle for the administrator to unravel.

It's a riddle either way. "Why is my truncate failing?"

The lease path allows the riddle to be solved in a way that moves the
ecosystem forwards. It provides a mechanism to notify (effectively mmu
notifers plumbed to userspace), an opportunity for capable RDMA apps /
drivers to do better than SIGKILL, and a path for filesystems to
continue to innovate and not make users choose filesystems just on the
chance they might need to do RDMA.

> You already said it is too hard for expert FS developers to maintain a
> mode switch

I do disagree with a truncate behavior switch, but reflink already has
a mkfs switch so it's obviously possible for any future feature that
might run afoul of the RDMA restrictions to have fs-feature control.

> , it seems like a really big stretch to think application
> and systems architects will have any hope to do better.

Certainly they can, it's just a matter of documenting options. It can
be made easier if we can get commonly named options across filesystems
to disable lease dependent functionality.

> It makes much more sense for the admin to flip some kind of bit and
> the FS guarentees the safety that you are asking the admin to create.

Flipping the bit changes the ABI contract in backwards incompatible
ways. I'm saying go the other way, audit the configuration for legacy
RDMA safety.

> > We would need to make sure that lease notifications include the
> > information to identify the lease breaker to debug escapes that
> > might happen, but it is a solution that can be qualified to not
> > lease break.
>
> I think building a complicated lease framework and then telling
> everyone in user space to design around it so it never gets used would
> be very hard to explain and justify.

There is no requirement to design around it. If an RDMA-implementation
doesn't use it the longterm-GUPs are already blocked. If the
implementation does use it, but fails to service lease breaks it gets
SIGKILL with information of what lead to the SIGKILL so the
configuration can be fixed. Implementations that want to do better
have an opportunity to be a partner to the filesytem and repair the
MR.

> Never mind the security implications if some seemingly harmless future
> filesystem change causes unexpected lease revokes across something
> like a tenant boundary.

Fileystems innovate quickly, but not that quickly. Ongoing
communication between FS and RDMA developers is not insurmountable.

> > In any event, this lets end users pick their filesystem
> > (modulo RDMA incompatible features), provides an enumeration of
> > lease break sources in the kernel, and opens up FS-DAX to a wider
> > array of RDMA adapters. In general this is what Linux has
> > historically done, give end users technology freedom.
>
> I think this is not the Linux model. The kernel should not allow
> unpriv user space to do an operation that could be unsafe.

There's permission to block unprivileged writes/truncates to a file,
otherwise I'm missing what hole is being opened? That said, the horse
already left the barn. Linux has already shipped in the page-cache
case "punch hole in the middle of a MR succeeds and leaves the state
of the file relative to ongoing RDMA inconsistent". Now that we know
about the bug the question is how do we do better than the current
status quo of taking all of the functionality away.

> I continue to think this is is the best idea that has come up - but
> only if the filesystem is involved and expressly tells the kernel
> layers that this combination of DAX & filesystem is safe.

I think we're getting into "need to discuss at LSF/MM territory",
because the concept of "DAX safety", or even DAX as an explicit FS
capability has been a point of contention since day one. We're trying
change DAX to be defined by mmap API flags like MAP_SYNC and maybe
MAP_DIRECT in the future.

For example, if the MR was not established to a MAP_SYNC vma then the
kernel should be free to indirect the RDMA through the page-cache like
the typical non-DAX case. DAX as a global setting is too coarse.
