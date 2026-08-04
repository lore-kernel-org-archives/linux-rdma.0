Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010059.outbound.protection.outlook.com [52.101.46.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6548F442FC7;
	Tue,  4 Aug 2026 08:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832725; cv=fail; b=QqRGHRH8jZAkudDRdJEuuLyakpLoIFkGdVm917SY5OoEJveBd6jz0R4lnoEHq7hQ1lyLiHIeGfIxxhEksuerM84ou54nt/Vo2m9bepBHh0F36aYk6Qm7geGc/Ao9bhpqMPNOG+7Wet9qZsRlzQtVFJH7fIa9IaR7PZyaVu3G4h8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832725; c=relaxed/simple;
	bh=Om/YphdYx0xEwrwDgR3s0UyhvuNAAcT/GzEd9IlnAn4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ERc2wSBVC3MWhITUWbYFeKhoQRZO0bMD7egOdMUyyZqn1CKIj/rou6z5GM3pHR+r6X8ylCdPavzBDQly8Z/P07wsoNuRUz0alzTjjIQ7ab2CE92inqc1sM6V+PA+NN8qSkn4s7+LjYejvbZzo50IESt2v30P/rWasfkLU2jigmk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tw99U7vc; arc=fail smtp.client-ip=52.101.46.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tw99U7vc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=acm7Bo758xCNdmC1ApmPfi+VyXj+XrPlS68Z6Bf9jU8GEbOs5v8PgEw8Kcg2pkP/1e6BQkX2ccBo6iC9eLfclfvD8lOXPgxY2bKqvJbJpqcXxf+EqrMV0gJ3vpOQaKgVb5BOfkyZtl7k6uOK+zIzRKSjlztTaQhZrszPbEL7ksuhvCKfKeIGbEfFXy752eBt3MHwH9eW66pixdkTeXo5M+H83/LvpJIFot5lSl5nujnQUm88jpWbSDhAP3xzzxl7+n/ZBcoPiHzMEhqpChNtoZxgLcOHVsqUn2A2aoxodQ9/9fv45ZB5AmZuM7KEoO72hYfANGXC1s9CShNoyl4lqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h8aLoDLh/xjeos60Zcl7Q6zQLEhbNz0l8bfyG81LOIk=;
 b=eyH/CzU+fme4mVBIY6UV0kxWNGpohxDkSMJIxHPb2tIe2DLL2lvkz9SIE99GjaEbZPkkn0uvO5icFVlvxTngQE1l3jsR5Sd1mxpm6y1wGGTtTeFvfp77ol2y/JMZFL8efUAuXmKAf/oCwFrGaAHdilMUBk8Ru8fE48QoOxgeUlEZWJgPanr+O0Yu+LyXpdoPBprgw9ZDaezGqAapUnQErmPLvC0qLnJUrKEhgjkov5tVLvgcY8MwELWcW+GF0XOsnAEWg0PiA+NPvzkG31Q1h6Ylh24ez6hE4Adum556K1x3cfCNofwW80Cjnwi+dV8B3SHWaUqWkWYCMGGmibwDsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h8aLoDLh/xjeos60Zcl7Q6zQLEhbNz0l8bfyG81LOIk=;
 b=tw99U7vcQz+hDZKZ8T1vUIshIlGgStx77WJ6bZXW5HI70XcELgVun1jT950+kZne0CIbsy0uttxa7JoNzTYQ/XB4HhJQWoz7BzdXQHd+WkpL74dLIKf4Y4+z1VBARb+QdoQNDMNI37y52Ki2W4XDqJWCmg0xbg4pi61K9DyHXl/qhgaoQP/nV029TbffF/uStxY75r4X46mbOrhRP0badX6XAWmVitKvfp3VPAjN2GhD6Wt+46F3TxM4f1bvNMwTXY3tWpFZkUZIcGIFo+MBRcD5hBVAtSat492OEoUydjNGiDBO5jEJWYq1/5CvL/Ghi5pqHFRw3UcENt4tLh3ogg==
Received: from PH0P220CA0013.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:d3::11)
 by CY3PR12MB9555.namprd12.prod.outlook.com (2603:10b6:930:10a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Tue, 4 Aug
 2026 08:38:38 +0000
Received: from SN1PEPF000252A0.namprd05.prod.outlook.com (2603:10b6:510:d3::4)
 by PH0P220CA0013.outlook.office365.com (2603:10b6:510:d3::11) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.16
 via Frontend Transport; Tue, 4 Aug 2026 08:38:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SN1PEPF000252A0.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Tue, 4 Aug 2026 08:38:37 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 4 Aug
 2026 01:38:24 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.20; Tue, 4 Aug 2026 01:38:24 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 4 Aug 2026 01:38:16 -0700
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
Subject: [PATCH net-next V2 12/13] selftests: drv-net: psp: Fix responder parsing
Date: Tue, 4 Aug 2026 11:35:34 +0300
Message-ID: <20260804083535.2946459-13-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260804083535.2946459-1-tariqt@nvidia.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A0:EE_|CY3PR12MB9555:EE_
X-MS-Office365-Filtering-Correlation-Id: d9323689-dd8c-4d14-b5f9-08def203c796
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|376014|7416014|1800799024|6133799003|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	LgIj3tJeLTmHicdQzHZGQK3TkjY4fKXvq6yOCoflSExb9uIPu5h7vz6BeZdlEI4bFJfZoanfTPAWIJGkIe0buUvWDlBt9UradYrYXHQVytLfsW6HtaJDw9/PdGU/6QgwKs/K5W/ZfzEDT92h5HIFYXW6621lqp8XEHjXw6UJmzvytlDlFj2pdt/2Tu9mzTvTskNzPjowT9sslfiBNgYvhwwsrfS0kuZcTt8A3E5w5nf27cy5mWeoju8TAxWm3BOvmY1xdcirFYvwnJW7Sie87/zshUv3gZhgI248NbxOuHZqYSuvd5++0Ti8KJY7dypN76c5/6GPlvsQy20S+7SLRRiPl7jrH5+7vcscV8MOF0Q+BYdX8E4JjTRxDAA6n6sK9Url3LinBqDnKpXJ7E+E+OW85CKcng71gDuaNY4jrim2y6zi//FNvvu41NGpQmORur76Co3XEJNdqr6c2ZXHGGxWoRhi1DxQ8yBCsTFdQv4UW2tUtkwEn3zqdX9UkoW01KRw+MdPBsl5/yqP4Ami8EC7qffNzm/YamUuYu4MCxkis9BVe7FDnpZ10VtILvj/2XVORfIcpRcqu86+AtjbfKLRlrIyLHqBZHjw6gcavBQbsazxXtAVjUQwENE3WRhYSgndbG0ddteR3SI4qFkXzOSC3GRSz/FqgnByuaNPeSK77sHFwmrpYsnAphsSRl/5sPk0Y4i6kL99tcQjv3M5LA==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(376014)(7416014)(1800799024)(6133799003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RqNV7jyqF8TptyQiJnCav6QV1RdJxKii5kOdQrYtT/9HWtmPxYlcb6T1nQn+wwsOU1zmp9slswwo+7Wmf7gKT39k/l55asN6YFBAq/rxKhz38/k0k5uCRpLEqQwgCOsGu6GIcSEbmuSMzA5TQHBgpeK1jSPK7xc+3OHKTixdrI514BJfwAvWt2f+Ae0jwXfD6EoWmuCVMcT5WiPxCNq3+hMjq9jsZy89k0kZXYL2ywGJ3/svZvgi1uvBx5mG1EMP+B9LUXlmfwbNo2b1IIlFyP8cuuDbNnO7lkiPwT8BCHGjW/V1aZCW5UU/aUYmaMfv5bLPkxllrPR3TINkECH0OI1N83jLqIeJTTcpTOrDv1Vahf8wzYuL3y6yeD5CtIpLuKQSxN8990CZeDmbS9AvUpIHRNl3gInl+uMvwh/Bytf95QX8R5wwr6dAtIOS9PFs
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 08:38:37.9215
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9323689-dd8c-4d14-b5f9-08def203c796
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9555

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

