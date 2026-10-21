Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.8
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792569059;
	b=Iw0DLZsVvAFcs349CxTWYWKPrwgjK4LIzRr/ITpKajjCj22iaewRDZMo2d1xTDoxN6ub
	 WhVieb01EVH/E/EqsiFsjTEznS6PTSQgIDin7xIlVGwtChl/3eXtARHSew6e9cPDEqmt/
	 G+1Q0/jpF7q4zh3MCfms9ohEgoiTUGpce+dI9HeLhR8C2dzIEiduFZ40xmy7sQSxoyQ3R
	 WmnjBWBNla8uRdv7/o4qW54+GFDz1nyHZg5J8Q8nn5JKb2Q3U76x58GIb0ge5GBjK9xDs
	 9jWAYAbIbX42zQlGENvvfzKXaoDZhQbijtbH20tVtuM1RF2weDrS2M4RbBLTvfqqT/A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792569059;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-NV-OnPremToCloud:X-EOPAttributedMessage:
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
	bh=ZxxgLyjapCM37CghNO3/VaU0BevjMAqeu5Wa0KVRrfU=;
	b=FpedMz5CQtCMY6GYv14KvPTzjaDNDuELT5jVtrqZMJbuojnsdHYsvkmhmtkrtYP0/KSS
	 s4K5Ey4fuo3+oil1WJoAlOOcV+3JhYBxf067CL77I0yWWVhcg/HxXBfWWzaNZOXOQeW5H
	 brur8qlCXiz2wcBZVwuWj0h1X8NIp6FjQ2cuMijdkQOsVdhMrRC1tzVracEH6meC4Cegp
	 xxG7eIFmaGKbp5IojWtfp7R3Jkjz4w7+T6Carr61oqkkC8CIn3A8FxKkmQPrlXWpEL15p
	 C0NK2xbgeCoz3GIP+nMy94JEhF+fS962ZdINeJ05zDqM1RNHuTd9ptqoVd55I3hcPUQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BSC+qn3T;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.8
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012008.outbound.protection.outlook.com [52.101.43.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA1B1606A31C;
	Wed, 21 Oct 2026 07:50:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA1B1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BSC+qn3T
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HK6+HbX1qHqy1oMSOBFmkKHx6lM7N049V9494sbzp3p2Yn7BulW3b2teDPkPbU5bslisbuL3NrFP9qbjZ9jdGjRmI76tHlRGAh2N5GNf/6WrM2CUZfU+d09npNo+UuFtOtSYiA2BakoXoSlDBuRku5xq0fFaZv1cZ9LxtUKHyhVTg2WCfE7rNv4JGKgkn04k8HmBuEU2ctP5fXjY83WMNfPSvdGpu21OMoP7wQ0eV1xmgv/Q9VA/h0iKPH5llX/Tlua3mxeSysGliqiO9GpmaIgLOC0LybYFJMKqAh00PiaKhRthGcONvIYG3DYv6oYTlwmCxIV3o7Vc0+dYM8Vogw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZxxgLyjapCM37CghNO3/VaU0BevjMAqeu5Wa0KVRrfU=;
 b=K35xUxj0LAGjKC8tCL6t8x7PkL6I1V7di+OHMJfo/SLCn2EY+GFdpj6XyBz2aYdgEpo8BzkHcV5AHew+qtIUJVMXsHgfUvhtrQRz4dxh1TzgJkkJGYBcC6HET7tXIgm0yJSktNRHkL+yOc8YseC3yaG0fhPfTcfVGnjTYtfDQ/EOjpEIO1pcp63R7luEawTY2KqOcpMpT8+HfG4tjREWgm/+29Jnas6APOouB/3KBkTTZyY+RgX5gaeNihFnzPoFBJ5FQnhxWZS3UMs8/R73GLzbsHfN3qkl6qm/A1FKxJTHF6kn4VOuSp41mcxegstm0YKwZ54+GrT8WQ5u/IjLJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lunn.ch smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZxxgLyjapCM37CghNO3/VaU0BevjMAqeu5Wa0KVRrfU=;
 b=BSC+qn3TyqZSfKr7/yktClz4q2vR5bIE46ra+sX54izNuNh8+pDuCa5okWTRKoZg68TVNyXWRzIAJcpYr3iYCFpuZ50mCI8V8p80Wqjo/NQoPl4OXAMaj6BNEO4TcI2Bt4bWLFtBuoMjtYsN4nEuylNO3RhU0LO+RHYq8+k99EgVITVyh75vD26t0b9EBzHornl+59eBiP3pJjqGVNrjxLmzSU0tsxJu7y0COKo4wK6BnXnonh2mqIfIuTwgUXdWUJvOzR9TF2UKkXUjyQ0QjHtlf7dGpHyYmnbIzKEldfaVZ0j1g2LdGnNAl1NHh2ycgU7ZEcSOQzPLqoYRIo9PnA==
Received: from SJ0PR05CA0129.namprd05.prod.outlook.com (2603:10b6:a03:33d::14)
 by CY5PR12MB6155.namprd12.prod.outlook.com (2603:10b6:930:25::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Wed, 21 Oct
 2026 07:50:55 +0000
Received: from PH7PEPF0000000A.namprd04.prod.outlook.com
 (2603:10b6:a03:33d:cafe::78) by SJ0PR05CA0129.outlook.office365.com
 (2603:10b6:a03:33d::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.14 via Frontend Transport; Wed,
 21 Oct 2026 07:50:54 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.161) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 PH7PEPF0000000A.mail.protection.outlook.com (10.167.243.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 07:50:54 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 21 Oct
 2026 00:50:31 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 21 Oct
 2026 00:50:30 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.49 via Frontend Transport; Wed, 21
 Oct 2026 00:50:25 -0700
From: Tariq Toukan <tariqt@nvidia.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: Alexandre Cassen <acassen@corp.free.fr>, Alex Vesker <valex@nvidia.com>,
	Erez Shitrit <erezsh@nvidia.com>, Gal Pressman <gal@nvidia.com>, "Itamar
 Gozlan" <igozlan@nvidia.com>, Kees Cook <kees@kernel.org>, Kees Cook
	<kees+treewide@kernel.org>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Mark Bloch
	<mbloch@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>, Prathamesh Deshpande
	<prathameshdeshpande7@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>, "Tariq
 Toukan" <tariqt@nvidia.com>, William Theesfeld <william@theesfeld.net>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: [PATCH net 3/3] net/mlx5: DR, Fix out-of-bounds write when sync to HW fails
Date: Wed, 21 Oct 2026 10:49:49 +0300
Message-ID: <20261021074949.3471704-4-tariqt@nvidia.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261021074949.3471704-1-tariqt@nvidia.com>
References: <20261021074949.3471704-1-tariqt@nvidia.com>
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
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PEPF0000000A:EE_|CY5PR12MB6155:EE_
X-MS-Office365-Filtering-Correlation-Id: ed279e7a-8399-460f-dbf1-08df2f4808e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|82310400026|1800799024|7416014|6133799003|22082099003|18002099003|11063799006|10067099003|261009221727099003|261009220027099003|261009221227099003|261009223027099003|261009223327099003|56012099006|41080700001;
X-Microsoft-Antispam-Message-Info:
	NYtxoaXqTo3v3wRu2prYvDqRIF5vIl8vukywob8HtDgTHB/xnzpiCFqLqephUHevX9OqKAQME2aUBOC+qnd13tE0iN2RXxNZ2e49fZ6g+fhi+LkNeaDlA8D/KiG99v/bYiahw9aT1QdSopR3Vf26wIdEClEAmp7gwCf3/X5PVhgyOziAAI+B+HCMcKSDNs2lTdotk8EDD8337h1TiH62rbMbkFiFKy5AzcGUUB1g9foNUxXEgJ4wf4i2uT1C0mB6YCS1CeXfLqG1TchQs32R763CXmcloZ77NLv1MY0kN5eXQWek8b+pt48rRv4FWe5nTFz+ijQwBEjjEhnYGfpZ2Q2+SNuA25ZOLR5rvJ1aGRFn5fKImsgpB8okBqgY6yZF51DrEXL8JxG8LErsEIQv2hBp2TnCwE5m8nKpQ3Rsi6+JUpAIV8kkStFeF6DpTG+8By5Oj/wsYyfndsTmxQZDmhzaAfqGxAN6ldpJhnArYcdB+EOlreHkdvnMB7HF86ByRbmx51fBrA8p3DdP2uBDHvn3WJsuprzpiEhuvnr3XR9PnK15PKo5wDy/X4Nmf5p1rPO4GdrvJMcw9GLPR6gHZgigD0nirY+2PQJr11lJvsSQjtqCF/jqtj17f9Jfe/YJ0C4pda5Lv8BENr7hgfEhggW08V5Vcluvo6JuLbSe9NX/nIJq680tSE0hNHC40B3DX6WD27lEBymus8VZsw0aw/iB4yvTOSl7zymuX71fkk+9FcP1bcBMFsPQBEvc4b9mesO4gxajcjGT9qsNUKvlRw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(82310400026)(1800799024)(7416014)(6133799003)(22082099003)(18002099003)(11063799006)(10067099003)(261009221727099003)(261009220027099003)(261009221227099003)(261009223027099003)(261009223327099003)(56012099006)(41080700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	SY0agwQhxzRmZnN8ppMPGXT6H/zr4rMi5W/S/IT//qzGr42i/AO5MALFq4cPI8vAlXUf4npSc5ihdSJFQg70dfZHjRhAVjS2ARg7Ymlu9GZmnqnVDBbHHZE7rEpWK98ZUr5y7s/HnQUIoNli2nWQiNQvT97EjdW86NGKan9C5ZSnifW4ZoRTLJq7E3IGBVqjxtRfS8ntCr+98NMLWTPc/Vvsp3IGLtTSZAyXjvucz7CxgUJETlFz51FRghm4xsZFbpUu5enMkUYIFKUfqrJUDiWsn1G4Vb5hCZ2Wnynsuq9HrJrdHMGeWJxCQFzYimsXBfq7Nf2OHMF7sqVw8dkr9RBH1jF3DqM8hbcNCoj0fuZD5lgCoBzTY2xF6rQXgckNp1xYV3pd3+LRdx56Y5/fewm2R++VR6lTu3GJky7gtJKM6+TvaPluANusbdotg8US
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 07:50:54.1590
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed279e7a-8399-460f-dbf1-08df2f4808e0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH7PEPF0000000A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6155

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

mlx5dr_icm_free_chunk() moves a freed chunk to the "hot" chunks array by
writing it to hot_chunks_arr and, once the accumulated hot memory
crosses a threshold, triggers a sync to HW that flushes the array.  The
array is large enough to hold the chunks of a single accumulation cycle,
and relies on the sync path to flush it.

However, if sync to HW fails, hot chunks array is not cleared, and every
subsequent mlx5dr_icm_free_chunk will write past the end of
hot_chunks_arr, resulting in an out-of-bounds write and kernel heap
corruption.

A failed sync to HW also means it is no longer safe to recycle ICM: a
chunk's memory may only be returned to the buddy allocator (and thus be
reused) after a sync has confirmed that HW no longer references it.

Fix both problems by putting the pool into an error state when a sync to
HW fails - mlx5dr_icm_free_chunk() stops queuing freed chunks, so it
never writes past hot_chunks_arr. The chunk's ICM memory is not returned
to the buddy allocator (HW may still reference it); the segment is left
reserved and is reclaimed when the pool is destroyed.

Fixes: 4519fc45beeb ("net/mlx5: DR, Keep track of hot ICM chunks in an array instead of list")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 .../mlx5/core/steering/sws/dr_icm_pool.c      | 23 +++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c
index 1b928b40686e..375ab8c2043f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/sws/dr_icm_pool.c
@@ -33,6 +33,10 @@ struct mlx5dr_icm_pool {
 	u64 hot_memory_size;
 	/* hot memory size threshold for triggering sync */
 	u64 th;
+	/* Set when a sync to HW fails - no new chunks are served,
+	 * and freed chunks are no longer queued.
+	 */
+	bool sync_failed;
 };
 
 struct mlx5dr_icm_dm {
@@ -369,6 +373,12 @@ static int dr_icm_pool_sync_all_buddy_pools(struct mlx5dr_icm_pool *pool)
 	err = mlx5dr_cmd_sync_steering(pool->dmn->mdev);
 	if (err) {
 		mlx5dr_err(pool->dmn, "Failed to sync to HW (err: %d)\n", err);
+		/* The hot chunks could not be flushed. Put the pool in an error
+		 * state so that no further chunks are queued (which would
+		 * overflow hot_chunks_arr) or served (which could reuse ICM
+		 * that HW may still reference).
+		 */
+		pool->sync_failed = true;
 		return err;
 	}
 
@@ -475,6 +485,14 @@ void mlx5dr_icm_free_chunk(struct mlx5dr_icm_chunk *chunk)
 	/* move the chunk to the waiting chunks array, AKA "hot" memory */
 	mutex_lock(&pool->mutex);
 
+	/* If a previous sync to HW failed, the pool is in an error state.
+	 * The chunk must not be queued. ICM memory is not returned to the
+	 * buddy allocator - it is reclaimed only when the pool is destroyed.
+	 * Just free the chunk's bookkeeping struct.
+	 */
+	if (pool->sync_failed)
+		goto out;
+
 	pool->hot_memory_size += mlx5dr_icm_pool_get_chunk_byte_size(chunk);
 
 	hot_chunk = &pool->hot_chunks_arr[pool->hot_chunks_num++];
@@ -482,12 +500,13 @@ void mlx5dr_icm_free_chunk(struct mlx5dr_icm_chunk *chunk)
 	hot_chunk->seg = chunk->seg;
 	hot_chunk->size = chunk->size;
 
-	kmem_cache_free(chunks_cache, chunk);
-
 	/* Check if we have chunks that are waiting for sync-ste */
 	if (dr_icm_pool_is_sync_required(pool))
 		dr_icm_pool_sync_all_buddy_pools(pool);
 
+out:
+	kmem_cache_free(chunks_cache, chunk);
+
 	mutex_unlock(&pool->mutex);
 }
 
-- 
2.44.0

