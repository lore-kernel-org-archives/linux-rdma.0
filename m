From: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/usnic: Handle 0 counts in resource allocation
Date: Wed,  9 Dec 2015 10:42:19 -0800
Message-ID: <1449686539-29959-6-git-send-email-neescoba@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Reese Faucette <rfaucett-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Xuyang Wang <xuywang-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_vnic.c | 54 +++++++++++++++++---------------
 1 file changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_vnic.c b/drivers/infiniband/hw/usnic/usnic_vnic.c
index 66de93f..8875107 100644
--- a/drivers/infiniband/hw/usnic/usnic_vnic.c
+++ b/drivers/infiniband/hw/usnic/usnic_vnic.c
@@ -237,7 +237,7 @@ usnic_vnic_get_resources(struct usnic_vnic *vnic, enum usnic_vnic_res_type type,
 	struct usnic_vnic_res *res;
 	int i;
 
-	if (usnic_vnic_res_free_cnt(vnic, type) < cnt || cnt < 1 || !owner)
+	if (usnic_vnic_res_free_cnt(vnic, type) < cnt || cnt < 0 || !owner)
 		return ERR_PTR(-EINVAL);
 
 	ret = kzalloc(sizeof(*ret), GFP_ATOMIC);
@@ -247,26 +247,28 @@ usnic_vnic_get_resources(struct usnic_vnic *vnic, enum usnic_vnic_res_type type,
 		return ERR_PTR(-ENOMEM);
 	}
 
-	ret->res = kzalloc(sizeof(*(ret->res))*cnt, GFP_ATOMIC);
-	if (!ret->res) {
-		usnic_err("Failed to allocate resources for %s. Out of memory\n",
-				usnic_vnic_pci_name(vnic));
-		kfree(ret);
-		return ERR_PTR(-ENOMEM);
-	}
+	if (cnt > 0) {
+		ret->res = kcalloc(cnt, sizeof(*(ret->res)), GFP_ATOMIC);
+		if (!ret->res) {
+			usnic_err("Failed to allocate resources for %s. Out of memory\n",
+					usnic_vnic_pci_name(vnic));
+			kfree(ret);
+			return ERR_PTR(-ENOMEM);
+		}
 
-	spin_lock(&vnic->res_lock);
-	src = &vnic->chunks[type];
-	for (i = 0; i < src->cnt && ret->cnt < cnt; i++) {
-		res = src->res[i];
-		if (!res->owner) {
-			src->free_cnt--;
-			res->owner = owner;
-			ret->res[ret->cnt++] = res;
+		spin_lock(&vnic->res_lock);
+		src = &vnic->chunks[type];
+		for (i = 0; i < src->cnt && ret->cnt < cnt; i++) {
+			res = src->res[i];
+			if (!res->owner) {
+				src->free_cnt--;
+				res->owner = owner;
+				ret->res[ret->cnt++] = res;
+			}
 		}
-	}
 
-	spin_unlock(&vnic->res_lock);
+		spin_unlock(&vnic->res_lock);
+	}
 	ret->type = type;
 	ret->vnic = vnic;
 	WARN_ON(ret->cnt != cnt);
@@ -281,14 +283,16 @@ void usnic_vnic_put_resources(struct usnic_vnic_res_chunk *chunk)
 	int i;
 	struct usnic_vnic *vnic = chunk->vnic;
 
-	spin_lock(&vnic->res_lock);
-	while ((i = --chunk->cnt) >= 0) {
-		res = chunk->res[i];
-		chunk->res[i] = NULL;
-		res->owner = NULL;
-		vnic->chunks[res->type].free_cnt++;
+	if (chunk->cnt > 0) {
+		spin_lock(&vnic->res_lock);
+		while ((i = --chunk->cnt) >= 0) {
+			res = chunk->res[i];
+			chunk->res[i] = NULL;
+			res->owner = NULL;
+			vnic->chunks[res->type].free_cnt++;
+		}
+		spin_unlock(&vnic->res_lock);
 	}
-	spin_unlock(&vnic->res_lock);
 
 	kfree(chunk->res);
 	kfree(chunk);
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
