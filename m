From: Bob Biloxi <iambobbiloxi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Query regarding MAD_DEMUX and Secure Host
Date: Mon, 15 Dec 2014 15:07:58 +0530
Message-ID: <CANwwZzXucfdxVYJWD3F=gJ2PLOnXEt-9aDSm4pskwO_pXFjaZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I was going through the mlx4 code for Secure Host and MAD_DEMUX feature.

I had a few queries..hoping that i can get these clarified.


If i understand correctly mlx4 codebase (mlx4_core/mlx4_en/mlx4_ib
drivers) take care of both RoCE and Infiniband adapters ( in both
dedicated and shared/SRIOV mode)


(1) After reading through the RoCE standard, I understood that Subnet
Management features are not supported in RoCE(they are part of
Infiniband)

(2) Also, as i understand MAD_DEMUX mechanism is used to control which
management traffic is passed to the host.

So by correlating these two( 1 & 2), am I correct in my understanding
when i say that MAD_DEMUX feature is not required to be
supported/implemented in Mellanox RoCE Drivers?

It is required only for Infiniband drivers?


I would be really thankful to get my understanding clarified.


Thanks so much....


Best Regards,
Bob
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
