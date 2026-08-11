Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012013.outbound.protection.outlook.com [52.101.53.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1ED3803C3;
	Tue, 11 Aug 2026 16:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786465214; cv=fail; b=GF+gWtf4vt7EJ5zwvZqfLzBoq4rzvaMtYckk1hDx05CY6AM22JmlI+FudM+byhBW9dJzJmbIrBmM9Zc6dCCGO1J9o88lUJkPFDkFJ25/CdWq8kc/sn25P8oSGgYiQ7A3FIo4fjsBMhdjrqkxnrJhzG8otn1RojVCmJYrTH/x/bQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786465214; c=relaxed/simple;
	bh=yWZft8LpYcnAjJyCJyM5cBtXTF6ByHqWCyN5dz/nK8Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=rg2rsXvnGcKA0LZrNvXhOp6coof8AN4kfXbp8rGleBWDwZd1z2cPsu2cI26/vtew5iqoTV3nz9e+aM54rbVqJriHDIP7POl/QzzLHVdxybpZ+sKaoFpVbVJjzZ7NQvp3ioQNPMka1hB1xjWWyyP524Wz7pUUF22wG1NRoH3SSpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EEyX7dBq; arc=fail smtp.client-ip=52.101.53.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EEyX7dBq"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lX1cnF4W/dVtToktAA79wAUZLJsxtoaFRdkoNc3kqAhanaI4dYgqfTZSw118cadCSJCmaP0StvHcewFS4uzfw3mzrlXr2fkNWstezhOBq2xCI5+VcUydBHnqe0BzoPdjyAH1eNc71Z+nyz+bxj+FfGcMllE3Z0o2ptfiLT5PIbeAScPN2aaDJOB8UVhRQZl/uYoJeydjpeKloDw1h2NUPGkV+z622LPe1DdXv0xng8JyhXVfTdktm+vA+3wb+Uljy4Ih7lyTRIhbxgywli5yrsIz6fbUr6xxMsKHMYReGrfVVp9IhyvFJRmzSIr8IVNbd3231duS//P0ahYltx+X1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9a2kDf4ZZZIMLAy6B8mOdaEJudAYK9P4RwZRrjsPfC8=;
 b=LRoFr9OPxxxGgXtmwOXmKkNRCL0Zc09hfVIpQxzpyax+7wNh+SFQcPoLmxC4vkPr4KurbcnjyDl7hMD5c7VW9F/YITCNZFp5FOVKUQCuHlFVTNofgEHrGP6dJ1dNgcdXBZeNUvQ5SlDQkSrHFJPLwHTo14khMWNe9M7VqTh91FmvH0dGu4t7lp/l9b9kStGAsHhtXUODIas+HnSCDzxpOA4cVXTcLeee2kHiWr1H19xjfYs4ZJu5QZ4gtISVGak1Qpv/JZ15ujTebfjcb1mVfUDdAOgvbwpII7NYda4YhKqJzsi8D/QLZV9sLFFgW5t0PYkM2H6hrBacTaDuPIrV6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9a2kDf4ZZZIMLAy6B8mOdaEJudAYK9P4RwZRrjsPfC8=;
 b=EEyX7dBq3ZQ76WfDdN13VmPkw3bFQ2Wp5LUaOd7hXTSp9BH/RXytyWFHwLk0ar1HNWD4N1kFxdOFx5n/yF6CG3MN2GgaISeSV7K02V8d0Ew3JS3jhFn8kNG8954fk9ElsWetv/JZYSipt03aOWFkqFfh/XA1AEMFukh8+rNaLspvdWY+Fouepr9igqW0DJcA9fCliB6TqlYMKXeAEdYAezjnPAls83Vlgc3jbs+AJCshNpkoQj18w6gGr3lDJo/sckcLt//xKGopCQQKNzbNYSykT1NPaVOmy4CqRB3w6zzrIBNuR4OrQHJLxh/aT52TI/4G3sbbMDX7wliT1rEsfQ==
Received: from SJ0PR05CA0040.namprd05.prod.outlook.com (2603:10b6:a03:33f::15)
 by CH1PPF4CBE7339A.namprd12.prod.outlook.com (2603:10b6:61f:fc00::60e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.11; Tue, 11 Aug
 2026 16:19:57 +0000
Received: from CO1PEPF000075F4.namprd03.prod.outlook.com
 (2603:10b6:a03:33f:cafe::79) by SJ0PR05CA0040.outlook.office365.com
 (2603:10b6:a03:33f::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.12 via Frontend Transport; Tue,
 11 Aug 2026 16:19:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1PEPF000075F4.mail.protection.outlook.com (10.167.249.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Tue, 11 Aug 2026 16:19:52 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 11 Aug
 2026 09:19:24 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 11 Aug
 2026 09:19:24 -0700
Received: from [10.135.59.1] (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Tue, 11
 Aug 2026 09:19:21 -0700
From: Edward Srouji <edwards@nvidia.com>
Date: Tue, 11 Aug 2026 19:19:16 +0300
Subject: [PATCH rdma-next] RDMA/uverbs: Fix mmap_lock/disassociation_lock
 circular dependency
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-ID: <20260811-fix-mmap-lockdep-v1-1-1151b41063b4@nvidia.com>
X-B4-Tracking: v=1; b=H4sIAINLe2oC/x2MWwqAIBAArxL73UIm9LpK9LHoVktpohFBdPekz
 4GZeSBxFE4wFA9EviTJ4TOosgCzkl8YxWaGuqqbqlMKZ7nROQq4H2azHLBXlrqe9KxbAzkLkbP
 zL0eI1hF6vk+Y3vcDI1VLZW0AAAA=
X-Change-ID: 20260811-fix-mmap-lockdep-91da89a3f37c
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	"Junxian Huang" <huangjunxian6@hisilicon.com>, Chengchang Tang
	<tangchengchang@huawei.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Or Har-Toov
	<ohartoov@nvidia.com>, Edward Srouji <edwards@nvidia.com>, Leon Romanovsky
	<leon@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786465161; l=10315;
 i=edwards@nvidia.com; s=20251029; h=from:subject:message-id;
 bh=uMVdx7tC6BK0AC0Z7QSC6Sj702Jph2RbworWtpmNFQs=;
 b=5IJzAjp7r07BmGS9P6nM3OVcmby6LvkrfxjMIvXmlFPcYRqDi1fWIIbA2LRgp09tJhkNAY37v
 dTDeXfQUhO0DS/e9hmzkXW+2Q+VX5cnvL1Ckcw5YpWe5I4Zb1g6zzA8
X-Developer-Key: i=edwards@nvidia.com; a=ed25519;
 pk=VME+d2WbMZT5AY+AolKh2XIdrnXWUwwzz/XLQ3jXgDM=
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F4:EE_|CH1PPF4CBE7339A:EE_
X-MS-Office365-Filtering-Correlation-Id: dc090f24-70ee-4f89-64b3-08def7c45fd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|82310400026|36860700016|18002099003|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	Gl1udZzOZ1INaSP8XwqWXX///Vxsf6GqS7bLveMZzbTCJhdhS/f7+yMpv0L/pob7C3QlvxyCV2bND8iwrbe8D/0A57ADFkdx3u5ZOAu06TVT05GR9uzd+eCBR86l2Hf5VHLUIJTiq3zOyjfSPlS7A/GgnWi1aj/6+rXJut4FAzlVL7+0mjsngQOITIMheU/0CFIVGcoTwgf3pdHUNrXTLnugweI7giQeiBu1+0zTGkYg49mWpXNg3wtftZySJDBWdNybKstdMRA4F6HtfiDtVQUb7ETIcbMydoev+ee4Lv+KzOan/bgRXxYxzNBtLMOKBK+7vtxyJKRQxJzd3cv9LWsM6tIKkRe6yLX7zhLO8+MdveDdt1nsKAmvbqT9nEl0xmQc79JkOecFxg0sytaCdV2l4KITGovIuxX95vEGW7MivG5mjX6zvANDJcaGDGwp7jy8G6XQfVwxuOFCvDJjCvWPSQbwjGiPybY1LqmjKOLD6kpclFoIQr3WoV2Pt2v2xTQ04xOU7sFu14mVC6NKMv4Db6HPCsMZE+OvME4HzUU1HUN4qaJOsZgm7QinmarswgxyDe0tT7i7HUmR4cQqnt603ETjAyF7YU3zOCfD7DII3h84atO8k5jzDhVHV0XIq2I/FzOBIbFXfrdn40K+Jul66FvasytVk3w1hYqgyDpgwIvK3Byvw3GwmYjTnBrwoe9aKLqUvdffrRJFG5WJzg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(82310400026)(36860700016)(18002099003)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LA+ppvqh7lwrEMwQJ3YboNHa+tXhtytXcsDiPwpsPOjGrjDkYaNDLqzqbfqyxZbKVEiFACC60m0QN+djvavJNS6mi0wW0hw0N1D24XCoAbik2jyokxZoJIB4CV+3Z31lvTr/eOaGwuJJvNfYyRtwUuUkxpbtJk9YuuF55VTaXYXKl4myNls9SuNROyrTRe82GIWUSigHJDmbpvC+Dm2nz71DZ/vrp5ScwQt3QCzltFM89E80XnowfwA+j69r+tmtWNR4gXfkYLkTUDxPxFbDJ5sUI0OQGblpkF/GNQkHBJ/BJpJoFZnEYmjutpbPcqcMBwJoIpXT/Xta5fFeU3X5JhNpYGyAEzmPqDps1+1X2U+0U0mJhuwzjN50hmWRwQyC2KATG2wJ+ufQp0qYxgcI7zl2kjvm2uEIgUWHcuLUXhjGymsFFw7svCH7rtRcHnPN
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 16:19:52.5662
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dc090f24-70ee-4f89-64b3-08def7c45fd4
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PPF4CBE7339A

From: Or Har-Toov <ohartoov@nvidia.com>

Commit 51976c6cd786 ("RDMA/core: Provide rdma_user_mmap_disassociate()
to disassociate mmap pages") introduced disassociation_lock to protect
new mmap registrations against uverbs_user_mmap_disassociate(), but
created an ABBA deadlock:

  Thread A (mmap / fork):
    mmap_lock -> disassociation_lock

  Thread B (disassociate):
    disassociation_lock -> mmap_lock

Fix by removing disassociation_lock entirely and using the pre-existing
hw_destroy_rwsem instead. hw_destroy_rwsem already provides the same
protection: rdma_umap_open() and ib_uverbs_mmap() both use
down_read_trylock() before registering a new VMA, so holding hw_destroy_rwsem
in uverbs_user_mmap_disassociate() is sufficient to block new registrations.
trylock is used in both mmap paths (not blocking down_read) because
mmap_lock is already held on entry, and uverbs_user_mmap_disassociate()
acquires mmap_lock internally — a blocking read would recreate the same
deadlock.

The only caller that was not taking hw_destroy_rwsem for write was
rdma_user_mmap_disassociate(). Fix it to take the rwsem per-ufile while
iterating under lists_mutex.  This is safe because ib_uverbs_close()
releases hw_destroy_rwsem entirely before acquiring lists_mutex, so the
two locks are never held simultaneously.

lockdep warning:

 [  776.654252] ======================================================
 [  776.655214] WARNING: possible circular locking dependency detected
 [  776.656167] 6.18.0for-upstream_debug_94e244d9ccab #1 Not tainted
 [  776.657114] ------------------------------------------------------
 [  776.658087] devlink/14824 is trying to acquire lock:
 [  776.658879] ffff88811170c800 (&mm->mmap_lock){++++}-{4:4}, at: uverbs_user_mmap_disassociate+0x168/0x780 [ib_uverbs]
 [  776.660479]
 [  776.660479] but task is already holding lock:
 [  776.661460] ffff888142d92b08 (&file->disassociation_lock){+.+.}-{4:4}, at: uverbs_user_mmap_disassociate+0x39/0x780 [ib_uverbs]
 [  776.663177]
 [  776.663177] which lock already depends on the new lock.
 [  776.663177]
 [  776.664525]
 [  776.664525] the existing dependency chain (in reverse order) is:
 [  776.665724]
 [  776.665724] -> #2 (&file->disassociation_lock){+.+.}-{4:4}:
 [  776.666887]        __mutex_lock+0x16d/0x2330
 [  776.667633]        rdma_umap_open+0x129/0x280 [ib_uverbs]
 [  776.668489]        dup_mmap+0xa40/0x1790
 [  776.669170]        copy_process+0x5dd2/0x6170
 [  776.669933]        kernel_clone+0xb6/0x610
 [  776.670636]        __do_sys_clone+0xb5/0xf0
 [  776.671354]        do_syscall_64+0x70/0x12e0
 [  776.672083]        entry_SYSCALL_64_after_hwframe+0x4b/0x53
 [  776.672940]
 [  776.672940] -> #1 (&mm->mmap_lock/1){+.+.}-{4:4}:
 [  776.673985]        down_write_nested+0x90/0x1e0
 [  776.674751]        dup_mmap+0x201/0x1790
 [  776.675448]        copy_process+0x5dd2/0x6170
 [  776.676180]        kernel_clone+0xb6/0x610
 [  776.676904]        __do_sys_clone+0xb5/0xf0
 [  776.677615]        do_syscall_64+0x70/0x12e0
 [  776.678351]        entry_SYSCALL_64_after_hwframe+0x4b/0x53
 [  776.679239]
 [  776.679239] -> #0 (&mm->mmap_lock){++++}-{4:4}:
 [  776.680253]        __lock_acquire+0x18c6/0x2ec0
 [  776.681018]        lock_acquire+0x10e/0x2e0
 [  776.681742]        down_read+0x95/0x430
 [  776.682395]        uverbs_user_mmap_disassociate+0x168/0x780 [ib_uverbs]
 [  776.683436]        uverbs_destroy_ufile_hw+0x1ae/0x270 [ib_uverbs]
 [  776.684416]        ib_uverbs_remove_one+0x22b/0x420 [ib_uverbs]
 [  776.685371]        remove_client_context+0xa6/0xf0 [ib_core]
 [  776.686342]        disable_device+0x12b/0x240 [ib_core]
 [  776.687249]        __ib_unregister_device+0x269/0x460 [ib_core]
 [  776.688233]        ib_unregister_device+0x21/0x30 [ib_core]
 [  776.689140]        mlx5r_remove+0xd0/0x170 [mlx5_ib]
 [  776.689999]        device_release_driver_internal+0x3b2/0x560
 [  776.694876]        bus_remove_device+0x1f5/0x3e0
 [  776.695638]        device_del+0x3b9/0x990
 [  776.696329]        mlx5_detach_device+0x17e/0x350 [mlx5_core]
 [  776.697429]        mlx5_unload_one_devl_locked+0x3f/0xb0 [mlx5_core]
 [  776.698578]        mlx5_devlink_reload_down+0x1f9/0x550 [mlx5_core]
 [  776.699712]        devlink_reload+0x13e/0x680
 [  776.700456]        devlink_nl_reload_doit+0xc29/0x1160
 [  776.701293]        genl_family_rcv_msg_doit+0x1c9/0x2a0
 [  776.702135]        genl_rcv_msg+0x3f0/0x6b0
 [  776.702854]        netlink_rcv_skb+0x11d/0x370
 [  776.703605]        genl_rcv+0x24/0x40
 [  776.704236]        netlink_unicast+0x5b4/0x970
 [  776.704984]        netlink_sendmsg+0x730/0xbf0
 [  776.705748]        __sock_sendmsg+0xc5/0x190
 [  776.706461]        __sys_sendto+0x201/0x2f0
 [  776.707188]        __x64_sys_sendto+0xdc/0x1b0
 [  776.707931]        do_syscall_64+0x70/0x12e0
 [  776.708643]        entry_SYSCALL_64_after_hwframe+0x4b/0x53
 [  776.709546]
 [  776.709546] other info that might help us debug this:
 [  776.709546]
 [  776.710910] Chain exists of:
 [  776.710910]   &mm->mmap_lock --> &mm->mmap_lock/1 --> &file->disassociation_lock
 [  776.710910]
 [  776.712805]  Possible unsafe locking scenario:
 [  776.712805]
 [  776.713828]        CPU0                    CPU1
 [  776.714589]        ----                    ----
 [  776.715347]   lock(&file->disassociation_lock);
 [  776.716097]                                lock(&mm->mmap_lock/1);
 [  776.717067]                                lock(&file->disassociation_lock);
 [  776.718199]   rlock(&mm->mmap_lock);
 [  776.718857]
 [  776.718857]  *** DEADLOCK ***

Fixes: 51976c6cd786 ("RDMA/core: Provide rdma_user_mmap_disassociate() to disassociate mmap pages")
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
---
 drivers/infiniband/core/rdma_core.c   |  1 -
 drivers/infiniband/core/uverbs_main.c | 25 +++++++++++--------------
 include/rdma/uverbs_types.h           |  2 --
 3 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index fd5651c003aed3178188b4f89ede86d893676a9a..a7cbe643e33c6e5247a8f4eebc3b8ab1d9a66e4f 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -69,7 +69,6 @@ void ib_uverbs_release_file(struct kref *ref)
 
 	if (file->disassociate_page)
 		__free_pages(file->disassociate_page, 0);
-	mutex_destroy(&file->disassociation_lock);
 	mutex_destroy(&file->umap_lock);
 	mutex_destroy(&file->ucontext_lock);
 	kfree(file);
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 3ccf58e96aedebb6f8886ef5b8fad5660475c4c7..5be21fca4948272b9a66e8ee357ca9432556c887 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -643,12 +643,15 @@ static int ib_uverbs_mmap(struct file *filp, struct vm_area_struct *vma)
 		goto out;
 	}
 
-	mutex_lock(&file->disassociation_lock);
+	if (!down_read_trylock(&file->hw_destroy_rwsem)) {
+		ret = -EIO;
+		goto out;
+	}
 
 	vma->vm_ops = &rdma_umap_ops;
 	ret = ucontext->device->ops.mmap(ucontext, vma);
 
-	mutex_unlock(&file->disassociation_lock);
+	up_read(&file->hw_destroy_rwsem);
 out:
 	srcu_read_unlock(&file->device->disassociate_srcu, srcu_key);
 	return ret;
@@ -670,7 +673,6 @@ static void rdma_umap_open(struct vm_area_struct *vma)
 	/* We are racing with disassociation */
 	if (!down_read_trylock(&ufile->hw_destroy_rwsem))
 		goto out_zap;
-	mutex_lock(&ufile->disassociation_lock);
 
 	/*
 	 * Disassociation already completed, the VMA should already be zapped.
@@ -683,12 +685,10 @@ static void rdma_umap_open(struct vm_area_struct *vma)
 		goto out_unlock;
 	rdma_umap_priv_init(priv, vma, opriv->entry);
 
-	mutex_unlock(&ufile->disassociation_lock);
 	up_read(&ufile->hw_destroy_rwsem);
 	return;
 
 out_unlock:
-	mutex_unlock(&ufile->disassociation_lock);
 	up_read(&ufile->hw_destroy_rwsem);
 out_zap:
 	/*
@@ -772,7 +772,7 @@ void uverbs_user_mmap_disassociate(struct ib_uverbs_file *ufile)
 {
 	struct rdma_umap_priv *priv, *next_priv;
 
-	mutex_lock(&ufile->disassociation_lock);
+	lockdep_assert_held_write(&ufile->hw_destroy_rwsem);
 
 	while (1) {
 		struct mm_struct *mm = NULL;
@@ -798,10 +798,8 @@ void uverbs_user_mmap_disassociate(struct ib_uverbs_file *ufile)
 			break;
 		}
 		mutex_unlock(&ufile->umap_lock);
-		if (!mm) {
-			mutex_unlock(&ufile->disassociation_lock);
+		if (!mm)
 			return;
-		}
 
 		/*
 		 * The umap_lock is nested under mmap_lock since it used within
@@ -831,8 +829,6 @@ void uverbs_user_mmap_disassociate(struct ib_uverbs_file *ufile)
 		mmap_read_unlock(mm);
 		mmput(mm);
 	}
-
-	mutex_unlock(&ufile->disassociation_lock);
 }
 
 /**
@@ -850,8 +846,11 @@ void rdma_user_mmap_disassociate(struct ib_device *device)
 
 	mutex_lock(&uverbs_dev->lists_mutex);
 	list_for_each_entry(ufile, &uverbs_dev->uverbs_file_list, list) {
-		if (ufile->ucontext)
+		if (ufile->ucontext) {
+			down_write(&ufile->hw_destroy_rwsem);
 			uverbs_user_mmap_disassociate(ufile);
+			up_write(&ufile->hw_destroy_rwsem);
+		}
 	}
 	mutex_unlock(&uverbs_dev->lists_mutex);
 }
@@ -926,8 +925,6 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 	mutex_init(&file->umap_lock);
 	INIT_LIST_HEAD(&file->umaps);
 
-	mutex_init(&file->disassociation_lock);
-
 	filp->private_data = file;
 	list_add_tail(&file->list, &dev->uverbs_file_list);
 	mutex_unlock(&dev->lists_mutex);
diff --git a/include/rdma/uverbs_types.h b/include/rdma/uverbs_types.h
index 5a07f9a6dcd1f6e2faaf2df25d2661d5bf2a170e..6f3622892c0cc6d71890f4ece7bd3a0c59432ee2 100644
--- a/include/rdma/uverbs_types.h
+++ b/include/rdma/uverbs_types.h
@@ -180,8 +180,6 @@ struct ib_uverbs_file {
 	struct page *disassociate_page;
 
 	struct xarray		idr;
-
-	struct mutex disassociation_lock;
 };
 
 extern const struct uverbs_obj_type_class uverbs_idr_class;

---
base-commit: a12d9145145b21c50531afb6e3f711b1f34e1465
change-id: 20260811-fix-mmap-lockdep-91da89a3f37c

Best regards,
-- 
Edward Srouji <edwards@nvidia.com>

