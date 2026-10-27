Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793093054;
	b=Tjft1rVv+NV8qSmUYMf4madyYO4XzzeD6J/DzFcwaUp5tpgZtvnuC6k/6tJdZb/7WjNB
	 GL8eC1SFkT1Tk23qQE2pcOgd77N/CWRoq4An+q/7RAuazF5xt3qak9HviWaH+fKq5wPVA
	 1RlzPw4zpWxbTDKTutUF9Y0pJXuRhrx0dQFuU7xi3Cb4flFjrEUAEGujxk8wmmnMxftIL
	 oQRksEzySDduGMnAl7ivccnHPgdO2S5TcyWNaCcj8E+0C1N0b4ZsX93zU0vWIO/vc3A/A
	 rduX7+mlZnQKaCy5x2+saXIStavaBn8CZvjRQlqBnKyvqtgrO9SCSsmVFwD8PlPJJ1w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793093054;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=J/AkA0inPMcYpoNdECXZisnC24EnrmNk02qEnSZtAJg=;
	b=QaxFX8pU6huqVhYtbkXbA3hWR8asX7qSkAdXcMxiIM3u5vHyIVZVqXljD97cvBd6+kEJ
	 NtzBReijFchKX/4mszYoP3lPBxbwatacVUm48x3522SfOE4vFxNr1vc+tEjrgtXXFSf/B
	 fu7/wtI5CT2JXInYWeDJfgvzQGdgjikLX2+IAP8+4EXhLAtrSZDF2LS4bP4Iao6eAvTd1
	 0uMIsA/uTzYZ/DjK87miUxRR/WbUG+SUhm/M8R3QhmFSGfFlhjm0whz7IJxS4dbjHclu+
	 vQZeRCg01zvZi+Uq81GJmjXukgP8cJkycoD00YE8ggruN0z4CZQz8f4+IUQZ1frqtkg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=jaShUFsa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.51
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012051.outbound.protection.outlook.com [40.93.195.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2ABC606A323;
	Tue, 27 Oct 2026 09:24:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B2ABC606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=jaShUFsa
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QkB2R965mD0fFytiu1//c/3pNh4sPyqvf8GVffvdBtwSIcWOXR7dcKC60hO4F9rqFglQWMXdq6p71NLGEmoN8/VxxzG79b5kpD5POgbRYgW5T2tCi8cGDzyh8OEYopjtcDIZTt/e6CB/ZFAU3ba+prDGi8wZEedL2YIAik4BgvYnI/eDyfQpfm3T5+n4cUinAkphmP0fMn++t9I/xPXsR3Q2bflODZidbXHWjdLaIUW6je68u5dpZEg8UJgTM1W0bXMU7Pnatn2e5Uu9KEBDLlNr8wxBgT1z9HDVACfT1asoWPlTf9qGatow9as5vhVzlCdQUBPbHEIg+qL0n7QFBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/AkA0inPMcYpoNdECXZisnC24EnrmNk02qEnSZtAJg=;
 b=ybQIvv0Knd4Vjf1aNFORc04t6JGNsGWJmORvM0CYig3G5F3royEtuU2sqLotpBARenYZ0QHXzWNuvf0jHMl1318XqsBNg92cUw5JmATAOKamlPwTqxlMtmACwIqZBV/745Myt9u1HYSne3m/CeEqbNHC7gwMLvvJFys6Fx7qFKFGH4zypvHki5Vd0W+Q58fhtn8hzxSVaUOQBZlJdUeOag4vo3pNk8xwD2kCcrq1hNHB750dG1p8VvRqyUWziyNyGxB7sngBuWPvDYlalzY/wqr566em3a3gOZD1pSV+8EQPzs0Y00Xc1cf9cFTxcznAWDKnhk3yBPs6GTtvWPKJ6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/AkA0inPMcYpoNdECXZisnC24EnrmNk02qEnSZtAJg=;
 b=jaShUFsa27TKQ8teeqhhQc9dvEIsSRT7GyaDFwaF8X9/9MMtDR7k+jlwoZnV+AgQNIbMf7/hdbYlDT/iROIiwCPEJyOv+TTmrYj5LbhOtyw7yPvNcuqJZlOum0yIGnJU2NyZPikSNB+jlMrKGKkRWuAAcRa+4tdZ/GlxeUR8Pmw=
Received: from CYZPR14CA0019.namprd14.prod.outlook.com (2603:10b6:930:8f::10)
 by PH0PR12MB8150.namprd12.prod.outlook.com (2603:10b6:510:293::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 09:24:10 +0000
Received: from CY8PEPF0000005B.namprd21.prod.outlook.com
 (2603:10b6:930:8f:cafe::20) by CYZPR14CA0019.outlook.office365.com
 (2603:10b6:930:8f::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.22 via Frontend Transport; Tue,
 27 Oct 2026 09:24:10 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY8PEPF0000005B.mail.protection.outlook.com (10.167.247.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.0 via Frontend Transport; Tue, 27 Oct 2026 09:24:09 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 27 Oct
 2026 04:24:09 -0500
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Tue, 27 Oct
 2026 04:24:09 -0500
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Tue, 27 Oct 2026 04:24:06 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>
CC: <allen.hubbe@amd.com>, <a.k@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Abhijit
 Gangurde" <abhijit.gangurde@amd.com>
Subject: [for-next 2/3] RDMA/ionic: set the SQ WQE color bit
Date: Tue, 27 Oct 2026 14:53:52 +0530
Message-ID: <20261027092353.1961552-2-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261027092353.1961552-1-abhijit.gangurde@amd.com>
References: <20261027092353.1961552-1-abhijit.gangurde@amd.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PEPF0000005B:EE_|PH0PR12MB8150:EE_
X-MS-Office365-Filtering-Correlation-Id: e7f9fbdc-02e9-49c0-7694-08df340c0eb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700016|23010399003|82310400026|261026121527099003|11063799006|56012099006|261021121427099003|261009223027099003|261022105027099003|261022075727099003|261021135927099003|10067099003|22082099003|18002099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	VpPERcjHCu0ncM6C4WtPIXJYzyFlZ6MISVRcdhyJ9UQ3ENFSFMA/eVPQ9GZFgVBKV00uMeamk3HFH4Co5YrnSfNxoR3JiTp3+Fi8kn76Y1vLzMenM15IKpVodXPnaqwYozhrqX7dGwYPJuuST+STMlHCmupLAYdUJaoLe3CtUkHdUCD5b0sPVYfJ5zPUHDqWzbfgWyc93CcvIGKw/xPQXuhOThCEuW7rQ1OiAJSgVFEJU3djHVMALh/UcbKEUnkX+ZRp3tiKGbMOLwnbqo/yn9TGmlizIWp4+Fn88rIOaxTwbc/4/XGlyiiekLeoeBlgig1pCRR9Cf5bgJmbcd4DmxWBGMLJxoORPMGUBtNdEnAc94StD9hsgAmn3PmOgWy3q7XUmQLxpAflvrzXzl/MEqDma4r7s91vj4F6O1iOZghhB4OCcb5EVO3fW9lQMYcNl9bz0Wyd3BR/PcG22AAetLzjHoOuZP/MR0oApWZHWz0Ke0FOdxj09eiDOHphNKBC+cjj/NUYbqXNVSO5YUge6iXyFs2jOv3N4NE+4y0Bf2Mhyr9lfwuEUbxsx7n/bujOZB23az2USxE9qHxFUkbUpB7fzf6/iWfoOslSzhjRy+kzFTPJO62MN8+MaQu8HccfzS9pWzIhpQY153QYKmlZsyjv28oWt0h8ZZxw43dtCjbqCN8cUy6wOMP1ebwV08e9BzE7GficvpKPkb5c3BlFbw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700016)(23010399003)(82310400026)(261026121527099003)(11063799006)(56012099006)(261021121427099003)(261009223027099003)(261022105027099003)(261022075727099003)(261021135927099003)(10067099003)(22082099003)(18002099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	tldw4f9FrtAPqeCh0xnl/bxIaAToeIgkI+lb+/JKoYtz4tqb2K92tcIKO2njLIr8A9QYfCsi/tA1SSBHNFH2FmaW3b6Ajhyz/vJalkLYmKUTsqfUludcPTb7q4tC/shOkLjg5+MmLso+WwukXKSFwY8xtO0Kg0l/CVcNsztV5jz08VW1IcgTE65ssT829wbew4ra4uiEol2sCpcd+GhxQmkC5hb7ruJjaRGNv+y6QZ/WvVW2xlkFHffrzCjO9oGNaGvSlkqjZjoDRWQxjJWsVB7k1e5/E34xWUEeoQ5kqdVOEM5/OO67CdvOw9a6zoSzg68NTaTKcBADEFy0kfwZlsGLUraqKtr3o4gecdYz2Um2g7DFIYR8RV815myCZ9pvHK8xtDwIwcegsBFJuNy6cj42Z5ceqbVu6/2gfMGcZBXQSSv0LKP3LqA1g/xE/X74
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 09:24:09.9966
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7f9fbdc-02e9-49c0-7694-08df340c0eb4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY8PEPF0000005B.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8150

From: Amit Kumar <a.k@amd.com>

The NIC uses the WQE color bit to tell one pass of the send queue
from the next. Userspace sets IONIC_V1_FLAG_COLOR and toggles it when
prod wraps. Do the same for kernel send queues, and start again at
the initial color when a QP reset returns prod to zero.

Signed-off-by: Amit Kumar <a.k@amd.com>
Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 drivers/infiniband/hw/ionic/ionic_controlpath.c | 3 +++
 drivers/infiniband/hw/ionic/ionic_datapath.c    | 4 ++++
 drivers/infiniband/hw/ionic/ionic_fw.h          | 1 +
 drivers/infiniband/hw/ionic/ionic_ibdev.h       | 1 +
 4 files changed, 9 insertions(+)

diff --git a/drivers/infiniband/hw/ionic/ionic_controlpath.c b/drivers/infiniband/hw/ionic/ionic_controlpath.c
index 00f9086f3bab..1738635bacf4 100644
--- a/drivers/infiniband/hw/ionic/ionic_controlpath.c
+++ b/drivers/infiniband/hw/ionic/ionic_controlpath.c
@@ -1949,6 +1949,8 @@ static int ionic_qp_sq_init(struct ionic_ibdev *dev, struct ionic_ctx *ctx,
 		return rc;
 	}
 
+	qp->sq_color = true;
+
 	rc = -EINVAL;
 
 	if (max_wr < 0 || max_wr > 0xffff)
@@ -2662,6 +2664,7 @@ static void ionic_reset_qp(struct ionic_ibdev *dev, struct ionic_qp *qp)
 		qp->sq_msn_cons = 0;
 		qp->sq.prod = 0;
 		qp->sq.cons = 0;
+		qp->sq_color = true;
 		spin_unlock(&qp->sq_lock);
 	}
 
diff --git a/drivers/infiniband/hw/ionic/ionic_datapath.c b/drivers/infiniband/hw/ionic/ionic_datapath.c
index c5726c6bd5cb..422e53e21054 100644
--- a/drivers/infiniband/hw/ionic/ionic_datapath.c
+++ b/drivers/infiniband/hw/ionic/ionic_datapath.c
@@ -820,6 +820,9 @@ static void ionic_prep_base(struct ionic_qp *qp,
 
 	wqe->base.wqe_idx = cpu_to_le64(qp->sq.prod);
 
+	if (qp->sq_color)
+		wqe->base.flags |= cpu_to_be16(IONIC_V1_FLAG_COLOR);
+
 	if (wr->send_flags & IB_SEND_FENCE)
 		wqe->base.flags |= cpu_to_be16(IONIC_V1_FLAG_FENCE);
 
@@ -843,6 +846,7 @@ static void ionic_prep_base(struct ionic_qp *qp,
 	}
 
 	ionic_queue_produce(&qp->sq);
+	qp->sq_color = ionic_color_wrap(qp->sq.prod, qp->sq_color);
 }
 
 static int ionic_prep_common(struct ionic_qp *qp,
diff --git a/drivers/infiniband/hw/ionic/ionic_fw.h b/drivers/infiniband/hw/ionic/ionic_fw.h
index 1db67fcb9a53..b8e996d4b8b9 100644
--- a/drivers/infiniband/hw/ionic/ionic_fw.h
+++ b/drivers/infiniband/hw/ionic/ionic_fw.h
@@ -532,6 +532,7 @@ enum ionic_v1_op {
 	IONIC_V1_FLAG_SOL		= BIT(1),
 	IONIC_V1_FLAG_INL		= BIT(2),
 	IONIC_V1_FLAG_SIG		= BIT(3),
+	IONIC_V1_FLAG_COLOR		= BIT(4),
 
 	/* flags last four bits for sgl spec format */
 	IONIC_V1_FLAG_SPEC32		= (1u << 12),
diff --git a/drivers/infiniband/hw/ionic/ionic_ibdev.h b/drivers/infiniband/hw/ionic/ionic_ibdev.h
index f8d580dd4d95..cf4b85355f26 100644
--- a/drivers/infiniband/hw/ionic/ionic_ibdev.h
+++ b/drivers/infiniband/hw/ionic/ionic_ibdev.h
@@ -306,6 +306,7 @@ struct ionic_qp {
 	u8			sq_cmb;
 	bool			sq_flush;
 	bool			sq_flush_rcvd;
+	bool			sq_color;
 
 	struct ionic_rq		rq;
 
-- 
2.43.0

