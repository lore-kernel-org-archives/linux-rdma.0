Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012004.outbound.protection.outlook.com [40.107.200.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0205043C7BD;
	Thu, 16 Jul 2026 17:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784221427; cv=fail; b=NsKyr1OOFnCt9CSQ8Oqnh4SzsJxpo7OBa9UGt8aKTQMJiGqg6gtyG+IyfH1+Bk8JDPioqjt8SbMHJfsqBfXOKZZrbJ7jt7mRbENmmtVYJJw0eB74F8vUdUzGRGQTY83X7F6LtU58Nok7j0bikMEL0FrKdr3sDKE0j446E0nsKv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784221427; c=relaxed/simple;
	bh=vMQSrUbrovc1B13RpPHQ4m0/j2dnKeFDWiCUtJDKMIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XKkEKi3ggoNpTs1tD39wmK8IeVugtAzPVzyy11bI9TYDE9ZyZ4LwmQRCJ8UFulEJtT8Uz6CIsB9SkKdLfWOAZFbDnK+XpD4xTPzz7MuwEuAFtFk8vPwVBCZ2tpxMPagcTdR7W3tLUb/6j0uET0kQqy+stIUySW1Yy0aAnermtrU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YI34DZ69; arc=fail smtp.client-ip=40.107.200.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YI34DZ69"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aXD1NW+twpcTQeycpl3n9CtSNOFNDBYps7R8odKuKvNTyt5wnN4P6ghfEFUb2ycKSgSVLabYsVkk7GGTuMmeLBAl7U9khEOPFO9zix7eT3+2oPvOeUAbmBc/Mfj0pxmWjK4QI1WS6W52PsIDfplc55T3Rez8g1qAyB8l5Yw2dP+1TwM7slMDvbAiDYG7EK5ErKGRy3i4QVlBLzPf/1BkPUOMRIePMf44Yu6bAd3Qt2NRRjXvkyaIn2XLPhfcH+7tXiBfAfm1IikxEA/1I9mq5pRMlVLLnKNQWr1VG2OshLmMvFHBBkoR5Trzs2YrX8ZxDat7eiELZlLu1fP3mMqtLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/n7e9PY+UaVZoZW3oKyJ8yy2LRQdYhyoQQmm+kP1Trw=;
 b=MDrg72qgI0RaCiw7WCxWHNEGd0qPVxU+Oxt/XCErxDjX9tIC92XRfNiZndlJdVK177FuoGBFAvDEpobSHTYBi68iPxpovGeLLXu9oupCizlySs14XUkxAALTQ8Zrp7v5Xw+I39uFN/eH4UWTEDwyw10s0rIdLa9P7/oZCr0w1P7m4B7jlH0RNCEN8KEMyfeuASEew6RGMQvYci9AC6E5zn85gyER+d9pY4fwkmjni8QrqmyAuuF2MU/3eUD+5w3yqZM7/kD50GJT+GbokfPyE0+POcb9KTCwUUjXTmQ3yj+E2qleVraG3Z/0A4N5TMX90oOESMzBqGiRXww7TeWJEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/n7e9PY+UaVZoZW3oKyJ8yy2LRQdYhyoQQmm+kP1Trw=;
 b=YI34DZ69e+HjtBhTxnosVKL/eKhLHxdyT3e+SFyEInQvxlpe1aCzcHECpAIkJ9eSBokcxNhpYhhTZfZbx1wxUjVb9gFS2FAO/pRVSUlylfRC6ZoWI4JeJzxqYdwXLmKQPg0mMPL17hie9U2PIgtLXbWGf0rqq60MlDwo05KkkK77mbRWnuSEpWz9XGFb4pRhKdKuOMWltHIwCUO2jhIkelJ6Q9fQdGvH/J9uuY9gNPc6fCjz7w5ru2o6PbnZyzBd2bZjAcng0NiSoDJxe7MQIwBQx8tDYbI7gEkR+7Fo/LSDBWNX6xqImTWzV9qlrHBEzr8zBywIa7NcVdF8A7zH2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS7PR12MB6216.namprd12.prod.outlook.com (2603:10b6:8:94::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.12; Thu, 16 Jul 2026 17:03:33 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Thu, 16 Jul 2026
 17:03:33 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	Justin Stitt <justinstitt@google.com>,
	kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v3 08/11] vfio: selftests: Add dev_dbg
Date: Thu, 16 Jul 2026 14:03:24 -0300
Message-ID: <8-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0107.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::20) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB6216:EE_
X-MS-Office365-Filtering-Correlation-Id: e7b14c8b-3c6e-4fe7-da8e-08dee35c2993
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|921020|11063799006|10067099003|56012099006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	bCeNDvT1hSz6JH9TGv3PBURCIxgG1f/cMbOs6eBJBb8tkzmnNat0naTnec8wS165PPQUDHaIpPNtjMc/mVdsLCabaCWOrLiG4e6kxiy9aQeLYmCoR5eY5SFx0JuzlEjASkGHgN3MzGj4vOaHpUM1KeHuKDfe4SR00yJJ+NHbtAt0CVE1jqljp8QslttT0IieHEnk856c7GSEJQNWLpO7oXH24hJMbsZc2PcilhJqKv2Sa0XEIirfZgA0upUrRohK2LtlGccodWbgQuGS2AGBqYyuHY4S1+6I2w0ppX2/Gv6oNMsR5DjQtdrKlnmn9vwt+Lc1YR2Mtm6vVBHVrc42NyLIFV7A52P/vv69bZuUwmQteuM2kp+ifYbp3YgLYQTH1wItfdlistpwo9WC80OTYODj5X/+z+F4HBxGuioTpH8MSWf27mXAFG438htGAIPAQwEYScOeDQgl2vE2xnDBK9E19jIXhkjbthf619PhcEKWORI/+YnCRD+eZjmDrhZhxkR4yYN5v1xlqyfpw/MdOIcsXPI5DAFTPzee3WOhWNilmBISrQSBQd+M5I9B6MLnh7lEAHZMPoxTOnUS3nss8Np2ILxAmuD1rumlF4jhxi8Vw7jFTisgaIJLb8D19eZ33eTtPmta5lyoP6fFE7+7T3qQcJidUinfv+WC5XrljyY+JbGhIqndCHVzVkmjyohzpxCEuVsDpILVhu40a7gQqA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(921020)(11063799006)(10067099003)(56012099006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zIE2GabN3GNcreq6VH4I7Xk1jlcBDTryWWMNKtqmcQ9nYURKFJ83QPMrx+AO?=
 =?us-ascii?Q?JbM6ri5lslVn62mNs9gvj9R28ZWLBrabkV9XZhnoK9LDhiyTRD+U9DGasi9i?=
 =?us-ascii?Q?pvtQaooYyHJuxmxI2kZ5BbDPRvfMrzyvl34hUUXALuHmvgad+5VRcoT8WM4U?=
 =?us-ascii?Q?sqGNQcDWCjYN7obzVX6fOdnF0ksau52YWlHrxqiii1OJ5tUtsuE5M15Z5Iaa?=
 =?us-ascii?Q?rNM9/6WyH3uLZhFcmNJSZAvQDVGz5KcdzPzoN3HdUMyliUEdnLXu3bflLojZ?=
 =?us-ascii?Q?4KOc78P5UT4H8hBDmFeN3qhIdLZOzDJRdS7aa9DNL7XeMsn0E9l9W7GQ34yY?=
 =?us-ascii?Q?Ayn43zOs9xrMfHEO9SNeCst3OaIwyumQftnsd0HQJlfE6D6jWiP35JzU8ah5?=
 =?us-ascii?Q?50CW4dmoDpAAxwlCVPy/nsqw2nkCm+1iLwwQ0onWNGzkK59YI643VENspGr5?=
 =?us-ascii?Q?TPMI/2vI6osXBEoY5cxPJEL17oK9+wW+NqZNpZYGurY9XP7Nx4QgCXetkDZt?=
 =?us-ascii?Q?9WwoQPde95c1upqYYQ2GxfzbMHJSwoc1sJNyrZqzUq5YVoq3TS86hUinkGWR?=
 =?us-ascii?Q?UmHaANSuGgRJhG6rqs8Wisb3+a9mBwqSdrBmdWpaqs+lQ26KPS9y+ihyDGAV?=
 =?us-ascii?Q?f4XlPvelCT5Noh4ki3gnO9MP5y2Tl+qrTiUw3UfciwvtFuxZaC38900Ijj17?=
 =?us-ascii?Q?2sbjdDKruA7JRbjeCa9Xs9iqoKfplleD3AtnqJSS1Aqa1Uk27erP35uwWQDH?=
 =?us-ascii?Q?vvR3sHAI217EKb6tvjfj2EHC/7zKWFbjR+koZTzVTmeaHSOEZ3lSwWbqj555?=
 =?us-ascii?Q?Ntf5FMzz1xt6qpzOBjBAb8G9BnvJj1Iwvvfv9uzry6uv4zLz0iMhUDcOp0iZ?=
 =?us-ascii?Q?HRt+vcRvdvQcE52pR6WsZQkDM7Woj8TUKvKU+7sKtdfIBU8T3LgDr2wggctd?=
 =?us-ascii?Q?GEw8jLQ7Yb7kO/kCiR+TJZufl0+AGUXhl5eNMngO/cfj5uRCPi+i6KU/zef5?=
 =?us-ascii?Q?q5EjBbrBEhRdub7DgmcHc6Dc673zi9UqFjoQltbwa30APsUQpTTB8a/nWWak?=
 =?us-ascii?Q?cEvv5cr756QxMGo2TCfWo+6X3plepsG7vAJkbspjoKmcKO10w9Pt69n/ZYYl?=
 =?us-ascii?Q?WnwqeDm3n2+pBy4CZZaa/fSFlv6wiYLZT/h73WSMjf5lMeek8wuTuE1Jf+hJ?=
 =?us-ascii?Q?U3joT5qvC1RO4YYVyG/PQEGoAuO0WqDmDXH4lerO6c8vFHNWELiFecyKw/RW?=
 =?us-ascii?Q?Pjb/9TVKp2lSkFtJf+u7P0qhpfeEaWZvvnsX/2LzkzH++nQHaPRDVoGWrMIF?=
 =?us-ascii?Q?gfHHtmRcRm0AHGPx2wkx/oEnMhvYbqzZf4Maaj2yeONLSba0QzP63Qb2wNAH?=
 =?us-ascii?Q?Ehi49LklyRiIIp+kv949ycEzZAAImAucG8CVxl0r7wIDg4aoxIYfmJADiF2k?=
 =?us-ascii?Q?CG8AvNK9ZS0AySMzFEjIjubkYXU0x7fW4mSxkSVm9l2XUJ8W/PNcyJYFvDB8?=
 =?us-ascii?Q?lf1OMMABfWWRbSryu37QVMzwP5Lg9HKssnsa3KLAZocNIiA3nsH3/gGtDV8+?=
 =?us-ascii?Q?O500d+8MlXHOgI8KgglBPap/b3eTeVbmXY3Sd0ttS2mi6WAZd8oR8I8H4YgH?=
 =?us-ascii?Q?AD/E2HAEr+ath9GN2LAbcmXfu2bIyXJSoTnSfqDdkg0Y3QqPIQI9YQfYwq7w?=
 =?us-ascii?Q?olGIW4cQuafdpONAXjXLsQqNRPCWEiHmdMvFrdpNF6cRFlYf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7b14c8b-3c6e-4fe7-da8e-08dee35c2993
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 17:03:30.9105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qTV7PpwOBQqpn3p1I771EqzEJnQvjCz5xtO1UJs02ifP/kLCNetuNzM9mcZLRhL2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6216

Enable it with a #define DEBUG at the top of the file. Allows leaving
behind debugging prints that are useful in case future changes are
required.

Assisted-by: Claude:claude-opus-4.6
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../vfio/lib/include/libvfio/vfio_pci_device.h        | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
index 3eabead717bbda..2a72b76c0e96bd 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
@@ -40,6 +40,17 @@ struct vfio_pci_device {
 
 struct vfio_pci_device *vfio_pci_device_alloc(const char *bdf, struct iommu *iommu);
 void vfio_pci_device_free(struct vfio_pci_device *device);
+
+#ifdef DEBUG
+#define dev_dbg dev_info
+#else
+#define dev_dbg(_dev, _fmt, ...)                             \
+	do {                                                 \
+		if (0)                                       \
+			dev_info(_dev, _fmt, ##__VA_ARGS__); \
+	} while (0)
+#endif
+
 struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu);
 void vfio_pci_device_cleanup(struct vfio_pci_device *device);
 
-- 
2.43.0

