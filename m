From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] iw_cxgb4: add INFINIBAND_ADDR_TRANS dependency
Date: Mon, 4 Jun 2018 09:36:16 -0600
Message-ID: <20180604153616.GA29572@ziepe.ca>
References: <20180530215826.1343234-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180530215826.1343234-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Steve Wise <swise@chelsio.com>, Doug Ledford <dledford@redhat.com>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 30, 2018 at 11:58:18PM +0200, Arnd Bergmann wrote:
> The newly added fill_res_ep_entry function fails to link if
> CONFIG_INFINIBAND_ADDR_TRANS is not set:
> 
> drivers/infiniband/hw/cxgb4/restrack.o: In function `fill_res_ep_entry':
> restrack.c:(.text+0x3cc): undefined reference to `rdma_res_to_id'
> restrack.c:(.text+0x3d0): undefined reference to `rdma_iw_cm_id'
> 
> This adds a Kconfig dependency for the driver.
> 
> Fixes: 116aeb887371 ("iw_cxgb4: provide detailed provider-specific CM_ID information")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Greg Thelen <gthelen@google.com>
> ---
>  drivers/infiniband/hw/cxgb4/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

Applied to for-next

Thanks,
Jason
