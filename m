From: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 0/2] IB/{core,mlx4_ib}: RX/TX checksum offload
Date: Wed,  5 Aug 2015 18:34:25 +0300
Message-ID: <1438788867-18332-1-git-send-email-amirv@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Dube <edube-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

This small patchset introduces a new member "csum_cap" inside ib_device_attr.
It is used to report RX/TX checksum offload capabilities of the device.
Having a new field enables reporting more specific capabilities than
the single bit IB_DEVICE_IP_CSUM.

This will be used by a revised version of the IP checksum patches [1], that
will be sent later on.

The patchset was applied and tested over branch to-be-rebased/for-4.3, commit
153b730 ("Merge branch 'hfi1-v4' into to-be-rebased/for-4.3")

[1] - libibverbs: https://patchwork.kernel.org/patch/6604211/
      libmlx4: https://patchwork.kernel.org/patch/6604221/

Thanks,
Amir

Amir Vadai (1):
  IB/mlx4_ib: Add support for RX/TX checksum offload capabilities report

Bodong Wang (1):
  IB/core: Add support for RX/TX checksum offload capabilities report

 drivers/infiniband/core/uverbs_cmd.c | 6 ++++++
 drivers/infiniband/hw/mlx4/main.c    | 6 ++++++
 include/rdma/ib_verbs.h              | 8 ++++++++
 include/uapi/rdma/ib_user_verbs.h    | 2 ++
 4 files changed, 22 insertions(+)

-- 
2.4.3.413.ga5fe668

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
