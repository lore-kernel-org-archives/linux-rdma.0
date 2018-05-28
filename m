From: Yishai Hadas <yishaih@dev.mellanox.co.il>
Subject: Re: [PATCH rdma-next 3/3] IB/mlx5: Introduce a new mini-CQE format
Date: Mon, 28 May 2018 19:52:03 +0300
Message-ID: <959cc280-3aad-fb55-9779-e6e1ab79fb85@dev.mellanox.co.il>
References: <20180527104234.17261-1-leon@kernel.org>
 <20180527104234.17261-4-leon@kernel.org>
 <20180528161148.GD17491@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180528161148.GD17491@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Yonatan Cohen <yonatanc@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 5/28/2018 7:11 PM, Jason Gunthorpe wrote:
> On Sun, May 27, 2018 at 01:42:34PM +0300, Leon Romanovsky wrote:
>> From: Yonatan Cohen <yonatanc@mellanox.com>
>>
>> The new mini-CQE format includes the stride index, byte count and
>> packet checksum.
>> Stride index is needed for striding WQ feature.
>> This patch exposes this capability and enables its setting
>> via mlx5 UHW data as part of query device and cq creation.
>>
>> Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
>> Reviewed-by: Guy Levi <guyle@mellanox.com>
>> Signed-off-by: Yonatan Cohen <yonatanc@mellanox.com>
>> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
>>   drivers/infiniband/hw/mlx5/cq.c   | 42 +++++++++++++++++++++++++++++----------
>>   drivers/infiniband/hw/mlx5/main.c |  4 ++++
>>   include/uapi/rdma/mlx5-abi.h      |  2 +-
>>   3 files changed, 37 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
>> index 7b4ce1a19de0..ad39d64b8108 100644
>> +++ b/drivers/infiniband/hw/mlx5/cq.c
>> @@ -751,6 +751,28 @@ static int alloc_cq_frag_buf(struct mlx5_ib_dev *dev,
>>   	return 0;
>>   }
>>   
>> +enum {
>> +	MLX5_CQE_RES_FORMAT_HASH = 0,
>> +	MLX5_CQE_RES_FORMAT_CSUM = 1,
>> +	MLX5_CQE_RES_FORMAT_CSUM_STRIDX = 3,
>> +};
> 
> What is this??

Those are mlx5 device values not uapi.

>> +static int mini_cqe_res_format_to_hw(struct mlx5_ib_dev *dev, u8 format)
>> +{
>> +	switch (format) {
>> +	case MLX5_IB_CQE_RES_FORMAT_HASH:
>> +		return MLX5_CQE_RES_FORMAT_HASH;
> 
> Used here..

This is some conversion between the uapi to the device values.

>> +		mini_cqe_format =
>> +			mini_cqe_res_format_to_hw(dev,
>> +						  ucmd.cqe_comp_res_format);
> 
> And format comes from a ucmd, so that enum is upai.

Correct, see mlx5-abi.h as part of this patch.

> Put it in the right place and put the right comment beside
> struct mlx5_ib_create_cq's cqe_comp_res_format..
> 
> And what is wrong with the user space patches? Where is the update to
> enum mlx5dv_cqe_comp_res_format ? And why is this wrong?
> 

See the first patch from below PR [1], it brings the new enum value to 
the user area as part of kernel-headers/rdma/mlx5-abi.h.

[1] https://github.com/linux-rdma/rdma-core/pull/337

> struct mlx5dv_cq_init_attr {
>          uint64_t comp_mask; /* Use enum mlx5dv_cq_init_attr_mask */
>          uint8_t cqe_comp_res_format; /* Use enum mlx5dv_cqe_comp_res_format */
>                                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^
> 

The user space uses the DV prefix (e.g. 
MLX5DV_CQE_RES_FORMAT_CSUM_STRIDX), no change from previous flags around 
enum mlx5dv_cqe_comp_res_format.
