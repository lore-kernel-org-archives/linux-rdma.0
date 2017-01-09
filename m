From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core] redhat: Remove non-existed infiniband modules
Date: Mon,  9 Jan 2017 10:54:29 +0200
Message-ID: <20170109085429.32598-1-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The modules ib_addr.ko, ib_mad.ko and ib_sa.ko were integrated
into ib_core.ko in following kernel commits:
 * c2e49c92326f ("IB/SA: Integrate ib_sa module into ib_core module")
 * 4c2cb4220431 ("IB/MAD: Integrate ib_mad module into ib_core module")
 * e3f20f02864f ("IB/core: Integrate IB address resolution module into core")

Fixes: 39fa824dd80e ("redhat: add udev/systemd/etc infrastructure bits")
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 redhat/rdma.kernel-init | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/redhat/rdma.kernel-init b/redhat/rdma.kernel-init
index 6cb4732..ecfe5b5 100644
--- a/redhat/rdma.kernel-init
+++ b/redhat/rdma.kernel-init
@@ -14,7 +14,7 @@ MTRR_SCRIPT=/usr/libexec/rdma-fixup-mtrr.awk
 LOAD_ULP_MODULES=""
 LOAD_CORE_USER_MODULES="ib_umad ib_uverbs ib_ucm rdma_ucm"
 LOAD_CORE_CM_MODULES="iw_cm ib_cm rdma_cm"
-LOAD_CORE_MODULES="ib_core ib_mad ib_sa ib_addr"
+LOAD_CORE_MODULES="ib_core"
 LOAD_TECH_PREVIEW_DRIVERS="no"

 if [ -f $CONFIG ]; then
--
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
