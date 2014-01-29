From: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: mlx4 qp allocation
Date: Wed, 29 Jan 2014 15:52:09 +0530
Message-ID: <CANwwZzUfoNB1pyyu8VC2Do3mvCBOmeam+_9CAEW-eQbVCMdHNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

I was going through the linux/drivers/net/ethernet/mellanox/mlx4/qp.c

Got a few questions. Would really appreciate if someone can clarify:

In the function, mlx4_qp_alloc_icm,

To allocate a QP, there are 2 paths taken:

using the ALLOC_RES virtual command

using the MAP_ICM

These paths are taken based on the return value of mlx4_is_func(dev).
This is true for MASTER or SLAVE which I believe is Physical Function
Driver/Virtual Function Driver. So for SRIOV, it covers all cases.

The MAP_ICM portion which gets executed as part of __mlx4_qp_alloc_icm
never gets called??

Am I understanding it properly? Because as per my understanding ICM
needs to be allocated for all the QPs.

Please help me in understanding this.

Thanks so much.

Best Regards,

Bob
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
