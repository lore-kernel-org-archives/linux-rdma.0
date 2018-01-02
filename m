From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] RDMA/bnxt_re: Use zeroing memory allocator than
 allocator/memset
Date: Tue, 2 Jan 2018 14:06:35 -0700
Message-ID: <20180102210635.GD7614@ziepe.ca>
References: <1514723558-5923-1-git-send-email-himanshujha199640@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1514723558-5923-1-git-send-email-himanshujha199640@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: selvin.xavier@broadcom.com, devesh.sharma@broadcom.com, somnath.kotur@broadcom.com, sriharsha.basavapatna@broadcom.com, dledford@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 31, 2017 at 06:02:38PM +0530, Himanshu Jha wrote:
> Use dma_zalloc_coherent for allocating zeroed
> memory and remove unnecessary memset function.
> 
> Done using Coccinelle.
> Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
> 0-day tested with no failures.
> 
> Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
>  drivers/infiniband/hw/bnxt_re/qplib_res.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)

Applied to for-next thanks

Jason
