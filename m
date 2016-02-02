From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libmlx5 0/7] Raw Packet QP for mlx5
Date: Tue,  2 Feb 2016 20:50:54 +0200
Message-ID: <1454439061-929-1-git-send-email-majd@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Yishai,

This patch set adds support for Raw Packet QP for libmlx5.

Raw Packet QP enables the user to send and receive raw packets. The user is
responsible of building the packet including the headers.

Raw Packet QP works with non-default CQE version, and in order to tie
CQE to Raw Packet QP, we need to provide a user-index in the creation of QPs
when working with non-default CQE version.

The first 5 patches add support for CQE version 1 for QPs and XSRQs. The later
patches add support for Raw Packet QP (control and data path).

Haggai Abramovsky (5):
  Add infrastructure for resource identification
  Add resource tracking database
  Add new poll_cq according to the new CQE format
  Add QP and XSRQ create/destroy flow with user index
  Work with CQE version 1

Majd Dibbiny (2):
  Allocate separate RQ and SQ buffers for Raw Packet QP
  Add Raw Packet QP data-path functionality

 src/cq.c       | 271 +++++++++++++++++++++++++++++++++++++++++++++++----------
 src/mlx5-abi.h |  20 ++++-
 src/mlx5.c     |  90 +++++++++++++++++++
 src/mlx5.h     |  63 +++++++++++++-
 src/qp.c       | 114 ++++++++++++++++++++----
 src/verbs.c    | 210 +++++++++++++++++++++++++++++++++++---------
 src/wqe.h      |  20 +++++
 7 files changed, 686 insertions(+), 102 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
