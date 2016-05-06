From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 07/17] RDMA/iw_cxgb4: handle return value of c4iw_l2t_send() and send_mpa_req()
Date: Fri,  6 May 2016 22:18:00 +0530
Message-ID: <1462553290-16422-8-git-send-email-hariprasad@chelsio.com>
References: <1462553290-16422-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462553290-16422-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

->In act_open_rpl(), CPL_ERR_TCAM_FULL error handling branch, there is
no handling of the return value of send_fw_act_open_req().
->In send_fw_act_open_req(), there is no handling of return value of
c4iw_l2t_send(), which may cause a ep leak and won't notify upper layer=
s
on connection establish failure.
->send_mpa_req() should act on the return from c4iw_l2t_send() and
return the error to the caller.
->In case of c4iw_l2t_send() failure in send_mpa_req(), returns without
starting the timer and not changing the ep state, which is further
handled by act_establish()
-> In act_establish()=EF=BC=8Cif send_mpa_request's get_skb returns an =
error,
may cause an ep leak. So handle return value of send_mpa_req()

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 35 ++++++++++++++++++++++----------=
---
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/c=
xgb4/cm.c
index 410154c86061..658ea16d3265 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -217,6 +217,8 @@ static int c4iw_l2t_send(struct c4iw_rdev *rdev, st=
ruct sk_buff *skb,
 	error =3D cxgb4_l2t_send(rdev->lldi.ports[0], skb, l2e);
 	if (error < 0)
 		kfree_skb(skb);
+	else if (error =3D=3D NET_XMIT_DROP)
+		return -ENOMEM;
 	return error < 0 ? error : 0;
 }
=20
@@ -879,10 +881,10 @@ clip_release:
 	return ret;
 }
=20
-static void send_mpa_req(struct c4iw_ep *ep, struct sk_buff *skb,
-		u8 mpa_rev_to_use)
+static int send_mpa_req(struct c4iw_ep *ep, struct sk_buff *skb,
+			u8 mpa_rev_to_use)
 {
-	int mpalen, wrlen;
+	int mpalen, wrlen, ret;
 	struct fw_ofld_tx_data_wr *req;
 	struct mpa_message *mpa;
 	struct mpa_v2_conn_params mpa_v2_params;
@@ -898,7 +900,7 @@ static void send_mpa_req(struct c4iw_ep *ep, struct=
 sk_buff *skb,
 	skb =3D get_skb(skb, wrlen, GFP_KERNEL);
 	if (!skb) {
 		connect_reply_upcall(ep, -ENOMEM);
-		return;
+		return -ENOMEM;
 	}
 	set_wr_txq(skb, CPL_PRIORITY_DATA, ep->txq_idx);
=20
@@ -966,12 +968,14 @@ static void send_mpa_req(struct c4iw_ep *ep, stru=
ct sk_buff *skb,
 	t4_set_arp_err_handler(skb, NULL, arp_failure_discard);
 	BUG_ON(ep->mpa_skb);
 	ep->mpa_skb =3D skb;
-	c4iw_l2t_send(&ep->com.dev->rdev, skb, ep->l2t);
+	ret =3D c4iw_l2t_send(&ep->com.dev->rdev, skb, ep->l2t);
+	if (ret)
+		return ret;
 	start_ep_timer(ep);
 	__state_set(&ep->com, MPA_REQ_SENT);
 	ep->mpa_attr.initiator =3D 1;
 	ep->snd_seq +=3D mpalen;
-	return;
+	return ret;
 }
=20
 static int send_mpa_reject(struct c4iw_ep *ep, const void *pdata, u8 p=
len)
@@ -1174,9 +1178,11 @@ static int act_establish(struct c4iw_dev *dev, s=
truct sk_buff *skb)
 	if (ret)
 		goto err;
 	if (ep->retry_with_mpa_v1)
-		send_mpa_req(ep, skb, 1);
+		ret =3D send_mpa_req(ep, skb, 1);
 	else
-		send_mpa_req(ep, skb, mpa_rev);
+		ret =3D send_mpa_req(ep, skb, mpa_rev);
+	if (ret)
+		goto err;
 	mutex_unlock(&ep->com.mutex);
 	return 0;
 err:
@@ -1850,7 +1856,7 @@ static int abort_rpl(struct c4iw_dev *dev, struct=
 sk_buff *skb)
 	return 0;
 }
=20
-static void send_fw_act_open_req(struct c4iw_ep *ep, unsigned int atid=
)
+static int send_fw_act_open_req(struct c4iw_ep *ep, unsigned int atid)
 {
 	struct sk_buff *skb;
 	struct fw_ofld_connection_wr *req;
@@ -1920,7 +1926,7 @@ static void send_fw_act_open_req(struct c4iw_ep *=
ep, unsigned int atid)
 	req->tcb.opt2 =3D cpu_to_be32((__force u32)req->tcb.opt2);
 	set_wr_txq(skb, CPL_PRIORITY_CONTROL, ep->ctrlq_idx);
 	set_bit(ACT_OFLD_CONN, &ep->com.history);
-	c4iw_l2t_send(&ep->com.dev->rdev, skb, ep->l2t);
+	return c4iw_l2t_send(&ep->com.dev->rdev, skb, ep->l2t);
 }
=20
 /*
@@ -2146,6 +2152,7 @@ static int act_open_rpl(struct c4iw_dev *dev, str=
uct sk_buff *skb)
 	struct sockaddr_in *ra;
 	struct sockaddr_in6 *la6;
 	struct sockaddr_in6 *ra6;
+	int ret =3D 0;
=20
 	ep =3D lookup_atid(t, atid);
 	la =3D (struct sockaddr_in *)&ep->com.local_addr;
@@ -2181,9 +2188,10 @@ static int act_open_rpl(struct c4iw_dev *dev, st=
ruct sk_buff *skb)
 		mutex_unlock(&dev->rdev.stats.lock);
 		if (ep->com.local_addr.ss_family =3D=3D AF_INET &&
 		    dev->rdev.lldi.enable_fw_ofld_conn) {
-			send_fw_act_open_req(ep,
-					     TID_TID_G(AOPEN_ATID_G(
-					     ntohl(rpl->atid_status))));
+			ret =3D send_fw_act_open_req(ep, TID_TID_G(AOPEN_ATID_G(
+						   ntohl(rpl->atid_status))));
+			if (ret)
+				goto fail;
 			return 0;
 		}
 		break;
@@ -2223,6 +2231,7 @@ static int act_open_rpl(struct c4iw_dev *dev, str=
uct sk_buff *skb)
 		break;
 	}
=20
+fail:
 	connect_reply_upcall(ep, status2errno(status));
 	state_set(&ep->com, DEAD);
=20
--=20
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
