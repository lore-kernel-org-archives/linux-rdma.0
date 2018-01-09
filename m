From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH] IB/hfi1: Prevent a NULL dereference
Date: Tue, 9 Jan 2018 09:02:46 -0500
Message-ID: <d9746200-f940-b8af-cd5a-95904d40fe41@intel.com>
References: <20180109092714.valolokywtmbprw7@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20180109092714.valolokywtmbprw7@mwanda>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, "Michael J. Ruhl" <michael.j.ruhl@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 1/9/2018 4:27 AM, Dan Carpenter wrote:
> In the original code, we set "fd->uctxt" to NULL and then dereference it
> which will cause an Oops.
> 
> Fixes: f2a3bc00a03c ("IB/hfi1: Protect context array set/clear with spinlock")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
> index 82086241aac3..3de1ac94bb85 100644
> --- a/drivers/infiniband/hw/hfi1/file_ops.c
> +++ b/drivers/infiniband/hw/hfi1/file_ops.c
> @@ -763,10 +763,10 @@ static int complete_subctxt(struct hfi1_filedata *fd)
>   	}
>   
>   	if (ret) {
> +		__clear_bit(fd->subctxt, fd->uctxt->in_use_ctxts);
>   		hfi1_rcd_put(fd->uctxt);
>   		fd->uctxt = NULL;
>   		spin_lock_irqsave(&fd->dd->uctxt_lock, flags);
> -		__clear_bit(fd->subctxt, fd->uctxt->in_use_ctxts);
>   		spin_unlock_irqrestore(&fd->dd->uctxt_lock, flags);
>   	}
>   
> 

Thanks!

Acked-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
