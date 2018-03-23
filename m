From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH v5 2/3] RDMA/i40iw: Eliminate duplicate barriers on
 weakly-ordered archs
Date: Fri, 23 Mar 2018 15:15:04 -0400
Message-ID: <352b0adc-5489-c919-fa0a-2a3a3b2d37a0@codeaurora.org>
References: <1521736009-23387-1-git-send-email-okaya@codeaurora.org>
 <1521736009-23387-3-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521736009-23387-3-git-send-email-okaya@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 3/22/2018 12:26 PM, Sinan Kaya wrote:
> +++ b/drivers/infiniband/hw/i40iw/i40iw_ctrl.c
> @@ -706,9 +706,11 @@ static void i40iw_sc_ccq_arm(struct i40iw_sc_cq *ccq)
>  	wmb();       /* make sure shadow area is updated before arming */
>  
>  	if (ccq->dev->is_pf)
> -		i40iw_wr32(ccq->dev->hw, I40E_PFPE_CQARM, ccq->cq_uk.cq_id);
> +		i40iw_wr32_relaxed(ccq->dev->hw, I40E_PFPE_CQARM,
> +				   ccq->cq_uk.cq_id);
>  	else
> -		i40iw_wr32(ccq->dev->hw, I40E_VFPE_CQARM1, ccq->cq_uk.cq_id);
> +		i40iw_wr32_relaxed(ccq->dev->hw, I40E_VFPE_CQARM1,
> +				   ccq->cq_uk.cq_id);

do we want an mmiowb() here?

>  }


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
