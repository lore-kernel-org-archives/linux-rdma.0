Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794283262;
	b=Q+bW0c7C+tnvxUkPtrW04Dw9+m1/LFX59TgZJtlCs6v2ktsuyS1EkGzfio0sD3hdGw95
	 k95J9MNuMyVFwzzbZbZe6NI6AHmrLclIcM/MO9wXvGf3WsiKp3LL5LR1EQRILHwNLojDU
	 AUE1JwpqYPDFvmmLS5dn07BVql5G7JG9lsSiLeQphJPG2Q683ACoMDTBvfjOKa5sBA5fe
	 zmxdpjxBFji3oXYD9DpUzp7JVEbNQNqI4FVi6ZXX3ZoTlhQHMdpATY6cedB/twbV67j5M
	 6eXzy04oQpmszUaqGappKGwyvQnPClHZMS30vc31an1X7rvTSlRqXSLD3mvHqkNCrow==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794283262;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=o8cgC6nWCZ7SpCixRo48bdGdL0sd/K8L8wL40JzCBxw=;
	b=oaIqDT3WG8Rna1z/j3vu4NxMLdU0BYDKP4dWjhbtsW/BUcZUNa+iDO9pNVqvdOSwuKSk
	 sgcYkNH0qRM3sJgtuGxrnI4GegtKwLTtwFmiZcvyebBHtW1IU5HVxGE9J+frXMQcxVZQq
	 /C1bbTjmjIVmA7kWEr8lB5PFEsdg/0LKOsx4TMC9KAi/sy0pS14wMRZOnioCIcHHWfNN1
	 epqar/J1whchP0BTGVKDdAWe/cUqhUY+9a7+HDUeqxkfC15hKQZDEQ8L5XMbLEeZlO1c8
	 f1BUauPr/Ad/aa7iOgWsmgRZmf2CNHI9UD/upn2uCQepVMpI2X05XOBPR/j8tb9EAEg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Yc/fiz4B";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C390A60A2614;
	Tue, 10 Nov 2026 04:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yc/fiz4B
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794283261;
	b=W0zdT4WGCU44YgTuQC7EuraXjMY/iYGocEWOGoQckrL0C+0Dhg9z4dmSfgAznwKTILQA
	 c4BAGSGd6zylGZyn0RfC5fpJ6vx1CowPDjyZX2k+Qclrhwm4FOxUzaUFo+YeKy1kLuEAN
	 Bg0Y5TCBYIj/bCZI9YH1yUP/FC4zMIzeT6HvPupG7xLaQy9AVzmfpCVErkSG18P8KM+21
	 jPkh8HiUZpzG6YURFXKfbmv57BqRLjwIsu8moDFce2eZSDu5S5au/h4+YSgbRom/LnSR5
	 cJEslAQeTOR7d/U4OonEILsp3RCSphiqTuF1oEw1yQcpYB7MhA5fec+tY2FRbktWiVQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794283261;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=o8cgC6nWCZ7SpCixRo48bdGdL0sd/K8L8wL40JzCBxw=;
	b=B84kR2AslnuDHGbtyzh+OjYSgabEQzZlHWuM36WRCQP0dwTBIwZMPCDzmtktrq0GGn/w
	 5ar57/VB1/g1HcT49icCnumvd5gqe6pimlY6nDQOPtsaUfTd0sF/TcZrCQVUM3iY8aITm
	 v4Tql3IIQznu3vwuOOjeG1zmOMvG1Sg0zPbBp8tWPg4/TEIw4zPK+6kggOBXeAX2vnTFH
	 2n6MhSBaaOKnuj4tbUOWZAP4fnHExBoDcyKeKTzZfKqyT3DER1dk3y4GcYiTS8vLBKuUb
	 jYzNi9uYCvM5O1z/iD9OgZBNXCe0nnutXNs/PSyEOm3UnMkiePaBmzvnRXx7ianVipw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5501F1F008A3;
	Tue, 10 Nov 2026 04:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794283261;
	bh=o8cgC6nWCZ7SpCixRo48bdGdL0sd/K8L8wL40JzCBxw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Yc/fiz4BDXw7kl5o70hn0SH/tSva4U/MOrMLoG3uG114KJjQh3K4e+PTp1mGTS/Oy
	 PA/dwwqJJidO54ANiYZxJzM+uRrun5F2SVyr+76+pmffpht1mfnku0O2stedJ64QGs
	 uIJ5cXrTlpOnPDtZgw2tdHyamAAk48u8lBx2ro05Cs0CYs1SDeZlb5NZyzhgODzm22
	 KfI9DfjI9xskFq63D9B9zsPwl+HpHvFboeEbQPITdL1rt3+iWYL3/yrKUStCHvuSAu
	 nmvHyU5CjxF8wSdSRrRenPNqunGpkEjqWvMjC1g0gPLESuli1DDgM6NV1MBk63ZSmz
	 k8fYNXIw1J4uQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D86E64880C;
	Tue, 10 Nov 2026 04:00:51 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Mon, 09 Nov 2026 20:00:38 -0800
