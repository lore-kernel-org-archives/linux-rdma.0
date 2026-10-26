Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792993091;
	b=WlHAjkEXq4LBjIYsl1nHxGgGiaQfYAMSto5JhXGAKabv3U9TDnhOqgavvKFSw4lzfrw/
	 95DDlycVAfXTBuLF7m7JnHoTluwvhZRhS0hck6OqWuBr6XAdnxvAyWGTEcaL2E0PbDmaI
	 iE6kFcN3jrk2SnOJP6el4QvBxU+NPsquJ6qqlIqrIlIAvrFvf8TdfhzfdEQluROJPj+rV
	 e1A4bEbXXqH8q8nTM7rB+jbWw5usZnqZYaPxwLGp+INB7+3GF8HXRJwtT2+4lkcZ5LOYl
	 qYT72M8k9XnA546dzwHSjVq6LozLFxhwxvty0JmFMBHnlp21bXEtLQwOiCw9FbaafZw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993091;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=MpMaLNlimllblJa9cIjGeCnm3n3JY1R2x4eK/IUw1K8=;
	b=c9ap9W3kBSFpQR2624rdfc6wUUYSCAlhj0CWbpacK4XJFbgokeQSQozDgXVlcNDzOM1i
	 8/Ae4e58q2NflDjX1s+A1JYR247Usz+cEg+F5UJD14TCk8ucaszMIl0Mk/O1sZEO0E7/9
	 Qx7aPzTrmEKctVmfQTEihQpYSGH+IbP99tXcUx/kWuK4c5kKQMUs6n9N1+l6Rr6EYhNFx
	 o/0hc+MTXFEVwguekr7Mh4Z494KaWiN2PImnbjp0pI403ZXnPkD3Uj1q2sF+oKCp/mBXc
	 OwqM65z1W/FAgNiAA73nExOxKZs0rKa2EmB+7nW7jE3Hdx92vy23TTbq8p4IitLxv4Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nuz3D67E;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.41
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012041.outbound.protection.outlook.com [52.101.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9517606D316;
	Mon, 26 Oct 2026 05:38:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9517606D316
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=nuz3D67E
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ruw0ePCkA5LiD7KPtlqaK0H6pT24dpvJ6Ov30CphINHvHnoOwNlaCFnECMONFPFG/nLPDvXaOo/fNNehLKYm7oRrI32Y4zzCSuoI6laUcD6/29TIbw6PY++AaF3OC2+XlWnW8FreV5/PU6Q5BrKtU1uVMW/P06F819vgXbpSAhEByA10dfPtB/sd4nG2La8TZEmRbkcwZVnoGuXgoKBY2SFEoy/gWt220teC4xsGK5oX+6SRIOYKi4HyE6GT+7pzG52XZ+M1/onGVxLCXRBjZYPZCrHjAMm3p2Xn/RHF1FZSKTMwHjr8Ls6SXWkqeizgyDgWm/90hiiZKtKcBv3lzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MpMaLNlimllblJa9cIjGeCnm3n3JY1R2x4eK/IUw1K8=;
 b=H5M/ruxciZfnI9xUSulZwsHmcKdnLwBwRBQ8r33BVDcqkVpbZL22i/KYAjUw+c+Ag2yt5qoHo+p1rvDAjvUU/vlwH08lQxEiwRoKNDARVFj5pBWcIrrGkbfLoNvptwXg/qN6/LsM8LAswZekOvhLVlsjTCyVNqZvHcwUY14PVb5dC7Wlk+RymcB562ESon9qLb5f6IX9noxHVi7LaTGmu5gdABNC7PMzAOmlqAKByUx6wCJS9uRO1VU51Ay7Oow1aSnNN6Jtg86Vg0veNvXVaxU6dMRItqzXMj2wubntxoXCt11KBcT4y4+TvEzlg1bS5hly9W6RVCa7krWGNmtE6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MpMaLNlimllblJa9cIjGeCnm3n3JY1R2x4eK/IUw1K8=;
 b=nuz3D67E+rAlVsBMuiHDmTr1bvZD5FzXu3gO7XqOoZzS35VLVdUB0y30yGJO+1risNEz8OzZFa1+sRZKnoIkXehSBw+BtOaBkF/zPyhuIsgdizaYBBPzmZwtZE8BTry2h3TmZsB4pRA28WM0+qrLvgTaEuzsacoY9N5ZrR9oEahK9JC0D3E/ir2R/XN6kPXTDF9x7yXbGkLcV/R+FAZXxhPXegfOabcHRPQET259kM5x6z3zF8OKt4ZD8YRiFCgPhL95O+T3BfeZ8oKLHPN4Tft8fiEW5hiIozf85VLshf0SSAWuFOXoXHvl+ewTLOvae1PJPg4OP3jDFWUOh0NEOg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by SA1PR12MB7442.namprd12.prod.outlook.com
 (2603:10b6:806:2b5::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 05:37:46 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 05:37:46 +0000
From: Alistair Popple <apopple@nvidia.com>
To: dri-devel@lists.freedesktop.org,
	christian.koenig@amd.com,
	sumit.semwal@linaro.org,
	jgg@nvidia.com
Cc: Alistair Popple <apopple@nvidia.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Matthew Brost <matthew.brost@intel.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dongwon Kim <dongwon.kim@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Baolu Lu <baolu.lu@linux.intel.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	intel-xe@lists.freedesktop.org,
	amd-gfx@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	zhipingz@meta.com,
	treding@nvidia.com,
	jhubbard@nvidia.com
Subject: [PATCH 14/26] drm/amdgpu: Use the SGT mapping type
Date: Mon, 26 Oct 2026 16:36:05 +1100
Message-ID: <20261026053623.202642-15-apopple@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261026053623.202642-1-apopple@nvidia.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5PR01CA0058.ausprd01.prod.outlook.com
 (2603:10c6:10:1fc::17) To SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|SA1PR12MB7442:EE_
X-MS-Office365-Filtering-Correlation-Id: 29047b8f-6137-4721-de2f-08df332343c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|18002099003|22082099003|3023799007|56012099006|11063799006|261022075727099003|261021123027099003|10067099003|261009221227099003|261009223027099003|261021121427099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	MjEGpmcDYCG8x7D3//ZpLf/0LMQh5ANbDaJ9LlXRATxI4nFgowF4IriK9Pi1E8WFjCgMw1KtrcqoCnshX9BwIE3UFY4ZMl4pZCkZ12Ckm5Hgk7DyajlvjuhVeKGe4m6ry0QyaRgtMxhRSw5MtrcXtyR1e+k5d1PsOZgipxyM6c9/DJrDTnz/S+N9xUutZl3d4NFl1YfiAGuMfO34fOsemW6HuZ1sNFNjYLSKRjPcMC9eLVTexO2ilwis9JfH10dSsLpbXw6jh9XnVJLnlGaT/xGR49tC4o+ZHkNEZ010AgHn+RbeJdwyaQzPhrP8977C8Z/1sgKbqTkzF80Zi5ztAPFIM6Q8uUJEokcSq72a7TgLozNqjCTKkNxB8+0rNiDJkuBxWFVtN9HwfxNQpBE9F2WUQrUmaU0+Z7tuDXhtfnMxMtXw0fHIG3d5oQ/spVGxq9rpsoh6E9CDvZ8A5VEIghAdtKrOmud78Z6+MZDKeMigbZH7S7D927lvI66XK3K2ypvmHUWwnlbXQEZJuAoNFOrY8Hgo91DcMSW0UCJx24Wqxr2q2fpZ+z0IJ9o+q9j0ZS3S0nfP207y/iI/QT83zwqMCQ6CNcomnJ0PX2Az3kbbD/yg5PF+Kgry5Vdxl5fvyhmROdOB3V+aBSY3cmJCAhEwWkCafdkL/z0L2UIE0lY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(3023799007)(56012099006)(11063799006)(261022075727099003)(261021123027099003)(10067099003)(261009221227099003)(261009223027099003)(261021121427099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0H6GbSTLFCcIDnoVALKfPZ8A8mpaiUOUF/1wdBpT887pglJopyyniq2TGC0K?=
 =?us-ascii?Q?8wPZPSxLaIOFWTn1iPYKYxNAUQANPc+iOTpIgYS/DKFBCiToZwquMDtRW3+w?=
 =?us-ascii?Q?kyJefKyhU28vwz1yta6gYRWItcyGCbS+ZlWEX/W6RZjeXtQNXwCH+M+Qsl4j?=
 =?us-ascii?Q?dpdZPxYhxwon4fQnU5hJ6G2XS7Cf1zwNAh55Kv3KSaUW7s3IcxkFnoMP/8PG?=
 =?us-ascii?Q?ToSLLSY24TdkOgSJBbMDFyYhQiiRgUq4EN6v1didIKwOiFsQ7+BS4q7m3Kdf?=
 =?us-ascii?Q?cc5mz9ufjnn3zdknj/PJIMYJYHQctudX+U9/HzwiEVJDLFhj5acT8g9gqz0J?=
 =?us-ascii?Q?Z6MnW3UnR66H0cssl4QfJ9j96ZcfyDZ5AkigDgDL0o4oeaa8aBN2pEsj9ink?=
 =?us-ascii?Q?edvd70zsEOk+XYJA5n0zs45a86VKc7+0l8lMLu4hBjvheaJsb6/RDKyHAfg6?=
 =?us-ascii?Q?Hl6avn8qk9YT6oHvmzY3egi4emjDZPDvC5b7OVM319R8y83wXtqcXaJ33o3O?=
 =?us-ascii?Q?wKlYi1V9g9Ec7tL5YHOr1f0izmOKZClHqTb93VOxZOrZi+6MWpNpsc9L3oaz?=
 =?us-ascii?Q?jO8/bcJTkwF30To7JkYlduWGxzFIdTssjOMSFQxrHLLqyhZFybc/SS1njDd8?=
 =?us-ascii?Q?wTCgKHWh/nz1E/CQHGPLwH/vhgSvChk9Ad0gh8JsdcEJpE3jRalpVp5cPP9k?=
 =?us-ascii?Q?+JriCqsIPvmJsZKr0EKsCEWJgL0mZ8E2DuqDrwskqsRo+URxnCzOml93Ghr9?=
 =?us-ascii?Q?nMdIY0eOo2DgqySjXJQ8ynP2Rvcuz6l5ExFVAbbt0CcbUKWw1c4zmU0Aga/Z?=
 =?us-ascii?Q?G7NfvjdwlbdFQLWpbT5iLMUyfiigKfQ5109G4fciStUqr5VfblhRyuTCYLbM?=
 =?us-ascii?Q?qBxKpXj5HaCMh6fKenKR8YyfYLCUccOMt6drI5JudA+nrQc++xCztu1m7nt7?=
 =?us-ascii?Q?E2m4TQzaEJ/CsCnQC2bi+W0WFDaQcXGVT9jQbBWvAdh6X3+mfwKauImxkzYC?=
 =?us-ascii?Q?p1IRxL4Bi8Z0brUsJ8njdJX5plvJR7AveJafGzldNHa14DmvaQ/snuypybSF?=
 =?us-ascii?Q?9qFb6/iLXK2ePEkhYOHEd7UT0oYTRmzmRkgywqGBam9tsbYXTwiRaLyBZSzD?=
 =?us-ascii?Q?9FF5oKnxij9WdPCLEqMP/gH89IMY30tzU4EM74lkMeUBk9yF/zRdMADywLRR?=
 =?us-ascii?Q?8cXJS1sPpE+CO9uiZ4ySPWNywnia7+HgGiSLxbfY5SxCWJulrquNCzQHkmMH?=
 =?us-ascii?Q?6GIPwELGcUoH50M+tvBz45OJmAhR5u7nOd/h6MKPLva3+ePEQ24glRSVayXa?=
 =?us-ascii?Q?SKaoTROZfDR5ySNfHuAQ/P0RJy4lpYECpu7QQncUJgX1IS+EBe/OVUTEv9C+?=
 =?us-ascii?Q?BhmEKaAMkw9ijYo36F8vtxJJaTV9xL/F00YXAsEzBnysqk1GdDNJ43v+Nqy4?=
 =?us-ascii?Q?v6BBAqDK2m9Ult2qNzTHPUqt9/eNswZKVHZu3HqmKREDMkISe5cXSUHuVvvU?=
 =?us-ascii?Q?QY6MyMzUfpRRgy+SSFpqRCVTuKuJE0BTKDzeA8nrs8JdCqg9F8q3Qb6FlIoS?=
 =?us-ascii?Q?HbOUWQwTXHmnRSF74dS/xYJkoo4/R7o+WZ8sbZdN4C+oSevdK+OmA+vxdDds?=
 =?us-ascii?Q?FbUGhdf6QIPVQ9fXDuqZLIvJXmULSOiW+X5Fulv1R9FN9KSqmiK8kLPQ+Klp?=
 =?us-ascii?Q?Ctj8I8KVF6pa9Ivn+ipIDIiytzz1HG8N540L4qdfxDDQ8YW3QXF8VoTXGV2j?=
 =?us-ascii?Q?b6dh9r2amg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29047b8f-6137-4721-de2f-08df332343c2
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 05:37:46.4367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oDECtDpwD6R5IgXihmu0B3idluPazS8xYOnC/vm+wVW7EJl/VV5vBC2gnFbl/nmpEEwps+xOU3l3azmQrdoSVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7442

From: Jason Gunthorpe <jgg@nvidia.com>

Similar to xe, amdgpu wants to check pci_p2pdma_distance(), and
only needs that if peer2peer can be supported by the GPU. It can migrate to
system memory and support non-p2p DMA as well.

Further it supports a private non-PCI XGMI path. For now hack this on top
of a SGT type, but eventually this is likely better off as its own mapping
type.

Add two exporter SGT mapping types, one that matches P2P and one that
matches all of the non-p2p. The pin and map code will force migrate if
the non-p2p one is matched.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
[ the match set is recorded in attach->matches and the type
  selected from it at pin or map, so the pin walk, detach and the attach
  error path ask dma_buf_attach_accepts_sgt_p2p() whether an attachment
  could take P2P at all, and the XGMI override rewrites the recorded match
  set entry rather than only attach->map_type. The map path keeps using
  dma_buf_sgt_p2p_allowed() for the attachment being mapped, which has just
  been selected. The runtime PM reference follows the same question: held
  while P2P is in the match set, dropped in detach. - apopple ]
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 137 +++++++++++++-------
 1 file changed, 92 insertions(+), 45 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
index 9adf3eed8822..19ee9f85ff30 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -41,6 +41,7 @@
 #include <drm/amdgpu_drm.h>
 #include <drm/ttm/ttm_tt.h>
 #include <linux/dma-buf.h>
+#include <linux/dma-buf-mapping.h>
 #include <linux/dma-fence-array.h>
 #include <linux/pci-p2pdma.h>
 #include <linux/pm_runtime.h>
@@ -79,43 +80,11 @@ static struct amdgpu_device *dma_buf_attach_adev(struct dma_buf_attachment *atta
 static int amdgpu_dma_buf_attach(struct dma_buf *dmabuf,
 				 struct dma_buf_attachment *attach)
 {
-	struct amdgpu_device *attach_adev = dma_buf_attach_adev(attach);
 	struct drm_gem_object *obj = dmabuf->priv;
 	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
 	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
 	int r;
 
-	/*
-	 * Disable peer-to-peer access for DCC-enabled VRAM surfaces on GFX12+.
-	 * Such buffers cannot be safely accessed over P2P due to device-local
-	 * compression metadata. Fallback to system-memory path instead.
-	 * Device supports GFX12 (GC 12.x or newer)
-	 * BO was created with the AMDGPU_GEM_CREATE_GFX12_DCC flag
-	 *
-	 */
-	if (amdgpu_ip_version(adev, GC_HWIP, 0) >= IP_VERSION(12, 0, 0) &&
-	    bo->flags & AMDGPU_GEM_CREATE_GFX12_DCC)
-		attach->peer2peer = false;
-
-	if (!amdgpu_dmabuf_is_xgmi_accessible(attach_adev, bo) &&
-	    pci_p2pdma_distance(adev->pdev, attach->dev, false) < 0)
-		attach->peer2peer = false;
-
-	/*
-	 * Only allow P2P while the exporter is active, and keep it active
-	 * until detach.  With runtime PM disabled take a plain reference so
-	 * the put in detach stays balanced.
-	 */
-	if (attach->peer2peer) {
-		struct device *dev = adev_to_drm(adev)->dev;
-		int ret = pm_runtime_get_if_active(dev);
-
-		if (!ret)
-			attach->peer2peer = false;
-		else if (ret < 0)
-			pm_runtime_get_noresume(dev);
-	}
-
 	r = dma_resv_lock(bo->tbo.base.resv, NULL);
 	if (r)
 		goto err_pm_put;
@@ -127,7 +96,8 @@ static int amdgpu_dma_buf_attach(struct dma_buf *dmabuf,
 	return 0;
 
 err_pm_put:
-	if (attach->peer2peer)
+	/* Drop the reference taken in amdgpu_dma_buf_match_mapping() */
+	if (dma_buf_attach_accepts_sgt_p2p(attach))
 		pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);
 	return r;
 }
@@ -138,7 +108,7 @@ static int amdgpu_dma_buf_attach(struct dma_buf *dmabuf,
  * @dmabuf: DMA-buf where we remove the attachment from
  * @attach: the attachment to remove
  *
- * Drop the runtime PM reference taken in amdgpu_dma_buf_attach().
+ * Drop the runtime PM reference taken in amdgpu_dma_buf_match_mapping().
  */
 static void amdgpu_dma_buf_detach(struct dma_buf *dmabuf,
 				  struct dma_buf_attachment *attach)
@@ -147,7 +117,7 @@ static void amdgpu_dma_buf_detach(struct dma_buf *dmabuf,
 	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
 	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
 
-	if (attach->peer2peer)
+	if (dma_buf_attach_accepts_sgt_p2p(attach))
 		pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);
 }
 
@@ -175,7 +145,7 @@ static int amdgpu_dma_buf_pin(struct dma_buf_attachment *attach)
 	 * notiers are enabled.
 	 */
 	list_for_each_entry(attach, &dmabuf->attachments, node)
-		if (!attach->peer2peer)
+		if (!dma_buf_attach_accepts_sgt_p2p(attach))
 			domains &= ~AMDGPU_GEM_DOMAIN_VRAM;
 
 	if (domains & AMDGPU_GEM_DOMAIN_VRAM)
@@ -218,6 +188,7 @@ static void amdgpu_dma_buf_unpin(struct dma_buf_attachment *attach)
 static struct sg_table *amdgpu_dma_buf_map(struct dma_buf_attachment *attach,
 					   enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
 	struct dma_buf *dma_buf = attach->dmabuf;
 	struct drm_gem_object *obj = dma_buf->priv;
 	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
@@ -231,7 +202,7 @@ static struct sg_table *amdgpu_dma_buf_map(struct dma_buf_attachment *attach,
 		unsigned int domains = AMDGPU_GEM_DOMAIN_GTT;
 
 		if (bo->preferred_domains & AMDGPU_GEM_DOMAIN_VRAM &&
-		    attach->peer2peer) {
+		    dma_buf_sgt_p2p_allowed(attach)) {
 			bo->flags |= AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED;
 			domains |= AMDGPU_GEM_DOMAIN_VRAM;
 		}
@@ -249,7 +220,7 @@ static struct sg_table *amdgpu_dma_buf_map(struct dma_buf_attachment *attach,
 		if (IS_ERR(sgt))
 			return sgt;
 
-		if (dma_map_sgtable(attach->dev, sgt, dir,
+		if (dma_map_sgtable(dma_dev, sgt, dir,
 				    DMA_ATTR_SKIP_CPU_SYNC))
 			goto error_free;
 		break;
@@ -261,7 +232,7 @@ static struct sg_table *amdgpu_dma_buf_map(struct dma_buf_attachment *attach,
 			return ERR_PTR(-EINVAL);
 
 		r = amdgpu_vram_mgr_alloc_sgt(adev, bo->tbo.resource, 0,
-					      bo->tbo.base.size, attach->dev,
+					      bo->tbo.base.size, dma_dev,
 					      dir, &sgt);
 		if (r)
 			return ERR_PTR(r);
@@ -269,7 +240,7 @@ static struct sg_table *amdgpu_dma_buf_map(struct dma_buf_attachment *attach,
 
 	case AMDGPU_PL_MMIO_REMAP:
 		r = amdgpu_ttm_mmio_remap_alloc_sgt(adev, bo->tbo.resource,
-						    attach->dev, dir, &sgt);
+						    dma_dev, dir, &sgt);
 		if (r)
 			return ERR_PTR(r);
 		break;
@@ -299,21 +270,22 @@ static void amdgpu_dma_buf_unmap(struct dma_buf_attachment *attach,
 				 struct sg_table *sgt,
 				 enum dma_data_direction dir)
 {
+	struct device *dma_dev = dma_buf_sgt_dma_device(attach);
 	struct drm_gem_object *obj = attach->dmabuf->priv;
 	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
 
 	if (bo->tbo.resource &&
 	    bo->tbo.resource->mem_type == AMDGPU_PL_MMIO_REMAP) {
-		amdgpu_ttm_mmio_remap_free_sgt(attach->dev, dir, sgt);
+		amdgpu_ttm_mmio_remap_free_sgt(dma_dev, dir, sgt);
 		return;
 	}
 
 	if (sg_page(sgt->sgl)) {
-		dma_unmap_sgtable(attach->dev, sgt, dir, 0);
+		dma_unmap_sgtable(dma_dev, sgt, dir, 0);
 		sg_free_table(sgt);
 		kfree(sgt);
 	} else {
-		amdgpu_vram_mgr_free_sgt(attach->dev, dir, sgt);
+		amdgpu_vram_mgr_free_sgt(dma_dev, dir, sgt);
 	}
 }
 
@@ -388,18 +360,93 @@ static void amdgpu_dma_buf_vunmap(struct dma_buf *dma_buf, struct iosys_map *map
 	amdgpu_bo_unpin(bo);
 }
 
+static const struct dma_buf_mapping_sgt_exp_ops amdgpu_dma_buf_sgt_ops = {
+	.map_dma_buf = amdgpu_dma_buf_map,
+	.unmap_dma_buf = amdgpu_dma_buf_unmap,
+};
+
+static int amdgpu_dma_buf_match_mapping(struct dma_buf_match_args *args)
+{
+	struct dma_buf_attachment *attach = args->attach;
+	struct drm_gem_object *obj = args->dmabuf->priv;
+	struct amdgpu_bo *bo = gem_to_amdgpu_bo(obj);
+	struct amdgpu_device *adev = amdgpu_ttm_adev(bo->tbo.bdev);
+	struct device *dev = adev_to_drm(adev)->dev;
+	struct dma_buf_mapping_match sgt_match[2];
+	unsigned int num_match = 0;
+	bool peer2peer = true;
+	int ret;
+
+	/*
+	 * Disable peer-to-peer access for DCC-enabled VRAM surfaces on GFX12+.
+	 * Such buffers cannot be safely accessed over P2P due to device-local
+	 * compression metadata. Fallback to system-memory path instead.
+	 * Device supports GFX12 (GC 12.x or newer)
+	 * BO was created with the AMDGPU_GEM_CREATE_GFX12_DCC flag
+	 *
+	 */
+	if (amdgpu_ip_version(adev, GC_HWIP, 0) >= IP_VERSION(12, 0, 0) &&
+	    bo->flags & AMDGPU_GEM_CREATE_GFX12_DCC)
+		peer2peer = false;
+
+	/*
+	 * Only allow P2P while the exporter is active, and keep it active
+	 * until detach.  With runtime PM disabled take a plain reference so
+	 * the put in detach stays balanced.
+	 */
+	if (peer2peer) {
+		ret = pm_runtime_get_if_active(dev);
+		if (!ret)
+			peer2peer = false;
+		else if (ret < 0)
+			pm_runtime_get_noresume(dev);
+	}
+
+	if (peer2peer)
+		sgt_match[num_match++] = DMA_BUF_EMAPPING_SGT_P2P(
+			&amdgpu_dma_buf_sgt_ops, adev->pdev);
+	sgt_match[num_match++] = DMA_BUF_EMAPPING_SGT(&amdgpu_dma_buf_sgt_ops);
+
+	ret = dma_buf_match_mapping(args, sgt_match, num_match);
+	if (ret)
+		goto err_pm_put;
+
+	/*
+	 * If the transfer will use XGMI then force a P2P match: the importer
+	 * reaches VRAM over XGMI, so the BO may stay there even though PCIe
+	 * P2P did not match. Rewrite the recorded match set entry rather than
+	 * only attach->map_type, which is what dma_buf_mapping_select() will
+	 * copy from at pin or map time.
+	 */
+	if (peer2peer && !dma_buf_attach_accepts_sgt_p2p(attach) &&
+	    amdgpu_dmabuf_is_xgmi_accessible(dma_buf_attach_adev(attach), bo)) {
+		attach->matches[0].sgt_data.exporter_requires_p2p =
+			DMA_SGT_EXPORTER_REQUIRES_P2P_DISTANCE;
+		attach->map_type = attach->matches[0];
+	}
+
+	/* The PM reference is only needed while P2P is actually possible. */
+	if (peer2peer && !dma_buf_attach_accepts_sgt_p2p(attach))
+		pm_runtime_put_autosuspend(dev);
+	return 0;
+
+err_pm_put:
+	if (peer2peer)
+		pm_runtime_put_autosuspend(dev);
+	return ret;
+}
+
 const struct dma_buf_ops amdgpu_dmabuf_ops = {
 	.attach = amdgpu_dma_buf_attach,
 	.detach = amdgpu_dma_buf_detach,
 	.pin = amdgpu_dma_buf_pin,
 	.unpin = amdgpu_dma_buf_unpin,
-	.map_dma_buf = amdgpu_dma_buf_map,
-	.unmap_dma_buf = amdgpu_dma_buf_unmap,
 	.release = drm_gem_dmabuf_release,
 	.begin_cpu_access = amdgpu_dma_buf_begin_cpu_access,
 	.mmap = drm_gem_dmabuf_mmap,
 	.vmap = amdgpu_dma_buf_vmap,
 	.vunmap = amdgpu_dma_buf_vunmap,
+	.match_mapping = amdgpu_dma_buf_match_mapping,
 };
 
 /**
-- 
2.54.0

