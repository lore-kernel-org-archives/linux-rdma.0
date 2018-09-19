From: "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>
Subject: RE: [PATCH] rdma: move the ib_wr_opcode enum to include/uapi
Date: Wed, 19 Sep 2018 23:03:04 +0000
Message-ID: <13AA599688F47243B14FCFCCC2C803BB4BDC4DE4@FMSMSX103.amr.corp.intel.com>
References: <20180814223303.83556-1-seth.howell@intel.com>
 <20180815225021.GB31799@ziepe.ca>
 <EA913ED399BBA34AA4EAC2EDC24CDD008611724E@FMSMSX105.amr.corp.intel.com>
 <20180816180126.GB10507@ziepe.ca>
 <EA913ED399BBA34AA4EAC2EDC24CDD0086118B12@FMSMSX105.amr.corp.intel.com>
 <11f85f780435a5ded567bc8559d7c770d3bc4464.camel@intel.com>
 <20180917210824.GF11367@ziepe.ca>
 <0df4e4958250fd6cdb978005ace970c877269535.camel@intel.com>
 <20180917224743.GG11367@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180917224743.GG11367@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, "Walker, Benjamin" <benjamin.walker@intel.com>
Cc: "Howell, Seth" <seth.howell@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "monis@mellanox.com" <monis@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,

> > What is the correct way for a user space application to check whether
> > a NIC supports SEND_WITH_INVAL? We are currently examining the
> > device_cap_flags in the structure returned by ibv_query_device.
> > Specifically, we're looking at IBV_DEVICE_MEM_MGT_EXTENSIONS.
> However,
> > for i40iw, that flag is set. I'm concerned that the feature support
> > flags are common between user space and the kernel, but the actual
> support differs in this case.
> 
> That is the correct thing to do. Sadly the i40iw driver is broken, it should be
> fixed to either mask those flags or implement the functionality.
> 

A fix to add SEND_WITH_INVAL support to the user space i40iw is coming.
It is currently in regression testing.

Thank you,
Tatyana 

> Jason
