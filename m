From: Yishai Hadas <yishaih@dev.mellanox.co.il>
Subject: Re: [PATCH mlx5-next v2 11/13] IB/mlx5: Add flow counters binding
 support
Date: Wed, 30 May 2018 18:24:00 +0300
Message-ID: <0dec7cc6-5715-4513-d55b-c53271c4fbee@dev.mellanox.co.il>
References: <20180529130917.13592-1-leon@kernel.org>
 <20180529130917.13592-12-leon@kernel.org> <20180529195627.GA31423@ziepe.ca>
 <316f5042-b47d-2cee-48de-514467817e7a@dev.mellanox.co.il>
 <20180530150608.GA30754@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180530150608.GA30754@ziepe.ca>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>, Alex Rosenbaum <alexr@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 5/30/2018 6:06 PM, Jason Gunthorpe wrote:
> On Wed, May 30, 2018 at 03:31:34PM +0300, Yishai Hadas wrote:
>> On 5/29/2018 10:56 PM, Jason Gunthorpe wrote:
>>> On Tue, May 29, 2018 at 04:09:15PM +0300, Leon Romanovsky wrote:
>>>> diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
>>>> index 508ea8c82da7..ef3f430a7050 100644
>>>> +++ b/include/uapi/rdma/mlx5-abi.h
>>>> @@ -443,4 +443,18 @@ enum {
>>>>   enum {
>>>>   	MLX5_IB_CLOCK_INFO_V1              = 0,
>>>>   };
>>>> +
>>>> +struct mlx5_ib_flow_counters_data {
>>>> +	__aligned_u64   counters_data;
>>>> +	__u32   ncounters;
>>>> +	__u32   reserved;
>>>> +};
>>>> +
>>>> +struct mlx5_ib_create_flow {
>>>> +	__u32   ncounters_data;
>>>> +	__u32   reserved;
>>>> +	/* Following are counters data based on ncounters_data */
>>>> +	struct mlx5_ib_flow_counters_data data[];
>>>> +};
>>>> +
>>>>   #endif /* MLX5_ABI_USER_H */
>>>
>>> This uapi thing still needs to be fixed as I pointed out before.
>>
>> In V3 we can go with below, no change in memory layout but it can clarify
>> the code/usage.
>>
>> struct mlx5_ib_flow_counters_desc {
>>          __u32   description;
>>          __u32   index;
>> };
>>
>> struct mlx5_ib_flow_counters_data {
>>          RDMA_UAPI_PTR(struct mlx5_ib_flow_counters_desc *, counters_data);
>>          __u32   ncounters;
>>          __u32   reserved;
>> };
> 
> OK, this is what I asked for originally..
> 
>> struct mlx5_ib_create_flow {
>>          __u32   ncounters_data;
>>          __u32   reserved;
>>          /* Following are counters data based on ncounters_data */
>>          struct mlx5_ib_flow_counters_data data[];
>>
>>
>>> I still can't figure out why this should be a 2d array.
>>
>> This comes to support the future case of multiple counters objects/specs
>> passed with the same flow. There is a need to differentiate mapping data for
>> each counters object and that is done via the 'ncounters_data' field and the
>> 2d array.
> 
> This still doesn't make any sense to me. How are these multiple
> counters objects/specs going to be identified?
> 
> Basically, what does the array index for data[] mean? Should it match
> the spec index from the main verb or something?
> 

Each entry in the data[] should match a corresponding counter object 
that was pointed by a counters spec upon the flow creation.

> This is a good place for a comment, since the intention is completely
> opaque here.

Sure, we'll add comment to clarify the above.
