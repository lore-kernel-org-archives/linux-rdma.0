From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2] IB/cxgb3: remove cxio_dbg.c
Date: Wed, 14 Feb 2018 16:52:36 -0700
Message-ID: <20180214235236.GA16962@ziepe.ca>
References: <1517949451-24264-1-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1517949451-24264-1-git-send-email-clabbe@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Corentin Labbe <clabbe@baylibre.com>
Cc: dledford@redhat.com, hal.rosenstock@gmail.com, sean.hefty@intel.com, swise@chelsio.com, joe@perches.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 06, 2018 at 08:37:31PM +0000, Corentin Labbe wrote:
> cxio_dbg.c is uncompiled since commit 2b540355cd2f ("RDMA/cxgb3: cleanups")
> 10 years after, we could remove it.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> Acked-by: Steve Wise <swise@opengridcomputing.com>
> 
> Changes since v1:
> - Remove also all DEBUG code as suggested by Joe Perches
> 
>  drivers/infiniband/hw/cxgb3/Kconfig    |   9 --
>  drivers/infiniband/hw/cxgb3/Makefile   |   2 -
>  drivers/infiniband/hw/cxgb3/cxio_dbg.c | 206 ---------------------------------
>  drivers/infiniband/hw/cxgb3/cxio_hal.h |   9 --
>  drivers/infiniband/hw/cxgb3/iwch_cq.c  |   6 -
>  5 files changed, 232 deletions(-)
>  delete mode 100644 drivers/infiniband/hw/cxgb3/cxio_dbg.c

Applied to -next, thanks

Jason
