From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [rdma-rc 10/11] Revert "IB/core: Allow QP state transition from
 reset to error"
Date: Thu, 27 Jul 2017 10:52:08 -0400
Message-ID: <49fe625b-cd44-137e-c001-1d85297f4e62@intel.com>
References: <20170726181232.7363-1-leon@kernel.org>
 <20170726181232.7363-11-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170726181232.7363-11-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/26/2017 2:12 PM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> The commit ebc9ca43e1d5 ("IB/core: Allow QP state transition from reset to error")
> allowed transition from Reset to Error state for the QPs. This behavior
> doesn't follow the IBTA specification 1.3, which in 10.3.1 QUEUE PAIR AND
> EE CONTEXT STATES section.
> 
> The quote from the spec:
> "An error can be forced from any state, except Reset, with
> the Modify QP/EE Verb."
> 
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>   drivers/infiniband/core/verbs.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index fb98ed67d5bc..7f8fe443df46 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -895,7 +895,6 @@ static const struct {
>   } qp_state_table[IB_QPS_ERR + 1][IB_QPS_ERR + 1] = {
>   	[IB_QPS_RESET] = {
>   		[IB_QPS_RESET] = { .valid = 1 },
> -		[IB_QPS_ERR] =   { .valid = 1 },
>   		[IB_QPS_INIT]  = {
>   			.valid = 1,
>   			.req_param = {
> 

The diagram from that section clearly shows you can't go from reset to 
error. However table 91 as in our original commit message says it could 
go to error from any state. Taking a step back and thinking about it, 
I'm not sure it really makes sense to be able to go from reset to error 
anyway. There is nothing that can go wrong until the qp is transitioned 
out of reset really.

Any idea why this patch was never adopted:
http://www.spinics.net/lists/linux-rdma/msg07627.html

This was during my storage hiatus so I wasn't following things RDMA back 
then. However this seems like the correct approach to me. Granted that 
patch would look different as the code has moved around but the same 
sort of check could go in ipoib_ib_dev_stop_default().

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
