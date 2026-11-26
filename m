Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705051;
	b=h5BAyhzfs8JqVt10yU8h1ma62YcsjgM6tZgzjj2dvEgCJXNaqClgsMS3bRwgdDGbBdi/
	 JbEdIqhRoxVxqslpjiCh9WmvAZzcrqmgXHMDGEyQWU8EawLV2mTlPTqTvcK3Rr/k/G5sG
	 frxrtLf0I3+I/l09kTslwxBVZCyYhroszA9pWMjOWKVa3vkXUQ7XIB3HT17I/j/1ShLwK
	 5S93fWH9b6G0zZ81C4wipS3CShIPSjwEGwKLj5rbMryfRkdpO8HqLSnIgTiBKl+WJuyoM
	 WXqiQ4E1cOh1q9fQiIIF5vVy00e4dFrpdz7RY9HkKQGmvywr/zWQdYIAxQ3D4/CLKeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705051;
	h=DMARC-Filter:DKIM-Signature:Date:References:X-Original-From:To:
	 Mime-Version:X-Mailer:Message-Id:In-Reply-To:
	 Content-Transfer-Encoding:Cc:From:Subject:Content-Type:
	 X-Lms-Return-Path:Received;
	bh=bTKveouMaT+A6TZaLVjzx5FaUHxsQsCtsYgSd5VZTEQ=;
	b=4xbUyp8a1LH+0FpAVeOGZIp5YnnjtY2trZxGISkFghJGc3ng8sduZ3St6geVokYlEtak
	 zt+zSJfkVv5RdIbTE1K8mLOLfvpbPLJ7xeiz87+dtT8ZYFShI8PzbtNxJN0Mjn7bhCVny
	 hdFG87vTeE8B/URX81KoDes6J2nGYXt/2Q1E53F+0CfzZdPinNs8mAuf03qyBcW6b3pdO
	 CxT5uzcY9+rez4+HoysjeeN2gy9oZGofBIilEwJ0RV7DkYUkRMebPE0Te88xZYiZlnpoW
	 T+TFvSqV4VClNetvFPvkfd8vA+kNFGUFl31O+t/751+HFJclx2nXgejvx661+ErGSFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yunsilicon.com;
	spf=pass smtp.mailfrom=yunsilicon.com;
	dkim=pass header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=a9RByk+6;
	arc=none smtp.remote-ip=209.127.231.45
