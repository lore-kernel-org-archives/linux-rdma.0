From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH for-rc 0/2] IB/hfi1: RC patches
Date: Tue, 11 Sep 2018 11:38:31 -0600
Message-ID: <20180911173831.GB5633@ziepe.ca>
References: <20180910143437.10122.50679.stgit@scvm10.sc.intel.com>
 <20180911151725.GA29149@ziepe.ca>
 <b462fb6d-6fd7-7898-f2b3-d3658e7132f2@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b462fb6d-6fd7-7898-f2b3-d3658e7132f2@intel.com>
Sender: stable-owner@vger.kernel.org
To: Dennis Dalessandro <dennis.dalessandro@intel.com>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 11, 2018 at 12:25:11PM -0400, Dennis Dalessandro wrote:
> On 9/11/2018 11:17 AM, Jason Gunthorpe wrote:
> > On Mon, Sep 10, 2018 at 07:53:44AM -0700, Dennis Dalessandro wrote:
> > > Hi Doug and Jason,
> > > 
> > > Here are two patches that should probably land in the RC. The first one ensures
> > > we don't index beyond the end of an array. The other is more subtle but arguably
> > > more important. The bug it fixes results in incorrect IRQ bits to be set and the
> > > result is we do not get an interrupt for an error and have to wait for another
> > > interrupt to fire to see said error.
> > > 
> > > 
> > > Dennis Dalessandro (1):
> > >        IB/hfi1: Ensure ucast_dlid access doesnt exceed bounds
> > > 
> > > Michael J. Ruhl (1):
> > >        IB/hfi1: set_intr_bits uses incorrect source for register modification
> > 
> > These don't apply to current for-rc:
> > 
> > Applying: IB/hfi1: Ensure ucast_dlid access doesnt exceed bounds
> > Applying: IB/hfi1: set_intr_bits uses incorrect source for register modification
> > Using index info to reconstruct a base tree...
> > M	drivers/infiniband/hw/hfi1/chip.c
> > Falling back to patching base and 3-way merge...
> > Auto-merging drivers/infiniband/hw/hfi1/chip.c
> > CONFLICT (content): Merge conflict in drivers/infiniband/hw/hfi1/chip.c
> > error: Failed to merge in the changes.
> > Patch failed at 0002 IB/hfi1: set_intr_bits uses incorrect source for register modification
> > Use 'git am --show-current-patch' to see the failed patch
> > When you have resolved this problem, run "git am --continue".
> > If you prefer to skip this patch, run "git am --skip" instead.
> > To restore the original branch and stop patching, run "git am --abort".
> 
> Ah, I think I got my wires crossed. Mike's patch should land in for-next. It
> fixes one of his earlier patches that Doug pulled in. Can you just apply
> this there or do you want me to re-send? My patch can still go to -rc
> though.

I'll take Michael's patch, to for-next, but the other one needs a
better commit message. You can't fix 'theoretical bugs' in -stable.

Jason
