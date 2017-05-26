From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/mlx5: set UMR wqe fence according to HCA cap
Date: Fri, 26 May 2017 22:04:28 +0300
Message-ID: <082ef80e-b7c1-135c-130f-24a1196e2dad@mellanox.com>
References: <1495743219-1085-1-git-send-email-maxg@mellanox.com>
 <1495743219-1085-2-git-send-email-maxg@mellanox.com>
 <20170526065020.GA19681@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170526065020.GA19681-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shahar.salzman-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 5/26/2017 9:50 AM, Christoph Hellwig wrote:
> On Thu, May 25, 2017 at 11:13:39PM +0300, Max Gurtovoy wrote:
>> Cache the needed umr_fence and set the wqe ctrl segmennt
>> accordingly.
>>
>> Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Acked-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> ---
>>  drivers/infiniband/hw/mlx5/main.c    |   14 ++++++++++++++
>>  drivers/infiniband/hw/mlx5/mlx5_ib.h |    1 +
>>  drivers/infiniband/hw/mlx5/qp.c      |   15 +++++++--------
>>  3 files changed, 22 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
>> index d45772d..83d1f9b 100644
>> --- a/drivers/infiniband/hw/mlx5/main.c
>> +++ b/drivers/infiniband/hw/mlx5/main.c
>> @@ -2979,6 +2979,18 @@ static int create_umr_res(struct mlx5_ib_dev *dev)
>>  	return ret;
>>  }
>>
>> +static u8 mlx5_get_umr_fence(u8 umr_fence_cap)
>> +{
>> +	switch (umr_fence_cap) {
>> +	case MLX5_CAP_UMR_FENCE_STRONG:
>> +		return MLX5_FENCE_MODE_STRONG_ORDERING;
>> +	case MLX5_CAP_UMR_FENCE_SMALL:
>> +		return MLX5_FENCE_MODE_INITIATOR_SMALL;
>> +	default:
>> +		return MLX5_FENCE_MODE_NONE;
>
> Of course I don't really understand your firmware interface, but
> shouldn't strong ordering be the default, and only certain fw
> cap bits would relax it?
>

Actually it's a default value (MLX5_CAP_UMR_FENCE_STRONG = 0x0), but I 
can set it default in this function too in V2.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
