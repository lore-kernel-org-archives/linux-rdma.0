Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010044.outbound.protection.outlook.com [40.93.198.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C343AFCF2;
	Tue, 28 Jul 2026 11:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785237227; cv=fail; b=nTASAbTKk9nMQNJx0OkBqE8la4WoSXfIqxsozjxDfzp2VewDccs8icXRGdh4AGetHmPLq5eYd/pDvjeVwSKeUHqP+jUZ468CyUPU6HWMnJXXhu/Dgnth5Wnazg7UXj/GdwXAv36ioKd0Egk1wUCM9HFS3zpRhVfJ9/7Mj3xtf5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785237227; c=relaxed/simple;
	bh=bAhJRn6JeiACWcCM1ijW2dbckk8/LN/BJkrVtJo8Wss=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MtnjkQB497MCTr/gy2Vph6dq5mDAWdkqWfzYHvOhyInMkWSb7fnmgEzEsCH1YKvhakIrCucHDlA9A0x4vTwdFbxipTJyuJi7BOm75ZHfqeWmJ3yOZL61G5x99BlADTrnKmGbYy5xgunPRuwQnRjUWb51a7HrqkP2QkLo8iHrHPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uyiFSnxf; arc=fail smtp.client-ip=40.93.198.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uyiFSnxf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mCWv5fKFrFpOcIlNWQ0vkVaPMYScqrPdNKlvR6UV575LC9WFjmr5mSyh3M+IfeB10xRSJnADEXScm4u7h59+/jCqE0tsTnokPetw76HJqJNFlkFECtHy7hPVo6TzmF/PHvXgHOvOdmwpbEyQo+aL8k4N/HcepV/mAj43AhdQQPY3cQnts6YD3t2M6Zbwe6c6I5llhrOwRA13wZxcfiugZLZlP5tHi/rYhAXB//W54G68SVIwrHuR4xscWgCIvzUKdcqMvaWe+5kzyJw8Ob3exajeyoVsQLOnYliVhaBWPNTJbAXhReO98fRTbZEY5HPaaZQ89+RAh5+m7PcouNL65A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hA+DO17tjFRbCY+hU0HvVoEWAUN3Gg4GFE9B767F37g=;
 b=LGgGpfKvqdofnA+sDRQ2SqQnTI05wx4nb3Z9i36/INPgPBZFvm2gXFw8YKqi1sK6eUH4VSiqp+DcTHOnxRCIkX64r4dCtK1r4u0PaNXcovFpnpTPgSUSLTo6IoSQamZRjjC48tZgMqjdXS3rWbIE+xT38l8vdxK3oPYVD6vdGJv8Y6Se4pwdrx9yJI5Q04r7Om4pC8jrcvfPn8FopuOUba2QsgSGyjKGI1RS2wYkwaspNL5VVnJafdQRph4vrNKKLtwhwI4gV+gRlt1obTjeBsbyyjU2ksDxte3Zim19jsC0VmYPCt/MvPGCJGm8D1+HphNYyhE8TqSDZz91glkEtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hA+DO17tjFRbCY+hU0HvVoEWAUN3Gg4GFE9B767F37g=;
 b=uyiFSnxfq/WJt5YWgIpoYHGvACY9RyOON4fL5Gl9mOdu99XC1/jZqQFsglQtQjC6E1DNNDYsaFJKgeh6JMimnQ1MGXDTTcHvEHRNHMfvcph1jPdv6nKxY5LCeePJDPHddQADG1EXqUWcCwwdUUqYeuUv6GDYWpWT1yj67PXj1qc=
Received: from CH0P220CA0016.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::32)
 by BY5PR12MB4290.namprd12.prod.outlook.com (2603:10b6:a03:20e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Tue, 28 Jul
 2026 11:13:41 +0000
Received: from CH3PEPF0000000A.namprd04.prod.outlook.com
 (2603:10b6:610:ef:cafe::e) by CH0P220CA0016.outlook.office365.com
 (2603:10b6:610:ef::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend
 Transport; Tue, 28 Jul 2026 11:13:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH3PEPF0000000A.mail.protection.outlook.com (10.167.244.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 11:13:40 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 06:13:40 -0500
Received: from xhdabhijitg41x.xilinx.com (10.180.168.240) by
 satlexmb07.amd.com (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.41
 via Frontend Transport; Tue, 28 Jul 2026 06:13:36 -0500
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
To: <jgg@ziepe.ca>, <leon@kernel.org>, <brett.creeley@amd.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <pabeni@redhat.com>
CC: <allen.hubbe@amd.com>, <nikhil.agarwal@amd.com>,
	<linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Abhijit Gangurde <abhijit.gangurde@amd.com>
Subject: [for-next v5 1/2] net: ionic: Fetch RCQ sign bit from firmware
Date: Tue, 28 Jul 2026 16:43:22 +0530
Message-ID: <20260728111323.2559185-2-abhijit.gangurde@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260728111323.2559185-1-abhijit.gangurde@amd.com>
References: <20260728111323.2559185-1-abhijit.gangurde@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000A:EE_|BY5PR12MB4290:EE_
X-MS-Office365-Filtering-Correlation-Id: c161caf7-629c-47df-e583-08deec994778
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|7416014|376014|1800799024|56012099006|11063799006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	CjfIf2ZnR61/sUJQaI8AtkiuJzzG1CnlaJwrpkXtF6I94hLwM0CL6vZMp9q/znE0xKjCuW4lpFJWsxGWBlfmYV8GQmzhqVpzwIyags47afKuSpRd9nb69XXdveqtxZ7zBnJgdEgN1JODfryeZj+4Mc59v+N7JLi34X7LZtOEEofXSAS2qAN9WYIAHvBNdMUNs3VfVrG91fiwL4aG7lzzwQNrted4EgTTxpnN0+CHknSyuXTqJT7DkClUFEHIPWcmK4nNIhELXq12pI0INBak4En0LlK1rnbsnTPSn8Zeozspr45TGB2eOz63a5uOJOWYOOfmYtiKf7S83AN08nJlUeMABlpKWN08kVrhbx+H1Lw9NR7El9fXRqJcxzgy4SlUXEDSTOBvQ08I2ORNBjVgmQHJlVJ4M5B0wW9qq/LmH+wkdEuGsO2LKwovoQ9XdMUTWILTCfGtgG8idB0HwEd4BCqNI+L14apVn7OuSo7yDf0ySyr+1RiervxQlPSmF0rAtEFO5Mnp3HJceq12JjmgI0aRBbOTahSKFU8X754IcQGiE2PH2hfVZm3Oi/2whVCW3qVhppGhd2ULEs3ba4CP6iXgbeMpxeHYgkNKfKD9JdFE90z7MFkiiI06UvsuCew5AUWY8Ob5gALCrQjJK87uKx/bvCYo5T3a+sRfpt8gZLiugBeJpEbMTzARfTqO+UBHfDgAfZ3k1MiyvgGjygNPmw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(7416014)(376014)(1800799024)(56012099006)(11063799006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UCiVzGh08uacEAP9MA1HZ3e8D2sBn2mn2KCw+GJBLrC+SLwfFAX7PgXTLiFEwPhj6Pl2MWRoL4xS9hr7EXRpICqw03PSCQjTE9onwB7kn4HOcBvrwCAGAxMJ4Q6QlWOkXhJHj/AML2i8YJeJ0qsiTuBfS5UcK3GqHLR4KPqcVYGGYhbBBbcrz/IrmuS09owpM/2fkx4UxveLBM4yxtVSCyJGjKH1LitlWzD1fkFoXWtJkzXOFYtmSWHfwNg+4DQwKlFRKT7n3shYnEeW/VEsGn2MnloE9pMoMOn38QVz7yBJq54xT2DyglJNUawqF5+3H2NZpLR/WQXwUL5/UAWTRLj172MDwW2RSi6Ca/KPIMI32USsllmhxQ8C/G+mhrgfLotkSDrtI8BwKiSQSqMPoYzVA/pNJWRWc5n6iAavyo9uXfXgBG7bOM3+Oaiixs3S
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 11:13:40.5890
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c161caf7-629c-47df-e583-08deec994778
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4290

Read the rcq_sign_bit from the RDMA LIF identity reported by firmware.

Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>
---
 drivers/net/ethernet/pensando/ionic/ionic_if.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_if.h b/drivers/net/ethernet/pensando/ionic/ionic_if.h
index 6afc1fc3c7ed..15f2bc3f4043 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_if.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_if.h
@@ -555,6 +555,8 @@ enum ionic_lif_rdma_cap_stats {
  *	@rdma.eq_qtype:        RDMA Event Qtype
  *	@rdma.stats_type:      Supported statistics type
  *	                       (enum ionic_lif_rdma_cap_stats)
+ *	@rdma.rsvd:            Reserved byte
+ *	@rdma.rcq_sign_bit:    RCQ sign bit
  *	@rdma.rsvd1:           Reserved byte(s)
  * @words:               word access to struct contents
  */
@@ -600,7 +602,9 @@ union ionic_lif_identity {
 			struct ionic_lif_logical_qtype cq_qtype;
 			struct ionic_lif_logical_qtype eq_qtype;
 			__le16 stats_type;
-			u8 rsvd1[162];
+			u8 rsvd;
+			u8 rcq_sign_bit;
+			u8 rsvd1[160];
 		} __packed rdma;
 	} __packed;
 	__le32 words[478];
-- 
2.44.4

