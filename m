From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/mthca: remove mthca_user.h
Date: Sun, 28 Jan 2018 14:12:58 -0700
Message-ID: <20180128211257.GB26025@ziepe.ca>
References: <1517143183-24393-1-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1517143183-24393-1-git-send-email-clabbe@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Corentin Labbe <clabbe@baylibre.com>
Cc: dledford@redhat.com, hal.rosenstock@gmail.com, sean.hefty@intel.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 28, 2018 at 12:39:43PM +0000, Corentin Labbe wrote:
> mthca_user.h is unused since commit 486f60954c71 ("IB/mthca: Move user vendor structures")
> Remove it from tree.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/hw/mthca/mthca_user.h | 112 -------------------------------
>  1 file changed, 112 deletions(-)
>  delete mode 100644 drivers/infiniband/hw/mthca/mthca_user.h

Applied to for-next thanks

Jason