Subject: [PATCH rdma-next v3 05/13] RDMA/core: extended address handle
 attributes
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261109-uet-ib-core-v3-5-3e7e7ffed2e9@broadcom.com>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
In-Reply-To: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794283250; l=16509;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=DTsX1pacJms5NTO68SFvcR4RydlW+miX0+yXZrnmoUM=;
 b=GCLX53bNxmKsCdVesMpgoHxOtEwDXZjhhNLKy0t3WM57LcCc3tlaEtPKMh4OyvLtrVZqXQHt1
 w3zD3VqrLf1DeEzUBv+WESSWJh1xq11EqZhMEtEs3EcqQYminfZg8do
X-Developer-Key: i=eric.davis@broadcom.com; a=ed25519;
 pk=uy3oCTOYBipIPjryXGMynBmtPvbO6qN2FOrduzpiI4A=
X-Endpoint-Received: by B4 Relay for eric.davis@broadcom.com/20261014 with
 auth_id=1186
X-Original-From: Eric Davis <eric.davis@broadcom.com>
Reply-To: eric.davis@broadcom.com
Content-Transfer-Encoding: 7bit

From: Eric Davis <eric.davis@broadcom.com>

An unconnected transport over UET resolves a peer by both its network
address and its queue pair number. The write() create-AH command has no
room for additional attributes. Add rdma_ah_attr_ex to carry new
attributes, reach it through rdma_ah_init_attr, and add an ioctl method
that supports it.

rdma_create_user_ah() now takes the init attributes rather than the
address alone, so callers pass the wider set.

Signed-off-by: Eric Davis <eric.davis@broadcom.com>
---
 drivers/infiniband/core/user_mad.c         |  4 +-
 drivers/infiniband/core/uverbs.h           |  3 ++
 drivers/infiniband/core/uverbs_cmd.c       | 60 ++++++++++++++----------
 drivers/infiniband/core/uverbs_std_types.c | 74 +++++++++++++++++++++++++++++-
 drivers/infiniband/core/verbs.c            | 43 +++++++++--------
 include/rdma/ib_verbs.h                    | 20 ++++++--
 include/uapi/rdma/ib_user_ioctl_cmds.h     |  7 +++
 include/uapi/rdma/ib_user_ioctl_verbs.h    |  9 ++++
 8 files changed, 173 insertions(+), 47 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index c3ef9f85c7eb..05e2898f0a6a 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -512,6 +512,7 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 	struct ib_umad_packet *packet;
 	struct ib_mad_agent *agent;
 	struct rdma_ah_attr ah_attr;
+	struct rdma_ah_init_attr init_attr = {};
 	struct ib_ah *ah;
 	__be64 *tid;
 	int ret, hdr_len, copy_offset, rmpp_active;
