From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] IB/qib: remove qib_keys.c
Date: Sun, 28 Jan 2018 14:13:12 -0700
Message-ID: <20180128211312.GC26025@ziepe.ca>
References: <1517152135-24942-1-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1517152135-24942-1-git-send-email-clabbe@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Corentin Labbe <clabbe@baylibre.com>
Cc: dledford@redhat.com, hal.rosenstock@gmail.com, infinipath@intel.com, sean.hefty@intel.com, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 28, 2018 at 03:08:55PM +0000, Corentin Labbe wrote:
> qib_keys.c was left uncompilable in commit 7c2e11fe2dbe ("IB/qib: Remove qp and mr functionality from qib")
> Since nothing need it, remove it from tree.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
>  drivers/infiniband/hw/qib/qib_keys.c | 235 -----------------------------------
>  1 file changed, 235 deletions(-)
>  delete mode 100644 drivers/infiniband/hw/qib/qib_keys.c

Applied to for-next, thanks

Jason
