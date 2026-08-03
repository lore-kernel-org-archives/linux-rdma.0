Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020072.outbound.protection.outlook.com [52.101.56.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B3B34F24E
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 16:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785772993; cv=fail; b=YIzyqN82IMlfxI8I0BZz1KXK20PSqpBLXJgRMy3Z4lGJzTQ9CqUr8LkttBQwPFCv7vAEnVabql2qoh8wzjopmL+2StkNXg4DzqAMa7eQt+TJCsHMwCsjICXQdq5UzINGvm5CdSD0Yk77cdQym2x6Zfh98nNFyZ3c8q9GMhnk+us=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785772993; c=relaxed/simple;
	bh=gvfW9+7w1/blUz1HHfXbXZKPZI27/FhY+U6KXgufOV0=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K/uhKWLZvqSGYnQygcQmuidvHCyo6Sof561DQKb9BL6F0Q6MOUI17FxDNGJo72w/Ol5evL8CU4bXHg0eI4toxhRkq8oz4/IXx99c/hwF0PlTK9GLJMXs7XtA4/wDKE/iDVxbODdrgTDqv+8VgsV8WzmnzZj6TNEAHvHi8qaLlI0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=DeTX0fML; arc=fail smtp.client-ip=52.101.56.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="DeTX0fML"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s89EQLITOs9Kwunn6m2NRQpgjzzGKWoe4YDFpA4AmqRataQd/LCKtSA8CaTIta23eU6hEWDxd4oeyxgeEin0riMBPpR/bp7OkX9JdFepOT1R6g5xnbOZHKbx44X+Qs4Z61wXPIXFVcsjFAjqgobGpbabRlKQFJUylMqH6vwb+NkPem2dDLKlv5vTr6T7N27usmxjcgM3ACgZKSk8l2+cE6jV4xNzT7RtOANnJFQDQrFe+IGG+kAgl5yxW4UPvJwoatSX4noneMCD8PHTOb+++9wvrRl2Yl0RPvCaKFULF2NUDtFw3M0e4Mpsx2WwKslNtBI7vblFX2jvFgPAYddjWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5qx16ir6DE3v329UhhEwlG8NMMJIpMPAPud0ybvyGWc=;
 b=WnrbQ2DmBokzACifxNnXk1EXKCID33lA0FyFSLoDTqbwdI7WJssHOD/2uQLkl7zXmyHQQlLbgvGWPnaIRtcKkbig1BdZJQeWdLHvVnqsAn1yfgSKYKTz4HJqfw4NWgLvkqQjzM8LiAEzvEyd7UPaJ1GxHihbHZbO30hJYHBLmwUam2K0TjegYREIklcDLeu2v139yvIdzgyn2phP4CeGHs3Hp7W1/bWNqPcJaktKE2T8/a+y7cME6z7o34wiY2Fyec3Wz0VdMTyIDHF8cvlAKsxqsGIodJQFBb64XOlcsi5gGic+GqfiUAMtiUyZ9gmea68kMCPMfFKtG3kjuFjqHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 208.255.156.42) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass (p=none sp=none pct=100)
 action=none header.from=cornelisnetworks.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5qx16ir6DE3v329UhhEwlG8NMMJIpMPAPud0ybvyGWc=;
 b=DeTX0fMLeZgzCnNEEm/cYBZwvrisY519l2mMcEyVX857J7dTfJF87bpPQjt8NisygAn/uJjYYsGkw9b9ynkKL1NqMqvSgVI7LsrENusHOLx2QY/WeU1jksQ+c4x0iKQRMSFXXYnEDJj6l2W51QlA+mb44ZipO+7xgXj6K4QRdY1Y+yOLtUe4mCybPVJ8Cu2T7EsCiVFeXfgR1ySxxOOW4/EVGxOvWovPVX8Q5nAFv/ElfkQUlcq2Itjm5Covd3S4knGyH3Sxl5TiFKcMhUXFpUKV/AEZP//BZYZlnuWY9MXn0DeIpMk8FXz4tNyah9icoqFItxzbYQ3JmyMkcX4pHA==
