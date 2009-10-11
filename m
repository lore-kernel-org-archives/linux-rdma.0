From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [ewg] [PATCH] mlx4: remove limitation on LSO header size
Date: Sun, 11 Oct 2009 11:47:57 +0200
Message-ID: <20091011094757.GA4929@mtls03>
References: <20090930090701.GA2385@mtls03> <4AC858E0.2010506@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AC858E0.2010506-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 04, 2009 at 10:12:16AM +0200, Or Gerlitz wrote:
>> Also, this patch will cause IB_DEVICE_UD_TSO to be set only of FW versions that set MLX4_DEV_CAP_FLAG_BLH; e.g. FW version 2.6.000 and higher.
> warning to users having an older firmware installed?

I am not sure this deserves a warning - after all it's just that the
feature is not supported.

> So the driver doesn't use the actual value of the max_gso_sz capability,  
> isn't this a bug?  the BLH bit  (any reason not the mention in the  
> change-log what these three letters stand for...?) serves you to support  
> large LSO headers, but isn't enough, max_gso_sz is related to the  
> payload and should be used, I think.
>
According to the spec, for LSO to be supported at all, max_gso_sz must
be none zero. Moreover, for BLH to be supported (BLH stands for Big
LSO Header), the MLX4_DEV_CAP_FLAG_BLH flag must be set and hence the
condition on both of them.


>>  	if (dev->dev->caps.bmme_flags & MLX4_BMME_FLAG_RESERVED_LKEY)
>>  		props->device_cap_flags |= IB_DEVICE_LOCAL_DMA_LKEY;
>> diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
>> index 219b103..1b356cf 100644
>> --- a/drivers/infiniband/hw/mlx4/qp.c
>> +++ b/drivers/infiniband/hw/mlx4/qp.c
>> @@ -261,7 +261,7 @@ static int send_wqe_overhead(enum ib_qp_type type, u32 flags)
>>  	case IB_QPT_UD:
>>  		return sizeof (struct mlx4_wqe_ctrl_seg) +
>>  			sizeof (struct mlx4_wqe_datagram_seg) +
>> -			((flags & MLX4_IB_QP_LSO) ? 64 : 0);
>> +			((flags & MLX4_IB_QP_LSO) ? 128 : 0);
> 64 , 128 ... here and later in build_lso_seg ,  how about defining some  
> human readable something?

OK, I will replace with an enum.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
