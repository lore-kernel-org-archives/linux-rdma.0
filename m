From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Thu, 7 Feb 2019 17:44:04 -0800
Message-ID: <20190208014403.GA32701@iweiny-DESK2.sc.intel.com>
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
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Dave Chinner <david@fromorbit.com>, Doug Ledford <dledford@redhat.com>, Christopher Lameter <cl@linux.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 07, 2019 at 03:54:58PM -0800, Dan Williams wrote:
> On Thu, Feb 7, 2019 at 9:17 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > Insisting to run RDMA & DAX without ODP and building an elaborate
> > revoke mechanism to support non-ODP HW is inherently baroque.
> >
> > Use the HW that supports ODP.
> >
> > Since no HW can do disable of a MR, the escalation path is SIGKILL
> > which makes it a non-production toy.
> >
> > What you keep missing is that for people doing this - the RDMA is a
> > critical compoment of the system, you can't just say the kernel will
> > randomly degrade/kill RDMA processes - that is a 'toy' configuration
> > that is not production worthy.
> >
> > Especially since this revoke idea is basically a DOS engine for the
> > RDMA protocol if another process can do actions to trigger revoke. Now
> > we have a new class of security problems. (again, screams non
> > production toy)
> >
> > The only production worthy way is to have the FS be a partner in
> > making this work without requiring revoke, so the critical RDMA
> > traffic can operate safely.
> >
> > Otherwise we need to stick to ODP.
> 
> Thanks for this it clears a lot of things up for me...
> 
> ...but this statement:
> 
> > The only production worthy way is to have the FS be a partner in
> > making this work without requiring revoke, so the critical RDMA
> > traffic can operate safely.
> 
> ...belies a path forward. Just swap out "FS be a partner" with "system
> administrator be a partner". In other words, If the RDMA stack can't
> tolerate an MR being disabled then the administrator needs to actively
> disable the paths that would trigger it. Turn off reflink, don't
> truncate, avoid any future FS feature that might generate unwanted
> lease breaks. We would need to make sure that lease notifications
> include the information to identify the lease breaker to debug escapes
> that might happen, but it is a solution that can be qualified to not
> lease break. In any event, this lets end users pick their filesystem
> (modulo RDMA incompatible features), provides an enumeration of lease
> break sources in the kernel, and opens up FS-DAX to a wider array of
> RDMA adapters. In general this is what Linux has historically done,
> give end users technology freedom.

To back off the details of this thread a bit...

The details of limitations imposed and how they would be tracked within the
kernel would be a great thing to discuss face to face.  Hence the reason for my
proposal as a topic.

Ira