Received: from CH2PR10CA0017.namprd10.prod.outlook.com (2603:10b6:610:4c::27)
 by MW6PR01MB8628.prod.exchangelabs.com (2603:10b6:303:248::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.17; Mon, 3 Aug 2026 16:03:07 +0000
Received: from BL02EPF00021F6F.namprd02.prod.outlook.com
 (2603:10b6:610:4c:cafe::15) by CH2PR10CA0017.outlook.office365.com
 (2603:10b6:610:4c::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.18 via Frontend Transport; Mon, 3
 Aug 2026 16:03:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 208.255.156.42)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cornelisnetworks.com;
Received-SPF: Pass (protection.outlook.com: domain of cornelisnetworks.com
 designates 208.255.156.42 as permitted sender)
 receiver=protection.outlook.com; client-ip=208.255.156.42;
 helo=cn-mailer-00.localdomain; pr=C
Received: from cn-mailer-00.localdomain (208.255.156.42) by
 BL02EPF00021F6F.mail.protection.outlook.com (10.167.249.11) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Mon, 3 Aug 2026 16:03:04 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id BBDEC155AC0;
	Mon,  3 Aug 2026 12:03:04 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id B6DF61810DF01;
	Mon,  3 Aug 2026 12:03:04 -0400 (EDT)
Subject: [PATCH v3 for-next 23/24] RDMA/hfi2: Modernize mmap to use
 rdma_user_mmap_entry infrastructure
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org
Date: Mon, 03 Aug 2026 12:03:04 -0400
Message-ID: <178577298470.1792062.4631687774237410007.stgit@awdrv-04>
In-Reply-To: <178577280181.1792062.14134152769069940570.stgit@awdrv-04>
References: <178577280181.1792062.14134152769069940570.stgit@awdrv-04>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6F:EE_|MW6PR01MB8628:EE_
X-MS-Office365-Filtering-Correlation-Id: 566bfc51-85dd-4015-d5d8-08def178b3f2
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700016|23010399003|18002099003|22082099003|55112099003|3023799007|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	8/7W5Xi18miQ5f5VnhWrAPBybM0zPQHZOkb2CYfH0MHtKUFOb3aPK9wDBIWA+HEhkCHC/ImzXKY7Nhqq461b/FNmf4ie8cMQN282Dj3Djc+wK1QySKrJMUIIZHLXLhQYLqK+D73d8l6tDBEj9WgzECPypk/fgVF/zQF0BQY6VmWrj3h7aV1xLXlswpPN2l10IR4GJqHTN+FPCre19A8KDtVUOAHJR1iaX5lNrzyA7LPFG1+7+dES1SxXmWM1hVvPmvB9HJtag5wDK/ULV/xwX0SXNIGIpKN2ySLdKwOQn03pp2Y02lDI2gUiJK08gjF2EPLKokaDc2q/8bjXNnX1rbadNl/bfJKNump9lnAcc8Bbf6Ikawt5GVhVxScs11csapmaC9qCmh+KA7NE7snlLjLGDFXGZZzUtK1c0IfI53mEdOPOKboHjRI4mNJ/8iBGWjx9kvECKSm1/pqWmvnsLoMMbzcNePLJmm3VFJ+fanQekXzuwPyPw9Ybe5HtSLjuX3PUyEISlNO4pRwf0C1C4d3urhYR7nprlag64g0SJsn6L96t6LhDAnbTP+eGkWV8+A3hWj0xBnfA7Gh5s6g0GUcYD/K6KK90aoucpJJLr6ynpL8IoWvjuFIgrjd3n8Jl5BZaHbMgioCMKlLPhJq6TRhMXtlxoVa/kRTKjFOuIuHwoDTc9QIjS8vyN4JGOQpWLBEQeMjjh4bxe7j0v+d7Zw==
X-Forefront-Antispam-Report:
	CIP:208.255.156.42;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700016)(23010399003)(18002099003)(22082099003)(55112099003)(3023799007)(56012099006)(10067099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lQcGzYUzRsZ4XZyaDZCHvTLB21V5oD9o1GxfKypcY+G64kAUowwyj6EHi3wpldLkVoTptvi/+GaRF4NU7o+EQChAbq71quH2uj3BtH68M6ZUBa2RBvi/jcRyJWorMm9vj8mYXdGUs1ZsqaM/TV4lBL3/sd0M+hkp6prCFjyqcqaWY3qkCPvKXEZRTwwgeoB0+mhjni/orZcLEBRkIROYZrXSNNI0zU89upYWDEXoSeyANI1uAAo6dZnKEh3qN7NDoEdfLXTp5E5u/E1HjIkn7BY0gI9ZD490CG/+IT53fEPABLWMaJLELvGyBQaMhXsyyYUorP8r1E2F57P8iaKXmiKPQrMJtZG4ttghRngmudui+fV7Be3WAPdC3Owcq0ImifETPAxSqTAhDUx/TqbmRn5NAyIoovEqLjFAj4EaWOEhnlXx5BRFBN58f8hcetKO
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 16:03:04.9904
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 566bfc51-85dd-4015-d5d8-08def178b3f2
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[208.255.156.42];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR01MB8628

New RDMA drivers are required to use the rdma_user_mmap_entry API
instead of encoding buffer types directly into vm_pgoff tokens. Add
the mmap_entries array to hfi2_filedata to track per-context mmap
entry pointers for cleanup on context teardown. Export rvt_mmap()
from rdmavt so hfi2 can call it as a fallback for CQ/QP/SRQ mmaps
managed by rdmavt's pending_mmaps list. Also remove the dead
hfi1_tid_info struct from the hfi2 ABI header.

Assisted-by: Claude:claude-sonnet-4-5
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
---
  Changes since v2:
  - rdmavt/cq.c: add synchronize_rcu() before vfree(old_u_wc) and
    vfree(old_k_wc) in rvt_resize_cq() to close free-while-mapped race.
  - rdmavt/srq.c: add synchronize_rcu() before vfree(owq) and
    kvfree(okwq) in rvt_modify_srq() to close free-while-mapped race.
---
 drivers/infiniband/hw/hfi2/hfi2.h   |  123 ++++++++++++++++++++++-------------
 drivers/infiniband/sw/rdmavt/cq.c   |    9 +--
 drivers/infiniband/sw/rdmavt/mmap.c |    7 +-
 drivers/infiniband/sw/rdmavt/srq.c  |   20 +++---
 include/uapi/rdma/hfi2-abi.h        |   11 ---
 5 files changed, 93 insertions(+), 77 deletions(-)

diff --git a/drivers/infiniband/hw/hfi2/hfi2.h b/drivers/infiniband/hw/hfi2/hfi2.h
index 5ad8cefc7dc1..32a755c0d3d0 100644
--- a/drivers/infiniband/hw/hfi2/hfi2.h
+++ b/drivers/infiniband/hw/hfi2/hfi2.h
@@ -1284,6 +1284,12 @@ struct chip_params {
 	u32 csr_err_mask_reg;
 	u32 csr_err_clear_reg;
 
+	/*
+	 * Chip-variant operation callbacks. Function pointers are used here
+	 * to abstract differences between chip variants (e.g. JKR and future
+	 * generations). Each variant populates its own chip_params instance
+	 * with the appropriate implementations at driver init time.
+	 */
 	void (*hfi2_setextled)(struct hfi2_pportdata *ppd, u32 on);
 	void (*start_led_override)(struct hfi2_pportdata *ppd,
 				   unsigned int timeon, unsigned int timeoff);
@@ -1307,9 +1313,9 @@ struct chip_params {
 				    u32 size);
 	bool (*check_synth_status)(struct hfi2_devdata *dd);
 	void (*update_synth_status)(struct hfi2_devdata *dd);
-	u64 (*create_pbc)(struct hfi2_pportdata *ppd, bool hfi2_loopback, u64 flags,
-			  int srate_mbs, u32 vl, u32 dw_len, u32 l2, u32 dlid,
-			  u32 sctxt);
+	u64 (*create_pbc)(struct hfi2_pportdata *ppd, bool hfi2_loopback,
+			  u64 flags, int srate_mbs, u32 vl, u32 dw_len, u32 l2,
+			  u32 dlid, u32 sctxt);
 	void (*set_pio_integrity)(struct hfi2_devdata *dd, u32 pidx, u32 ctxt,
 				  int type, enum spi_cmds cmd);
 	int (*find_used_resources)(struct hfi2_devdata *dd);
@@ -1834,7 +1840,7 @@ void hfi2_pf0_cleanup(struct hfi2_devdata *dd);
 
 void hfi2_handle_linkup_change(struct hfi2_pportdata *ppd, u32 linkup);
 void hfi2_cport_handle_linkup_change(struct hfi2_pportdata *ppd,
-				struct opa_port_info *pi, u32 linkup);
+				     struct opa_port_info *pi, u32 linkup);
 void hfi2_go_port_active(struct hfi2_pportdata *ppd);
 
 void hfi2_handle_user_interrupt(struct hfi2_ctxtdata *rcd);
@@ -1854,10 +1860,14 @@ int hfi2_rcd_put(struct hfi2_ctxtdata *rcd);
 int hfi2_rcd_get(struct hfi2_ctxtdata *rcd);
 struct hfi2_ctxtdata *hfi2_rcd_get_by_index(struct hfi2_devdata *dd, u16 ctxt);
 int hfi2_handle_receive_interrupt(struct hfi2_ctxtdata *rcd, int thread);
-int hfi2_handle_receive_interrupt_nodma_rtail(struct hfi2_ctxtdata *rcd, int thread);
-int hfi2_handle_receive_interrupt_dma_rtail(struct hfi2_ctxtdata *rcd, int thread);
-int hfi2_handle_receive_interrupt_napi_fp(struct hfi2_ctxtdata *rcd, int budget);
-int hfi2_handle_receive_interrupt_napi_sp(struct hfi2_ctxtdata *rcd, int budget);
+int hfi2_handle_receive_interrupt_nodma_rtail(struct hfi2_ctxtdata *rcd,
+					      int thread);
+int hfi2_handle_receive_interrupt_dma_rtail(struct hfi2_ctxtdata *rcd,
+					    int thread);
+int hfi2_handle_receive_interrupt_napi_fp(struct hfi2_ctxtdata *rcd,
+					  int budget);
+int hfi2_handle_receive_interrupt_napi_sp(struct hfi2_ctxtdata *rcd,
+					  int budget);
 void hfi2_set_all_slowpath(struct hfi2_pportdata *ppd);
 
 extern const struct pci_device_id hfi2_pci_tbl[];
@@ -2154,20 +2164,20 @@ static inline u32 egress_cycles(u32 len, u32 rate)
 
 void hfi2_set_link_ipg(struct hfi2_pportdata *ppd);
 void hfi2_process_becn(struct hfi2_pportdata *ppd, u8 sl, u32 rlid, u32 lqpn,
-		  u32 rqpn, u8 svc_type);
+		       u32 rqpn, u8 svc_type);
 void hfi2_return_cnp(struct hfi2_ibport *ibp, struct rvt_qp *qp, u32 remote_qpn,
-		u16 pkey, u32 slid, u32 dlid, u8 sc5,
-		const struct ib_grh *old_grh);
-void hfi2_return_cnp_16B(struct hfi2_ibport *ibp, struct rvt_qp *qp, u32 remote_qpn,
-		    u16 pkey, u32 slid, u32 dlid, u8 sc5,
-		    const struct ib_grh *old_grh);
+		     u16 pkey, u32 slid, u32 dlid, u8 sc5,
+		     const struct ib_grh *old_grh);
+void hfi2_return_cnp_16B(struct hfi2_ibport *ibp, struct rvt_qp *qp,
+			 u32 remote_qpn, u16 pkey, u32 slid, u32 dlid, u8 sc5,
+			 const struct ib_grh *old_grh);
 typedef void (*hfi2_handle_cnp)(struct hfi2_ibport *ibp, struct rvt_qp *qp,
 				u32 remote_qpn, u16 pkey, u32 slid, u32 dlid,
 				u8 sc5, const struct ib_grh *old_grh);
 
 #define PKEY_CHECK_INVALID -1