Received: from va-2-45.ptr.blmpb.com (va-2-45.ptr.blmpb.com [209.127.231.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE427606A6A0
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 14:57:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE427606A6A0
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yunsilicon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yunsilicon.com header.i=@yunsilicon.com header.a=rsa-sha256 header.s=feishu2403070942 header.b=a9RByk+6
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=feishu2403070942; d=yunsilicon.com; t=1795705046; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=bTKveouMaT+A6TZaLVjzx5FaUHxsQsCtsYgSd5VZTEQ=;
 b=a9RByk+6DrsFgBVH7dIKiuM23hRcD62ujryWIrXTTp9atZTIGYbOUOnTSsPwLL1bw/iBS3
 8SZFZMa0aL3/uBgiVIp9nJEM/caxKbTxK03Vc9dM674iJuYM4lh+EJBUfxQXocuB7BCaOT
 OWd4tcK6oodDlqgaRAiZD99vESbS/w2rH9wIjUSRZfaVJ9ta/XQ43nkwGD9msPVfUxDiSf
 Q3ytndqIz5r8TLW0Mw1/6zYTpMOxeI/S+vP9Z9j0cGU5ClxVVXSMZmuPJGzS8zTtWG2oFD
 Y06oHkAHFtTXXsqWLQQDRtuDr77kxVh9eyn3YrskI/XyseI6nEpWFbTcqyBHJA==
Date: Thu, 26 Nov 2026 22:57:23 +0800
References: <20261126145711.70868-1-tianx@yunsilicon.com>
X-Original-From: Xin Tian <tianx@yunsilicon.com>
To: "Andrew Lunn" <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, 
	"Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, 
	"Paolo Abeni" <pabeni@redhat.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, 
	"Leon Romanovsky" <leon@kernel.org>, 
	"Junxian Huang" <huangjunxian6@hisilicon.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.1
Message-Id: <20261126145721.70868-5-tianx@yunsilicon.com>
In-Reply-To: <20261126145711.70868-1-tianx@yunsilicon.com>
Content-Transfer-Encoding: 7bit
Cc: <weihg@yunsilicon.com>, <linux-kernel@vger.kernel.org>, 
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>, 
	<kerneljasonxing@gmail.com>
From: "Xin Tian" <tianx@yunsilicon.com>
Subject: [PATCH v2 04/11] net/xsc: query HCA capabilities and reset function
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26b0848d4+4daa74+vger.kernel.org+tianx@yunsilicon.com>
Received: from DESKTOP-TGBQGEC.localdomain ([183.193.56.110]) by smtp.feishu.cn with ESMTPS; Thu, 26 Nov 2026 22:57:23 +0800

resources

Query the firmware HCA capabilities needed by the ethernet driver and
reset the function resources during probe.

Signed-off-by: Xin Tian <tianx@yunsilicon.com>
---
 .../ethernet/yunsilicon/xsc/common/xsc_core.h | 18 +++++
 .../net/ethernet/yunsilicon/xsc/pci/main.c    | 70 +++++++++++++++++++
 2 files changed, 88 insertions(+)

diff --git a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
index a6f0149ed..1ffbc2daa 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
+++ b/drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h
@@ -24,6 +24,18 @@
 #define XSC_PAGE_SHIFT_4K		12
 #define XSC_PAGE_SIZE_4K		(_AC(1, UL) << XSC_PAGE_SHIFT_4K)
 
+struct xsc_caps {
+	u32		max_cqes;
+	u32		send_ds_num;
+	u32		recv_ds_num;
+	u8		log_max_qp_depth;
+	u16		msix_base;
+	u16		msix_num;
+	u32		nic_caps;
+};
+
+#define XSC_CAP_MAC_PORT_MASK			GENMASK(15, 8)
+
 struct xsc_cmd;
 
 struct xsc_core_device {
@@ -33,6 +45,12 @@ struct xsc_core_device {
 	void __iomem		*bar;
 	int			bar_num;
 
+	u8			mac_port;
+	u8			pcie_no;
+	u8			pf_id;
+	u16			glb_func_id;
+
+	struct xsc_caps		caps;
 	struct xsc_cmd		*cmd;
 };
 
diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
index 9b08580f5..42c5a1bae 100644
--- a/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/main.c
@@ -29,6 +29,63 @@ static int xsc_set_dma_caps(struct pci_dev *pdev)
 	return err;
 }
 
+static int xsc_cmd_query_hca_cap(struct xsc_core_device *xdev,
+				 struct xsc_caps *caps)
+{
+	struct xsc_cmd_query_hca_cap_mbox_out *out;
+	struct xsc_cmd_query_hca_cap_mbox_in in;
+	int err;
+
+	out = kzalloc_obj(*out, GFP_KERNEL);
+	if (!out)
+		return -ENOMEM;
+
+	memset(&in, 0, sizeof(in));
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_QUERY_HCA_CAP);
+	in.cpu_num = cpu_to_be16(num_online_cpus());
+
+	err = xsc_cmd_exec(xdev, &in, sizeof(in), out, sizeof(*out));
+	if (err)
+		goto err_free;
+
+	xdev->glb_func_id = be32_to_cpu(out->hca_cap.glb_func_id);
+
+	caps->max_cqes = 1 << out->hca_cap.log_max_cq_sz;
+	caps->send_ds_num = out->hca_cap.send_seg_num;
+	caps->recv_ds_num = out->hca_cap.recv_seg_num;
+
+	caps->nic_caps = (caps->nic_caps & ~XSC_CAP_MAC_PORT_MASK) |
+			 FIELD_PREP(XSC_CAP_MAC_PORT_MASK,
+				    out->hca_cap.mac_port & 0xff);
+	xdev->mac_port = FIELD_GET(XSC_CAP_MAC_PORT_MASK, caps->nic_caps);
+
+	caps->msix_base = be16_to_cpu(out->hca_cap.msix_base);
+	caps->msix_num = be16_to_cpu(out->hca_cap.msix_num);
+
+	caps->log_max_qp_depth = out->hca_cap.log_max_qp_depth & 0xff;
+
+	xdev->pcie_no = out->hca_cap.pcie_no;
+	xdev->pf_id = out->hca_cap.pf_id;
+
+	kfree(out);
+	return 0;
+err_free:
+	kfree(out);
+	return err;
+}
+
+static int xsc_reset_function_resource(struct xsc_core_device *xdev)
+{
+	struct xsc_function_reset_mbox_out out;
+	struct xsc_function_reset_mbox_in in;
+
+	memset(&in, 0, sizeof(in));
+	in.hdr.opcode = cpu_to_be16(XSC_CMD_OP_FUNCTION_RESET);
+	in.glb_func_id = cpu_to_be16(xdev->glb_func_id);
+
+	return xsc_cmd_exec(xdev, &in, sizeof(in), &out, sizeof(out));
+}
+
 static int xsc_pci_init(struct xsc_core_device *xdev,
 			const struct pci_device_id *id)
 {
@@ -90,6 +147,19 @@ static int xsc_pci_init(struct xsc_core_device *xdev,
 		goto err_cmd_cleanup;
 	}
 
+	err = xsc_cmd_query_hca_cap(xdev, &xdev->caps);
+	if (err) {
+		pci_err(pdev, "failed to query hca caps: err=%d\n", err);
+		goto err_cmd_cleanup;
+	}
+
+	err = xsc_reset_function_resource(xdev);
+	if (err) {
+		pci_err(pdev, "failed to reset function resource: err=%d\n",
+			err);
+		goto err_cmd_cleanup;
+	}
+
 	return 0;
 
 err_cmd_cleanup:
-- 
2.43.0
