From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: IB/mlx4: Use EAGAIN error code instead or EINVAL in function mlx4_ib_poll_one
Date: Wed, 27 Jul 2016 01:24:51 -0700
Message-ID: <1469607893-10657-1-git-send-email-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Please review the following two patches.
First patch makes int-return function to a void one as it anyway returns 0.
Second patch replace all EINVAL error codes returned from mlx4_ib_poll_one
to EAGAIN.

[PATCH 1/2] IB/mlx4: Make function use_tunnel_data return void
[PATCH 2/2] IB/mlx4: Return EAGAIN for any error in mlx4_ib_poll_one
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
