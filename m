From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v5 04/10] IB/mlx5: Initialize mlx5_ib_qp signature related
Date: Mon, 24 Feb 2014 10:10:57 +0200
Message-ID: <530AFE91.6040102@dev.mellanox.co.il>
References: <1393157953-24834-1-git-send-email-sagig@mellanox.com>	 <1393157953-24834-5-git-send-email-sagig@mellanox.com> <1393224376.22656.13.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393224376.22656.13.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/24/2014 8:46 AM, Nicholas A. Bellinger wrote:
> On Sun, 2014-02-23 at 14:19 +0200, Sagi Grimberg wrote:
>> If user requested signature enable we Initialize
>> relevant mlx5_ib_qp members. we mark the qp as sig_enable
>> and we increase the effective SQ size, but still
>> limit the user max_send_wr to original size computed.
>> We also allow the create_qp routine to accept sig_enable
>> create flag.
>>
>> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>   drivers/infiniband/hw/mlx5/mlx5_ib.h |    3 +++
>>   drivers/infiniband/hw/mlx5/qp.c      |   12 +++++++++---
>>   include/linux/mlx5/qp.h              |    1 +
>>   3 files changed, 13 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
>> index 79c4f14..e438f08 100644
>> --- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
>> +++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
>> @@ -189,6 +189,9 @@ struct mlx5_ib_qp {
>>   
>>   	int			create_type;
>>   	u32			pa_lkey;
>> +
>> +	/* Store signature errors */
>> +	bool			signature_en;
>>   };
>>   
>>   struct mlx5_ib_cq_buf {
>> diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
>> index 7dfe8a1..01999f3 100644
>> --- a/drivers/infiniband/hw/mlx5/qp.c
>> +++ b/drivers/infiniband/hw/mlx5/qp.c
> <SNIP>
>
>> @@ -665,7 +671,7 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
>>   	int err;
>>   
>>   	uuari = &dev->mdev.priv.uuari;
>> -	if (init_attr->create_flags)
>> +	if (init_attr->create_flags & ~IB_QP_CREATE_SIGNATURE_EN)
>>   		return -EINVAL;
>>   
>>   	if (init_attr->qp_type == MLX5_IB_QPT_REG_UMR)
>
> FYI, this particular block doesn't apply against >= v3.14-rc2 code.
>
> Dropping it for now, and applying the rest as #5.
>
> Please fix if necessary.

This block comes from Eli's commit that exists in Roland tree:

commit 1a4c3a3dc5fdeef2a7bdf4ac7d81df58c3c0a51e
Author: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Date:   Thu Feb 6 17:41:25 2014 +0200

     IB/mlx5: Don't set "block multicast loopback" capability

     Currently Connect-IB does not support blocking multicast loopback, so
     don't set IB_DEVICE_BLOCK_MULTICAST_LOOPBACK in the device caps.

     Reported by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
     Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
     Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

It's OK for you to drop this block since it reference this specific commit.

> --nab
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
