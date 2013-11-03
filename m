From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 1/2] IB/core: Fix build warnings
Date: Sun,  3 Nov 2013 10:20:43 +0200
Message-ID: <1383466844-8805-2-git-send-email-ogerlitz@mellanox.com>
References: <1383466844-8805-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383466844-8805-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46ix the below few "make W=3D1" build warnings we have on the IB core.

drivers/infiniband/core/sysfs.c: In function =E2=80=98state_show=E2=80=99=
:
drivers/infiniband/core/sysfs.c:107: warning: comparison of unsigned ex=
pression >=3D 0 is always true
drivers/infiniband/core/verbs.c: In function =E2=80=98ib_modify_qp_is_o=
k=E2=80=99:
drivers/infiniband/core/verbs.c:783: warning: comparison of unsigned ex=
pression < 0 is always false
drivers/infiniband/core/verbs.c:784: warning: comparison of unsigned ex=
pression < 0 is always false
drivers/infiniband/core/iwcm.c: In function =E2=80=98destroy_cm_id=E2=80=
=99:
drivers/infiniband/core/iwcm.c:330: warning: variable =E2=80=98ret=E2=80=
=99 set but not used

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/iwcm.c  |    3 +--
 drivers/infiniband/core/sysfs.c |    2 +-
 drivers/infiniband/core/verbs.c |    3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/i=
wcm.c
index c47c203..bdb4d50 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -327,7 +327,6 @@ static void destroy_cm_id(struct iw_cm_id *cm_id)
 {
 	struct iwcm_id_private *cm_id_priv;
 	unsigned long flags;
-	int ret;
=20
 	cm_id_priv =3D container_of(cm_id, struct iwcm_id_private, id);
 	/*
@@ -343,7 +342,7 @@ static void destroy_cm_id(struct iw_cm_id *cm_id)
 		cm_id_priv->state =3D IW_CM_STATE_DESTROYING;
 		spin_unlock_irqrestore(&cm_id_priv->lock, flags);
 		/* destroy the listening endpoint */
-		ret =3D cm_id->device->iwcm->destroy_listen(cm_id);
+		(void)cm_id->device->iwcm->destroy_listen(cm_id);
 		spin_lock_irqsave(&cm_id_priv->lock, flags);
 		break;
 	case IW_CM_STATE_ESTABLISHED:
diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/=
sysfs.c
index cde1e7b..1184050 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -104,7 +104,7 @@ static ssize_t state_show(struct ib_port *p, struct=
 port_attribute *unused,
 		return ret;
=20
 	return sprintf(buf, "%d: %s\n", attr.state,
-		       attr.state >=3D 0 && attr.state < ARRAY_SIZE(state_name) ?
+		       attr.state < ARRAY_SIZE(state_name) ?
 		       state_name[attr.state] : "UNKNOWN");
 }
=20
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/=
verbs.c
index a321df2..7b0c1f4 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -780,8 +780,7 @@ int ib_modify_qp_is_ok(enum ib_qp_state cur_state, =
enum ib_qp_state next_state,
 {
 	enum ib_qp_attr_mask req_param, opt_param;
=20
-	if (cur_state  < 0 || cur_state  > IB_QPS_ERR ||
-	    next_state < 0 || next_state > IB_QPS_ERR)
+	if (cur_state  > IB_QPS_ERR || next_state > IB_QPS_ERR)
 		return 0;
=20
 	if (mask & IB_QP_CUR_STATE  &&
--=20
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
