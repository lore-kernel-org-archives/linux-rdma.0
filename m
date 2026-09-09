Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012068.outbound.protection.outlook.com [40.107.209.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE2B52D2C7;
	Wed,  9 Sep 2026 23:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788998266; cv=fail; b=pzR4V422neBR9MZYx+BzYTv4TBc5puB5JBTuqJjuURosn+VraVWJuQpN8gn+A9I7VwdDr/qZ48TCiG4EFcNWBR0+j461Q+PbB4kfXBDkqbTYwzG94hukzHjiww/1sHf5UIWUlq49TNWhFpLX/IfG/aSs2CJpntnMs8SSgP+orB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788998266; c=relaxed/simple;
	bh=PEonLIrvjNR2Y0SllC8Px7tZBZE2/JHmeJAAFuVNTS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DIv16MriCHQjJN3zVE0AfMpMrRqaUBspqpEvKulUNogW4zqLtCVQKIVRq1/pc+/W083O97Uu8rZPq8b9cyoQe3ndahVfZmH47SaLraYIJmSXNGUF8TcLmW3E+QLN3lp86/uCezXxs5YzigUbquvOWgPSkC/kAaVtOjC8nOiMUY0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=R3CDRrJy; arc=fail smtp.client-ip=40.107.209.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="R3CDRrJy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FGdU6S7yS5J/xhbyVioLErk99DwZgA0YUtIm0Fr+/m7pK4qjxdwTA7zSZWoVF8rPLLTuCQqNG8bWx8g/Bv3/bCLmujpqtbzcIsaoCoIdONrthDwYNu1Z0p7ZFLavJUkukM8japOeRQ825b/SCHYa+tw0xOMH2XTl7I9/+BvdzEtuXmyo4zwUDeNgXM1QDVMKpiAsStsE+OEyz6A59yuJnDJ49eL8cu9jPP77Ma4tE9vII0EYTEmmBO/modFwMh6uVEbuuXV9vWceJAdh4Gd4ApnfecU1sURLNXCbvzf6MFV6n1auEjb00tjrjqrUezt+o9llNIIkrjh/72A/Qz8Gcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdakHkdVZr8toF2mDMoJuABxX75SF8IKZyPEoGjCN3w=;
 b=r4avNFNSr6rfUcrNd6DyYEcChaze/EiEC5AWpWnZGk95h16VVQY199agXr+u0dTjyQDHsWj05u3VkLzrsUdQ3/shniLlaxeh3gTAVI6RWeHdet4z5k0LJRaylUa3bEAxkn3kYzDWTHiCIC0GEkry/l7pZNbLLloimNIMSh9eHChXr1rFTK99V1pkKOBsRzQjN1wKG7u0lVWOde+yw85CVxEk/2gR90Hh+PMVJsA0sBlZV5jxZso30zO2OmRowk1yuktYFRYjjrtADGG/WCX+5wK+pqKocgded2X46q10eJgmSh4mvcGW7pyH0qX8zPNfE0XzdqhFv5BZ5Mc1h5oRvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdakHkdVZr8toF2mDMoJuABxX75SF8IKZyPEoGjCN3w=;
 b=R3CDRrJyLN5Y8sl8O11UoCfrd2TsKDFE8rfjGn8xq/Umpvqk4Qg+aTouq3pCgAVfTNAqUxwnF2tX+GfReWyYrEbBPSFjYT5wk1NhbRWzHE/w+LBZvKJwiZtBnFRa/uwLA+wAdsSPLc8XqfzTE0V5pbp0hcdEc4uwOoi8Yt38ivadp0VLOnC+gybGUbkrmmoE/3HHLK68o2b52myOsAC8AA62Qn/qJMov9aqehMG1XVO1//pgoCmu5HzgXZNydFLi/DRsOcc2V5dV++ipr6HIH4q3n5pF4CYJmlrF6yP9TIvldxIDhUhsEsaD0+Us1XswgCi0aknNL8zdkiGk2BTl4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS7PR12MB8418.namprd12.prod.outlook.com (2603:10b6:8:e9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Wed, 9 Sep 2026
 23:57:39 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0406.007; Wed, 9 Sep 2026
 23:57:39 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>
Cc: patches@lists.linux.dev
Subject: [PATCH v5 07/10] vfio: selftests: Add dev_dbg
Date: Wed,  9 Sep 2026 20:57:33 -0300
Message-ID: <7-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
In-Reply-To: <0-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT2PR01CA0001.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB8418:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c04da12-4f42-4f42-1ad1-08df0ece2050
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|921020|6133799003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	5fIJZbqdorqqiPZtS36NAg2zE7RFO8jqcGPvYVDOR22fWqoSBDI2AYlV6O8HbpdFV9Nz5mceq6ob3ZbNzLSN4vWMv+57+aRVU59PVRYtIbiWsEt6MEGv07RG6H/W+JTFbUSUgq6C5IOZT6WfPsR8P7bq3MRKnTu5Ukij1ADZXEEjyQ/8C2lg5G5Bgd5i2+0hvur8chCUyKercNjIGqndM2g5aiTWhF2YThoBMFD2jsF221AodptxUA/bjf+jB6Ou5psZTpDzl8HX7Pak4xZcDlT1JiB7gkzdpGloqsgGUXvpnGgsYx1upoPjR9Q/qkGvnellqCTckZTb+jrs6JOwPt1/Bu2p70wWIWCJXMKA3JaBidNMSrubrhI4JyMM49jjlyZhsq6149C/PM8vZ0ShSYQoGe7VWSKntuWzloFNkq8R+XVa8Hb8faOHqq4cPZVOEV5w11AASzaIMTgUE55EImuXQY+wLjlyKmpXa2mmCY+HaaHsHboeDJlY9mxoIpZMpUFcbVxerP9X+QL1F1Y389hjlCqrQxGTIZMGVp1o8yYdKhj4akFHaFIvlgBh1aphf7hvyLv5trq3gWHQ2c867L1DRbFw1LP3Qi8zHqtPdjJ1j8iV1Ih/ckeXmmxL7T8hozTqLJbTDao7PzpvQD/M7UR9eulV0xnuh8iGDnP+h8kGNdvROPpNqncqH0pNUHaiZwjdoF3l/ds3e9yP5ejH+w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(921020)(6133799003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PYoEkvxcaFfPWbTzRH++YaiVMzDUmSujre9VcZKgbEEWpxBRCe2te6BFL3+w?=
 =?us-ascii?Q?DSzAgKk4mUVASs85/AOCWs4tha8L8uRdFdxhty0GbFQfUUsXfPhvwNInnd85?=
 =?us-ascii?Q?knj+AioiPDwZld7Hvll2iW1mx5VKvxqqQ/xCrOS9bacIRn7vecbWiUXq4DxA?=
 =?us-ascii?Q?eKvYv3CFtBbOeYYLWvArztnqFK4UJwAO3RWRa9J7tklPtsRZyVFsH9gX0xJG?=
 =?us-ascii?Q?3AwdII3oUXBWkwG9Y3uG1cM32/6can2yQVUWXHuII/cA+tjFzM0mqaGXBdzp?=
 =?us-ascii?Q?EglLmwW02TVM5/9iE+YzK8nx/x7tIw/TaHmCHoqOT1nzkWz+iyku1u3ElCwy?=
 =?us-ascii?Q?ag0gCiSTEuAY4ORMJ1oN/GHX/oiY1VCQXSd5Blfo1ZCkIup5NJ+cQK/G7b50?=
 =?us-ascii?Q?R+RUzYVsjVVKiHvkRrlzRr4d44I88NO2LSoepk4g2fdzIvUErsCpO750kLld?=
 =?us-ascii?Q?QyBMBizVgtOyZhPXBTjwYAEmJFsDaekqiAy+bdtUDYc7liS8F9AdEuXXXLLd?=
 =?us-ascii?Q?sCri/S1jJeDOIy+uD6T+aF07QYgwNGLF7SeqM82PcSp91Gv003jN1iphC1o9?=
 =?us-ascii?Q?vWccFbDqs+qS6DEqf8GHrLbs9FWePQqOSWpg0IDK4V7uCQzt87RzK+qOUJzh?=
 =?us-ascii?Q?XEaJHymUOOf7rpqMfv9f2p9TE4SxATcpCElng6JcSpRPTQBwDCt0lmN4GVli?=
 =?us-ascii?Q?v+jusozZRk9k78BVZga3om6m8zGDIBjxF9oJ0dGepUF0J3L00/m+i49O1te8?=
 =?us-ascii?Q?JWqBPjjGCBu0jcw8KWJRFler0EiPuohTCVeZNJ1+P29gUahMAr9SrWlzzdJ2?=
 =?us-ascii?Q?JVuxa/nyorqM1hLJet1gY/oqmfaz/VvZkUM39RxvnkMfRN4mD2mLawhkv7vR?=
 =?us-ascii?Q?qqDjwwciqMaDhyLxDRVM+xzxFh5fOD1ukPZqK5smKzucpSOcsc+ZhvmbXrtu?=
 =?us-ascii?Q?iLiDex2l0jLfcdMw+F/8zjQ7kwZFTMQ+Q8/ebmXy9SEKPQPKx8vv1PKeMJsS?=
 =?us-ascii?Q?Sk4hPWDLKiuos+WpHM3GIz+I99BglsJIeIL6F7HMWAfzUB02auHywwFkqYO2?=
 =?us-ascii?Q?+bGu7nSjDy/lGTDQvaxoYEyIOeVFH/FuxKsszA6uEMRsj9ssPINABhdGIHJ4?=
 =?us-ascii?Q?BwEVQ/FF+eWOb6FNec1nuUlR59wpKOVWSKa22SAB8Rf78dafusEUQNDrdrwJ?=
 =?us-ascii?Q?tYFR7tEOoKfE1ZNePwf+kK6Ch0IhvooNwd4muMsWLfc3uiA5xFS36t9xArfR?=
 =?us-ascii?Q?BeeoqezVlGakHOwyLG8IymFkOfDwBIDyhsbjQLiYw0pQqLSkfGPQ4b7j8QMU?=
 =?us-ascii?Q?g7p4cibZPb6pR0Mu6ew3nHeEmcP3vKS3tYPsTnFKmb/AvTK9+8MWrFkxOqwl?=
 =?us-ascii?Q?3JTWMJ7XSP0krgBSJXsndccSA0GMf/QiFYkmqGA38i7j7qFhoVV60CLxxA78?=
 =?us-ascii?Q?IUwY2ypY5RiAU5pOhwODaGsdP32Gae4jwFJrK4obaaEvl5TwNJ25zYOhp0CJ?=
 =?us-ascii?Q?QMWjtkZXJQxmwVzGm37nkuwTa3ejsLVhRKF2yFsURCj81QVqzdfsVaSB7Aw6?=
 =?us-ascii?Q?WP9WUCbqkw/ciz6isivL1kwxI3LNmAfDNCICNkVUfa+sDMYej5v8CgT1Hc5T?=
 =?us-ascii?Q?jybqk76ZWrdvLu/A2CsMoQgz1GlQ/xbf1Oid+u2Y2yjKU5wVQ91jgPMqlNgL?=
 =?us-ascii?Q?Sg/NBRwYVeKjds9PGyt7Uq6e4rcDs+JFibMV2LHnMWPw05Qq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c04da12-4f42-4f42-1ad1-08df0ece2050
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 23:57:38.1762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2wC8q3885bJq/AfQOUuFl3VDZKLF5ZhusoNvKfnJyjByGVyLJbQfnp/KtaXOZELa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8418

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
index e19bd94b8dd2ac..007adc322c1ea4 100644
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

