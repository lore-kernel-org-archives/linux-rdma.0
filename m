From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 08/15] IB/uverbs: Add ioctl support for 32bit processes
Date: Tue, 13 Feb 2018 12:18:34 +0200
Message-ID: <20180213101841.20101-9-leon@kernel.org>
References: <20180213101841.20101-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213101841.20101-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

32 bit processes running on a 64 bit kernel call compat_ioctl so that
implementations can revise any structure layout issues. Point compat_ioctl
at our normal ioctl because:

- All our structures are designed to be the same on 32 and 64 bit, ie we
  use __aligned_u64 when required and are careful to manage padding.

- Any pointers are stored in u64's and userspace is expected
  to prepare them properly.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 395a3b091229..cd72555ad457 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -942,6 +942,7 @@ static const struct file_operations uverbs_fops = {
 	.llseek	 = no_llseek,
 #if IS_ENABLED(CONFIG_INFINIBAND_EXP_USER_ACCESS)
 	.unlocked_ioctl = ib_uverbs_ioctl,
+	.compat_ioctl = ib_uverbs_ioctl,
 #endif
 };
 
@@ -954,6 +955,7 @@ static const struct file_operations uverbs_mmap_fops = {
 	.llseek	 = no_llseek,
 #if IS_ENABLED(CONFIG_INFINIBAND_EXP_USER_ACCESS)
 	.unlocked_ioctl = ib_uverbs_ioctl,
+	.compat_ioctl = ib_uverbs_ioctl,
 #endif
 };
 
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
