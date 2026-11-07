Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063835;
	b=C++cHSXfJPH/ClvCfDo7Q+fKriq9kVSkOI4m/I5OptvDW9Csn5aPvrNPNNYh3HgJqKyK
	 48H3PaXaLjwJ0b1y2eNNEe72ZacbvEtT2C5k4nK8FoOXBFFpH0NnqlJIyqLSwxjem0sUn
	 64KvMlDuNGwTg55kp/K6fS3RjCWneZNb/5LHSQiCFnonr0dJzr4TkErLaqMxT2f6DSc1N
	 I72PTIcYg19yd7H/XVB92masfndWbc/6adrbwnquzbBcSpkgq3OMUxcXECZ18d2iuClGS
	 TcnHS1YjZqOxfr4IGIPxC9Uf9MyEhWjv+v/YqplKItm4pKSUPvD1PJNCZyJZuIsAo2g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063835;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=x1kh08r2uui2Ftlhw63uWg19gjv8kG3d1EDC3HTcyJ8=;
	b=JiFK00Cexz8yccFRXw++ApKZlkGrTqeK7kKUxrW8pCfYpIeR3XZEeGWyjbcaWMLyl4Ci
	 lLI7sodY7RZ624c65ewUlDNSI7VIAiHNnkCRHCDXsweo5hAwFCc1k+8UBvKIj/vKQUXHB
	 SFXUMGrVBjWMaA7AgF9gV7tAm+FFBD3lgCt9nC0zq66YzU+UZ4GqgB9OcA0jyUEigTQvU
	 7x/2NQJ9UFiFshetiEbCcwkm36jt7950ZVF5WGSfvk03QKEO+f7g//EVKEGdjbdQfHrJS
	 TLkEaxGb+0llKqR9hQosrkWh3JkcTg3rnhdZeiwjUWeXVIHpSbYpCIaudurbMYVHn+w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b="pdx0s/7V";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.45
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010045.outbound.protection.outlook.com [52.101.46.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683B860A5BCC;
	Sat,  7 Nov 2026 15:03:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 683B860A5BCC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=pdx0s/7V
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f/I5uYNSTWebE1cPEVoBFCGU1F2Anv5mZ5quI1MU75/m88+Qsxf3wscW2/4pjTdtJAslmWuQX6WLinNnpMmKXsAY3A2Y3vjjy6x9dQgU8q16IqGSFAsk3W+MpfQae+/+RGwBpHVaDrL4ZFmQqmjaLW4bFcRQJ7Tnnn5v1I4uU4VasVF0bIgSaitl4103JQJoiAwYoGqlMt1BxXD6k5XbZyGfkLsg8/t/YCnYPB9yqatNCsSDS9SRPt+iApeKmLjAcCFzqONGNo3f0XTKhGdHE6cXicNVAkqoRvOnivga31ZL7/jeiyupElBn8bpjKHV/oe5zYr5/z2qWYC/p2p6eRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x1kh08r2uui2Ftlhw63uWg19gjv8kG3d1EDC3HTcyJ8=;
 b=Hk8af4NcGNIJM9wRFcyPi1ueqXKDGOH1nvHrKnayKlmLQSPmaRsNHC+jDnsO2jz2XfCj9gkRFRA+A1gJow4aIA14FAI3LlkFNA2fgN0CqhqMOUbHxfAzIw84FTe3FHE6BFvrJDEh0Ap86LsNXs6qskNr+dqokqE6igU2UqR8ZZ7Mmj7XChj7t78D8ugsWsdJp9RuTVabL1xM5pzoRylPTpD27knqqJ//gfVDSuxzBq3a71q5Mid1bR36Hc7DLpRIJSY8ICnvH0L4xQ7OuHthEDZ92s+XxxyK8P8DMrwrsqyEcIbF2ghNzjaLhNLNBtiWMSkvrsFObMrILsFaR2d24Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x1kh08r2uui2Ftlhw63uWg19gjv8kG3d1EDC3HTcyJ8=;
 b=pdx0s/7VaXBOQX22vO9XsL5L2aHywcgrNWvk8j9DGjQE5+F9uLxOCbu5KBX+9eDjDZqUJdJel/TXCAQZliJB1uEeak2nK5auGfqXx/o4JW2+XaFqItJCMCK0LgoL/whqGUybk9EetQOBzQKRBJB1XU97wCP8PJC+VfO5HeWAqaw=
Received: from CY8PR12CA0034.namprd12.prod.outlook.com (2603:10b6:930:49::22)
 by LV3PR12MB9440.namprd12.prod.outlook.com (2603:10b6:408:215::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 15:03:50 +0000
Received: from CY5PEPF00000E81.namprd05.prod.outlook.com
 (2603:10b6:930:49:cafe::6d) by CY8PR12CA0034.outlook.office365.com
 (2603:10b6:930:49::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 15:03:50 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CY5PEPF00000E81.mail.protection.outlook.com (10.167.247.180) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 15:03:49 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Sat, 7 Nov
 2026 09:03:49 -0600
Received: from xhdipdslab46.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.53 via Frontend
 Transport; Sat, 7 Nov 2026 09:03:45 -0600
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <eric.joyner@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next 0/4] RDMA/ionic: add DMA MR and v2 atomic WQE
Date: Sat, 7 Nov 2026 20:32:45 +0530
Message-ID: <20261107150249.1576835-1-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: CY5PEPF00000E81:EE_|LV3PR12MB9440:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e6cb494-6dd9-48ca-301e-08df3ce0549b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|7416014|376014|23010399003|1800799024|18002099003|10067099003|261026140227099003|11063799006|261026121527099003|261028144727099003|261021121427099003|56012099006|261021135927099003|261022105027099003|261021123027099003|261009223027099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	dWkgs9lbGlJG4Nl7whxeQXNIrLi3xV6ShHe71zEgMaOOkGH/GalYoSxG0oa1wTEKrdt0MZk8Lje5HFXh91OZDMrCyR1JyUxxOVEr6uKHddLUg+134Eg+hZPT4bW9aRfTPME896QNNxVJJvk1IuBBDVT+aSb4PJcKKSNtmQQXsHg58Nu3To+hk99EUvL0SoFvTb5YPJ5g2GgOziDMC3ZKKvOlKTGxV2qfTAnEZQtaaF6SefCxccbTHP4N0C5hAetJ08Bsb7JEXVMTaQBFNE7oosZSMvVA9ehQ4C7h31lYoXiL83zsCf9jAND3INTJLp46WawYpcLfF48lGBoZNj92HXjdFTACfbxjdolUKi4C7cCryFg4I9oHBK+xmDy1ZlipSlcWUx8YQa/JA9f0vVh11cJgnaFGxizSb1WGsBpwctHawFlo0DZ/WNOcflpc4hdburmaT7/4NFT1XLENzg0DISxDmzsA+BWA5CmWp3oblHnTbnLDcfC30REBDQLhOzlzCse7xg8XCrmCXWGuTelKSw4rPxEbTHGJttQNxA4XY37DAy/vuQa63e+GsqAVxobc/I9KgS+du/vkQJ+T+6G5kjCNmEebjmSEAh3+lT/7SCnw2V8lH+wjzwqj76/De62I4QbjZGLhIYVfsHJ2T/6nK+rL0CKzutjKjl3lX74aloWz798aXA6Lmc4067w9nA2m3vVq8HdJ+psaqUM8yjyKNQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(7416014)(376014)(23010399003)(1800799024)(18002099003)(10067099003)(261026140227099003)(11063799006)(261026121527099003)(261028144727099003)(261021121427099003)(56012099006)(261021135927099003)(261022105027099003)(261021123027099003)(261009223027099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	f7CMrJ/odn6+ofrgDLA66mXyryUGz14v4YTbr9ZXaieGNmGJiBR14KT9FgD/8HBArbTwdr8lz6tAwJzPqpg5bvwB7UuwUaG0qY2JDOVc2dwZwaVAlgel2gPDjTeIYB4peKbrnpgqfYWGT2yFt4nNW40+ZqV52g76t9I5Dlxc/qjYfKp7/GoNpoBzLx4eu91ISKb/a1HSwcqewE9tyoI8R2G0JCSGozY1iOoIOs1ok2k6mPj6WwHrGtAh6lFychpVX257Hb2ag3sFEAZ+1fj6Ujvr563mIRE2EjczWPWMI3e/Yi2FVhWXzU0BSXT0RDrN3Tpl28BbAT12liqojoPneFqAJa2z3jlnxFyd+yRGl/PvIk16p/UbsNhM/Lnn3imLgO2pTpGGoST27OBycNvn6ILbER77KV48k4P3UjbOtGsPbqH/mwQ859bZMHyFr2dq
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 15:03:49.8807
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e6cb494-6dd9-48ca-301e-08df3ce0549b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY5PEPF00000E81.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9440

Add a generic RDMA capability word to the LIF identity and use it
to allocate a PD-scoped DMA memory region. Use the v2 atomic send
WQE on RDMA version 2. Also fix the v1 atomic WQE so the operands
are not overwritten by the common payload.

Net changes pull request:
The following changes since commit 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4:

  Linux 7.4-rc1 (2026-11-01 13:26:31 -0800)

are available in the Git repository at:

  https://github.com/abhijitG-xlnx/linux.git ionic-shared

for you to fetch changes up to e64b2ae81599ce9e17fab5e635b8fe22df09739b:

  net: ionic: add an RDMA capability word to the LIF identity (2026-11-05 09:18:39 +0530)

Abhijit Gangurde (2):
  net: ionic: add an RDMA capability word to the LIF identity
  RDMA/ionic: preserve atomic operands in the send WQE

Gregor Dick (2):
  RDMA/ionic: allocate a PD-scoped DMA MR
  RDMA/ionic: use the v2 atomic send WQE layout

 .../infiniband/hw/ionic/ionic_controlpath.c   | 38 +++++++++++++++++--
 drivers/infiniband/hw/ionic/ionic_datapath.c  | 17 +++++++--
 drivers/infiniband/hw/ionic/ionic_fw.h        | 31 +++++++++++++++
 drivers/infiniband/hw/ionic/ionic_ibdev.h     |  1 -
 drivers/infiniband/hw/ionic/ionic_lif_cfg.c   |  1 +
 drivers/infiniband/hw/ionic/ionic_lif_cfg.h   |  1 +
 .../net/ethernet/pensando/ionic/ionic_if.h    |  4 +-
 7 files changed, 83 insertions(+), 10 deletions(-)

-- 
2.43.0

