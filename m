From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH v4 3/6] RDMA/i40iw: Eliminate duplicate barriers on
 weakly-ordered archs
Date: Wed, 21 Mar 2018 16:01:48 -0500
Message-ID: <596af6f5-3668-2545-4d79-b7b8c6713444@codeaurora.org>
References: <1521514068-8856-1-git-send-email-okaya@codeaurora.org>
 <1521514068-8856-4-git-send-email-okaya@codeaurora.org>
 <20180321200253.GA21453@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180321200253.GA21453@ziepe.ca>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 3/21/2018 3:02 PM, Jason Gunthorpe wrote:
> On Mon, Mar 19, 2018 at 10:47:45PM -0400, Sinan Kaya wrote:
>> diff --git a/drivers/infiniband/hw/i40iw/i40iw_uk.c b/drivers/infiniband/hw/i40iw/i40iw_uk.c
>> index 8afa5a6..7f0ebed 100644
>> +++ b/drivers/infiniband/hw/i40iw/i40iw_uk.c
>> @@ -723,7 +723,7 @@ static void i40iw_cq_request_notification(struct i40iw_cq_uk *cq,
>>  
>>  	wmb(); /* make sure WQE is populated before valid bit is set */
>>  
>> -	writel(cq->cq_id, cq->cqe_alloc_reg);
>> +	writel_relaxed(cq->cq_id, cq->cqe_alloc_reg);
>>  }
> 
> Ah, this one is probably not OK, i40iw_cq_request_notification is
> called here:
> 
> 	spin_lock_irqsave(&iwcq->lock, flags);
> 	ukcq->ops.iw_cq_request_notification(ukcq, cq_notify);
> 	spin_unlock_irqrestore(&iwcq->lock, flags);
> 
> So this needs to add mmmiomb(); to keep the same semantics.
> 
> Generally I think you need to be very careful to ensure that any
> conversion to _relaxed isn't contained by a spinlock, or the mmiomb()
> is present.
> 
> Maybe even do a first series with this obviously correct pattern:
> 
>  wmb();
>  writel() -> writel_relaxed()
>  writel() -> writel_relaxed()
>  [..]
>  mmiowmb();

Good catch. I changed it as follows:

+++ b/drivers/infiniband/hw/i40iw/i40iw_uk.c
@@ -723,7 +723,8 @@ static void i40iw_cq_request_notification(struct i40iw_cq_uk *cq,

        wmb(); /* make sure WQE is populated before valid bit is set */

-       writel(cq->cq_id, cq->cqe_alloc_reg);
+       writel_relaxed(cq->cq_id, cq->cqe_alloc_reg);
+       mmiowb();
 }


> 
> Jason
> 


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
