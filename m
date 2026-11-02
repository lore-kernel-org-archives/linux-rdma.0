Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.69
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793658504;
	b=E0dcfCK0JxRpidMNN254Kmd1z+aWyR/dhw1UoRwG0DwEM33RVVqdulXkv8dbnTD0trQ4
	 Ik2ODa8Q5j83SW0xe0uSTd1lBTkcVULTykj1fhIss0WDT0DhQrbkttqkYtlKhGMqPbTlf
	 AVR9LNIavSxXAOu5TRbj+FInIDH2zm7NJt86XlXindPQZPn8wcm6a9GAwd/jIujw4Lnvl
	 b/QJ2qt1YOn9CHx/2LOBvYk2LPmKk8rVtMqbOgPvVTnHlYk9Vk2wONVsYBHImm0FawLJZ
	 O/X1lKDgM09EyaVLWSswk7xlgdGiWWKMXk2A8fC4fUBCi/gY4N5BvHG53EjR4KmSthg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793658504;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:Subject:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:CC:X-Mailer:
	 X-Originating-IP:X-ClientProxiedBy:X-EOPAttributedMessage:
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
	bh=jA6nhWejTkfm3/eg/3LofGI+MVVNijjxp5pGkQw9to0=;
	b=zj+PqNn6eauHHXW7K0A200zVqxYj0eTKlzcRu6k65S76a0YbgvOQJxlZaZRPe1QKrDe3
	 8sgVnAbAMDSNtpKiElpePC93ImgCWcuJDCfDMu3VZ3ZLIJ8U7nSH7C3m8P5pCjktqN70o
	 gUf28r7pZtU+65JxitIN58aUHbOOFUfTPU9YLr1xW2mk7gKc47CNm0fvDJx7aIuH+IUw6
	 xXFzfpHTGU4YQMz5reSrpNK6Ghps+uJmH0+Kj91Z7sty0zWP0/bl1Qr4558YoRdYGEi9Y
	 EH9E/VJ9OrCSP8ilN0MXgT1G+qlyO8zWDOS4FNmBGFlOw0hr4aKsmdCkgPCLS78w2bg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=5WD0mQqs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.69
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012069.outbound.protection.outlook.com [40.107.209.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF48606A324;
	Mon,  2 Nov 2026 22:28:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CF48606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=5WD0mQqs
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mC677c4VHsq1wD+QjC8XFHjrpt6LpOLUTqGoKom0I0BzF4rwu8jXOUNWaKuPDpMIGU7b3lQf+JmcghNYL9Z3/oBQnw9f/Dn/E76KyUCn6J3OGkgMTdeeBi32ZvTSq9uD62OhTqc1AkmaNqs1Z0wrySS4XvfSImILlh2Fh7WPir0Ot+GmfXAcazUnwMJCaObg6IKFDef8c0MqA6QHmcVvhLE/PAamGz7MFS8ldJkYiWRU6eTflZ7Z9Ta+VWw0AysfurL/LyN5jydmpktohse+HwPhQgL6gYJUp9jSUCtExwivJd9hdEG1rtkoAVbgkJYGS546n8i7eThSvdNooteIBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jA6nhWejTkfm3/eg/3LofGI+MVVNijjxp5pGkQw9to0=;
 b=oeqUAdb7nI701XGX+EH5A+jJ5laqIfCSVaihHVruodo6wfrm2GfKXp0iHuYgAyLyl7inglxVaHD6gC3l91IwzXp1Q1P5AaWHhMsrQ0r0ay9Wsmhszav6yA8qRN4chpIQ5daXNsNwThdTKCs2fY+P29i2LKmttb0gUSsUQwgZFQrxbRvW261heBFx+y+awi7QoNyEjzoFbKYsP3XdFb64o4QGPR17bXookna0A7HqN6kb76Zg60wJcte1ByxQMj+UwhCdUsQA2VI7hFjcqvZXrq+fTI2gWFmluP8yvcq3mPe2/lWs3PA8+wDNDFL96WmqMAZghd96/xd2jTEEPR+uWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jA6nhWejTkfm3/eg/3LofGI+MVVNijjxp5pGkQw9to0=;
 b=5WD0mQqsLsV541d9EFtzEDeL+YwjyUSEkx9J2KSMe5ZmDMMB5fC5HZ1xQFbS1UA3Fbq4XicS3BLqQBl3hLHTYqfXJ2xofvUSWQt5j7Q76Kk1pad98FunGLzrbxusBVNXI5wvYNX668kHr7ShGaaVP+iuPYAEzKVu+NE7PGupxhg=
Received: from MW4P222CA0029.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::34)
 by DS7PR12MB9552.namprd12.prod.outlook.com (2603:10b6:8:24f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 22:28:17 +0000
Received: from SJ1PEPF000037B6.namprd05.prod.outlook.com
 (2603:10b6:303:114:cafe::55) by MW4P222CA0029.outlook.office365.com
 (2603:10b6:303:114::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.569.12 via Frontend Transport; Mon, 2
 Nov 2026 22:28:17 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF000037B6.mail.protection.outlook.com (10.167.244.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Mon, 2 Nov 2026 22:28:17 +0000
Received: from [192.168.0.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Mon, 2 Nov
 2026 16:28:15 -0600
From: "Nikhil P. Rao" <nikhil.rao@amd.com>
Subject: [PATCH net-next 0/3] ionic: make the device command timeout
 configurable
Date: Mon, 2 Nov 2026 22:27:38 +0000
Message-ID: <20261102-b4-ionic-cmd-timeout-v1-0-2f75c2d0a0c7@amd.com>
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
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFoO6WoC/yWMQQqDMBBFryKz7kASYwu9inTRTEY7BaMkYxHEu
 5u2y8f/7+1QOAsXuDc7ZP5IkTlVsJcG6PVMI6PEyuCMu1prHAaP9SKENEVUmXheFelmfOxa44M
 foKpL5kG2X7aHxIqJN4XHfylreDPptwrHcQJW5t7HggAAAA==
X-Change-ID: 20261102-b4-ionic-cmd-timeout-c704d5304b4f
To: Brett Creeley <brett.creeley@amd.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Abhijit Gangurde <abhijit.gangurde@amd.com>, Allen Hubbe
	<allen.hubbe@amd.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
	<leon@kernel.org>, Jiri Pirko <jiri@resnulli.us>, Simon Horman
	<horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, <linux-doc@vger.kernel.org>, Arun Kumar Prakash
	<ArunKumar.Prakash@amd.com>, "Nikhil P. Rao" <nikhil.rao@amd.com>
X-Mailer: b4 0.15.2
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000037B6:EE_|DS7PR12MB9552:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dc5830e-723d-4894-c1e9-08df3930976f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|36860700016|1800799024|376014|23010399003|6133799003|3023799007|10067099003|56012099006|261102123227099003|18002099003|261009223027099003|921020|261022105027099003|261021135927099003|261021123027099003|261021121427099003|261022075727099003|11063799006|261026121527099003|261028144727099003|261026140227099003;
X-Microsoft-Antispam-Message-Info:
	wYjdU+9e3QIjghAfCiLPhdw315uOJvZDcUudzV1THfyLnv13+nnWi3J9ql1RyfNaI5Crbj/L0ZvzWBAsN+MYTxZabIQPKik3wvhZrd+lsFqOzDoj2KwJMx595A/pObJHUeqCJ/a6XE4DrFDZph7v41CfM0+oAtxMNpSimh1XIAr1v05i5jdgA4dGYVCqxk0KVu/4a+25cgWemy8gmI18qmBO7n7UFv6N6/G+nAAociFlWkpZmoCYbcWLd0amG5S4tktSOCxn7g8EEmQFQ3EU3DRUUevb15EGZ4u5DTRdIVH49R6d+S7iJNZ3aoDdlUvPGyHDYZX+rdPD07rYRmJKwJfU5zTTgu04yEn6Kk7AShgulSuAU7CLM2mqbz5afTaMG7OG882Iy2TMOCT9TeHGDS3Pi0V1UKhU7GD10+4g7VU3yhpLobCEEtmqucsFH+kOsFyyejDVSjt6jD0IeaKvpZpiWk8rq0gV/hvMUcpqE+EC0G242QS8aYEF1uk2hCkj6ax97UKORE5oDmO+o6/fB6kd5oknH6lFxDQnVwlUi7FRYhmt4Ange2WRDD/FO2c63WYdBOmfIOfOCLZOKmVTH31Y3ziUC6azJ1BtAcZtInYgVEdkbSH8mx0XXNfl1CF8MVgej11+p/HK4DrnGzmGnJKLRtylVFnHnRsdT2R7IhDOZOxFvqCWFp5zOAJEPxcnhIirRB6xcIzMp6NVKAhsXZn8xGk557TdtfEXBI0OlTgyVb4vYJv5Ngyf7rq5+Tty
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(36860700016)(1800799024)(376014)(23010399003)(6133799003)(3023799007)(10067099003)(56012099006)(261102123227099003)(18002099003)(261009223027099003)(921020)(261022105027099003)(261021135927099003)(261021123027099003)(261021121427099003)(261022075727099003)(11063799006)(261026121527099003)(261028144727099003)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	oRVQlYFScM82u+qh3Dq9S0V/YWkSF3i9srou40bHzC7YnOZpJIWNbRfOTPEKBcehhJkAP/nq9jsPazqgeGPHYwnpyOfSVySV5dtC4QNs6bbQ+PbIzJUPoJHj1aoP69fnf4HQPnQsBtolCcESKhTExhBOKSfY+DsSwDPKrueDJ8CnaSjhmEDiHPyFDpLblbUWkTzLbY51RoS70CCerKc1WgwCq1omBljzSKJ7CjZnNmZfavRuZRVcmodJEVcwxlOALpKj9ZUxh8kmVpY1684rHrMFRR6k48Q2nWijf/faMZ1Wiq/wSgZafktLSEw2wqov6DPF8zmxU5N7ussGhogRz7yi6Fy0pF6VwO2nz3WOyal8YfeBuQw28avmr+bg7GrLKtwC+xV0Zv1h8/rQhPTaiyFMVWkx1SciXuSIHGGt3428cJA7KgH1Vp/aLNjhuZJ1
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 22:28:17.0496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dc5830e-723d-4894-c1e9-08df3930976f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000037B6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9552

ionic waits a fixed 5 seconds for device and admin queue commands, and
the RDMA driver gives its admin queue 2 seconds. Some commands can take
the firmware longer than that, for example while a PFC configuration
change flaps the links. The firmware is alive but slow, yet the
timed-out command and everything queued behind it fail, and an RDMA
admin queue timeout resets the RDMA LIF so that later verbs fail with
-ENODEV.

Patch 1 makes the timeout a per-device value without changing it.
Patch 2 has the RDMA admin queue use the ionic command timeout instead
of its own 2 seconds. Patch 3 adds a permanent devlink parameter,
cmd_timeout, stored in device NVM, that lengthens the timeout on
firmware that supports it.

Tested on an AMD Pensando adapter under KASAN and lockdep, including
repeated PCI resets with concurrent parameter reads.

This series was developed with the help of an LLM-based coding
assistant (Claude).

---
Arun Kumar Prakash (3):
      ionic: make the command timeout per device
      RDMA/ionic: Use the ionic command timeout for the admin queue
      ionic: add devlink param for command timeout

 Documentation/networking/devlink/ionic.rst         | 29 +++++++
 drivers/infiniband/hw/ionic/ionic_admin.c          |  9 ++-
 drivers/net/ethernet/pensando/ionic/ionic.h        | 15 +++-
 drivers/net/ethernet/pensando/ionic/ionic_api.h    |  8 ++
 drivers/net/ethernet/pensando/ionic/ionic_aux.c    |  8 +-
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |  4 +
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    | 90 ++++++++++++++++++++--
 drivers/net/ethernet/pensando/ionic/ionic_dev.h    |  3 +
 .../net/ethernet/pensando/ionic/ionic_devlink.c    | 89 +++++++++++++++++++++
 .../net/ethernet/pensando/ionic/ionic_devlink.h    |  2 +
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    | 12 +--
 drivers/net/ethernet/pensando/ionic/ionic_fw.c     |  8 +-
 drivers/net/ethernet/pensando/ionic/ionic_if.h     |  8 ++
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    | 13 ++--
 drivers/net/ethernet/pensando/ionic/ionic_main.c   | 17 ++--
 15 files changed, 281 insertions(+), 34 deletions(-)
---
base-commit: 4dd16e31135ea8437a720222df34e8745f385d6d
change-id: 20261102-b4-ionic-cmd-timeout-c704d5304b4f

Best regards,
--  
Nikhil P. Rao <nikhil.rao@amd.com>

