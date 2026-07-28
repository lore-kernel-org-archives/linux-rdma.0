Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB9045D1A6;
	Tue, 28 Jul 2026 18:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785263649; cv=none; b=YLPIUsHjVNTULas7F7GLojcBSLXeDoMQwcxNq2ukDPwMqrKPeMjG3bY2RxVxHlWUF091AqF4kOB+EzQGTf9OVbwIlAlZquSMsG4g2ABJGp6QJ6YxpJTSocJRFb3m79vCgXbbm6Whbh1kwirRtDeEtg4hSjXyRZASaWEMcc8rgKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785263649; c=relaxed/simple;
	bh=LhyKURfIiRF5tibLBA9kt7bkghB0jDIIzW7udhCFb8s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gFITOyx8K3WMmOggCY8Qjwm1RjKvEj26G7aCQWSKwTdhoEOeBkmcSBQTdzVs3VOeiibfN32HdcLwTHWKbgeejrcUHtoTqxBynrkpVfiNhKt0R5LfpFknbCrWfxkkhZEf9ZZAz22jRONDRXUzlB1C8Re6Xu6D0fZONLQFb129rRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PzLxfWju; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PzLxfWju"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ob12MoRHJOQKjIp/mbNQWo1xNI9hC5LuQxLdwspgE50=; b=PzLxfWjukRVpmTk5MAnrJyf7uk
	Iu7662ptaQOGofgKBLmd9LTr/k9whnXkcfMhCQvUqBT7+RQ4ulBjVZggqOXsGdibsyXQmNUjtFF7J
	b9NuldsOdMu1Dc4qT4D11FoRpSE0xJIdJbTN/52qF6j5OSJFH9MPCnsHMuvLxk7f1ME+SEdTYW0uJ
	rJ2Xw+JAF+4Z0PqwEQg+oHOnS7KMEfeuUBr/mbwtcKUOfYdhZHpep5Gma30lEohr4Ia1RSSE2Jg3T
	ZIdmhe4Ka3rcih+oAwih7OvJRHydfRVzc1BGTIW00W0ve4nvQiIcKkrWhae86Tbb78dmuPTwdFacN
	H32Vg0oA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1womct-000000064Y6-3di4;
	Tue, 28 Jul 2026 18:34:03 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	linux-rdma@vger.kernel.org
Subject: [PATCH] IB/mad: cleanup all kernel-doc comments
Date: Tue, 28 Jul 2026 11:34:03 -0700
Message-ID: <20260728183403.1136827-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a leading "struct" keyword to struct descriptions:
Warning: ../include/uapi/rdma/ib_user_mad.h:72 cannot understand function prototype: 'struct ib_user_mad_hdr_old'
Warning: ../include/uapi/rdma/ib_user_mad.h:116 cannot understand function prototype: 'struct ib_user_mad_hdr'
Warning: ../include/uapi/rdma/ib_user_mad.h:143 cannot understand function prototype: 'struct ib_user_mad'
Warning: ../include/uapi/rdma/ib_user_mad.h:184 cannot understand function prototype: 'struct ib_user_mad_reg_req'
Warning: ../include/uapi/rdma/ib_user_mad.h:216 cannot understand function prototype: 'enum'

One enum and #define are moved out of line so that the struct description
and the struct block are not split (separated).

When this is done, more warnings are exposed:
Warning: include/uapi/rdma/ib_user_mad.h:89 struct member 'length' not described in 'ib_user_mad_hdr_old'
Warning: include/uapi/rdma/ib_user_mad.h:135 struct member 'length' not described in 'ib_user_mad_hdr'
Warning: include/uapi/rdma/ib_user_mad.h:135 struct member 'reserved' not described in 'ib_user_mad_hdr'
Warning: include/uapi/rdma/ib_user_mad.h:227 struct member 'id' not described in 'ib_user_mad_reg_req2'
Warning: include/uapi/rdma/ib_user_mad.h:227 struct member 'qpn' not described in 'ib_user_mad_reg_req2'
Warning: include/uapi/rdma/ib_user_mad.h:227 struct member 'mgmt_class' not described in 'ib_user_mad_reg_req2'
Warning: include/uapi/rdma/ib_user_mad.h:227 struct member 'mgmt_class_version' not described in 'ib_user_mad_reg_req2'
Warning: include/uapi/rdma/ib_user_mad.h:227 struct member 'res' not described in 'ib_user_mad_reg_req2'
Warning: include/uapi/rdma/ib_user_mad.h:227 struct member 'flags' not described in 'ib_user_mad_reg_req2'
Warning: include/uapi/rdma/ib_user_mad.h:227 struct member 'method_mask' not described in 'ib_user_mad_reg_req2'
Warning: include/uapi/rdma/ib_user_mad.h:227 struct member 'oui' not described in 'ib_user_mad_reg_req2'
Warning: include/uapi/rdma/ib_user_mad.h:227 struct member 'rmpp_version' not described in 'ib_user_mad_reg_req2'
Warning: include/uapi/rdma/ib_user_mad.h:227 struct member 'reserved' not described in 'ib_user_mad_reg_req2'

