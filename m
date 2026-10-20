Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792465417;
	b=S1VqUUhDOG6SyWv0LoB2MfdBHjtkYSBKQ23vL803t7UovXsAr/FOWMTqrV6piXbFBvEh
	 8EXr6JSKggrTzGVw36ywYwx+J9zXrv5bLcNcWohFsZuYQmdER6QhfUrp0gqCJTJD2RknP
	 M/qp6+Vumk0Cmt0/nzcyCkLEsCdums8pOI+mB/yA0X8EygqYx+0PRk3ev4slpzCRolWp1
	 SRUi3wbYdKnR5b1BVKYnAXJRXs0PzxAb499iP773u6AS2+5NpZqJtCy0bLQxNPH3/aPLG
	 qoFXIsZdef0yQQ5yB/9OIKgCyJSZDgfoq4Vv7JTWMGlulpcxjsynT7l0GD+Sws8Dh5A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792465417;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ly91CA7QjB0yfExInbS/fKsLRnzGLs9BWByVDIJDBNg=;
	b=M0ENrps6uGiJa5hGYabGm78pmuuMAjmjOKFU760M1hi961B05qKEZcUJi3ppAAAQX+XM
	 xdFo5kPgKa7OMSj7IdeERTHGqTQp7LdQI/x3qnt6vU/emuRIHN77hDgN6igNY3Y5AI7oY
	 hEqPZ5L9YmsEEYzht4k5N0HOTaFaFG4W4aeCxLf2prq10HdaPaJMsviDWcVNGbD7HOqyD
	 eM5fkBd52ZtwR/l5opGc6rny8E9ALEcxlDaPLn0KAZHBCU+oLxd9pViAKrdSh47ildI6h
	 bQH7vY3NjlO3Cg1vLGHF3FCBbIv5uTALtXFKGtF+ZNpwxfVPrKvKKVHqEcpDmseQUvA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WbumNXLt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FC1606A319;
	Tue, 20 Oct 2026 03:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WbumNXLt
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792465416;
	b=sNVyaB1nlPBIO9HG4rAzndcOleJJh/Jh7AYtOyrLUhEwywHtYF/4zR71q4gYGpNQXMHk
	 dkRNbVHT9sDfO3xlasJLq/Xqs8bOn3oTYCFEl5e5Z0Xa3wkjCA6ignlNRslghxaX3oeGH
	 +ius9j74CLnBeXMTIkf/b3Lx6imjTEcC0dVftb2wvd5g/tKWTIBuZjRY/lSl4yqReJ7/V
	 HOM5iTp0Ql0FQjV1C+jDJ40lNGM48HDj7o02sE9llQRKb3hOjRkV5LKqvAOA/toGwYJ/C
	 qLbDdZKQVEBnqodLZw+lekXsDdXd6X9msOSa+9HjOCHENWOCIMvbmBY6PpjFUKKA4Wg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792465416;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ly91CA7QjB0yfExInbS/fKsLRnzGLs9BWByVDIJDBNg=;
	b=ZDipXttutkFx7knizg2IaaWbuaPDrzu2UnUG0OJeIlzAcyqIGfkX9SITekXHA4z7wBxW
	 OLy+QTXp9CyVwVm0enamAHrsNXUzek8Y4+CVg9cWZ7OkfPPt5LP2LJuln8SUWPdUSxNws
	 zedaOMOEeG2++XqkWzvcWa83T7+SbNfQ711JkZCsUmpNyGbIM29AW5n3GyurRKpRfmmBK
	 OqpRPXae1Z4zgMRYY04cXjMVmjEqPVAl79wqz4sLA2g0MxluE+xddThulQ3AZw63rqBPR
	 4EuIWLtZM6mSaqq8C7OdNnO7iOrm6kT2U6Z7R5/e66jWWzWlpxRpOLARYLLFZ5I/Y3g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B7C361F000C5;
	Tue, 20 Oct 2026 03:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465416;
	bh=ly91CA7QjB0yfExInbS/fKsLRnzGLs9BWByVDIJDBNg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=WbumNXLtV3405fBZmnD4cmTO+k6NCGZohhiHPH36aunxCJsJiP6Saj7P8sZjZTs/8
	 TTnB1f6I83bRNSlXMct5FqAcyrJD6vSrib0c86liTvukc97hwrUDmbfht4OopVIH9p
	 cmsISuWSBqknkd1xlUGX/bp3pPhtsYE/WyUDhJNoqv3rlIj1umJnjPkhCG9YsTdaY4
	 j26+wPKkD+CTJMd8P7B8rxz/LfVURysDVYyVVVIgy8x5GkW5iHCmv0NVv22CrQUZt6
	 64F3nc134Pr0+gWXC2wJOt5AdWXTinuM11er84Qg4fazii/WYFOg5mOSyBf+4l59Gz
	 dTxRpeBWTtcgg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2DDF340709;
	Tue, 20 Oct 2026 03:03:35 +0000 (UTC)
