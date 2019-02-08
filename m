From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Thu, 7 Feb 2019 22:19:50 -0700
Message-ID: <20190208051950.GA4283@ziepe.ca>
References: <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
 <20190206210356.GZ6173@dastard>
 <20190206220828.GJ12227@ziepe.ca>
 <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
 <20190207035258.GD6173@dastard>
 <20190207052310.GA22726@ziepe.ca>
 <CAPcyv4jd4gxvt3faYYRbv5gkc6NGOKjY_Z-P0Ph=ss=gWZw7sA@mail.gmail.com>
 <20190207171736.GD22726@ziepe.ca>
 <CAPcyv4hsHeCGjcJNEmMg_6FYEsQ_8Z=bvx+WmO1v_LmoXbJrxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4hsHeCGjcJNEmMg_6FYEsQ_8Z=bvx+WmO1v_LmoXbJrxA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, Doug Ledford <dledford@redhat.com>, Christopher Lameter <cl@linux.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 07, 2019 at 03:54:58PM -0800, Dan Williams wrote:

> > The only production worthy way is to have the FS be a partner in
> > making this work without requiring revoke, so the critical RDMA
> > traffic can operate safely.
> 
> ...belies a path forward. Just swap out "FS be a partner" with "system
> administrator be a partner". In other words, If the RDMA stack can't
> tolerate an MR being disabled then the administrator needs to actively
> disable the paths that would trigger it. Turn off reflink, don't
> truncate, avoid any future FS feature that might generate unwanted
> lease breaks. 

This is what I suggested already, except with explicit kernel aid, not
left as some gordian riddle for the administrator to unravel.

You already said it is too hard for expert FS developers to maintain a
mode switch, it seems like a really big stretch to think application
and systems architects will have any hope to do better.

It makes much more sense for the admin to flip some kind of bit and
the FS guarentees the safety that you are asking the admin to create.

> We would need to make sure that lease notifications include the
> information to identify the lease breaker to debug escapes that
> might happen, but it is a solution that can be qualified to not
> lease break. 

I think building a complicated lease framework and then telling
everyone in user space to design around it so it never gets used would
be very hard to explain and justify.

Never mind the security implications if some seemingly harmless future
filesystem change causes unexpected lease revokes across something
like a tenant boundary.

> In any event, this lets end users pick their filesystem
> (modulo RDMA incompatible features), provides an enumeration of
> lease break sources in the kernel, and opens up FS-DAX to a wider
> array of RDMA adapters. In general this is what Linux has
> historically done, give end users technology freedom.

I think this is not the Linux model. The kernel should not allow
unpriv user space to do an operation that could be unsafe.

I continue to think this is is the best idea that has come up - but
only if the filesystem is involved and expressly tells the kernel
layers that this combination of DAX & filesystem is safe.

Jason
