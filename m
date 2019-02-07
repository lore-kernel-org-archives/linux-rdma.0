From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Thu, 7 Feb 2019 10:17:36 -0700
Message-ID: <20190207171736.GD22726@ziepe.ca>
References: <20190206173114.GB12227@ziepe.ca>
 <20190206175233.GN21860@bombadil.infradead.org>
 <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
 <20190206210356.GZ6173@dastard>
 <20190206220828.GJ12227@ziepe.ca>
 <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
 <20190207035258.GD6173@dastard>
 <20190207052310.GA22726@ziepe.ca>
 <CAPcyv4jd4gxvt3faYYRbv5gkc6NGOKjY_Z-P0Ph=ss=gWZw7sA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4jd4gxvt3faYYRbv5gkc6NGOKjY_Z-P0Ph=ss=gWZw7sA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>, Doug Ledford <dledford@redhat.com>, Christopher Lameter <cl@linux.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 06, 2019 at 10:00:28PM -0800, Dan Williams wrote:

> > > If your argument is that "existing RDMA apps don't have a recall
> > > mechanism" then that's what they are going to need to implement to
> > > work with DAX+RDMA. Reliable remote access arbitration is required
> > > for DAX+RDMA, regardless of what filesysetm the data is hosted on.
> >
> > My argument is that is a toy configuration that no production user
> > would use. It either has the ability to wait for the lease to revoke
> > 'forever' without consequence or the application will be critically
> > de-stablized by the kernel's escalation to time bound the response.
> > (or production systems never get revoke)
> 
> I think we're off track on the need for leases for anything other than
> non-ODP hardware.
> 
> Otherwise this argument seems to be saying there is absolutely no safe
> way to recall a memory registration from hardware, which does not make
> sense because SIGKILL needs to work as a last resort.

SIGKILL destroys all the process's resources. This is supported.

You are asking for some way to do a targeted *disablement* (we can't
do destroy) of a single resource.

There is an optional operation that could do what you want
'rereg_user_mr'- however only 3 out of 17 drivers implement it, one of
those drivers supports ODP, and one is supporting old hardware nearing
its end of life.

Of the two that are left, it looks like you might be able to use
IB_MR_REREG_PD to basically disable the MR. Maybe. The spec for this
API is not as a fence - the application is supposed to quiet traffic
before invoking it. So even if it did work, it may not be synchronous
enough to be safe for DAX.

But lets imagine the one driver where this is relavents gets updated
FW that makes this into a fence..

Then the application's communication would more or less explode in a
very strange and unexpected way, but perhaps it could learn to put the
pieces back together, reconnect and restart from scratch.

So, we could imagine doing something here, but it requires things we
don't have, more standardization, and drivers to implement new
functionality. This is not likely to happen.

Thus any lease mechanism is essentially stuck with SIGKILL as the
escalation.

> > The arguing here is that there is certainly a subset of people that
> > don't want to use ODP. If we tell them a hard 'no' then the
> > conversation is done.
> 
> Again, SIGKILL must work the RDMA target can't survive that, so it's
> not impossible, or are you saying not even SIGKILL can guarantee an
> RDMA registration goes idle? Then I can see that "hard no" having real
> teeth otherwise it's a matter of software.

Resorting to SIGKILL makes this into a toy, no real production user
would operate in that world.

> > I don't like the idea of building toy leases just for this one,
> > arguably baroque, case.
> 
> What makes it a toy and baroque? Outside of RDMA registrations being
> irretrievable I have a gap in my understanding of what makes this
> pointless to even attempt?

Insisting to run RDMA & DAX without ODP and building an elaborate
revoke mechanism to support non-ODP HW is inherently baroque. 

Use the HW that supports ODP.

Since no HW can do disable of a MR, the escalation path is SIGKILL
which makes it a non-production toy.

What you keep missing is that for people doing this - the RDMA is a
critical compoment of the system, you can't just say the kernel will
randomly degrade/kill RDMA processes - that is a 'toy' configuration
that is not production worthy.

Especially since this revoke idea is basically a DOS engine for the
RDMA protocol if another process can do actions to trigger revoke. Now
we have a new class of security problems. (again, screams non
production toy)

The only production worthy way is to have the FS be a partner in
making this work without requiring revoke, so the critical RDMA
traffic can operate safely.

Otherwise we need to stick to ODP.

Jason