From: Eric Davis via B4 Relay <devnull+eric.davis.broadcom.com@kernel.org>
Date: Mon, 19 Oct 2026 20:03:31 -0700
Subject: [PATCH rdma-next v2 04/13] RDMA/core: add the reliable unconnected
 queue pair type
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
Message-Id: <20261019-uet-ib-core-v2-4-8bd654f25370@broadcom.com>
References: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
In-Reply-To: <20261019-uet-ib-core-v2-0-8bd654f25370@broadcom.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Eric Davis <eric.davis@broadcom.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792465414; l=4583;
 i=eric.davis@broadcom.com; s=20261014; h=from:subject:message-id;
 bh=EWRf4cDO67t06PHg/KvDiWA4QDgIyvbCWmC5JmJw6ms=;
 b=+7XEWOaGTNgo/sF7SDJcmkbhshgB+MvK8BKmy2b1uBMr9iuhlci0Ic/kvoKpzsRWx69DgPmj/
 mjm8OI/5LdPCVrBJDumIgEUfw1JW4ejTBZ/+3KyTPOI3icJ2UYBDVHg
X-Developer-Key: i=eric.davis@broadcom.com; a=ed25519;
 pk=uy3oCTOYBipIPjryXGMynBmtPvbO6qN2FOrduzpiI4A=
X-Endpoint-Received: by B4 Relay for eric.davis@broadcom.com/20261014 with
 auth_id=1186
X-Original-From: Eric Davis <eric.davis@broadcom.com>
Reply-To: eric.davis@broadcom.com
Content-Transfer-Encoding: 7bit

From: Eric Davis <eric.davis@broadcom.com>

Add IB_QPT_RU and its userspace counterpart, together with the field
layout of a reliable unconnected queue pair number used by UET.

Such a number uses all 32 bits, unlike the 24-bit InfiniBand and RoCE
one, so exempt it from the restrack assertion that no queue pair number
sets the top byte.

Signed-off-by: Eric Davis <eric.davis@broadcom.com>
---
 drivers/infiniband/core/restrack.c      | 13 ++++++++++++-
 drivers/infiniband/core/uverbs_cmd.c    | 14 ++++++++++++++
 include/rdma/ib_verbs.h                 |  1 +
 include/uapi/rdma/ib_user_ioctl_verbs.h | 16 ++++++++++++++++
 4 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index a8b838fdc7b5..ddb09b17b733 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -241,7 +241,18 @@ void rdma_restrack_add(struct rdma_restrack_entry *res)
 		/* Special case to ensure that LQPN points to right QP */
 		struct ib_qp *qp = container_of(res, struct ib_qp, res);
 
-		WARN_ONCE(qp->qp_num >> 24 || qp->port >> 8,
+		/* An InfiniBand/RoCE QP number is 24 bits and the top byte is
+		 * where the port is folded in for SMI and GSI. A reliable
+		 * unconnected pair is an exception as its QP number is a
+		 * full 32b wide, though of the top byte only the absolute bit
+		 * may be set. An absolute number whose low bits are 0 or 1
+		 * still conflicts SMI/GSI on port 128, which takes a device
+		 * with both RU and MADs on that many ports.
+		 */
+		WARN_ONCE(qp->port >> 8 ||
+			  (qp->qp_type != IB_QPT_RU && qp->qp_num >> 24) ||
+			  (qp->qp_type == IB_QPT_RU &&
+			   qp->qp_num & IB_UVERBS_QPN_UET_RESERVED_MASK),
 			  "QP number 0x%0X and port 0x%0X", qp->qp_num,
 			  qp->port);
 		res->id = qp->qp_num;
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index ed55fbbdfc18..e4fdfa0d9548 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -2058,6 +2058,12 @@ static int ib_uverbs_post_send(struct uverbs_attr_bundle *attrs)
 		goto out;
 	}
 