@@ -569,7 +570,8 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 		rdma_ah_set_dgid_raw(&ah_attr, packet->mad.hdr.gid);
 	}
 
-	ah = rdma_create_user_ah(agent->qp->pd, &ah_attr, NULL);
+	init_attr.ah_attr = &ah_attr;
+	ah = rdma_create_user_ah(agent->qp->pd, &init_attr, NULL);
 	if (IS_ERR(ah)) {
 		ret = PTR_ERR(ah);
 		goto err_up;
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 728e09b41992..6aaac1c309f0 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -236,6 +236,9 @@ int ib_uverbs_dealloc_xrcd(struct ib_uobject *uobject, struct ib_xrcd *xrcd,
 int uverbs_dealloc_mw(struct ib_mw *mw);
 void ib_uverbs_detach_umcast(struct ib_qp *qp,
 			     struct ib_uqp_object *uobj);
+int copy_ah_attr_from_uverbs_ah(struct ib_device *dev,
+				struct rdma_ah_attr *rdma_attr,
+				const struct ib_uverbs_ah_attr *uverb_attr);
 
 struct bundle_alloc_head {
 	struct_group_tagged(bundle_alloc_head_hdr, hdr,
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index e4fdfa0d9548..cca386b2c3f0 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1746,6 +1746,37 @@ static int modify_qp_mask(enum ib_qp_type qp_type, int mask)
 	}
 }
 
+/* The ib_uverbs_ah_attr counterpart of copy_ah_attr_from_uverbs() below,
+ * which takes the modify QP layout. This one also rejects an invalid port.
+ */
+int copy_ah_attr_from_uverbs_ah(struct ib_device *dev,
+				struct rdma_ah_attr *rdma_attr,
+				const struct ib_uverbs_ah_attr *uverb_attr)
+{
+	if (!rdma_is_port_valid(dev, uverb_attr->port_num))
+		return -EINVAL;
+
+	rdma_attr->type = rdma_ah_find_type(dev, uverb_attr->port_num);
+	rdma_ah_set_make_grd(rdma_attr, false);
+	rdma_ah_set_dlid(rdma_attr, uverb_attr->dlid);
+	rdma_ah_set_sl(rdma_attr, uverb_attr->sl);
+	rdma_ah_set_path_bits(rdma_attr, uverb_attr->src_path_bits);
+	rdma_ah_set_static_rate(rdma_attr, uverb_attr->static_rate);
+	rdma_ah_set_port_num(rdma_attr, uverb_attr->port_num);
+
+	if (uverb_attr->is_global) {
+		rdma_ah_set_grh(rdma_attr, NULL, uverb_attr->grh.flow_label,
+				uverb_attr->grh.sgid_index,
+				uverb_attr->grh.hop_limit,
+				uverb_attr->grh.traffic_class);
+		rdma_ah_set_dgid_raw(rdma_attr, uverb_attr->grh.dgid);
+	} else {
+		rdma_ah_set_ah_flags(rdma_attr, 0);
+	}
+
+	return 0;
+}
+
 static void copy_ah_attr_from_uverbs(struct ib_device *dev,
 				     struct rdma_ah_attr *rdma_attr,
 				     struct ib_uverbs_qp_dest *uverb_attr)
@@ -2435,6 +2466,7 @@ static int ib_uverbs_create_ah(struct uverbs_attr_bundle *attrs)
 	struct ib_pd			*pd;
 	struct ib_ah			*ah;
 	struct rdma_ah_attr		attr = {};
+	struct rdma_ah_init_attr	init_attr = {};
 	int ret;
 	struct ib_device *ib_dev;
 
@@ -2446,36 +2478,18 @@ static int ib_uverbs_create_ah(struct uverbs_attr_bundle *attrs)
 	if (IS_ERR(uobj))
 		return PTR_ERR(uobj);
 
-	if (!rdma_is_port_valid(ib_dev, cmd.attr.port_num)) {
-		ret = -EINVAL;
-		goto err;
-	}
-
 	pd = uobj_get_obj_read(pd, UVERBS_OBJECT_PD, cmd.pd_handle, attrs);
 	if (IS_ERR(pd)) {
 		ret = PTR_ERR(pd);
 		goto err;
 	}
 
-	attr.type = rdma_ah_find_type(ib_dev, cmd.attr.port_num);
-	rdma_ah_set_make_grd(&attr, false);
-	rdma_ah_set_dlid(&attr, cmd.attr.dlid);
-	rdma_ah_set_sl(&attr, cmd.attr.sl);
-	rdma_ah_set_path_bits(&attr, cmd.attr.src_path_bits);
-	rdma_ah_set_static_rate(&attr, cmd.attr.static_rate);
-	rdma_ah_set_port_num(&attr, cmd.attr.port_num);
-
-	if (cmd.attr.is_global) {
-		rdma_ah_set_grh(&attr, NULL, cmd.attr.grh.flow_label,
-				cmd.attr.grh.sgid_index,
-				cmd.attr.grh.hop_limit,
-				cmd.attr.grh.traffic_class);
-		rdma_ah_set_dgid_raw(&attr, cmd.attr.grh.dgid);
-	} else {
-		rdma_ah_set_ah_flags(&attr, 0);
-	}
+	ret = copy_ah_attr_from_uverbs_ah(ib_dev, &attr, &cmd.attr);
+	if (ret)
+		goto err_put;
 
-	ah = rdma_create_user_ah(pd, &attr, &attrs->driver_udata);
+	init_attr.ah_attr = &attr;
+	ah = rdma_create_user_ah(pd, &init_attr, &attrs->driver_udata);
 	if (IS_ERR(ah)) {
 		ret = PTR_ERR(ah);
 		goto err_put;
diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index e160786e1df1..856d85945393 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -184,6 +184,77 @@ DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_MW,
 			    UVERBS_TYPE_ALLOC_IDR(uverbs_free_mw),
 			    &UVERBS_METHOD(UVERBS_METHOD_MW_DESTROY));
 
+/* Creating an address handle is still a write() command whose request
+ * struct cannot grow. A transport (reliable unconnected) that resolves a
+ * peer using both transport and network addresses requires additional
+ * fields in the address handle. Here the address handle create command is
+ * made available as an ioctl method, where additional attributes can be
+ * carried.
+ */
+static int UVERBS_HANDLER(UVERBS_METHOD_AH_EX_CREATE)(
+	struct uverbs_attr_bundle *attrs)
+{
+	struct ib_uobject *uobj = uverbs_attr_get_uobject(
+		attrs, UVERBS_ATTR_CREATE_AH_EX_HANDLE);
+	struct ib_pd *pd =
+		uverbs_attr_get_obj(attrs, UVERBS_ATTR_CREATE_AH_EX_PD_HANDLE);
+	struct ib_device *ib_dev = attrs->context->device;
+	struct ib_uverbs_ah_attr_ex uah;
+	struct rdma_ah_init_attr init_attr = {};
+	struct rdma_ah_attr_ex attr = {};
+	struct ib_ah *ah;
+	int ret;
+
+	/* Only a reliable unconnected device has a use for the extended
+	 * attributes.
+	 */
+	if (!(ib_dev->attrs.device_cap_flags & IB_DEVICE_RU))
+		return -EOPNOTSUPP;
+
+	ret = uverbs_copy_from_or_zero(&uah, attrs,
+				       UVERBS_ATTR_CREATE_AH_EX_AH_ATTR_EX);
+	if (ret)
+		return ret;
+
+	ret = copy_ah_attr_from_uverbs_ah(ib_dev, &attr.ah_attr, &uah.ah_attr);
+	if (ret)
+		return ret;
+
+	if (uah.remote_qpn & IB_UVERBS_QPN_UET_RESERVED_MASK)
+		return -EINVAL;
+
+	attr.remote_qpn = uah.remote_qpn;
+
+	init_attr.ah_attr = &attr.ah_attr;
+	init_attr.ah_attr_ex = &attr;
+
+	ah = rdma_create_user_ah(pd, &init_attr, &attrs->driver_udata);
+	if (IS_ERR(ah))
+		return PTR_ERR(ah);
+
+	ah->uobject = uobj;
+	uobj->object = ah;
+	uverbs_finalize_uobj_create(attrs, UVERBS_ATTR_CREATE_AH_EX_HANDLE);
+
+	return 0;
+}
+
+DECLARE_UVERBS_NAMED_METHOD(
+	UVERBS_METHOD_AH_EX_CREATE,
+	UVERBS_ATTR_IDR(UVERBS_ATTR_CREATE_AH_EX_HANDLE,
+			UVERBS_OBJECT_AH,
+			UVERBS_ACCESS_NEW,
+			UA_MANDATORY),
+	UVERBS_ATTR_IDR(UVERBS_ATTR_CREATE_AH_EX_PD_HANDLE,
+			UVERBS_OBJECT_PD,
+			UVERBS_ACCESS_READ,
+			UA_MANDATORY),
+	UVERBS_ATTR_PTR_IN(UVERBS_ATTR_CREATE_AH_EX_AH_ATTR_EX,
+			   UVERBS_ATTR_STRUCT(struct ib_uverbs_ah_attr_ex,
+					      remote_qpn),
+			   UA_MANDATORY),
+	UVERBS_ATTR_UHW());
+
 DECLARE_UVERBS_NAMED_METHOD_DESTROY(
 	UVERBS_METHOD_AH_DESTROY,
 	UVERBS_ATTR_IDR(UVERBS_ATTR_DESTROY_AH_HANDLE,
@@ -193,7 +264,8 @@ DECLARE_UVERBS_NAMED_METHOD_DESTROY(
 
 DECLARE_UVERBS_NAMED_OBJECT(UVERBS_OBJECT_AH,
 			    UVERBS_TYPE_ALLOC_IDR(uverbs_free_ah),
-			    &UVERBS_METHOD(UVERBS_METHOD_AH_DESTROY));
+			    &UVERBS_METHOD(UVERBS_METHOD_AH_DESTROY),
+			    &UVERBS_METHOD(UVERBS_METHOD_AH_EX_CREATE));
 
 DECLARE_UVERBS_NAMED_METHOD_DESTROY(
 	UVERBS_METHOD_FLOW_DESTROY,
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index ccdb08284432..7e3cfebebf75 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -561,24 +561,23 @@ rdma_update_sgid_attr(struct rdma_ah_attr *ah_attr,
 }
 
 static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
-				     struct rdma_ah_attr *ah_attr,
-				     u32 flags,
-				     struct ib_udata *udata,
-				     struct net_device *xmit_slave)
+				     struct rdma_ah_init_attr *init_attr,
+				     struct ib_udata *udata)
 {
-	struct rdma_ah_init_attr init_attr = {};
+	struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
 	struct ib_device *device = pd->device;
 	struct ib_ah *ah;
 	int ret;
 
-	might_sleep_if(flags & RDMA_CREATE_AH_SLEEPABLE);
+	might_sleep_if(init_attr->flags & RDMA_CREATE_AH_SLEEPABLE);
 
 	if (!udata && !device->ops.create_ah)
 		return ERR_PTR(-EOPNOTSUPP);
 
 	ah = rdma_zalloc_drv_obj_gfp(
 		device, ib_ah,
-		(flags & RDMA_CREATE_AH_SLEEPABLE) ? GFP_KERNEL : GFP_ATOMIC);
+		(init_attr->flags & RDMA_CREATE_AH_SLEEPABLE) ? GFP_KERNEL :
+								GFP_ATOMIC);
 	if (!ah)
 		return ERR_PTR(-ENOMEM);
 
@@ -586,14 +585,12 @@ static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
 	ah->pd = pd;
 	ah->type = ah_attr->type;
 	ah->sgid_attr = rdma_update_sgid_attr(ah_attr, NULL);
-	init_attr.ah_attr = ah_attr;
-	init_attr.flags = flags;
-	init_attr.xmit_slave = xmit_slave;
 
 	if (udata)
-		ret = device->ops.create_user_ah(ah, &init_attr, udata);
+		ret = device->ops.create_user_ah(ah, init_attr, udata);
 	else
-		ret = device->ops.create_ah(ah, &init_attr, NULL);
+		ret = device->ops.create_ah(ah, init_attr, NULL);
+
 	if (ret) {
 		if (ah->sgid_attr)
 			rdma_put_gid_attr(ah->sgid_attr);
@@ -619,6 +616,7 @@ static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
 struct ib_ah *rdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
 			     u32 flags)
 {
+	struct rdma_ah_init_attr init_attr = {};
 	const struct ib_gid_attr *old_sgid_attr;
 	struct net_device *slave;
 	struct ib_ah *ah;
@@ -634,7 +632,12 @@ struct ib_ah *rdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
 		rdma_unfill_sgid_attr(ah_attr, old_sgid_attr);
 		return ERR_CAST(slave);
 	}
-	ah = _rdma_create_ah(pd, ah_attr, flags, NULL, slave);
+
+	init_attr.ah_attr = ah_attr;
+	init_attr.flags = flags;
+	init_attr.xmit_slave = slave;
+
+	ah = _rdma_create_ah(pd, &init_attr, NULL);
 	rdma_lag_put_ah_roce_slave(slave);
 	rdma_unfill_sgid_attr(ah_attr, old_sgid_attr);
 	return ah;
@@ -646,18 +649,21 @@ EXPORT_SYMBOL(rdma_create_ah);
  * given address vector.
  * It resolves destination mac address for ah attribute of RoCE type.
  * @pd: The protection domain associated with the address handle.
- * @ah_attr: The attributes of the address vector.
+ * @init_attr: The address vector, and for an extended handle the
+ *             attributes beyond it.
  * @udata: pointer to user's input output buffer information need by
  *         provider driver.
  *
- * It returns 0 on success and returns appropriate error code on error.
  * The address handle is used to reference a local or global destination
  * in all UD QP post sends.
+ *
+ * Return: the address handle, or an ERR_PTR on error.
  */
 struct ib_ah *rdma_create_user_ah(struct ib_pd *pd,
-				  struct rdma_ah_attr *ah_attr,
+				  struct rdma_ah_init_attr *init_attr,
 				  struct ib_udata *udata)
 {
+	struct rdma_ah_attr *ah_attr = init_attr->ah_attr;
 	const struct ib_gid_attr *old_sgid_attr;
 	struct ib_ah *ah;
 	int err;
@@ -674,8 +680,9 @@ struct ib_ah *rdma_create_user_ah(struct ib_pd *pd,
 		}
 	}
 
-	ah = _rdma_create_ah(pd, ah_attr, RDMA_CREATE_AH_SLEEPABLE,
-			     udata, NULL);
+	init_attr->flags |= RDMA_CREATE_AH_SLEEPABLE;
+
+	ah = _rdma_create_ah(pd, init_attr, udata);
 
 out:
 	rdma_unfill_sgid_attr(ah_attr, old_sgid_attr);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8d74ed4fc581..68f7a271cf7a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -974,10 +974,14 @@ struct ib_mr_status {
  */
 __attribute_const__ enum ib_rate mult_to_ib_rate(int mult);
 
+struct rdma_ah_attr_ex;
+
 struct rdma_ah_init_attr {
 	struct rdma_ah_attr *ah_attr;
 	u32 flags;
 	struct net_device *xmit_slave;
+	/* set to name a peer by both transport+network addresses */
+	struct rdma_ah_attr_ex *ah_attr_ex;
 };
 
 enum rdma_ah_attr_type {
@@ -1016,6 +1020,11 @@ struct rdma_ah_attr {
 	};
 };
 
+struct rdma_ah_attr_ex {
+	struct rdma_ah_attr	ah_attr;
+	u32			remote_qpn;
+};
+
 enum ib_wc_status {
 	IB_WC_SUCCESS,
 	IB_WC_LOC_LEN_ERR,
@@ -3893,16 +3902,18 @@ struct ib_ah *rdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
  * rdma_create_user_ah - Creates an address handle for the given address vector.
  * It resolves destination mac address for ah attribute of RoCE type.
  * @pd: The protection domain associated with the address handle.
- * @ah_attr: The attributes of the address vector.
+ * @init_attr: The address vector, and for an extended handle the
+ *             attributes beyond it.
  * @udata: pointer to user's input output buffer information need by
  *         provider driver.
  *
- * It returns 0 on success and returns appropriate error code on error.
  * The address handle is used to reference a local or global destination
  * in all UD QP post sends.
+ *
+ * Return: the address handle, or an ERR_PTR on error.
  */
 struct ib_ah *rdma_create_user_ah(struct ib_pd *pd,
-				  struct rdma_ah_attr *ah_attr,
+				  struct rdma_ah_init_attr *init_attr,
 				  struct ib_udata *udata);
 /**
  * ib_get_gids_from_rdma_hdr - Get sgid and dgid from GRH or IPv4 header
@@ -4981,7 +4992,8 @@ static inline struct ib_global_route
 	return &attr->grh;
 }
 
-static inline void rdma_ah_set_dgid_raw(struct rdma_ah_attr *attr, void *dgid)
+static inline void rdma_ah_set_dgid_raw(struct rdma_ah_attr *attr,
+					const void *dgid)
 {
 	struct ib_global_route *grh = rdma_ah_retrieve_grh(attr);
 
diff --git a/include/uapi/rdma/ib_user_ioctl_cmds.h b/include/uapi/rdma/ib_user_ioctl_cmds.h
index 816b3107464f..40fcd4bd1b5e 100644
--- a/include/uapi/rdma/ib_user_ioctl_cmds.h
+++ b/include/uapi/rdma/ib_user_ioctl_cmds.h
@@ -410,6 +410,13 @@ enum uverbs_attrs_xrcd_destroy_ids {
 
 enum uverbs_methods_ah {
 	UVERBS_METHOD_AH_DESTROY,
+	UVERBS_METHOD_AH_EX_CREATE,
+};
+
+enum uverbs_attrs_create_ah_ex_cmd_attr_ids {
+	UVERBS_ATTR_CREATE_AH_EX_HANDLE,
+	UVERBS_ATTR_CREATE_AH_EX_PD_HANDLE,
+	UVERBS_ATTR_CREATE_AH_EX_AH_ATTR_EX,
 };
 
 enum uverbs_attrs_ah_destroy_ids {
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index c568ed365c28..4975771290eb 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -323,6 +323,15 @@ struct ib_uverbs_buffer_desc {
 #define IB_UVERBS_QPN_UET_RESERVED_MASK		0x7f000000
 #define IB_UVERBS_QPN_UET_ABSOLUTE_ADDR_BIT	0x80000000
 
+/* An address handle that names a peer using both transport+network addresses.
+ * Used for reliable unconnected QPs in both work request address handles and
+ * a Job address table.
+ */
+struct ib_uverbs_ah_attr_ex {
+	struct ib_uverbs_ah_attr ah_attr;
+	__u32 remote_qpn;
+};
+
 enum ib_uverbs_comp_cntr_entry {
 	IB_UVERBS_COMP_CNTR_ENTRY_COMP,
 	IB_UVERBS_COMP_CNTR_ENTRY_ERR,

-- 
2.56.0


