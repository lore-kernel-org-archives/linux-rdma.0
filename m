From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] iw_cxgb4: add INFINIBAND_ADDR_TRANS dependency
Date: Wed, 30 May 2018 16:25:20 -0600
Message-ID: <20180530222520.GJ30754@ziepe.ca>
References: <20180530215826.1343234-1-arnd@arndb.de>
 <20180530220405.GH30754@ziepe.ca>
 <0be4e0fb-8d8e-b337-fc8d-550c90829d8c@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0be4e0fb-8d8e-b337-fc8d-550c90829d8c@opengridcomputing.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 30, 2018 at 05:10:35PM -0500, Steve Wise wrote:
> 
> 
> On 5/30/2018 5:04 PM, Jason Gunthorpe wrote:
> > On Wed, May 30, 2018 at 11:58:18PM +0200, Arnd Bergmann wrote:
> >> The newly added fill_res_ep_entry function fails to link if
> >> CONFIG_INFINIBAND_ADDR_TRANS is not set:
> >>
> >> drivers/infiniband/hw/cxgb4/restrack.o: In function `fill_res_ep_entry':
> >> restrack.c:(.text+0x3cc): undefined reference to `rdma_res_to_id'
> >> restrack.c:(.text+0x3d0): undefined reference to `rdma_iw_cm_id'
> >>
> >> This adds a Kconfig dependency for the driver.
> >>
> >> Fixes: 116aeb887371 ("iw_cxgb4: provide detailed provider-specific CM_ID information")
> >> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >>  drivers/infiniband/hw/cxgb4/Kconfig | 1 +
> >>  1 file changed, 1 insertion(+)
> > Oh, I think we need to solve this with maybe a header fill null stub
> > instead..
> >
> > We don't want to disable drivers just because a user interface is
> > disabled.
> >
> 
> Why does CONFIG_INFINIBAND_ADDR_TRANS disable building rdma_cm.ko? That
> is not correct.

That seems like a reasonable thing to do..

But why does it break the compile? Those functions are in cma.c...

Jason
