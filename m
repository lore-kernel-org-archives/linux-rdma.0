From: Zhu Yanjun <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/6] Trivial patches for SoftRoCE
Date: Wed, 31 Jan 2018 06:06:53 -0500
Message-ID: <1517396819-29597-1-git-send-email-yanjun.zhu@oracle.com>
References: <20180130073006.GA3244@yuvallap>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180130073006.GA3244@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Follow advice from Yuval and Leon, to the functions rxe_av_chk_attr,
rxe_av_to_attr and rxe_av_fill_ip_info, the unnecessary parameter
are removed and the funtion type are changed to void.

To track the changes to these functions, every change is made
to a single patch.

Zhu Yanjun (6):
  IB/rxe: remove redudant parameter in function
  IB/rxe: change the function to void from int
  IB/rxe: remove unnecessary parameter in rxe_av_to_attr
  IB/rxe: change the function to void from int
  IB/rxe: change the function rxe_av_fill_ip_info to void
  IB/rxe: remove redudant parameter in rxe_av_fill_ip_info

 drivers/infiniband/sw/rxe/rxe_av.c    | 14 ++++----------
 drivers/infiniband/sw/rxe/rxe_loc.h   | 10 ++++------
 drivers/infiniband/sw/rxe/rxe_qp.c    | 15 ++++++---------
 drivers/infiniband/sw/rxe/rxe_verbs.c | 10 ++++------
 4 files changed, 18 insertions(+), 31 deletions(-)

-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
