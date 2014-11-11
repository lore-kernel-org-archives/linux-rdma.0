From: Mohammed Rafi K C <muhammedrafi13-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: ibv_reg_mr fails to register memory
Date: Tue, 11 Nov 2014 15:42:23 +0530
Message-ID: <1415700743.7672.1.camel@rafi>
Reply-To: muhammedrafi13-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "rtalur-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <rtalur-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi All,

I was trying to implement an application that support rdma using
librdmacm. When the process is trying to register the buffer using
ibv_reg_mr, it failes after registering  some number buffer.

We are using Mellanox Technologies MT27500 Family [ConnectX-3] cards. 

Reconfigured options are :

1) cat /sys/module/mlx4_core/parameters/log_num_mtt
    24
2) cat /sys/module/mlx4_core/parameters/log_mtts_per_seg
    7

Can anyone point out reason behind ibv_reg_mr fails ?

Thanks & Regards
Rafi KC

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
