Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010044.outbound.protection.outlook.com [52.101.85.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D551C3FA5F5;
	Thu, 30 Jul 2026 09:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785403228; cv=fail; b=E1VdCjt009vLCZ/MqYU/ZEqSRtGpGz+OWYc6sm+UE8nVedZyOu3P/VwXtsn6QipNc4yKJBXSLZXfHd4AqNqCeR/8PEPgMb9+UgcEAN7OD419SDeOn+/PGIqXJ//djeXqP2bqIP/OwzatVGfIzBaAStgJ+PTdtOHCAcfDr1QJipM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785403228; c=relaxed/simple;
	bh=Om/YphdYx0xEwrwDgR3s0UyhvuNAAcT/GzEd9IlnAn4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IWh60NL+yv8L4V0NUDGAEdav/zwlhMUuBrEXBhbegHzTx9fN0eenRCJ9XQA3ESWxAiJ+vaHUN2UKaT1FXD+c6ndvTPlEWWyWHGotge9EUh69A8CiBeq1gFal5irDVr0B+viHOqUC0oqY9FaCMYcuA+LBf3s9K3/22P2+qfuHsdw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=N2BRYEwL; arc=fail smtp.client-ip=52.101.85.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N2BRYEwL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fG9XZ8KSXOAjCQsSPb+Rv75qS2R6iv9XZGSzDzTWXF+zRDRJqCcPrzW6obgrrsDbNkWXmFtCE5rALS/M4S6DA+FMbMWItBGGMdpymluUZDdp8ZZ8BPq7+WoAyN+iZT/rvf/ZKuRFYGDz+VuuGC1gQVANceRcXUz3FsoBZmmAl6b3OGw3DXUYPr4aDMPEtT6/crB3Id2Q53JTM53oJ4QRUqTRiEOUjI1ZwzGgSb8gLKZAzdcsqSAYK9MTkUIuegC+uicTeziJE3rYwA203bkwTgxp6SIt7HFYN7WRFwRn1ceXLA3KrG6lXsll4fbvgCg4YZBfTf3q22gHlX7iZWX43w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h8aLoDLh/xjeos60Zcl7Q6zQLEhbNz0l8bfyG81LOIk=;
 b=Tifdl/xKllQmzHQzk+JUEAJYtpznZcR4O0uapCqJFWE9ui0VNNaD5q/2fbJzn8glD6fU45XAGNgXXNS6Z1XN32cvDG6baUaLh3ZUYCW8z2gJW32i5lnXkHgGuT6QCSc7spkHiTW7+n5AItcBy4DddUYo9EyWbrYPntz30U0RvgBXGneRxoiqtPM+ywWjpVkIWNY7VFZwxQkpWIfM4q7Y3UojUiEGWCVmFi5Edhn8itKrHjOu4F2u28PRQSbWKWsVjiBgjxoYSz4ZuYmaT3YYkUtidrSbWZW02/nr0qSwg98iArdNAKTjIzifUIq6G+fKhJefyVLOUxxFbQ6PErmUKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8aLoDLh/xjeos60Zcl7Q6zQLEhbNz0l8bfyG81LOIk=;
 b=N2BRYEwLOeT9Al+uU19+p3x5goJvtnpvTxeWqOJaWkFOov5GWqi1VrZ2xKFXuaDS4H2+tSrUEzcq7bXXPP73IHZTrZMUbnEDE2ZqmmO2K4vQEYOJF9J31u0jmdMvCDQBS125Ot86naHCFTdAFNDv8Eh330eUWzcFICuyP9JPIWeLTHIO+Y68KaXTKlRCy0O+sqIF6ZbGxTJ+dtK3qp/Z7p2HprFyqJ/r21ZNlSdWQoa6rMdMcIhyZxswHidj4o5/XSg2Baci91YK/5Ufd87SUdVxEWQd6JNYdFrAZJv6Xz92jjQ+c5XEf3+PhZ/00IlCaSaT2DW+fhYv/1iw6LFSSw==
Received: from BY3PR10CA0005.namprd10.prod.outlook.com (2603:10b6:a03:255::10)
 by DM4PR12MB5748.namprd12.prod.outlook.com (2603:10b6:8:5f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Thu, 30 Jul
 2026 09:20:21 +0000
Received: from SJ5PEPF000001CB.namprd05.prod.outlook.com
 (2603:10b6:a03:255:cafe::2d) by BY3PR10CA0005.outlook.office365.com
 (2603:10b6:a03:255::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.13 via Frontend Transport; Thu,
 30 Jul 2026 09:20:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001CB.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Thu, 30 Jul 2026 09:20:20 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 30 Jul
 2026 02:20:10 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Thu, 30 Jul
 2026 02:20:09 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Thu, 30
 Jul 2026 02:20:01 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Alexei Lazar
	<alazar@nvidia.com>, Boris Pismenny <borisp@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>, Cosmin Ratiu
	<cratiu@nvidia.com>, Daniel Zahka <daniel.zahka@gmail.com>, Doruk Tan Ozturk
	<doruk@0sec.ai>, Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Jacob Keller <Jacob.e.keller@intel.com>, Jianbo Liu
	<jianbol@nvidia.com>, Kees Cook <kees@kernel.org>, Lama Kayal
	<lkayal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, "Patrisious
 Haddad" <phaddad@nvidia.com>, Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu
	<rrameshbabu@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan
	<shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Simon Horman
	<horms@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Stanislav Fomichev
	<sdf.kernel@gmail.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 12/13] selftests: drv-net: psp: Fix responder parsing
Date: Thu, 30 Jul 2026 12:17:55 +0300
Message-ID: <20260730091756.2543777-14-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260730091756.2543777-1-tariqt@nvidia.com>
References: <20260730091756.2543777-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CB:EE_|DM4PR12MB5748:EE_
X-MS-Office365-Filtering-Correlation-Id: a8619a38-add3-4e55-2c9a-08deee1bc71a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|36860700016|82310400026|1800799024|6133799003|10067099003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	/4R5K8ONW2K2DdCIJb0DcSyLB6izK+k3vT8rUUEkkwLu+8qrK/LtxNeEoAlcCVYeLpMIIRPnAzJES8tjtixgS5uWnuoaNtTBkeae6ItfF/9zVLRocdSWTz2gmZ7kNTD3keYHu2JvkuDDVtZornfNbnbtUcFiqeTuGUCERNrlb9IIzfv47Gwu2pin463S2N05EVcv02RWVSb3uydjXPqbWP8v0omcRl8mqJpFKInAwq76u32YQsITF/KLvb1x0yBKGPy2kDhSjFnfy6IuDVEaM2WSBZGbQwrtfjLdOax7wTvaqMnBKBWdnYCP/FeHQKy3thSLuhg9R7Ica8eUOUIbkxskXT1s1HAQN2VS0iV4l1evCgs3IDd/2j1GMG3z2ATg7NBts4A+8N1XhLI2I+Kqk7SSrPM/krNVKsC5FTQr1qKO7p3hMdbPtR33HQTSxANERHmZj3NqMSplMyHfftkKiR8VzHnrsfGWIVp2Q+iRJFhzerITNY5T96wjZaoZGJu+EhhHKIkgsG449+JnBI3K5Qna4Da+IMvn6mcRBCkaWGcCQEyHeZM66lhwOleqvtXTl1cBx3Wpy1VFF/+POKWGRWppxu6mk2A2C9N2cufkVS/q5AUGtcA4BU8s0PxoqxyyGUJykVa8SmWTs4edN1ny9OBTR9Omk5fCSAFCBN3PCdZmibNxnD/lGVNFH5AbKUWctEH9qhls3nDgAjWnXGZgJw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(36860700016)(82310400026)(1800799024)(6133799003)(10067099003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/qlmUkAZ+J+jd2urf+Lz12SfP+lXf6tfvECWz6h/Tsr9xs/a2SrEQUSYgkQfzZYOfqcVDPTJ6KuHlrvJtPXwKsgTph3OcJel03WXQdMPFrbYfoOiEWHz/CbxF024OJroGmIA3Fr/0ZsSp05XfawJh+ABEX4y5f8kAN3s2oBSM4eMfDTXM+d/p6ol6Y32c2fo4cRZuOfa1mDBF5+zWfeKdec0yJntxMR/oU3A1fBnOOqvHx5XabB9hml9eSroNljK50l78QHousmKBPnudzGsf6t3Cu1JP1MpV6RD4S106MI18RTjXvRcocAv6aX/cZ1xvkXcWQJTR4QnSy9XmzRBFChlbECi011iZn6SiPDIkzauGTvaGjDOS+C/Y65Z/mE5NXfW/UsVVzf8AzX1yw5JiXFweFReDBczFkZt3g8YrWXKYCmr1iN644+8qkbytYJ+
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 09:20:20.4770
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8619a38-add3-4e55-2c9a-08deee1bc71a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5748

From: Cosmin Ratiu <cratiu@nvidia.com>

The psp_responder accumulates received data in a buffer and parses
received messages from it, but a message that's split in two across
command and argument (e.g. "psp conn" and "1") will permanently choke
the parser, because the stand-alone arg is never parsed after discarding
the command.

This is mostly a theoretical issue since a sent TCP segment from psp.py
of the form "psp conn 1" will arrive in one piece to psp_responder, but
the AI tools complain about the possibility that it might get split, so
fix it now before another command with an argument is added in the next
patch.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../selftests/drivers/net/psp_responder.c     | 38 +++++++++----------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/psp_responder.c b/tools/testing/selftests/drivers/net/psp_responder.c
index a26e7628bbb1..985161eb482b 100644
--- a/tools/testing/selftests/drivers/net/psp_responder.c
+++ b/tools/testing/selftests/drivers/net/psp_responder.c
@@ -185,22 +185,22 @@ run_session(struct ynl_sock *ys, struct opts *opts,
 			}
 
 			off += n;
-			n = off;
 
 #define __consume(sz)						\
 		({						\
-			if (n == (sz)) {			\
-				off = 0;			\
-			} else {				\
-				off -= (sz);			\
-				memmove(buf, &buf[(sz)], off);	\
-			}					\
+			off -= (sz);				\
+			memmove(buf, &buf[(sz)], off);		\
 		})
 
-#define cmd(_name)							\
+/* Only match once the command and its _extra_sz byte payload are both
+ * buffered, otherwise a split read would consume the name and strand
+ * the payload, desynchronizing the parser for good.
+ */
+#define cmd(_name, _extra_sz)						\
 		({							\
 			ssize_t sz = sizeof(_name);			\
-			bool match = n >= sz &&	!memcmp(buf, _name, sz); \
+			bool match = off >= sz + (_extra_sz) &&		\
+				!memcmp(buf, _name, sz);		\
 									\
 			if (match) {					\
 				dbg("command: " _name "\n");		\
@@ -213,10 +213,10 @@ run_session(struct ynl_sock *ys, struct opts *opts,
 			do {
 				consumed = false;
 
-				if (cmd("read len"))
+				if (cmd("read len", 0))
 					send_str(comm_sock, data_read);
 
-				if (cmd("data echo")) {
+				if (cmd("data echo", 0)) {
 					if (data_sock >= 0)
 						send(data_sock, "echo", 5,
 						     MSG_WAITALL);
@@ -224,7 +224,7 @@ run_session(struct ynl_sock *ys, struct opts *opts,
 						fprintf(stderr, "WARN: echo but no data sock\n");
 					send_ack(comm_sock);
 				}
-				if (cmd("data close")) {
+				if (cmd("data close", 0)) {
 					if (data_sock >= 0) {
 						close(data_sock);
 						data_sock = -1;
@@ -233,26 +233,22 @@ run_session(struct ynl_sock *ys, struct opts *opts,
 						race_close = true;
 					}
 				}
-				if (cmd("conn psp")) {
+				if (cmd("conn psp", 2)) {
 					if (accept_cfg != ACCEPT_CFG_NONE)
 						fprintf(stderr, "WARN: old conn config still set!\n");
 					accept_cfg = ACCEPT_CFG_PSP;
 					send_ack(comm_sock);
 					/* next two bytes are versions */
-					if (off >= 2) {
-						memcpy(&psp_vers, buf, 2);
-						__consume(2);
-					} else {
-						fprintf(stderr, "WARN: short conn psp command!\n");
-					}
+					memcpy(&psp_vers, buf, 2);
+					__consume(2);
 				}
-				if (cmd("conn clr")) {
+				if (cmd("conn clr", 0)) {
 					if (accept_cfg != ACCEPT_CFG_NONE)
 						fprintf(stderr, "WARN: old conn config still set!\n");
 					accept_cfg = ACCEPT_CFG_CLEAR;
 					send_ack(comm_sock);
 				}
-				if (cmd("exit"))
+				if (cmd("exit", 0))
 					should_quit = true;
 #undef cmd
 
-- 
2.44.0

