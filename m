From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] rdma: move the ib_wr_opcode enum to include/uapi
Date: Mon, 17 Sep 2018 15:08:24 -0600
Message-ID: <20180917210824.GF11367@ziepe.ca>
References: <20180814223303.83556-1-seth.howell@intel.com>
 <20180815225021.GB31799@ziepe.ca>
 <EA913ED399BBA34AA4EAC2EDC24CDD008611724E@FMSMSX105.amr.corp.intel.com>
 <20180816180126.GB10507@ziepe.ca>
 <EA913ED399BBA34AA4EAC2EDC24CDD0086118B12@FMSMSX105.amr.corp.intel.com>
 <11f85f780435a5ded567bc8559d7c770d3bc4464.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <11f85f780435a5ded567bc8559d7c770d3bc4464.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Walker, Benjamin" <benjamin.walker@intel.com>
Cc: "Howell, Seth" <seth.howell@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "monis@mellanox.com" <monis@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 17, 2018 at 08:38:16PM +0000, Walker, Benjamin wrote:
> On Mon, 2018-08-20 at 14:32 -0700, Howell, Seth wrote:
> > Hi Jason,
> > 
> > I apologize for the few days of radio silence on this one. I was able to apply
> > your patch on my local configuration and can confirm that it fixes the issue
> > of send with invalidate being improperly mapped between a user-space process
> > and the kernel rxe driver.
> > 
> > Thanks again for your time and help.
> > 
> > Seth Howell
> > 
> > From: linux-rdma-owner@vger.kernel.org [mailto:
> > linux-rdma-owner@vger.kernel.org] On Behalf Of Jason Gunthorpe
> > Sent: Thursday, August 16, 2018 11:01 AM
> > To: Howell, Seth <seth.howell@intel.com>
> > Cc: Walker, Benjamin <benjamin.walker@intel.com>; Doug Ledford <
> > dledford@redhat.com>; linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org
> > ; Moni Shoua <monis@mellanox.com>
> > Subject: Re: [PATCH] rdma: move the ib_wr_opcode enum to include/uapi
> > 
> > On Wed, Aug 15, 2018 at 11:27:36PM +0000, Howell, Seth wrote:
> > 
> > > Thank you for taking the time to review this issue. The patch you 
> > > submitted will definitely fix the problem I was facing.
> > 
> > Can you test it to be certain?
> > 
> > Thanks,
> > Jason
> 
> We've recently run into this same issue on i40iw, which appears to make the same
> mistake of using the kernel version of the enum instead of the userspace
> version. 

Confused by this?? i40iw_upost_send does not handle the kernel numbers
at all, as far as I can see? How does it develop a kernel dependency??

> What's the current status here? Can it be merged? I just checked and
> do not see it merged to Linux master.

Oh! This apparently got lost, thanks for bringing it up again.

> Running a user-space NVMe-oF target with RDMA and a recent Linux kernel
> initiator is not currently possible on rxe or i40iw because it requires send
> with invalidate support.

Okay, but i40iw doesn't seem to support send with invalidate at all in
userspace?

i40iw_upost_send() swithces on opcode, doesn't handle SEND_INV and
then blows up in the default clause - how does this patch make any
difference???

Jason
