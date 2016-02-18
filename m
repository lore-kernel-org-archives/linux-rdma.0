From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/2] Add support for don't trap steering rule
Date: Thu, 18 Feb 2016 18:31:04 +0200
Message-ID: <1455813066-13028-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, marinav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This series from Marina adds an option to create a normal flow steering
rule that doesn't trap received packets, allowing them to match lower
prioritized rules.

When the don't trap rule exists and matches a packet, the underlying HCA
should pass the packet to the rule's assigned QP(s). However, the HCA will
continue looking for other matches at lower priority rules, which may be
assigned to other QPs. This will let them get the traffic as well.

The series includes two patches:
The first patch exposes the IB creation flag.
The second patch implements this feature in mlx4 driver.

It was reviewed by Matan and me.

Yishai 

Marina Varshaver (2):
  IB/core: Add don't trap flag to flow creation
  IB/mlx4: Add support for the don't trap rule

 drivers/infiniband/core/uverbs_cmd.c     |  8 ++++
 drivers/infiniband/hw/mlx4/main.c        | 72 ++++++++++++++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlx4/fw.c  |  5 ++-
 drivers/net/ethernet/mellanox/mlx4/mcg.c |  6 ++-
 include/linux/mlx4/device.h              |  3 ++
 include/rdma/ib_verbs.h                  |  5 +++
 6 files changed, 93 insertions(+), 6 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
