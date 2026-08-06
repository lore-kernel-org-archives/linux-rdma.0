Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11023135.outbound.protection.outlook.com [40.93.196.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5568633AD8C
	for <linux-rdma@vger.kernel.org>; Thu,  6 Aug 2026 18:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.135
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786039948; cv=fail; b=MXv4yt5Km8qICf5O6wu8LlV1YW5JHGMz6MjP6/PjiNS3PqCbL5JZNJAdMYAdXDBkKBPTII/C3ASzAOk1K/guNFo0TpN0Yeu+kLmDVdCI2OVJVOxpYU6q1clQRI0/FVTHPC5nfor5RwEEPKkjKBv6pH9WELQE64OYW2XLKbJ05EQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786039948; c=relaxed/simple;
	bh=D7yHEZ4SbIu04Vszsuscq3PpZj/wSSVCNxwU4yyiabY=;
	h=Subject:From:To:Cc:Date:Message-ID:MIME-Version:Content-Type; b=gR0qyRTW4aXQZyidyVvs5ILx8pP7gfxXsvAhw/0NI+GsncDM/fGwTBg0Wos7TXd97/Nfkf7lcSngWOA7sDief7MfU/IGImH/hM7VbNGTZjBttugzdA+/GZCSS2S38JCJomDGOqBT2XwtYQ4N6DSGEm/bgTGZhpfYpB6ibTGolng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=V5VzXrZN; arc=fail smtp.client-ip=40.93.196.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="V5VzXrZN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NSQaZEXkGCZxpDNK+rWB/UZvSi9SwW9juNWGIT6Kqji/GlYhF3KDVrSYtQwC0RZNH9S/nUhrq7zj16HO2E1KHEK1Ar4L5h/k6kqJ6P+58/CsyLu+iJu8+/Q7TsVZMSa5ZgK0tuWH1NYV6gLeqRGI7c2aBnOKA29Xr3v8hCiScLH0GEbBmvgXL3I83x1RYedVaRriFS7rG1KZsSWEfs2Ckjp8/KgajOjwGfsWkdete7jNFpqHKP1UbavjCwJcmbq6FtU/uCNsSPn7IxZrGQy7l+qJdYc6musfayJS+bfzdCWPfzd6iDkTwk2DX9MkiW3YqFI2AmIZNt0XFeb41f5rGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tT0yR6YfOctawT80rLKc+haHXJO+cD7W46UTd5atDMM=;
 b=gnwlGI1cWh0rNzVhZIVCilpfBNcMJYisCN4tR45TVKXNElBDQL4fEaV6erXLOjQTQ/FIy7GZhXZWvK6Nc7vMlO9KoJC1Z08UX+GdtUTH9c0kV1gqFNkjesFErUKBEn15Qo8+gbk/kQyvW/zHSVJLVLtPIyC8kRM4NKR5h/kZsd0eTgfhVOCaD3bdG5qd2x2Is2Qz/+022oa4THYJKVuoe98jz7lxD5KyjRLdP61zdsQJsdOkJO68Qvpb2UFfZK08xsRlcsZYaYggbA62Hw5uMHDUDnaJW5U6a1OhScDytIcUr9Q7I7BqeV1dxO8CefoPqArTDiSxaNbSdhsi29kdgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 50.148.235.34) smtp.rcpttodomain=kernel.org
 smtp.mailfrom=cornelisnetworks.com; dmarc=fail (p=none sp=none pct=100)
 action=none header.from=cornelisnetworks.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tT0yR6YfOctawT80rLKc+haHXJO+cD7W46UTd5atDMM=;
 b=V5VzXrZNLEzW6BC40O22VDRq+Mwaei/v6iGU3uJms16rsKCtgJGkyVXaWZUHWzPgoa/FMNwU/R7HAQtZIinKf8AH2QjmAN5hPi1vy/VqRbOKgM+7+qQ5Rw4ANkKm5ikKOPSqQv92wzaB5JFv3sT2kwCxLLr4DvpWwjY305TjVAZ0MQTuXWp9xExuvI0lu1zhkvdXYjxT31B5kWyFQR0bM3SSb5LG3TaE/umsvp+Sw4GolSshEncLTWSRrYbC6Tfw1edz+cdEVGDONGoWvKqHc2Sf0oZafCgnVkcaSi4n+JV0lpf+idbab7MJNDtrudR3ohgc5IEJZSRydeLcUzKJNQ==