These are all repaired by using ':' as the separator between the struct
member @name and its description (instead of '-').

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: linux-rdma@vger.kernel.org

 include/uapi/rdma/ib_user_mad.h |   95 +++++++++++++++---------------
 1 file changed, 48 insertions(+), 47 deletions(-)

--- linux-next-20260727.orig/include/uapi/rdma/ib_user_mad.h
+++ linux-next-20260727/include/uapi/rdma/ib_user_mad.h
@@ -51,24 +51,24 @@
  */
 
 /**
- * ib_user_mad_hdr_old - Old version of MAD packet header without pkey_index
- * @id - ID of agent MAD received with/to be sent with
- * @status - 0 on successful receive, ETIMEDOUT if no response
+ * struct ib_user_mad_hdr_old - Old version of MAD packet header without pkey_index
+ * @id: ID of agent MAD received with/to be sent with
+ * @status: 0 on successful receive, ETIMEDOUT if no response
  *   received (transaction ID in data[] will be set to TID of original
  *   request) (ignored on send)
- * @timeout_ms - Milliseconds to wait for response (unset on receive)
- * @retries - Number of automatic retries to attempt
- * @qpn - Remote QP number received from/to be sent to
- * @qkey - Remote Q_Key to be sent with (unset on receive)
- * @lid - Remote lid received from/to be sent to
- * @sl - Service level received with/to be sent with
- * @path_bits - Local path bits received with/to be sent with
- * @grh_present - If set, GRH was received/should be sent
- * @gid_index - Local GID index to send with (unset on receive)
- * @hop_limit - Hop limit in GRH
- * @traffic_class - Traffic class in GRH
- * @gid - Remote GID in GRH
- * @flow_label - Flow label in GRH
+ * @timeout_ms: Milliseconds to wait for response (unset on receive)
+ * @retries: Number of automatic retries to attempt
+ * @qpn: Remote QP number received from/to be sent to
+ * @qkey: Remote Q_Key to be sent with (unset on receive)
+ * @lid: Remote lid received from/to be sent to
+ * @sl: Service level received with/to be sent with
+ * @path_bits: Local path bits received with/to be sent with
+ * @grh_present: If set, GRH was received/should be sent
+ * @gid_index: Local GID index to send with (unset on receive)
+ * @hop_limit: Hop limit in GRH
+ * @traffic_class: Traffic class in GRH
+ * @gid: Remote GID in GRH
+ * @flow_label: Flow label in GRH
  */
 struct ib_user_mad_hdr_old {
 	__u32	id;
@@ -90,29 +90,29 @@ struct ib_user_mad_hdr_old {
 };
 
 /**
- * ib_user_mad_hdr - MAD packet header
+ * struct ib_user_mad_hdr - MAD packet header
  *   This layout allows specifying/receiving the P_Key index.  To use
  *   this capability, an application must call the
  *   IB_USER_MAD_ENABLE_PKEY ioctl on the user MAD file handle before
  *   any other actions with the file handle.
- * @id - ID of agent MAD received with/to be sent with
- * @status - 0 on successful receive, ETIMEDOUT if no response
+ * @id: ID of agent MAD received with/to be sent with
+ * @status: 0 on successful receive, ETIMEDOUT if no response
  *   received (transaction ID in data[] will be set to TID of original
  *   request) (ignored on send)
- * @timeout_ms - Milliseconds to wait for response (unset on receive)
- * @retries - Number of automatic retries to attempt
- * @qpn - Remote QP number received from/to be sent to
- * @qkey - Remote Q_Key to be sent with (unset on receive)
- * @lid - Remote lid received from/to be sent to
- * @sl - Service level received with/to be sent with
- * @path_bits - Local path bits received with/to be sent with
- * @grh_present - If set, GRH was received/should be sent
- * @gid_index - Local GID index to send with (unset on receive)
- * @hop_limit - Hop limit in GRH
- * @traffic_class - Traffic class in GRH
- * @gid - Remote GID in GRH
- * @flow_label - Flow label in GRH
- * @pkey_index - P_Key index
+ * @timeout_ms: Milliseconds to wait for response (unset on receive)
+ * @retries: Number of automatic retries to attempt
+ * @qpn: Remote QP number received from/to be sent to
+ * @qkey: Remote Q_Key to be sent with (unset on receive)
+ * @lid: Remote lid received from/to be sent to
+ * @sl: Service level received with/to be sent with
+ * @path_bits: Local path bits received with/to be sent with
+ * @grh_present: If set, GRH was received/should be sent
+ * @gid_index: Local GID index to send with (unset on receive)
+ * @hop_limit: Hop limit in GRH
+ * @traffic_class: Traffic class in GRH
+ * @gid: Remote GID in GRH
+ * @flow_label: Flow label in GRH
+ * @pkey_index: P_Key index
  */
 struct ib_user_mad_hdr {
 	__u32	id;
@@ -136,9 +136,9 @@ struct ib_user_mad_hdr {
 };
 
 /**
- * ib_user_mad - MAD packet
- * @hdr - MAD packet header
- * @data - Contents of MAD
+ * struct ib_user_mad - MAD packet
+ * @hdr: MAD packet header
+ * @data: Contents of MAD
  *
  */
 struct ib_user_mad {
@@ -167,15 +167,15 @@ typedef unsigned long __attribute__((ali
 #define IB_USER_MAD_LONGS_PER_METHOD_MASK (128 / (8 * sizeof (long)))
 
 /**
- * ib_user_mad_reg_req - MAD registration request
- * @id - Set by the kernel; used to identify agent in future requests.
- * @qpn - Queue pair number; must be 0 or 1.
- * @method_mask - The caller will receive unsolicited MADs for any method
+ * struct ib_user_mad_reg_req - MAD registration request
+ * @id: Set by the kernel; used to identify agent in future requests.
+ * @qpn: Queue pair number; must be 0 or 1.
+ * @method_mask: The caller will receive unsolicited MADs for any method
  *   where @method_mask = 1.
- * @mgmt_class - Indicates which management class of MADs should be receive
+ * @mgmt_class: Indicates which management class of MADs should be receive
  *   by the caller.  This field is only required if the user wishes to
  *   receive unsolicited MADs, otherwise it should be 0.
- * @mgmt_class_version - Indicates which version of MADs for the given
+ * @mgmt_class_version: Indicates which version of MADs for the given
  *   management class to receive.
  * @oui: Indicates IEEE OUI when mgmt_class is a vendor class
  *   in the range from 0x30 to 0x4f. Otherwise not used.
@@ -193,7 +193,7 @@ struct ib_user_mad_reg_req {
 };
 
 /**
- * ib_user_mad_reg_req2 - MAD registration request
+ * struct ib_user_mad_reg_req2 - MAD registration request
  *
  * @id                 - Set by the _kernel_; used by userspace to identify the
  *                       registered agent in future requests.
@@ -214,10 +214,6 @@ struct ib_user_mad_reg_req {
  *                       used.
  * @rmpp_version       - If set, indicates the RMPP version to use.
  */
-enum {
-	IB_USER_MAD_USER_RMPP = (1 << 0),
-};
-#define IB_USER_MAD_REG_FLAGS_CAP (IB_USER_MAD_USER_RMPP)
 struct ib_user_mad_reg_req2 {
 	__u32	id;
 	__u32	qpn;
@@ -231,4 +227,9 @@ struct ib_user_mad_reg_req2 {
 	__u8	reserved[3];
 };
 
+enum {
+	IB_USER_MAD_USER_RMPP = (1 << 0),
+};
+#define IB_USER_MAD_REG_FLAGS_CAP (IB_USER_MAD_USER_RMPP)
+
 #endif /* IB_USER_MAD_H */
