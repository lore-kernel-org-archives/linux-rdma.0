From: j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 36/36] IB/mlx5/hmm: enable ODP using HMM.
Date: Thu, 21 May 2015 15:23:53 -0400
Message-ID: <1432236233-4035-37-git-send-email-j.glisse@gmail.com>
References: <1432236233-4035-1-git-send-email-j.glisse@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432236233-4035-1-git-send-email-j.glisse-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brendan Conoboy <blc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Joe Donohue <jdonohue-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Duncan Poole <dpoole-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Sherry Cheung <SCheung-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Subhash Gutti <sgutti-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Mark Hairgrove <mhairgrove-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Lucien Dunning <ldunning-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Cameron Buschardt <cabuschardt-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Arvind Gopalakrishnan <arvindg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46rom: J=C3=A9r=C3=B4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

All pieces are in place for ODP (on demand paging) to work using HMM.

Signed-off-by: J=C3=A9r=C3=B4me Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
cc: <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 4 ----
 drivers/infiniband/hw/mlx5/main.c    | 6 +++++-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/=
core/uverbs_cmd.c
index 3225ab5..16520bd 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3340,9 +3340,6 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_fi=
le *file,
 		goto end;
=20
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
-#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
-#error "CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM not supported at this s=
tage !"
-#else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 	resp.odp_caps.general_caps =3D attr.odp_caps.general_caps;
 	resp.odp_caps.per_transport_caps.rc_odp_caps =3D
 		attr.odp_caps.per_transport_caps.rc_odp_caps;
@@ -3351,7 +3348,6 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_fi=
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
index eddabf0..cff70a2 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -157,7 +157,11 @@ static int mlx5_ib_query_device(struct ib_device *=
ibdev,
=20
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM
-#error "CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM not supported at this s=
tage !"
+	if ((dev->mdev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG) &&
+	     ibdev->hmm_ready) {
+		props->device_cap_flags |=3D IB_DEVICE_ON_DEMAND_PAGING;
+		props->odp_caps =3D dev->odp_caps;
+	}
 #else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
 	if (dev->mdev->caps.gen.flags & MLX5_DEV_CAP_FLAG_ON_DMND_PG)
 		props->device_cap_flags |=3D IB_DEVICE_ON_DEMAND_PAGING;
--=20
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
