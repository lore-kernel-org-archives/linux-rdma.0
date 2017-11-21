From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/2] mlx5: Allow creation of a Multi-Packet RQ
 using direct verbs
Date: Tue, 21 Nov 2017 19:17:00 +0200
Message-ID: <63dd046b-ac6d-3ff2-0dc5-82d29bac9393@dev.mellanox.co.il>
References: <1511119268-5934-1-git-send-email-yishaih@mellanox.com>
 <1511119268-5934-3-git-send-email-yishaih@mellanox.com>
 <20171120190434.GG29075@ziepe.ca>
 <f164e1c4-e3b2-8778-448e-1fb0da6e6dc1@dev.mellanox.co.il>
 <20171121155304.GA18272@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121155304.GA18272-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/21/2017 5:53 PM, Jason Gunthorpe wrote:
> On Tue, Nov 21, 2017 at 02:01:33PM +0200, Yishai Hadas wrote:
>> On 11/20/2017 9:04 PM, Jason Gunthorpe wrote:
>>> On Sun, Nov 19, 2017 at 09:21:08PM +0200, Yishai Hadas wrote:
>>>> +	if (mlx5wq_attr) {
>>>> +		if (mlx5wq_attr->comp_mask & ~(MLX5DV_WQ_INIT_ATTR_MASK_RESERVED - 1))
>>>> +			return -EINVAL;
>>>
>>> Please no. Check that only the bits this function actually supports
>>> are set and get rid of _RESERVED.
>>>
>>
>> OK, PR was updated accordingly:
>> https://github.com/linux-rdma/rdma-core/pull/257
> 
> This new version is mixing bit widths:
> 
> +enum mlx5dv_wq_init_attr_mask {
> +	MLX5DV_WQ_INIT_ATTR_MASK_STRIDING_RQ	= 1 << 0,
> +};
> 
> +enum {
> +	DV_CREATE_WQ_SUPPORTED_COMP_MASK = MLX5DV_WQ_INIT_ATTR_MASK_STRIDING_RQ
> +};
> 
> +struct mlx5dv_wq_init_attr {
> +	uint64_t				comp_mask;
> [..]
> 
> So this expression:
> 
> +	if (mlx5wq_attr->comp_mask & ~DV_CREATE_WQ_SUPPORTED_COMP_MASK)
> 
> 
> Will bitwise invert a 32 bit value then 0 extend it to 64 bits, which
> is not the intention.

Are you are referring to a case that the user will turn on a bit in the 
comp_mask over the 32 bits and won't get an error ? Look at 
MLX5DV_CQ_INIT_ATTR_MASK_RESERVED usage it has the same potential issue.

> As I suggested earlier, I recommend helper functions for this in
> driver.h:
> 
> static inline bool check_comp_mask(uint64_t input, uint64_t supported)
> {
>       return (input & ~supported) == 0;

OK, can add this helper function in a pre-patch with a fix to the above 
CQ case.

> 
> if (!check_comp_mask(mlx5wq_attr->comp_mask,
>       MLX5DV_WQ_INIT_ATTR_MASK_STRIDING_RQ))
>         return -EINVAL;
>         
> I also dislike the unnecessary extra enum..

I prefer staying with the above enum (i.e. 
DV_CREATE_WQ_SUPPORTED_COMP_MASK) to hold the supported bits as done in 
mlx5 for QP & CQ. (see MLX5_CREATE_QP_SUP_COMP_MASK). In that way the 
code around check_comp_mask() won't be changed when extra bits will be 
added.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
