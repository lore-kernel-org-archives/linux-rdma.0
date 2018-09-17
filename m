From: "Howell, Seth" <seth.howell@intel.com>
Subject: RE: [PATCH] rdma: move the ib_wr_opcode enum to include/uapi
Date: Mon, 17 Sep 2018 23:14:33 +0000
Message-ID: <EA913ED399BBA34AA4EAC2EDC24CDD009C1DDDA7@fmsmsx101.amr.corp.intel.com>
References: <20180814223303.83556-1-seth.howell@intel.com>
 <20180815225021.GB31799@ziepe.ca>
 <EA913ED399BBA34AA4EAC2EDC24CDD008611724E@FMSMSX105.amr.corp.intel.com>
 <20180917230817.GA10882@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180917230817.GA10882@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Walker, Benjamin" <benjamin.walker@intel.com>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Moni Shoua <monis@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Thank you Jason!

-----Original Message-----
From: Jason Gunthorpe [mailto:jgg@ziepe.ca] 
Sent: Monday, September 17, 2018 4:08 PM
To: Howell, Seth <seth.howell@intel.com>
Cc: Walker, Benjamin <benjamin.walker@intel.com>; Doug Ledford <dledford@redhat.com>; linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org; Moni Shoua <monis@mellanox.com>
Subject: Re: [PATCH] rdma: move the ib_wr_opcode enum to include/uapi

> >From e3c1b1b81373601fa6cbad2ba5fadd2c8cfdfaed Mon Sep 17 00:00:00 
> >2001
> From: Seth Howell <seth.howell@intel.com>
> Date: Tue, 14 Aug 2018 15:33:02 -0700
> Subject: [PATCH] IB/rxe: Revise the ib_wr_opcode enum
> 
> This enum has become part of the uABI, as both RXE and the
> ib_uverbs_post_send() command expect userspace to supply values from 
> this enum. So it should be properly placed in include/uapi/rdma.
> 
> In userspace this enum is called 'enum ibv_wr_opcode' as part of 
> libibverbs.h. That enum defines different values for IB_WR_LOCAL_INV, 
> IB_WR_SEND_WITH_INV, and IB_WR_LSO. These were introduced 
> (incorrectly, it turns out) into libiberbs in 2015.
> 
> The kernel has changed its mind on the numbering for several of the 
> IB_WC values over the years, but has remained stable on 
> IB_WR_LOCAL_INV and below.
> 
> Based on this we can conclude that there is no real user space user of 
> the values beyond IB_WR_ATOMIC_FETCH_AND_ADD, as they have never 
> worked via rdma-core. This is confirmed by inspection, only rxe uses 
> the kernel enum and implements the latter operations. rxe has clearly 
> never worked with these attributes from userspace. Other drivers that 
> support these opcodes implement the functionality without calling out 
> to the kernel.
> 
> To make IB_WR_SEND_WITH_INV and related work for RXE in userspace we 
> choose to renumber the IB_WR enum in the kernel to match the uABI that 
> userspace has bee using since before Soft RoCE was merged. This is an 
> overall simpler configuration for the whole software stack, and 
> obviously can't break anything existing.
> 
> Reported-by: Seth Howell <seth.howell@intel.com>
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
>  include/rdma/ib_verbs.h           | 34 ++++++++++++++++++-------------
>  include/uapi/rdma/ib_user_verbs.h | 20 +++++++++++++++++-
>  2 files changed, 39 insertions(+), 15 deletions(-)

Applied to for-next

Thanks,
Jason
