From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 8/8 v2] IB/mlx5/hmm: enable ODP using HMM v2.
Date: Thu, 13 Aug 2015 15:20:53 -0400
Message-ID: <1439493653-1191-9-git-send-email-jglisse@redhat.com>
References: <1439493653-1191-1-git-send-email-jglisse@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439493653-1191-1-git-send-email-jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christophe Harle <charle-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Duncan Poole <dpoole-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Sherry Cheung <SCheung-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Subhash Gutti <sgutti-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Mark Hairgrove <mhairgrove-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Lucien Dunning <ldunning-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Cameron Buschardt <cabuschardt-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Arvind Gopalakrishnan <arvindg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

All pieces are in place for ODP (on demand paging) to work using HMM.
Add kernel option and final code to enable it.

Changed since v1:
  - Added kernel option in this last patch of the serie.

Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/Kconfig           | 10 ++++++++++
 drivers/infiniband/core/uverbs_cmd.c |  3 ---
 drivers/infiniband/hw/mlx5/main.c    |  4 ++++
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index b899531..764f524 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -49,6 +49,16 @@ config INFINIBAND_ON_DEMAND_PAGING
 	  memory regions without pinning their pages, fetching the
 	  pages on demand instead.
=20
+config INFINIBAND_ON_DEMAND_PAGING_HMM
+	bool "InfiniBand on-demand paging support using HMM."
+	depends on HMM
+	depends on INFINIBAND_ON_DEMAND_PAGING
+	default n
+	---help---
+	  Use HMM (heterogeneous memory management) kernel API for
+	  on demand paging. No userspace difference, this is just
+	  an alternative implementation of the feature.
+
 config INFINIBAND_ADDR_TRANS
 	bool
 	depends on INFINIBAND
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/=
core/uverbs_cmd.c
index 1db6a17..c3e14a8 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3445,8 +3445,6 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_fi=
le *file,
 		goto end;
=20
 #if IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)
-#if IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM)
-#else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 	resp.odp_caps.general_caps =3D attr.odp_caps.general_caps;
 	resp.odp_caps.per_transport_caps.rc_odp_caps =3D
 		attr.odp_caps.per_transport_caps.rc_odp_caps;
@@ -3455,7 +3453,6 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_fi=
le *file,
 	resp.odp_caps.per_transport_caps.ud_odp_caps =3D
 		attr.odp_caps.per_transport_caps.ud_odp_caps;
 	resp.odp_caps.reserved =3D 0;
-#endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
 	memset(&resp.odp_caps, 0, sizeof(resp.odp_caps));
 #endif /* CONFIG_INFINIBAND_ON_DEMAND_PAGING */
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/=
mlx5/main.c
index 32ed2f1..c340c3a 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -295,6 +295,10 @@ static int mlx5_ib_query_device(struct ib_device *=
ibdev,
=20
 #if IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)
 #if IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM)
+	if (MLX5_CAP_GEN(mdev, pg) && ibdev->hmm_ready) {
+		props->device_cap_flags |=3D IB_DEVICE_ON_DEMAND_PAGING;
+		props->odp_caps =3D dev->odp_caps;
+	}
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 	if (MLX5_CAP_GEN(mdev, pg))
 		props->device_cap_flags |=3D IB_DEVICE_ON_DEMAND_PAGING;
--=20
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
