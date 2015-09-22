From: wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [v1 0/2] Checksum offload capability report
Date: Tue, 22 Sep 2015 23:18:09 +0300
Message-ID: <1442953091-102103-1-git-send-email-bodong@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This series adds kernel support for checksum offload cap report. The first patch
adds reporting for RAW and RC QPs. Patch 2 sets the capability according to
hardware.

Changes from v1:
  * The cap is reported through existing device_cap_flags. Only new enum members
    are added rather than to use an extra structure. IB_DEVICE_UD_IP_CSUM is
    already defined there.
  * Note: although there is no link layer info indicated here, normally UD and
    RC QPs are only available through IB, RAW QP is only available over
    Ethernet.

Bodong Wang (2):
  IB/core: Add support of checksum capability reporting for RC and RAW
  IB/mlx4: Report checksum offload cap for RAW QP when query device

 drivers/infiniband/hw/mlx4/main.c | 2 ++
 include/rdma/ib_verbs.h           | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
