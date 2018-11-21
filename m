From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] infiniband/hw/cxgb4/qp.c: Use dma_zalloc_coherent
Date: Wed, 21 Nov 2018 15:59:52 -0700
Message-ID: <20181121225952.GB29924@ziepe.ca>
References: <5be99a9e.1c69fb81.87c65.4ec2@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5be99a9e.1c69fb81.87c65.4ec2@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
Cc: swise@chelsio.com, dledford@redhat.com, jrdr.linux@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, brajeswar.linux@gmail.com
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 12, 2018 at 08:51:59PM +0530, Sabyasachi Gupta wrote:
> Replaced dma_alloc_coherent + memset with dma_zalloc_coherent
> 
> Signed-off-by: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
> Acked-by: Steve Wise <swise@opengridcomputing.com>
> ---
>  drivers/infiniband/hw/cxgb4/qp.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Applied to for-next

Thanks,
Jason
