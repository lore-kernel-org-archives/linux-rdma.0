Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010036.outbound.protection.outlook.com [52.101.85.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3863F48C3F9;
	Wed,  3 Jun 2026 19:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780515266; cv=fail; b=s2xdlA+Tsi8HPj7ErtWUtqJDSJBq+CsyIQRDeFjcZvqHA3jARb9ZTBwDO4s6v/IWKSx/czgl+C32y2uD8EWp7169H3RaLR67N/w7iPbWzVMjoHROKI9H0WYAt0cFnCXFT2tKmtEf76PS4+Idjog4de00j4DQepbAj2xFSdTfxVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780515266; c=relaxed/simple;
	bh=XUdKELfHR0Vvjr77yA1zFiETp3lbfz7SjOS2SNNHBfY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NNChwmaNvA+D6BmtSicII187mGCWCqqMEux8vc/KL/iedaor3rP+mlFjOZRY+BuaAxVEtuRT3guGcS7Q8MERde+gPFhSG+2AOupoDJAg+86uvn57aesPxgDgxLGWwllAe2XLZiv6s395nWsLSxP0c/nPCANZPEj8BxqNKnZPLCQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VNiqmhQa; arc=fail smtp.client-ip=52.101.85.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VNiqmhQa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d0M4sWRrqGQEA1f86eNUzc8nONYQGffjf12VrH1UBS3wHEEJh+IDpmpIi/C9UjzcH/+nAcP01/zK4SdFaiE4ZSwdvIC5ajqJF1QHdYWizfYPXUpN1VFaaqyG3udZo00vqJshW0VKLLAfRQWy/CYucarHBGg7KSG6RraTkgJiWD9Zt9mHnU3EkUUCF/eHa9g0ICLJFA/OQXH0UlwmwOnmcCjBRbRxrkbSN3dENuNZWBCAlyOFmJli6Ir78HVcJnUme2e3FJSeN0VGzi0RAsSL8iVIAcGCirgtKXdtk/pg5ISm/UOSbCWJKeYCxw+3N6cDC6gbknHMe8X3CzudPedE4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y8LzT1SeYqLnJp7n0ocDF14XXGV2gFKqtsGqf5mcRRU=;
 b=oiQ4g6+cRxxtteZnL3v0s/pc1xp98qSZ18f1JAJ58qS74lwdy/wSjstGmGdgx3ZsAItkufNatwfYN0pcqUASolv5peXUSZEPVyV3vSXvkiIORp2QISlBm44C5eMHgtHUgqhuFMG8ahNFf6yUpymW0Da3e5qZmUhkQtR13kvlp4GQjubjgpE1JspTFttSbyc/qm9s7KqMAAWm8VvvQXjKognuxK/URff2FDBAd7VmU+P+E75yaaqcW9YPXzTsVFfHjCYLzeE5p4264I2qlrik93LYXKCTVoT2NVUfOCENGeLDU+HnAuD7N2UWobaptG4/XHhySiJHcuk0DR9NmihQEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8LzT1SeYqLnJp7n0ocDF14XXGV2gFKqtsGqf5mcRRU=;
 b=VNiqmhQauGQ8OHOxkKXvVelxxCfyntePzkbVKE04QjvN4yWTk85wGgQ7myT7WChBxp3dIkSCGWrOINU0RLJImvHLAJaLsj+uTjElmAP/P8+qDE1LLbLr+5psporcQt0CmbmNQvEGsRn7a2u/sQDOxl6iQ0t5Or7nX+QjbKQbX3JIDpCEV1e7K3Ekptny0Tdpf1vVeVGtjNmjExgKx/cXwV/2pD481JPkMfz1Dl8sc5MUMcHixGLJklTPlUblJzhrLXbu51eF17Qq2DapxbfEDZ+AzA/diqdxr+vsErDd6nb9Kv0GEFRO08u2iaBQyd7Pw0+QDZCjaUJzviSuDdyviw==
Received: from MW4PR04CA0043.namprd04.prod.outlook.com (2603:10b6:303:6a::18)
 by DS7PR12MB6336.namprd12.prod.outlook.com (2603:10b6:8:93::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.7; Wed, 3 Jun 2026 19:34:14 +0000
Received: from CO1PEPF000066E9.namprd05.prod.outlook.com
 (2603:10b6:303:6a:cafe::83) by MW4PR04CA0043.outlook.office365.com
 (2603:10b6:303:6a::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.7 via Frontend Transport; Wed, 3
 Jun 2026 19:34:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1PEPF000066E9.mail.protection.outlook.com (10.167.249.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.5 via Frontend Transport; Wed, 3 Jun 2026 19:34:13 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 3 Jun
 2026 12:33:58 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Wed, 3 Jun 2026 12:33:57 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Wed, 3 Jun 2026 12:33:49 -0700
From: Mark Bloch <mbloch@nvidia.com>
To: Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David
 S. Miller" <davem@davemloft.net>
CC: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Jiri Pirko <jiri@resnulli.us>, Simon Horman <horms@kernel.org>, Sunil Goutham
	<sgoutham@marvell.com>, Linu Cherian <lcherian@marvell.com>, Geetha sowjanya
	<gakula@marvell.com>, hariprasad <hkelam@marvell.com>, Subbaraya Sundeep
	<sbhatta@marvell.com>, Bharat Bhushan <bbhushan2@marvell.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Tariq Toukan
	<tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, "Borislav Petkov (AMD)"
	<bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>, Randy Dunlap
	<rdunlap@infradead.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Petr Mladek <pmladek@suse.com>, Tejun Heo
	<tj@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Feng Tang
	<feng.tang@linux.alibaba.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Christian Brauner <brauner@kernel.org>, Dapeng Mi
	<dapeng1.mi@linux.intel.com>, Kees Cook <kees@kernel.org>, Marco Elver
	<elver@google.com>, Eric Biggers <ebiggers@kernel.org>, Li RongQing
	<lirongqing@baidu.com>, "Paul E. McKenney" <paulmck@kernel.org>, "Ethan
 Nelson-Moore" <enelsonmoore@gmail.com>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>
Subject: [PATCH net-next V2 5/7] octeontx2-af: Register devlink after SR-IOV init
Date: Wed, 3 Jun 2026 22:32:57 +0300
Message-ID: <20260603193259.3412464-6-mbloch@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260603193259.3412464-1-mbloch@nvidia.com>
References: <20260603193259.3412464-1-mbloch@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000066E9:EE_|DS7PR12MB6336:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f9b9cd4-5231-48ef-7835-08dec1a7180b
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700016|82310400026|11063799006|22082099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	VNpZlhsBVEwY7YoxOlf+zsy5Jz8+Vrexr4riDlT9Ql2BG++8YI2NNFOExKPuENQ1EghPv9nn/nApDllBHH8kEEp4rbjxN9sRAoEHGDma0/oz0QH72lmRl9wL981mCri7N6f2RCUl3xBrKqew6PcW4ScO82znMQ/JgT8nFJMsV3yzN5AgFVF2N/8FGpgdXZ6BNmhdJKkygYiQT6nevER4onQLtzDrITgHMd1NpAU3m6af3X5gRTWlS/06mop4DBlrYBVSX44DFYFL85xFKUAUPB6uesuCgsrQnB9ZrCkGMBqOHEKKdItAoBz3k3QRTbSo0gTiMc+PB+1VtKVm+N0Fh0KdPzkqV4ePvIydhVxWw8NdbgAN9iD3YxyGOvAyle35kCpu0Ly6+Ss8PwSuoadSyyew9yaFw7lMe6nK+tKbfDz8jHndU63y2y6rn00lU2otNRgLXp5Ufec1vFFIR6aUO+KnummIiyH+v3fQabV6zuvUqOhHPL1z7b2m3pmf+O2Lw9tNgqoOR81zEFkUlsruPHrXfXC/OiVb7tMwg17ZowwC/ibxwt4XlEA9h8FZev71WMVT7PrWH2hoRkuIBdkgtufpgmN0eOV84PcLoZ9e1m/qj/iTBaLdc7+mZFvRsH+BJHShwSjirynlTFtws4PYr9fG1Ea3fDPgica05devB/SNtQsyf1LcjDn7sl57PvCVuKJSea8K7yge+1pmBhCU3zI7wvvAKABnVLdLkIjLKqc=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700016)(82310400026)(11063799006)(22082099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ubOrkRTdaU+O/7pDh9MDzUN/MlU3tHpz6lqdax84P6S9+Roak9V/c7xdC/TwgGJEN6MKsKn0mXUSGeiS7+eLusWhwURkqLjbA8JY+qC1fWrgVHBzYog9kE11cvnsjyCqc9KesBCjgo2Bcu8ORCFDtpUxegLfzFvB5C/wh7sLnqWuD52oL6QT817w0nl1Thhy3s58ylIhWyA4fr3muAqDUrg1TIUX2ccqmkX5QvzavMNC179rr+rWeRz5PuDch9zKVC7dDYV//8yETTQbFt0+v1aXOizyO59HQmt7NEKgfPYUqUooY8z5uzOaIeHhjpi7DnQy68H5/vw0U46j/vfwfpLeE6h+qZgFQYyxGk6zTg9iJ2zIuz7VyXksN1l7Lo2+K71fmnRemg9UsuSczb2By5rvUsh0nB98SCHx4vKDBWXV50hz8iPQ+BHVnrIDoOuy
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2026 19:34:13.9702
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f9b9cd4-5231-48ef-7835-08dec1a7180b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000066E9.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6336

A later patch makes devlink registration the point where devlink core may
call eswitch_mode_set() to apply a boot-time default eswitch mode.

Move octeontx2 AF devlink registration after SR-IOV is enabled and the
representor switch lock is initialized, so the AF eswitch mode set path
sees the state it depends on.

If devlink registration fails after SR-IOV setup, unregister interrupts
before disabling SR-IOV. This keeps the AF-VF mailbox IRQ handlers
synchronized before the AF-VF mailbox workqueue is destroyed.

Signed-off-by: Mark Bloch <mbloch@nvidia.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.c   | 24 ++++++++++---------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 3cf131508ecf..c2b52eb4ffab 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -3545,6 +3545,7 @@ static void rvu_update_module_params(struct rvu *rvu)
 static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct device *dev = &pdev->dev;
+	bool sriov_done = false;
 	struct rvu *rvu;
 	int    err;
 
@@ -3634,26 +3635,27 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_flr;
 	}
 
-	err = rvu_register_dl(rvu);
-	if (err) {
-		dev_err(dev, "%s: Failed to register devlink\n", __func__);
-		goto err_irq;
-	}
-
 	rvu_setup_rvum_blk_revid(rvu);
 
 	/* Enable AF's VFs (if any) */
 	err = rvu_enable_sriov(rvu);
 	if (err) {
 		dev_err(dev, "%s: Failed to enable sriov\n", __func__);
-		goto err_dl;
+		goto err_irq;
+	}
+	sriov_done = true;
+
+	mutex_init(&rvu->rswitch.switch_lock);
+
+	err = rvu_register_dl(rvu);
+	if (err) {
+		dev_err(dev, "%s: Failed to register devlink\n", __func__);
+		goto err_irq;
 	}
 
 	/* Initialize debugfs */
 	rvu_dbg_init(rvu);
 
-	mutex_init(&rvu->rswitch.switch_lock);
-
 	if (rvu->fwdata)
 		ptp_start(rvu, rvu->fwdata->sclk, rvu->fwdata->ptp_ext_clk_rate,
 			  rvu->fwdata->ptp_ext_tstamp);
@@ -3662,10 +3664,10 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	rvu_alloc_cint_qint_mem(rvu, &rvu->pf[RVU_AFPF], BLKADDR_NIX0,
 				(rvu->hw->block[BLKADDR_NIX0].lf.max));
 	return 0;
-err_dl:
-	rvu_unregister_dl(rvu);
 err_irq:
 	rvu_unregister_interrupts(rvu);
+	if (sriov_done)
+		rvu_disable_sriov(rvu);
 err_flr:
 	rvu_flr_wq_destroy(rvu);
 err_mbox:
-- 
2.34.1

