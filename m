From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH for-next 3/3] IB/hfi1: Close race condition on user
 context disable and close
Date: Tue, 26 Feb 2019 12:15:59 -0500
Message-ID: <316cda1d-eeaa-c75a-a4d8-fb087cd38714@intel.com>
References: <20190226164333.31476.43732.stgit@scvm10.sc.intel.com>
 <20190226164530.31476.26502.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190226164530.31476.26502.stgit@scvm10.sc.intel.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: jgg@ziepe.ca, dledford@redhat.com
Cc: linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 2/26/2019 11:45 AM, Dennis Dalessandro wrote:
>   struct hfi1_ctxtdata *hfi1_rcd_get_by_index(struct hfi1_devdata *dd, u16 ctxt);
> diff --git a/drivers/infiniband/hw/hfi1/init.c b/drivers/infiniband/hw/hfi1/init.c
> index 7841a0a..2cc5164 100644
> --- a/drivers/infiniband/hw/hfi1/init.c
> +++ b/drivers/infiniband/hw/hfi1/init.c
> @@ -214,12 +214,12 @@ static void hfi1_rcd_free(struct kref *kref)
>   	struct hfi1_ctxtdata *rcd =
>   		container_of(kref, struct hfi1_ctxtdata, kref);
>   
> -	hfi1_free_ctxtdata(rcd->dd, rcd);
> -
>   	spin_lock_irqsave(&rcd->dd->uctxt_lock, flags);
>   	rcd->dd->rcd[rcd->ctxt] = NULL;
>   	spin_unlock_irqrestore(&rcd->dd->uctxt_lock, flags);
>   
> +	hfi1_free_ctxtdata(rcd->dd, rcd);
> +
>   	kfree(rcd);
>   }
>   
Whoops, hold off on pulling this one just yet. We need to take a closer 
look at the above hunk.

-Denny