-int hfi2_egress_pkey_check(struct hfi2_pportdata *ppd, u32 slid, u16 pkey, u8 sc5,
-		      int8_t s_pkey_index);
+int hfi2_egress_pkey_check(struct hfi2_pportdata *ppd, u32 slid, u16 pkey,
+			   u8 sc5, int8_t s_pkey_index);
 
 #define PACKET_EGRESS_TIMEOUT 350
 static inline void pause_for_credit_return(struct hfi2_devdata *dd)
@@ -2357,7 +2367,8 @@ void hfi2_set_up_vl15(struct hfi2_pportdata *ppd, u16 vl15buf);
 void hfi2_reset_link_credits(struct hfi2_pportdata *ppd);
 void hfi2_assign_remote_cm_au_table(struct hfi2_pportdata *ppd, u8 vcu);
 
-int hfi2_set_buffer_control(struct hfi2_pportdata *ppd, struct buffer_control *bc);
+int hfi2_set_buffer_control(struct hfi2_pportdata *ppd,
+			    struct buffer_control *bc);
 
 static inline struct hfi2_devdata *dd_from_ppd(struct hfi2_pportdata *ppd)
 {
@@ -3158,14 +3169,16 @@ static inline u64 read_iport_csr(const struct hfi2_devdata *dd, int pidx,
 				 u32 offset)
 {
 	/* IPORT CSRs are separated by rxe_iport_stride */
-	return hfi2_read_csr(dd, offset + (dd->params->rxe_iport_stride * pidx));
+	return hfi2_read_csr(dd,
+			     offset + (dd->params->rxe_iport_stride * pidx));
 }
 
 static inline void write_iport_csr(struct hfi2_devdata *dd, int pidx,
 				   u32 offset, u64 value)
 {
 	/* IPORT CSRs are separated by rxe_iport_stride */
-	hfi2_write_csr(dd, offset + (dd->params->rxe_iport_stride * pidx), value);
+	hfi2_write_csr(dd, offset + (dd->params->rxe_iport_stride * pidx),
+		       value);
 }
 
 static inline u64 read_iprc_csr(const struct hfi2_devdata *dd, int pidx, int rc,
@@ -3175,8 +3188,9 @@ static inline u64 read_iprc_csr(const struct hfi2_devdata *dd, int pidx, int rc,
 	 * IPORT receive context CSRs are separated by rxe_iport_stride and
 	 * rxe_iprc_stride.
 	 */
-	return hfi2_read_ctxt_csr(dd, offset + (dd->params->rxe_iport_stride * pidx),
-			     rc, dd->params->rxe_iprc_stride);
+	return hfi2_read_ctxt_csr(
+		dd, offset + (dd->params->rxe_iport_stride * pidx), rc,
+		dd->params->rxe_iprc_stride);
 }
 
 static inline void write_iprc_csr(struct hfi2_devdata *dd, int pidx, int rc,
@@ -3186,36 +3200,40 @@ static inline void write_iprc_csr(struct hfi2_devdata *dd, int pidx, int rc,
 	 * IPORT receive context CSRs are separated by rxe_iport_stride and
 	 * rxe_iprc_stride.
 	 */
-	hfi2_write_ctxt_csr(dd, offset + (dd->params->rxe_iport_stride * pidx), rc,
-		       dd->params->rxe_iprc_stride, value);
+	hfi2_write_ctxt_csr(dd, offset + (dd->params->rxe_iport_stride * pidx),
+			    rc, dd->params->rxe_iprc_stride, value);
 }
 
 static inline u64 read_rctxt_csr(const struct hfi2_devdata *dd, int ctxt,
 				 u32 offset)
 {
 	/* restricted rcv context CSRs are separated by rxe_rctxt_stride */
-	return hfi2_read_ctxt_csr(dd, offset, ctxt, dd->params->rxe_rctxt_stride);
+	return hfi2_read_ctxt_csr(dd, offset, ctxt,
+				  dd->params->rxe_rctxt_stride);
 }
 
 static inline void write_rctxt_csr(struct hfi2_devdata *dd, int ctxt,
 				   u32 offset, u64 value)
 {
 	/* restricted rcv context CSRs are separated by rxe_rctxt_stride */
-	hfi2_write_ctxt_csr(dd, offset, ctxt, dd->params->rxe_rctxt_stride, value);
+	hfi2_write_ctxt_csr(dd, offset, ctxt, dd->params->rxe_rctxt_stride,
+			    value);
 }
 
 static inline u64 read_kctxt_csr(const struct hfi2_devdata *dd, int ctxt,
 				 u32 offset)
 {
 	/* kernel rcv context CSRs are separated by rxe_kctxt_stride */
-	return hfi2_read_ctxt_csr(dd, offset, ctxt, dd->params->rxe_kctxt_stride);
+	return hfi2_read_ctxt_csr(dd, offset, ctxt,
+				  dd->params->rxe_kctxt_stride);
 }
 
 static inline void write_kctxt_csr(struct hfi2_devdata *dd, int ctxt,
 				   u32 offset, u64 value)
 {
 	/* kernel rcv context CSRs are separated by rxe_kctxt_stride */
-	hfi2_write_ctxt_csr(dd, offset, ctxt, dd->params->rxe_kctxt_stride, value);
+	hfi2_write_ctxt_csr(dd, offset, ctxt, dd->params->rxe_kctxt_stride,
+			    value);
 }
 
 static inline u64 read_ku_csr(const struct hfi2_devdata *dd, int ctxt,
@@ -3236,42 +3254,48 @@ static inline u64 read_uctxt_csr(const struct hfi2_devdata *dd, int ctxt,
 				 u32 offset)
 {
 	/* user per-context CSRs are separated by rxe_uctxt_stride */
-	return hfi2_read_ctxt_csr(dd, offset, ctxt, dd->params->rxe_uctxt_stride);
+	return hfi2_read_ctxt_csr(dd, offset, ctxt,
+				  dd->params->rxe_uctxt_stride);
 }
 
 static inline void write_uctxt_csr(struct hfi2_devdata *dd, int ctxt,
 				   u32 offset, u64 value)
 {
 	/* user per-context CSRs are separated by rxe_uctxt_stride */
-	hfi2_write_ctxt_csr(dd, offset, ctxt, dd->params->rxe_uctxt_stride, value);
+	hfi2_write_ctxt_csr(dd, offset, ctxt, dd->params->rxe_uctxt_stride,
+			    value);
 }
 
 static inline u64 read_sctxt_csr(const struct hfi2_devdata *dd, int ctxt,
 				 u32 offset)
 {
 	/* send context CSRs are separated by txe_sctxt_stride */
-	return hfi2_read_ctxt_csr(dd, offset, ctxt, dd->params->txe_sctxt_stride);
+	return hfi2_read_ctxt_csr(dd, offset, ctxt,
+				  dd->params->txe_sctxt_stride);
 }
 
 static inline void write_sctxt_csr(struct hfi2_devdata *dd, int ctxt,
 				   u32 offset, u64 value)
 {
 	/* send context CSRs are separated by txe_sctxt_stride */
-	hfi2_write_ctxt_csr(dd, offset, ctxt, dd->params->txe_sctxt_stride, value);
+	hfi2_write_ctxt_csr(dd, offset, ctxt, dd->params->txe_sctxt_stride,
+			    value);
 }
 
 static inline u64 read_tctxt_csr(const struct hfi2_devdata *dd, int ctxt,
 				 u32 offset)
 {
 	/* TXE send context CSRs are separated by txe_tctxt_stride */
-	return hfi2_read_ctxt_csr(dd, offset, ctxt, dd->params->txe_tctxt_stride);
+	return hfi2_read_ctxt_csr(dd, offset, ctxt,
+				  dd->params->txe_tctxt_stride);
 }
 
 static inline void write_tctxt_csr(struct hfi2_devdata *dd, int ctxt,
 				   u32 offset, u64 value)
 {
 	/* TXE send context CSRs are separated by txe_tctxt_stride */
-	hfi2_write_ctxt_csr(dd, offset, ctxt, dd->params->txe_tctxt_stride, value);
+	hfi2_write_ctxt_csr(dd, offset, ctxt, dd->params->txe_tctxt_stride,
+			    value);
 }
 
 static inline u64 read_sdma_csr(const struct hfi2_devdata *dd, int eng,
@@ -3292,28 +3316,32 @@ static inline u64 read_sdmacfg_csr(const struct hfi2_devdata *dd, int eng,
 				   u32 offset)
 {
 	/* SDMA config engine CSRs are separated by txe_sdmacfg_stride */
-	return hfi2_read_csr(dd, offset + (dd->params->txe_sdmacfg_stride * eng));
+	return hfi2_read_csr(dd,
+			     offset + (dd->params->txe_sdmacfg_stride * eng));
 }
 
 static inline void write_sdmacfg_csr(struct hfi2_devdata *dd, int eng,
 				     u32 offset, u64 value)
 {
 	/* SDMA config engine CSRs are separated by txe_sdmacfg_stride */
-	hfi2_write_csr(dd, offset + (dd->params->txe_sdmacfg_stride * eng), value);
+	hfi2_write_csr(dd, offset + (dd->params->txe_sdmacfg_stride * eng),
+		       value);
 }
 
 static inline u64 read_eport_csr(const struct hfi2_devdata *dd, int pidx,
 				 u32 offset)
 {
 	/* EPORT CSRs are separated by txe_eport_stride */
-	return hfi2_read_csr(dd, offset + (dd->params->txe_eport_stride * pidx));
+	return hfi2_read_csr(dd,
+			     offset + (dd->params->txe_eport_stride * pidx));
 }
 
 static inline void write_eport_csr(struct hfi2_devdata *dd, int pidx,
 				   u32 offset, u64 value)
 {
 	/* EPORT CSRs are separated by txe_eport_stride */
-	hfi2_write_csr(dd, offset + (dd->params->txe_eport_stride * pidx), value);
+	hfi2_write_csr(dd, offset + (dd->params->txe_eport_stride * pidx),
+		       value);
 }
 
 static inline u64 read_epsc_csr(const struct hfi2_devdata *dd, int pidx, int sc,
@@ -3323,8 +3351,9 @@ static inline u64 read_epsc_csr(const struct hfi2_devdata *dd, int pidx, int sc,
 	 * EPORT send context CSRs are separated by txe_eport_stride and
 	 * txe_epsc_stride.
 	 */
-	return hfi2_read_ctxt_csr(dd, offset + (dd->params->txe_eport_stride * pidx),
-			     sc, dd->params->txe_epsc_stride);
+	return hfi2_read_ctxt_csr(
+		dd, offset + (dd->params->txe_eport_stride * pidx), sc,
+		dd->params->txe_epsc_stride);
 }
 
 static inline void write_epsc_csr(struct hfi2_devdata *dd, int pidx, int sc,
@@ -3334,8 +3363,8 @@ static inline void write_epsc_csr(struct hfi2_devdata *dd, int pidx, int sc,
 	 * EPORT send context CSRs are separated by txe_eport_stride and
 	 * txe_epsc_stride.
 	 */
-	hfi2_write_ctxt_csr(dd, offset + (dd->params->txe_eport_stride * pidx), sc,
-		       dd->params->txe_epsc_stride, value);
+	hfi2_write_ctxt_csr(dd, offset + (dd->params->txe_eport_stride * pidx),
+			    sc, dd->params->txe_epsc_stride, value);
 }
 
 static inline u64 read_epscarr_csr(const struct hfi2_devdata *dd, int pidx,
@@ -3345,8 +3374,8 @@ static inline u64 read_epscarr_csr(const struct hfi2_devdata *dd, int pidx,
 	 * EPORT send context array CSRs are separated by txe_eport_stride and
 	 * a per-context stride of 8.
 	 */
-	return hfi2_read_ctxt_csr(dd, offset + (dd->params->txe_eport_stride * pidx),
-			     sc, 8);
+	return hfi2_read_ctxt_csr(
+		dd, offset + (dd->params->txe_eport_stride * pidx), sc, 8);
 }
 
 static inline void write_epscarr_csr(struct hfi2_devdata *dd, int pidx, int sc,
@@ -3356,8 +3385,8 @@ static inline void write_epscarr_csr(struct hfi2_devdata *dd, int pidx, int sc,
 	 * EPORT send context array CSRs are separated by txe_eport_stride and
 	 * a per-context stride of 8.
 	 */
-	hfi2_write_ctxt_csr(dd, offset + (dd->params->txe_eport_stride * pidx), sc,
-		       8, value);
+	hfi2_write_ctxt_csr(dd, offset + (dd->params->txe_eport_stride * pidx),
+			    sc, 8, value);
 }
 
 static inline u32 rhe_rcv_type_err(struct hfi2_packet *packet)
@@ -3408,7 +3437,7 @@ enum preg_op {
 };
 
 int hfi2_priv_reg_op(struct hfi2_devdata *dd, int pidx, u32 ctxt, int type,
-		enum preg_op op, u64 arg);
+		     enum preg_op op, u64 arg);
 
 enum csr_type {
 	CSR_TYPE_IPORT = 1,
@@ -3427,6 +3456,6 @@ enum csr_type {
 };
 
 u64 hfi2_read_csr_type(struct hfi2_devdata *dd, enum csr_type type, u32 off,
-		  u16 ctxt, u8 pidx_eng);
+		       u16 ctxt, u8 pidx_eng);
 
 #endif /* _HFI2_KERNEL_H */
diff --git a/drivers/infiniband/sw/rdmavt/cq.c b/drivers/infiniband/sw/rdmavt/cq.c
index 45404611c9ce..be0293434f27 100644
--- a/drivers/infiniband/sw/rdmavt/cq.c
+++ b/drivers/infiniband/sw/rdmavt/cq.c
@@ -318,7 +318,7 @@ int rvt_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags notify_flags)
 	if (notify_flags & IB_CQ_REPORT_MISSED_EVENTS) {
 		if (cq->queue) {
 			if (RDMA_READ_UAPI_ATOMIC(cq->queue->head) !=
-				RDMA_READ_UAPI_ATOMIC(cq->queue->tail))
+			    RDMA_READ_UAPI_ATOMIC(cq->queue->tail))
 				ret = 1;
 		} else {
 			if (cq->kqueue->head != cq->kqueue->tail)
@@ -426,6 +426,7 @@ int rvt_resize_cq(struct ib_cq *ibcq, unsigned int cqe, struct ib_udata *udata)
 	}
 	spin_unlock_irq(&cq->lock);
 
+	synchronize_rcu();
 	if (u_wc)
 		vfree(old_u_wc);
 	else
@@ -518,9 +519,9 @@ int rvt_poll_cq(struct ib_cq *ibcq, int num_entries, struct ib_wc *entry)
  */
 int rvt_driver_cq_init(void)
 {
-	comp_vector_wq = alloc_workqueue("%s",
-					 WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_PERCPU,
-					 0, "rdmavt_cq");
+	comp_vector_wq =
+		alloc_workqueue("%s", WQ_HIGHPRI | WQ_CPU_INTENSIVE | WQ_PERCPU,
+				0, "rdmavt_cq");
 	if (!comp_vector_wq)
 		return -ENOMEM;
 
diff --git a/drivers/infiniband/sw/rdmavt/mmap.c b/drivers/infiniband/sw/rdmavt/mmap.c
index 473f464f33fa..f0bd096f457c 100644
--- a/drivers/infiniband/sw/rdmavt/mmap.c
+++ b/drivers/infiniband/sw/rdmavt/mmap.c
@@ -32,8 +32,7 @@ void rvt_mmap_init(struct rvt_dev_info *rdi)
  */
 void rvt_release_mmap_info(struct kref *ref)
 {
-	struct rvt_mmap_info *ip =
-		container_of(ref, struct rvt_mmap_info, ref);
+	struct rvt_mmap_info *ip = container_of(ref, struct rvt_mmap_info, ref);
 	struct rvt_dev_info *rdi = ib_to_rvt(ip->context->device);
 
 	spin_lock_irq(&rdi->pending_lock);
@@ -91,8 +90,7 @@ int rvt_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 	 * CQ, QP, or SRQ is soon followed by a call to mmap().
 	 */
 	spin_lock_irq(&rdi->pending_lock);
-	list_for_each_entry_safe(ip, pp, &rdi->pending_mmaps,
-				 pending_mmaps) {
+	list_for_each_entry_safe(ip, pp, &rdi->pending_mmaps, pending_mmaps) {
 		/* Only the creator is allowed to mmap the object */
 		if (context != ip->context || (__u64)offset != ip->offset)
 			continue;
@@ -115,6 +113,7 @@ int rvt_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 done:
 	return ret;
 }
+EXPORT_SYMBOL(rvt_mmap);
 
 /**
  * rvt_create_mmap_info - allocate information for hfi1_mmap
diff --git a/drivers/infiniband/sw/rdmavt/srq.c b/drivers/infiniband/sw/rdmavt/srq.c
index d022aa56c5bf..e9ebe4035572 100644
--- a/drivers/infiniband/sw/rdmavt/srq.c
+++ b/drivers/infiniband/sw/rdmavt/srq.c
@@ -53,10 +53,9 @@ int rvt_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *srq_init_attr,
 	 */
 	srq->rq.size = srq_init_attr->attr.max_wr + 1;
 	srq->rq.max_sge = srq_init_attr->attr.max_sge;
-	sz = sizeof(struct ib_sge) * srq->rq.max_sge +
-		sizeof(struct rvt_rwqe);
-	if (rvt_alloc_rq(&srq->rq, srq->rq.size * sz,
-			 dev->dparms.node, udata)) {
+	sz = sizeof(struct ib_sge) * srq->rq.max_sge + sizeof(struct rvt_rwqe);
+	if (rvt_alloc_rq(&srq->rq, srq->rq.size * sz, dev->dparms.node,
+			 udata)) {
 		ret = -ENOMEM;
 		goto bail_srq;
 	}
@@ -122,8 +121,7 @@ int rvt_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *srq_init_attr,
  * Return: 0 on success
  */
 int rvt_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
-		   enum ib_srq_attr_mask attr_mask,
-		   struct ib_udata *udata)
+		   enum ib_srq_attr_mask attr_mask, struct ib_udata *udata)
 {
 	struct rvt_srq *srq = ibsrq_to_rvtsrq(ibsrq);
 	struct rvt_dev_info *dev = ib_to_rvt(ibsrq->device);
@@ -139,14 +137,13 @@ int rvt_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 
 		/* Check that the requested sizes are below the limits. */
 		if ((attr->max_wr > dev->dparms.props.max_srq_wr) ||
-		    ((attr_mask & IB_SRQ_LIMIT) ?
-		     attr->srq_limit : srq->limit) > attr->max_wr)
+		    ((attr_mask & IB_SRQ_LIMIT) ? attr->srq_limit :
+						  srq->limit) > attr->max_wr)
 			return -EINVAL;
 		sz = sizeof(struct rvt_rwqe) +
-			srq->rq.max_sge * sizeof(struct ib_sge);
+		     srq->rq.max_sge * sizeof(struct ib_sge);
 		size = attr->max_wr + 1;
-		if (rvt_alloc_rq(&tmp_rq, size * sz, dev->dparms.node,
-				 udata))
+		if (rvt_alloc_rq(&tmp_rq, size * sz, dev->dparms.node, udata))
 			return -ENOMEM;
 		/* Check that we can write the offset to mmap. */
 		if (udata && udata->inlen >= sizeof(__u64)) {
@@ -220,6 +217,7 @@ int rvt_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 			srq->limit = attr->srq_limit;
 		spin_unlock_irq(&srq->rq.kwq->c_lock);
 
+		synchronize_rcu();
 		vfree(owq);
 		kvfree(okwq);
 
diff --git a/include/uapi/rdma/hfi2-abi.h b/include/uapi/rdma/hfi2-abi.h
index 7b7ca198b539..5b5b619bf1a8 100644
--- a/include/uapi/rdma/hfi2-abi.h
+++ b/include/uapi/rdma/hfi2-abi.h
@@ -248,17 +248,6 @@ struct hfi2_ctxt_info {
 	__u16 sdma_ring_size; /* number of entries in SDMA request ring */
 };
 
-struct hfi1_tid_info {
-	/* virtual address of first page in transfer */
-	__aligned_u64 vaddr;
-	/* pointer to tid array. this array is big enough */
-	__aligned_u64 tidlist;
-	/* number of tids programmed by this request */
-	__u32 tidcnt;
-	/* length of transfer buffer programmed by this request */
-	__u32 length;
-};
-
 #define HFI2_TID_UPDATE_FLAGS_MEMINFO_MASK 0xfUL
 #define HFI2_TID_UPDATE_FLAGS_RESERVED_MASK \
 	(~(__u64)(HFI2_TID_UPDATE_FLAGS_MEMINFO_MASK))