+	/* reliable unconnected work requests are posted by the provider */
+	if (qp->qp_type == IB_QPT_RU) {
+		ret = -EOPNOTSUPP;
+		goto out_put;
+	}
+
 	is_ud = qp->qp_type == IB_QPT_UD;
 	sg_ind = 0;
 	last = NULL;
@@ -2335,6 +2341,14 @@ static int ib_uverbs_post_recv(struct uverbs_attr_bundle *attrs)
 		goto out;
 	}
 
+	/* reliable unconnected work requests are posted by the provider */
+	if (qp->qp_type == IB_QPT_RU) {
+		rdma_lookup_put_uobject(&qp->uobject->uevent.uobject,
+					UVERBS_LOOKUP_READ);
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
 	resp.bad_wr = 0;
 	ret = qp->device->ops.post_recv(qp->real_qp, wr, &bad_wr);
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 02f3312c7cf2..8d74ed4fc581 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1188,6 +1188,7 @@ enum ib_qp_type {
 	IB_QPT_RAW_PACKET = IB_UVERBS_QPT_RAW_PACKET,
 	IB_QPT_XRC_INI = IB_UVERBS_QPT_XRC_INI,
 	IB_QPT_XRC_TGT = IB_UVERBS_QPT_XRC_TGT,
+	IB_QPT_RU = IB_UVERBS_QPT_RU,
 	IB_QPT_MAX,
 	IB_QPT_DRIVER = IB_UVERBS_QPT_DRIVER,
 	/* Reserve a range for qp types internal to the low level driver.
diff --git a/include/uapi/rdma/ib_user_ioctl_verbs.h b/include/uapi/rdma/ib_user_ioctl_verbs.h
index ed72f48960f8..b6d46115f799 100644
--- a/include/uapi/rdma/ib_user_ioctl_verbs.h
+++ b/include/uapi/rdma/ib_user_ioctl_verbs.h
@@ -91,6 +91,7 @@ enum ib_uverbs_qp_type {
 	IB_UVERBS_QPT_RAW_PACKET = 8,
 	IB_UVERBS_QPT_XRC_INI,
 	IB_UVERBS_QPT_XRC_TGT,
+	IB_UVERBS_QPT_RU,
 	IB_UVERBS_QPT_DRIVER = 0xFF,
 };
 
@@ -302,6 +303,21 @@ struct ib_uverbs_buffer_desc {
 	__aligned_u64 length;
 };
 
+/* A UET reliable unconnected queue pair number uses all 32 bits:
+ *
+ *	[ absolute 1b | reserved 7b | resource index 12b | PIDonFEP 12b ]
+ *
+ * An absolute pair is named by its number alone. A relative one is named
+ * within a job, so it must carry a job key when it is created. The reserved
+ * bits are zero.
+ */
+#define IB_UVERBS_QPN_UET_PID_ON_FEP_MASK	0x00000fff
+#define IB_UVERBS_QPN_UET_PID_ON_FEP_SHIFT	0
+#define IB_UVERBS_QPN_UET_RI_MASK		0x00fff000
+#define IB_UVERBS_QPN_UET_RI_SHIFT		12
+#define IB_UVERBS_QPN_UET_RESERVED_MASK		0x7f000000
+#define IB_UVERBS_QPN_UET_ABSOLUTE_ADDR_BIT	0x80000000
+
 enum ib_uverbs_comp_cntr_entry {
 	IB_UVERBS_COMP_CNTR_ENTRY_COMP,
 	IB_UVERBS_COMP_CNTR_ENTRY_ERR,

-- 
2.56.0


