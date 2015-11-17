From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH for-next 10/10] IB/iser: Support the remote invalidation
 exception
Date: Tue, 17 Nov 2015 10:08:12 +0200
Message-ID: <564AE06C.9020504@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-11-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1447691861-3796-11-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Wise <swise@opengridcomputing.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 11/16/2015 6:37 PM, Sagi Grimberg wrote:
> --- a/drivers/infiniband/ulp/iser/iser_verbs.c
> +++ b/drivers/infiniband/ulp/iser/iser_verbs.c
> @@ -847,7 +847,7 @@ static void iser_route_handler(struct rdma_cm_id *cma_id)
>   	conn_param.rnr_retry_count     = 6;
>   
>   	memset(&req_hdr, 0, sizeof(req_hdr));
> -	req_hdr.flags = (ISER_ZBVA_NOT_SUP | ISER_SEND_W_INV_NOT_SUP);
> +	req_hdr.flags = ISER_ZBVA_NOT_SUP;

isn't there a property of the **local** device we need to check before 
advertizing that
to the target? to be on the safe side, I would do  that only over 
devices that support
IB_DEVICE_MEM_MGT_EXTENSIONS, as non-local invalidations are part of the 
BMME ext
of IBTA, right?
