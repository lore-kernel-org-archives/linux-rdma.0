Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012049.outbound.protection.outlook.com [52.101.48.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3A3466B1B;
	Thu,  3 Sep 2026 08:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788425783; cv=fail; b=ul3XJmtvWQpEoL5XD+MNM/2xy13b1SPmQZIvpZVtgQlbQx2Jtb8hmgQqe+XQZ99xcAGxBPFkVMe+NpXmC3TveeTaNlYyTGrdb3+1vI6Dqtc6UigUgtzH15GajBYa++JvyAnn3YUNxQJa7NRn0IR8S071DIYYdn+XPWatJ/bejqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788425783; c=relaxed/simple;
	bh=llmkiTKntU8isghstGnS7rZUsF8QNehE/mWMq7zX1T4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CKbrkwAZDw7IyjivMLOFtH+9M04lfllwEOUris95ww1d2rPKELlUTkqcOOpN/FGY7LpZRperV+v8boYzBA6cpdBaw2cKO6ywfqOFziTDgZDZJDZwvnyi6oaoeEUY1hT2qZNwN6eEy+hURd2LIruKMJe1T3lRCSkGP7s5GSzaNZo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ny3cgP+J; arc=fail smtp.client-ip=52.101.48.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ny3cgP+J"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RvOjF6D642NSC3LuUEtSM/Tp3fwCLfaQmYlKUmzO9pmI6FnfIi24uvGSLqjG+UdedpBEOeCzhr7ru7B9CIMz37MiTSeI46Mo9UCmscQMBn7ZtNlQLh/lBZnu0kSBGhOvpM9YLVpN6aiG5GrJelZu2KnUHOjscRb+6Wi5zwT4IQJ8GuR4WRZvt4ABAHC7yuN2KT0mZIAKr1n6nhTSRx2DYrVPrJnxQj6FeOoIHTfhkizn0s7bDVf4Z7wopfcpNK+nTgln9uUr02+jglHlVfvsmvlZy8Zn2ZpqaGp/S9wwWu67Fczyr3kx7vShelZJI5TEaIKu8rPxMGxWKEogQyQi2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gl10A/OtWPHv6zXSDXs6qpU9nWErCMrDYCbo/fFQhS4=;
 b=tULet4VimzdkaeL3Tw/EFyxN6E8B58b2DDhBcJMhOAc4mAz4xueVaNR44r7lDlDkY4Ga8f4T+3OIFiuevWAEuA/XdPdlGKnmbCfeuhRfyyK+fY3GOomVIB2o+GfPFRxYNjRZ8/K+tzDw+Pu8tuuWvPcpK9eXp2KbMYa3vyizQCf2PBT6CmMHq6usRKGvRCCQC3oUKwi6iYZEEtwajrQ77n3C4E5ABOsWjbTNzgA20ZRkdS3R6heEpYC7PM4AprlJPaEYLvDrSQY92bw78afA+jsMILV0oiZm8fyHiFkfWRMjK6o7zC50GDqgxwuFmdZaOYUpEplI7sfZ+bPei3bxYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gl10A/OtWPHv6zXSDXs6qpU9nWErCMrDYCbo/fFQhS4=;
 b=ny3cgP+JXiwahJtN3YaMayIz+IZBDpCD2Bhklp0AFagfI1WYNLwL8ytYeGpLbNsweLETxCO3SiQYJKcLxBBJgRQSBqowmasWTHbftrbjWFLLzBlgmOO/7yio9x3EA4KmtMjvJEKzjuN0wpja+1veBadVVccw+OnqIinLxhyxwgPmjrG7Sihp58qnwfCjCInDeInT9H+rNDCLme8d+U0F1d+UfDgZQIdvDtIq1TwlO3qBcKodkxPkqRVzhwhlY3edcGjF+YugtHFgL9eT89CpVN2of8j19RTD1n8404t6ob7EAc4hBJXvvEoz6NFpE9BQWC4dKnqiMYq3Ajndq/EakA==
Received: from BY1P220CA0021.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::16)
 by SN7PR12MB7911.namprd12.prod.outlook.com (2603:10b6:806:32a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 08:56:11 +0000
Received: from CO1PEPF000075ED.namprd03.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::79) by BY1P220CA0021.outlook.office365.com
 (2603:10b6:a03:5c3::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.11 via Frontend Transport; Thu, 3
 Sep 2026 08:56:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000075ED.mail.protection.outlook.com (10.167.249.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Thu, 3 Sep 2026 08:56:11 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:55:49 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Thu, 3 Sep
 2026 01:55:49 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.46 via Frontend Transport; Thu, 3 Sep
 2026 01:55:37 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>
CC: Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Alexei Lazar
	<alazar@nvidia.com>, Alexei Starovoitov <ast@kernel.org>, Allison Henderson
	<allison.henderson@oracle.com>, Antonio Quartulli <antonio@openvpn.net>,
	Anubhav Singh <anubhavsinggh@google.com>, Bobby Eshleman
	<bobbyeshleman@meta.com>, Boris Pismenny <borisp@nvidia.com>,
	<bpf@vger.kernel.org>, Carolina Jubran <cjubran@nvidia.com>, Chris Mi
	<cmi@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Daniel Borkmann
	<daniel@iogearbox.net>, Daniel Zahka <daniel.zahka@gmail.com>, David Wei
	<dw@davidwei.uk>, Doruk Tan Ozturk <doruk@0sec.ai>, Dragos Tatulea
	<dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, Jacob Keller
	<Jacob.e.keller@intel.com>, Jesper Dangaard Brouer <hawk@kernel.org>, "Jianbo
 Liu" <jianbol@nvidia.com>, John Fastabend <john.fastabend@gmail.com>, "Kees
 Cook" <kees@kernel.org>, Lama Kayal <lkayal@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Patrisious Haddad <phaddad@nvidia.com>, Petr Machata <petrm@nvidia.com>,
	"Raed Salem" <raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	"Richard Gobert" <richardbgobert@gmail.com>, Saeed Mahameed
	<saeedm@nvidia.com>, "Shuah Khan" <shuah@kernel.org>, Shuah Khan
	<skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>, Stanislav
 Fomichev <sdf@fomichev.me>, Stanislav Fomichev <sdf.kernel@gmail.com>, Tariq
 Toukan <tariqt@nvidia.com>, Willem de Bruijn <willemb@google.com>, Willem de
 Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next V3 14/15] selftests: net: gro: Add PSP encapsulation and encryption
Date: Thu, 3 Sep 2026 11:52:14 +0300
Message-ID: <20260903085215.3691657-15-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20260903085215.3691657-1-tariqt@nvidia.com>
References: <20260903085215.3691657-1-tariqt@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000075ED:EE_|SN7PR12MB7911:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d6aa77b-63f5-4955-0312-08df099933ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|82310400026|36860700016|56012099006|10067099003|11063799006|6133799003|3023799007|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UOjumwfs47TLNFXQvSB1G+Q0GcdVFTr8pR3lJVohBDULIQ9nJaBEXik0Ki2s5poELHlhSBCSSKW9VA+fbWs4AQng3H7HIg8TFRALC33RgndseA3N79U8shoH/yl7ZEMLs84mA7ca5tLJYeQm2NCr6ptFIbxABzrmeVBA4cTqi/1raEPpzI9pFx+sePLQqicd/1vAmbKHAqrmnPQevftJ1YB56I+Zx6o3CZniX4Yb6oHHpCgdYS9gFdy8Y+LAWWbG9/3XBCBrE3epNC8lM1Jl+zaCyxaRt5X7BXrkdkX75QuFi2dI6BMCGw/ruPfqD7mv6YxmJWnOJYhsyF+a5HsF3A3g3kmm9VgQvu1YgD/DmGNNnxDRkrRcBtvqeE9Kb6R8B5hm/ckpmEd7soOHpQ5lTqwyumKEf106rLakjS02Z3sVCaP2QSZEYGfCxMkcvJdikHsQI50vrScv454K+QdBYuzKkrFuOSBr5wN0Ce7fSzF18eyUyaF4zd+5mLGyZHUNQDGmJqRgLHjVl45778Dq0Xp36Zn5831BJG5BkCC8BD0yeCVQQ71xXXACStmm6FlSXbX8FswBVgqNF4MnrRl/WZDkBxSaVH9CA8K2dPqhmWx3fqUQqvFxEEDZBfC5fPqQhVqzpMgkI6qYG5SJhv1ArxRaMAmBA0vezXR/JNNF1HtoDaCVCwJNOOJZjrOVUFhzj7A2Uz3dAZrHmq89/pZmVg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(82310400026)(36860700016)(56012099006)(10067099003)(11063799006)(6133799003)(3023799007)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	by37uDIupwpEJTGBW+SqR4+BeaXP9JdMi7JHKXUZaTdEC9/qEPpnnBOOlM8h2johFtX8yfCw328UYfBGXQCuxngPwMAZn2G0uf4qz8SgFr/RIx54WfzIBl6nlGIMLb33znBIsOi5MCYDX4C7qq+mazNPyD7pnacWkWxjz8e/qyWErnF1OgvTgRJYx2ccdD7VIzVkVjBl0SM32Ywnd/gF4R7qPlGO6LAyronz4KgMmVfJCEUbaYP8DXXhFdxo9zETlEagu7Z2B8L6L0MGiKJm62zjAHvyslo5GUbdUv53tONV6sfbvrn719h4mReEfxtMUUCTOJTX1oZSdtnncZaMBuh4GhbFKQ100hnH6fZm1vIuTjm/qj9xJmTRI32o7MLAjzSGELw+XX+l4t4d+8cDqPueZWKVzY2e3aqJwW30Aim/PQ22xNFXZ0FDp92q2b+N
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 08:56:11.2612
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d6aa77b-63f5-4955-0312-08df099933ce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075ED.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7911

From: Cosmin Ratiu <cratiu@nvidia.com>

Add a PSP mode which wraps every transmitted frame in PSP transport
mode and encrypts them in SW with the help of OpenSSL.
The receiving NIC decrypts and decapsulates, so the frame the
receiver sees on its AF_PACKET socket is identical to the non-PSP one
and every geometry assertion in this file applies unchanged.

Sender packet construction is unchange, PSP uses a different buffer to
avoid double encryption.

A few PSP-only cases are added: psp_spi_diff, psp_ver_diff, psp_mixed,
to cover coalescing scenarios which only exist for PSP.

OpenSSL is optional and scoped to this binary: gro is deployed by
several suites, so a missing libcrypto costs only the PSP mode.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 tools/testing/selftests/net/lib/Makefile |  16 ++
 tools/testing/selftests/net/lib/gro.c    | 337 ++++++++++++++++++++++-
 2 files changed, 351 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/lib/Makefile b/tools/testing/selftests/net/lib/Makefile
index ff83603397d0..ce67e8d3e4f6 100644
--- a/tools/testing/selftests/net/lib/Makefile
+++ b/tools/testing/selftests/net/lib/Makefile
@@ -22,4 +22,20 @@ TEST_INCLUDES := $(wildcard py/*.py sh/*.sh)
 
 include ../../lib.mk
 
+# gro optionally needs OpenSSL for PSP.
+PKG_CONFIG ?= pkg-config
+LIBCRYPTO_CFLAGS := $(shell $(PKG_CONFIG) --cflags libcrypto 2>/dev/null)
+LIBCRYPTO_LIBS := $(shell $(PKG_CONFIG) --libs libcrypto 2>/dev/null || \
+		    echo -lcrypto)
+HAVE_OPENSSL := $(shell echo 'int main(void) { return 0; }' | \
+		  $(CC) -x c - -include openssl/evp.h $(LIBCRYPTO_CFLAGS) \
+		  $(LIBCRYPTO_LIBS) -o /dev/null >/dev/null 2>&1 && echo 1)
+
+ifeq ($(HAVE_OPENSSL),1)
+$(OUTPUT)/gro: CFLAGS += -DHAVE_OPENSSL $(LIBCRYPTO_CFLAGS)
+$(OUTPUT)/gro: LDLIBS += $(LIBCRYPTO_LIBS)
+else
+$(warning libcrypto not found, gro will be built without PSP support)
+endif
+
 include ../bpf.mk
diff --git a/tools/testing/selftests/net/lib/gro.c b/tools/testing/selftests/net/lib/gro.c
index 7a333155de1a..25f54eed601f 100644
--- a/tools/testing/selftests/net/lib/gro.c
+++ b/tools/testing/selftests/net/lib/gro.c
@@ -64,6 +64,7 @@
 #define _GNU_SOURCE
 
 #include <arpa/inet.h>
+#include <endian.h>
 #include <errno.h>
 #include <error.h>
 #include <getopt.h>
@@ -79,14 +80,22 @@
 #include <netinet/ip.h>
 #include <netinet/ip6.h>
 #include <netinet/tcp.h>
+#include <netinet/udp.h>
 #include <stdbool.h>
 #include <stddef.h>
 #include <stdio.h>
 #include <stdarg.h>
+#include <stdlib.h>
 #include <string.h>
 #include <time.h>
 #include <unistd.h>
 
+#include <linux/psp.h>
+
+#ifdef HAVE_OPENSSL
+#include <openssl/evp.h>
+#endif
+
 #include "kselftest.h"
 #include "ksft.h"
 
@@ -110,6 +119,38 @@
 
 #define EXIT_OVER_COALESCE	42
 
+/* PSP transport mode encapsulation, as built by the sender:
+ *
+ *	[eth][IP][UDP dport=1000][PSP hdr][encrypted L4][ICV]
+ *
+ * Can't use the kernel-only include/net/psp/types.h header, so copy the
+ * encoding here.
+ */
+struct psphdr {
+	uint8_t		nexthdr;
+	uint8_t		hdrlen;
+	uint8_t		crypt_offset;
+	uint8_t		verfl;
+	uint32_t	spi;		/* big endian */
+	uint64_t	iv;		/* big endian */
+} __packed;
+
+#define PSP_UDP_PORT		1000
+#define PSP_UDP_LEN		sizeof(struct udphdr)
+#define PSP_HDR_LEN		sizeof(struct psphdr)
+#define PSP_ICV_LEN		16
+/* total frame growth: the inserted headers plus the trailing ICV */
+#define PSP_ENCAP_LEN		(PSP_UDP_LEN + PSP_HDR_LEN + PSP_ICV_LEN)
+#define PSP_HDRLEN_NOOPT	1	/* (1 + 1) * 8 == PSP_HDR_LEN */
+#define PSP_VERFL_ONE		0x01
+#define PSP_VERFL_VER_SHIFT	2
+#define PSP_MAX_ASSOC		2
+#define PSP_KEY_LEN_MAX		32
+
+enum {
+	OPT_PSP_ASSOC = 256,
+};
+
 #define ipv6_optlen(p)  (((p)->hdrlen+1) << 3) /* calculate IPv6 extension header len */
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 
@@ -143,6 +184,9 @@ static bool pppoe;
 static uint64_t txtime_ns;
 static int num_flows = 4;
 static bool order_check;
+static bool psp_enabled;
+static int psp_idx;
+static int psp_num_assoc;
 
 #define CAPACITY_PAYLOAD_LEN 200
 
@@ -158,7 +202,8 @@ static int max_payload(void)
 
 static int calc_mss(void)
 {
-	return ASSUMED_MTU - (total_hdr_len - ETH_HLEN);
+	return ASSUMED_MTU - (total_hdr_len - ETH_HLEN) -
+		(psp_enabled ? PSP_ENCAP_LEN : 0);
 }
 
 static int num_large_pkt(void)
@@ -384,6 +429,215 @@ static void fill_transportlayer(void *buf, int seq_offset, int ack_offset,
 	tcph->check = tcp_checksum(tcph, payload_len);
 }
 
+#ifdef HAVE_OPENSSL
+
+struct psp_assoc {
+	uint32_t	spi;
+	uint8_t		key[PSP_KEY_LEN_MAX];
+	int		keylen;
+	int		version;
+	EVP_CIPHER_CTX	*ctx;
+};
+
+static struct psp_assoc psp_assocs[PSP_MAX_ASSOC];
+static uint64_t psp_next_iv = 1;
+
+static char psp_scratch[L2_HLEN_MAX + IP_MAXPACKET + PSP_ENCAP_LEN];
+
+static int psp_key_len(int version)
+{
+	switch (version) {
+	case PSP_VERSION_HDR0_AES_GCM_128:
+	case PSP_VERSION_HDR0_AES_GMAC_128:
+		return 16;
+	case PSP_VERSION_HDR0_AES_GCM_256:
+	case PSP_VERSION_HDR0_AES_GMAC_256:
+		return 32;
+	default:
+		error(1, 0, "psp: unknown version %d", version);
+		return 0;
+	}
+}
+
+static bool psp_version_is_gmac(int version)
+{
+	return version == PSP_VERSION_HDR0_AES_GMAC_128 ||
+	       version == PSP_VERSION_HDR0_AES_GMAC_256;
+}
+
+/* Parses one --psp-assoc "version,spi,key".
+ * The SPI and key (both hex) is a PSP RX assoc from the device under test.
+ */
+static void psp_parse_assoc(char *arg)
+{
+	char *ver_s, *spi_s, *key_s, *end;
+	const EVP_CIPHER *cipher;
+	struct psp_assoc *assoc;
+	unsigned long val;
+	size_t len, i;
+
+	if (psp_num_assoc == PSP_MAX_ASSOC)
+		error(1, 0, "psp: at most %d associations", PSP_MAX_ASSOC);
+	assoc = &psp_assocs[psp_num_assoc];
+
+	ver_s = strtok(arg, ",");
+	spi_s = strtok(NULL, ",");
+	key_s = strtok(NULL, ",");
+	if (!ver_s || !spi_s || !key_s || strtok(NULL, ","))
+		error(1, 0, "psp: --psp-assoc wants version,spi,key");
+
+	errno = 0;
+	val = strtoul(ver_s, &end, 10);
+	if (errno || end == ver_s || *end ||
+	    val > PSP_VERSION_HDR0_AES_GMAC_256)
+		error(1, 0, "psp: bad version '%s'", ver_s);
+	assoc->version = val;
+
+	errno = 0;
+	val = strtoul(spi_s, &end, 16);
+	if (errno || end == spi_s || *end || val > 0xffffffffUL)
+		error(1, 0, "psp: bad SPI '%s'", spi_s);
+	assoc->spi = val;
+
+	len = strlen(key_s);
+	if (len != (size_t)psp_key_len(assoc->version) * 2 ||
+	    strspn(key_s, "0123456789abcdefABCDEF") != len)
+		error(1, 0, "psp: version %d needs a %d byte key, got '%s'",
+		      assoc->version, psp_key_len(assoc->version), key_s);
+
+	assoc->keylen = len / 2;
+	for (i = 0; i < len; i += 2) {
+		unsigned int byte;
+
+		if (sscanf(key_s + i, "%2x", &byte) != 1)
+			error(1, 0, "psp: bad key '%s'", key_s);
+		assoc->key[i / 2] = byte;
+	}
+
+	cipher = assoc->keylen == 16 ? EVP_aes_128_gcm() : EVP_aes_256_gcm();
+	assoc->ctx = EVP_CIPHER_CTX_new();
+	if (!assoc->ctx)
+		error(1, 0, "psp: EVP_CIPHER_CTX_new");
+	if (EVP_EncryptInit_ex(assoc->ctx, cipher, NULL, assoc->key,
+			       NULL) != 1)
+		error(1, 0, "psp: EVP_EncryptInit_ex key");
+	psp_num_assoc++;
+	psp_enabled = true;
+}
+
+static void psp_crypt(struct psp_assoc *assoc, const uint8_t *nonce,
+		      const uint8_t *aad, int aad_len,
+		      uint8_t *data, int data_len, uint8_t *icv)
+{
+	uint8_t *crypt_data = psp_version_is_gmac(assoc->version) ? NULL : data;
+	EVP_CIPHER_CTX *ctx = assoc->ctx;
+	int outl;
+
+	if (EVP_EncryptInit_ex(ctx, NULL, NULL, NULL, nonce) != 1)
+		error(1, 0, "psp: EVP_EncryptInit_ex nonce");
+	if (EVP_EncryptUpdate(ctx, NULL, &outl, aad, aad_len) != 1)
+		error(1, 0, "psp: EVP_EncryptUpdate aad");
+	if (EVP_EncryptUpdate(ctx, crypt_data, &outl, data, data_len) != 1)
+		error(1, 0, "psp: EVP_EncryptUpdate data");
+	if (EVP_EncryptFinal_ex(ctx, icv, &outl) != 1)
+		error(1, 0, "psp: EVP_EncryptFinal_ex");
+	if (EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_GET_TAG, PSP_ICV_LEN,
+				icv) != 1)
+		error(1, 0, "psp: EVP_CTRL_GCM_GET_TAG");
+}
+
+/* Encapsulates & encrypts @pkt with PSP transport mode into psp_scratch.
+ * Returns the scratch buffer and updates *@lenp.
+ */
+static char *psp_encapsulate(const char *pkt, int *lenp)
+{
+	struct psp_assoc *assoc = &psp_assocs[psp_idx];
+	int ip_hlen, l4_off, l4_len, aad_len;
+	struct psphdr *psph;
+	struct udphdr *udph;
+	__be16 sport, dport;
+	uint8_t *data, *icv;
+	int len = *lenp;
+	uint8_t nexthdr;
+
+	if (len + PSP_ENCAP_LEN > (int)sizeof(psp_scratch))
+		error(1, 0, "psp: %d byte frame does not fit", len);
+
+	memcpy(psp_scratch, pkt, len);
+
+	if (proto == PF_INET) {
+		struct iphdr *iph = (struct iphdr *)(psp_scratch + ETH_HLEN);
+
+		ip_hlen = iph->ihl * 4;
+		nexthdr = iph->protocol;
+	} else {
+		struct ipv6hdr *ip6h =
+			(struct ipv6hdr *)(psp_scratch + ETH_HLEN);
+
+		ip_hlen = sizeof(*ip6h);
+		nexthdr = ip6h->nexthdr;
+	}
+
+	l4_off = ETH_HLEN + ip_hlen;
+	l4_len = len - l4_off;
+	if (l4_len < 4)
+		error(1, 0, "psp: no room for an L4 header");
+
+	sport = *(__be16 *)(psp_scratch + l4_off);
+	dport = *(__be16 *)(psp_scratch + l4_off + sizeof(sport));
+
+	memmove(psp_scratch + l4_off + PSP_UDP_LEN + PSP_HDR_LEN,
+		psp_scratch + l4_off, l4_len);
+
+	udph = (struct udphdr *)(psp_scratch + l4_off);
+	udph->source = sport ^ dport;
+	udph->dest = htons(PSP_UDP_PORT);
+	udph->len = htons(PSP_UDP_LEN + PSP_HDR_LEN + l4_len + PSP_ICV_LEN);
+	udph->check = 0;
+
+	psph = (struct psphdr *)(udph + 1);
+	psph->nexthdr = nexthdr;
+	psph->hdrlen = PSP_HDRLEN_NOOPT;
+	psph->crypt_offset = 0;  /* Matches the kernel. */
+	psph->verfl = (assoc->version << PSP_VERFL_VER_SHIFT) | PSP_VERFL_ONE;
+	psph->spi = htonl(assoc->spi);
+	psph->iv = htobe64(psp_next_iv++);
+
+	data = (uint8_t *)psph + PSP_HDR_LEN;
+	icv = (uint8_t *)psph + PSP_HDR_LEN + l4_len;
+	aad_len = PSP_HDR_LEN;
+
+	/* The GCM nonce is wire (spi, iv), which are contiguous. */
+	psp_crypt(assoc,
+		  (const uint8_t *)psph + offsetof(struct psphdr, spi),
+		  (const uint8_t *)psph, aad_len, data, l4_len, icv);
+
+	if (proto == PF_INET) {
+		struct iphdr *iph = (struct iphdr *)(psp_scratch + ETH_HLEN);
+
+		iph->tot_len = htons(ntohs(iph->tot_len) + PSP_ENCAP_LEN);
+		iph->protocol = IPPROTO_UDP;
+		iph->check = 0;
+		iph->check = checksum_fold(iph, ip_hlen, 0);
+	} else {
+		struct ipv6hdr *ip6h =
+			(struct ipv6hdr *)(psp_scratch + ETH_HLEN);
+
+		ip6h->payload_len =
+			htons(ntohs(ip6h->payload_len) + PSP_ENCAP_LEN);
+		ip6h->nexthdr = IPPROTO_UDP;
+	}
+
+	*lenp = len + PSP_ENCAP_LEN;
+	return psp_scratch;
+}
+#else
+static void psp_parse_assoc(char *arg)
+{
+	error(1, 0, "gro was built without OpenSSL, PSP is not available");
+}
+#endif  /* HAVE_OPENSSL */
+
 static void write_packet(int fd, char *buf, int len, struct sockaddr_ll *daddr)
 {
 	char control[CMSG_SPACE(sizeof(uint64_t))];
@@ -392,6 +646,11 @@ static void write_packet(int fd, char *buf, int len, struct sockaddr_ll *daddr)
 	struct cmsghdr *cm;
 	int ret = -1;
 
+#ifdef HAVE_OPENSSL
+	if (psp_enabled)
+		buf = psp_encapsulate(buf, &len);
+#endif
+
 	iov.iov_base = buf;
 	iov.iov_len = len;
 
@@ -572,6 +831,10 @@ static void send_large(int fd, struct sockaddr_ll *daddr, int remainder)
 	const int mss = calc_mss();
 	int i;
 
+	if (num_pkt > MAX_LARGE_PKT_CNT)
+		error(1, 0, "too many large packets: %d > %zu", num_pkt,
+		      (size_t)MAX_LARGE_PKT_CNT);
+
 	for (i = 0; i < num_pkt; i++)
 		create_packet(pkts[i], i * mss, 0, mss, 0);
 	create_packet(last, num_pkt * mss, 0, remainder, 0);
@@ -1111,6 +1374,39 @@ static void send_changed_pppoe_sid(int fd, struct sockaddr_ll *daddr)
 	write_packet(fd, buf, pkt_size, daddr);
 }
 
+/* PSP packets don't coalesce across SPIs or versions. */
+static void send_psp_assoc_switch(int fd, struct sockaddr_ll *daddr)
+{
+	static char buf[MAX_HDR_LEN + PAYLOAD_LEN];
+	int pkt_size = total_hdr_len + PAYLOAD_LEN;
+
+	if (psp_num_assoc < 2)
+		error(1, 0, "%s needs two PSP associations", testname);
+
+	create_packet(buf, 0, 0, PAYLOAD_LEN, 0);
+	write_packet(fd, buf, pkt_size, daddr);
+
+	create_packet(buf, PAYLOAD_LEN, 0, PAYLOAD_LEN, 0);
+	psp_idx = 1;
+	write_packet(fd, buf, pkt_size, daddr);
+	psp_idx = 0;
+}
+
+/* A PSP packet and a cleartext packet of the same flow don't coalesce. */
+static void send_psp_mixed(int fd, struct sockaddr_ll *daddr)
+{
+	static char buf[MAX_HDR_LEN + PAYLOAD_LEN];
+	int pkt_size = total_hdr_len + PAYLOAD_LEN;
+
+	create_packet(buf, 0, 0, PAYLOAD_LEN, 0);
+	write_packet(fd, buf, pkt_size, daddr);
+
+	create_packet(buf, PAYLOAD_LEN, 0, PAYLOAD_LEN, 0);
+	psp_enabled = false;
+	write_packet(fd, buf, pkt_size, daddr);
+	psp_enabled = true;
+}
+
 static void bind_packetsocket(int fd)
 {
 	struct sockaddr_ll daddr = {};
@@ -1559,6 +1855,16 @@ static void gro_sender(void)
 		usleep(fin_delay_us);
 		write_packet(txfd, fin_pkt, total_hdr_len, &daddr);
 
+	/* PSP sub-tests */
+	} else if (strcmp(testname, "psp_spi_diff") == 0 ||
+		   strcmp(testname, "psp_ver_diff") == 0) {
+		send_psp_assoc_switch(txfd, &daddr);
+		usleep(fin_delay_us);
+		write_packet(txfd, fin_pkt, total_hdr_len, &daddr);
+	} else if (strcmp(testname, "psp_mixed") == 0) {
+		send_psp_mixed(txfd, &daddr);
+		usleep(fin_delay_us);
+		write_packet(txfd, fin_pkt, total_hdr_len, &daddr);
 	} else {
 		error(1, 0, "Unknown testcase: %s", testname);
 	}
@@ -1782,6 +2088,22 @@ static void gro_receiver(void)
 		printf("different PPPoE session ID doesn't coalesce: ");
 		check_recv_pkts(rxfd, correct_payload, 2);
 
+	/* PSP sub-tests */
+	} else if (strcmp(testname, "psp_spi_diff") == 0) {
+		correct_payload[0] = PAYLOAD_LEN;
+		correct_payload[1] = PAYLOAD_LEN;
+		printf("different PSP SPI doesn't coalesce: ");
+		check_recv_pkts(rxfd, correct_payload, 2);
+	} else if (strcmp(testname, "psp_ver_diff") == 0) {
+		correct_payload[0] = PAYLOAD_LEN;
+		correct_payload[1] = PAYLOAD_LEN;
+		printf("different PSP version doesn't coalesce: ");
+		check_recv_pkts(rxfd, correct_payload, 2);
+	} else if (strcmp(testname, "psp_mixed") == 0) {
+		correct_payload[0] = PAYLOAD_LEN;
+		correct_payload[1] = PAYLOAD_LEN;
+		printf("PSP and cleartext don't coalesce: ");
+		check_recv_pkts(rxfd, correct_payload, 2);
 	} else {
 		error(1, 0, "Test case error: unknown testname %s", testname);
 	}
