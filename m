From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH] infiniband/hw/cxgb3/cxio_hal.c: Use dma_zalloc_coherent
Date: Wed, 21 Nov 2018 15:59:43 -0700
Message-ID: <20181121225943.GA29924@ziepe.ca>
References: <5be5bad9.1c69fb81.db750.d226@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5be5bad9.1c69fb81.db750.d226@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
Cc: swise@chelsio.com, dledford@redhat.com, jrdr.linux@gmail.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, brajeswar.linux@gmail.com
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 09, 2018 at 10:20:29PM +0530, Sabyasachi Gupta wrote:
> Replaced dma_alloc_coherent + memset with dma_zalloc_coherent
> 
> Signed-off-by: Sabyasachi Gupta <sabyasachi.linux@gmail.com>
> Acked-by: Steve Wise <swise@opengridcomputing.com>
> Acked-by: Steve Wise <swise@opengridcomputing.com>
> ---
>  drivers/infiniband/hw/cxgb3/cxio_hal.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Applied to for-next

Thanks,
Jason
