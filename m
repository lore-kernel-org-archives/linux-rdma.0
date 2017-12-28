From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-next v1 4/6] IB/mlx5: Handle type IB_QPT_DRIVER when
 creating a QP
Date: Thu, 28 Dec 2017 12:02:56 +0200
Message-ID: <30a35dd5-3046-d7bb-e61f-7d18501fd06c@dev.mellanox.co.il>
References: <20171227171540.1646-1-leon@kernel.org>
 <20171227171540.1646-5-leon@kernel.org>
 <CAJ3xEMiExjjVUOYQsdMiHLNOjB+MOkz4c1TT9AT_inkfGfMuKA@mail.gmail.com>
 <20171227220227.GL31310@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171227220227.GL31310-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/28/2017 12:02 AM, Jason Gunthorpe wrote:
> On Wed, Dec 27, 2017 at 11:16:09PM +0200, Or Gerlitz wrote:
>> On Wed, Dec 27, 2017 at 7:15 PM, Leon wrote:
>>> From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>>> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
>>> @@ -202,6 +202,8 @@ struct mlx5_ib_flow_db {
>>>    * creates the actual hardware QP.
>>>    */
>>>   #define MLX5_IB_QPT_HW_GSI     IB_QPT_RESERVED2
>>> +#define MLX5_IB_QPT_DCI                IB_QPT_RESERVED3
>>> +#define MLX5_IB_QPT_DCT                IB_QPT_RESERVED4
>>
>> When we added the reserved QPTs we made an explicit statement at the
>> verbs header file that this is a "range for qp types internal to the
>> low level driver"
>>
>> In the down stream patches you are actually assuming user-space
>> knows that for mlx5 DCI/DCT equals IB_QPT_RESERVED3/4 which
>> violates this statement.
> 
> IB_QPT_RESERVED should NOT leak to the user driver ever, for some
> reason a flag is used. I thought we agreed to an enum during the
> original RFC?
> 
>> Maybe you need
>>
>> IB_QPT_VENDOR1
>> IB_QPT_VENDOR2
>> ...
>> IB_QPT_VENDOR10
> 
> No, no. The driver specific QP type is carried only within the driver
> specific udata and is never part of the common API.
> 

Correct, this is really what had been done, so we are fine here.

>> you added these two flags in the ABI file, but you never use them in downstream
>>
>> MLX5_QP_FLAG_TYPE_DCT
>> MLX5_QP_FLAG_TYPE_DCI
>>
>> patches, something must be wrong here even according to your design
> 
> Hm? they are used here:
> 
> +       if (ucmd->flags & MLX5_QP_FLAG_TYPE_DCI)
> +               init_attr->qp_type = MLX5_IB_QPT_DCI;
> +       else
> +               init_attr->qp_type = MLX5_IB_QPT_DCT;
> 
> Which is a bad ABI design, check flags explicitly never use else.

We can drop this 'else' as few lines above there was a check that both 
can't be set together. However, not sure that this change worth V2.

> Not sure how much I like this - why try so hard to keep the udata
> unchanged? 

We prefer to not increase the udata length if it's not really required. 
Doing that might force other changes around to preserve compatibility 
with legacy user space [1].

 From application point of view the API will be very clear to ask for a 
specific QP type. Here we are talking on some 'user driver <-> kernel 
driver' API to pass the request and as of the above we preferred to go 
by that way without increasing the udata.

[1] 
http://elixir.free-electrons.com/linux/latest/source/drivers/infiniband/hw/mlx5/qp.c#L1595.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
