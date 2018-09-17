From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] rdma: move the ib_wr_opcode enum to include/uapi
Date: Mon, 17 Sep 2018 16:47:43 -0600
Message-ID: <20180917224743.GG11367@ziepe.ca>
References: <20180814223303.83556-1-seth.howell@intel.com>
 <20180815225021.GB31799@ziepe.ca>
 <EA913ED399BBA34AA4EAC2EDC24CDD008611724E@FMSMSX105.amr.corp.intel.com>
 <20180816180126.GB10507@ziepe.ca>
 <EA913ED399BBA34AA4EAC2EDC24CDD0086118B12@FMSMSX105.amr.corp.intel.com>
 <11f85f780435a5ded567bc8559d7c770d3bc4464.camel@intel.com>
 <20180917210824.GF11367@ziepe.ca>
 <0df4e4958250fd6cdb978005ace970c877269535.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0df4e4958250fd6cdb978005ace970c877269535.camel@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Walker, Benjamin" <benjamin.walker@intel.com>
Cc: "Howell, Seth" <seth.howell@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "monis@mellanox.com" <monis@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 17, 2018 at 10:29:18PM +0000, Walker, Benjamin wrote:
> On Mon, 2018-09-17 at 15:08 -0600, Jason Gunthorpe wrote:
> > On Mon, Sep 17, 2018 at 08:38:16PM +0000, Walker, Benjamin wrote:
> > > We've recently run into this same issue on i40iw, which appears to make the
> > > same
> > > mistake of using the kernel version of the enum instead of the userspace
> > > version. 
> > 
> > Confused by this?? i40iw_upost_send does not handle the kernel numbers
> > at all, as far as I can see? How does it develop a kernel dependency??
> > 
> > > What's the current status here? Can it be merged? I just checked and
> > > do not see it merged to Linux master.
> > 
> > Oh! This apparently got lost, thanks for bringing it up again.
> > 
> > > Running a user-space NVMe-oF target with RDMA and a recent Linux kernel
> > > initiator is not currently possible on rxe or i40iw because it requires send
> > > with invalidate support.
> > 
> > Okay, but i40iw doesn't seem to support send with invalidate at all in
> > userspace?
> > 
> > i40iw_upost_send() swithces on opcode, doesn't handle SEND_INV and
> > then blows up in the default clause - how does this patch make any
> > difference???
> 
> It appears I've read the error message incorrectly and was looking at the kernel
> version (i40iw_post_send) as opposed to the user version (i40iw_upost_send).
> Indeed, the NIC does not support SEND_WTIH_INVAL at all in that function. The
> NIC does support SEND_WITH_INVAL in the kernel i40iw_post_send.

OK
 
> What is the correct way for a user space application to check whether a NIC
> supports SEND_WITH_INVAL? We are currently examining the device_cap_flags in the
> structure returned by ibv_query_device. Specifically, we're looking at
> IBV_DEVICE_MEM_MGT_EXTENSIONS. However, for i40iw, that flag is set. I'm
> concerned that the feature support flags are common between user space and the
> kernel, but the actual support differs in this case.

That is the correct thing to do. Sadly the i40iw driver is broken, it
should be fixed to either mask those flags or implement the
functionality.

Jason