Received: from BL1PR13CA0257.namprd13.prod.outlook.com (2603:10b6:208:2ba::22)
 by CO6PR01MB7434.prod.exchangelabs.com (2603:10b6:303:135::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.20; Thu, 6 Aug 2026 18:12:21 +0000
Received: from BN3PEPF0000B36E.namprd21.prod.outlook.com
 (2603:10b6:208:2ba:cafe::42) by BL1PR13CA0257.outlook.office365.com
 (2603:10b6:208:2ba::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.8 via Frontend Transport; Thu, 6
 Aug 2026 18:12:21 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 50.148.235.34)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=cornelisnetworks.com;
Received-SPF: Fail (protection.outlook.com: domain of cornelisnetworks.com
 does not designate 50.148.235.34 as permitted sender)
 receiver=protection.outlook.com; client-ip=50.148.235.34;
 helo=cn-mailer-00.localdomain;
Received: from cn-mailer-00.localdomain (50.148.235.34) by
 BN3PEPF0000B36E.mail.protection.outlook.com (10.167.243.165) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.0
 via Frontend Transport; Thu, 6 Aug 2026 18:12:20 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id 74AAF1D042A;
	Thu,  6 Aug 2026 14:12:20 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id 612E11810E40E;
	Thu,  6 Aug 2026 14:12:20 -0400 (EDT)
Subject: [PATCH] RDMA/hfi2: Add MAINTAINERS entry
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org
Date: Thu, 06 Aug 2026 14:12:20 -0400
Message-ID: <178603994025.3611040.18003173777504573447.stgit@awdrv-04>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36E:EE_|CO6PR01MB7434:EE_
X-MS-Office365-Filtering-Correlation-Id: cc4f3386-a566-425d-74c2-08def3e641ef
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|1800799024|82310400026|10067099003|56012099006|18002099003|55112099003;
X-Microsoft-Antispam-Message-Info:
	KvoHR2w06ei9Jpi2OCWUpMfTmRu+Pgwz0ijBM5p01kaBDnXwxeaDLHgCovuECQ9nXBOkB7x5dOgqj5snwvQJThCOjenJWevqGVQGdl/KicN65Idlem+/FuE7HtHWkraPOIP0pZzKcwHnJuJTDE99KFweAj8WKrceXnkgyywwbdieA5QceTlVKbeoMfoGUE3yTDs6UPQLXvtdcwvC0W1g2BYChUFK/EfEiw5OjzhceMrXdWu5CpF1wf1+IrNdKUoZj8ekw+HIk1c9prYpqyCtOivLJ6Z/rIdh5iVeij7gaWfvL6Y1LOEk/2PR3rOavG7jWSZSkrXi29wKVZTPaP54bdgyCE5d1vSM6P9X5LrbYF23eXENyYq9uL9paDBqru86dvQwuEnNH8P8bweRTNTjGzACy0PN/gvudQ3KHuFQTDGAOsgZ45Zb9aCnP3wRnozzHdoOFrt/TTwzi6ErlT5SfgnMCbTyMj+Ay7ftNsD+z8UWst1N408EV/xXQgKAoZj5QgaED3GRQJwIafxeL67xDHfbY4kQe/tue8L4Jyd2Z8nfP9H09BzJu/yPHeDhOpENNNGh/g0NxY4X7p1dCHKz9u0eWduX/2SDCf9ma1dzc/yCNxWl0f7STOlUQnWd8tSfmJEeNnVTrvdri7Q4tjjVQKgngAaXrQpCjvEk4Awff4kTPMQAeSuL9YhY9b4SmeyaSx6b13i/Vnm+0VSOMXueAw==
X-Forefront-Antispam-Report:
	CIP:50.148.235.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(1800799024)(82310400026)(10067099003)(56012099006)(18002099003)(55112099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VdNq99jko7KGSK5En2BiTixe8HH5/lH72j4JxaYwlmhsL7uX4hNQ4OOi7x6SVWcNGppr9gmUBTkCZWYLNr/hCIkQ5xGdIkMQEJ7BOrxSBE+vc2LxzIGpERT9/KuqCg2SWnhpA7z5M5Iuc4O5YbXzJbp/0C2CEifNboQRwI1YTstnnmO1cXhFHekPHZpAOZtC5S5o7YsUgf9Nq2Vz6yzta7BKKxeGunorIKJA3ukh7NfPMIvWzKRNYKb9vd2S3QVRysRbmqs++TxlO2XGjGyjlmhu2nw5Hmg8ldfjSb08ZsT6BtZCiXGFN972MIhq40gsofBCkLO0hKWhOeX+90uUGP/EzcNlugHoyYimEjdMKM3na/Xm/26VeGwqXiZQ9HmgDEereSCd8MMxRYfoBcWvUFlJrk18vgVItwFeb8nCj+X1jL7NkuU0XH6rGNYzc6Xr
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2026 18:12:20.6804
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc4f3386-a566-425d-74c2-08def3e641ef
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[50.148.235.34];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36E.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR01MB7434

The hfi2 driver was never given its own MAINTAINERS entry when it was
added; only the pre-existing HFI1 DRIVER entry covers
drivers/infiniband/hw/hfi1. Add a matching HFI2 DRIVER entry so that
drivers/infiniband/hw/hfi2 is properly tracked.

Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>

---
This can be squashed into one of the hfi2 patches even
---
 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 806bd2d80d15..203a68aaae9e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11481,6 +11481,12 @@ L:	linux-rdma@vger.kernel.org
 S:	Supported
 F:	drivers/infiniband/hw/hfi1
 
+HFI2 DRIVER
+M:	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
+L:	linux-rdma@vger.kernel.org
+S:	Supported
+F:	drivers/infiniband/hw/hfi2
+
 HFS FILESYSTEM
 M:	Viacheslav Dubeyko <slava@dubeyko.com>
 M:	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>