@@ -1802,6 +2124,7 @@ static void parse_args(int argc, char **argv)
 		{ "ip6ip6", no_argument, NULL, 'E' },
 		{ "pppoev4", no_argument, NULL, 'p' },
 		{ "pppoev6", no_argument, NULL, 'P' },
+		{ "psp-assoc", required_argument, NULL, OPT_PSP_ASSOC },
 		{ "num-flows", required_argument, NULL, 'n' },
 		{ "rx", no_argument, NULL, 'r' },
 		{ "saddr", required_argument, NULL, 's' },
@@ -1813,8 +2136,12 @@ static void parse_args(int argc, char **argv)
 	};
 	int c;
 
-	while ((c = getopt_long(argc, argv, "46d:D:eEi:n:pPrs:S:t:ov", opts, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "46d:D:eEi:n:pPrs:S:t:ov",
+			       opts, NULL)) != -1) {
 		switch (c) {
+		case OPT_PSP_ASSOC:
+			psp_parse_assoc(optarg);
+			break;
 		case '4':
 			proto = PF_INET;
 			ethhdr_proto = htons(ETH_P_IP);
@@ -1904,6 +2231,12 @@ int main(int argc, char **argv)
 		error(1, 0, "Protocol family is not ipv4 or ipv6");
 	}
 
+	if (psp_enabled && (ipip || ip6ip6 || pppoe))
+		error(1, 0, "--psp-assoc doesn't support ipip, ip6ip6 or PPPoE");
+
+	if (!strncmp(testname, "psp_", 4) && !psp_enabled)
+		error(1, 0, "test %s requires --psp-assoc", testname);
+
 	read_MAC(src_mac, smac);
 	read_MAC(dst_mac, dmac);
 
-- 
2.44.0

