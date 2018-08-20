From: "Howell, Seth" <seth.howell@intel.com>
Subject: RE: [PATCH] rdma: move the ib_wr_opcode enum to include/uapi
Date: Mon, 20 Aug 2018 21:32:50 +0000
Message-ID: <EA913ED399BBA34AA4EAC2EDC24CDD0086118B12@FMSMSX105.amr.corp.intel.com>
References: <20180814223303.83556-1-seth.howell@intel.com>
 <20180815225021.GB31799@ziepe.ca>
 <EA913ED399BBA34AA4EAC2EDC24CDD008611724E@FMSMSX105.amr.corp.intel.com>
 <20180816180126.GB10507@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180816180126.GB10507@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Walker, Benjamin" <benjamin.walker@intel.com>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Moni Shoua <monis@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

I apologize for the few days of radio silence on this one. I was able to apply your patch on my local configuration and can confirm that it fixes the issue of send with invalidate being improperly mapped between a user-space process and the kernel rxe driver.

Thanks again for your time and help.

Seth Howell

-----Original Message-----
From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-owner@vger.kernel.org] On Behalf Of Jason Gunthorpe
Sent: Thursday, August 16, 2018 11:01 AM
To: Howell, Seth <seth.howell@intel.com>
Cc: Walker, Benjamin <benjamin.walker@intel.com>; Doug Ledford <dledford@redhat.com>; linux-rdma@vger.kernel.org; linux-kernel@vger.kernel.org; Moni Shoua <monis@mellanox.com>
Subject: Re: [PATCH] rdma: move the ib_wr_opcode enum to include/uapi

On Wed, Aug 15, 2018 at 11:27:36PM +0000, Howell, Seth wrote:

> Thank you for taking the time to review this issue. The patch you 
> submitted will definitely fix the problem I was facing.

Can you test it to be certain?

Thanks,
Jason
