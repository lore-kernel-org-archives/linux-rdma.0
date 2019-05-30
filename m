From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH][next] IB/qib: Use struct_size() helper
Date: Thu, 30 May 2019 14:29:13 -0400
Message-ID: <a72f82a8-717c-3d5e-644c-4d7f30d3c43b@intel.com>
References: <20190529151326.GA24109@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190529151326.GA24109@embeddedor>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 5/29/2019 11:13 AM, Gustavo A. R. Silva wrote:
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes, in particular in the
> context in which this code is being used.
> 
> So, replace the following form:
> 
> sizeof(*pkt) + sizeof(pkt->addr[0])*n
> 
> with:
> 
> struct_size(pkt, addr, n)
> 
> Also, notice that variable size is unnecessary, hence it is removed.
> 
> This code was detected with the help of Coccinelle.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/infiniband/hw/qib/qib_user_sdma.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
> index 0c204776263f..97649f64e09e 100644
> --- a/drivers/infiniband/hw/qib/qib_user_sdma.c
> +++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
> @@ -904,10 +904,11 @@ static int qib_user_sdma_queue_pkts(const struct qib_devdata *dd,
>   		}
>   
>   		if (frag_size) {
> -			int pktsize, tidsmsize, n;
> +			int tidsmsize, n;
> +			size_t pktsize;
>   
>   			n = npages*((2*PAGE_SIZE/frag_size)+1);
> -			pktsize = sizeof(*pkt) + sizeof(pkt->addr[0])*n;
> +			pktsize = struct_size(pkt, addr, n);
>   
>   			/*
>   			 * Determine if this is tid-sdma or just sdma.
> 

Again, same minor objection but correct patch none the less.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
