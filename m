Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11021108.outbound.protection.outlook.com [40.107.208.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCA433BBB9
	for <linux-rdma@vger.kernel.org>; Fri,  7 Aug 2026 17:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786125355; cv=fail; b=MZ/wUpvhZbyzO+ngSZ6VK8GVTb120TFr4mnDVFmQnqGUPpWV3aVH+xsNIqZQZ9foZYhwRQn6uaLy4e2JEvkGzEWqWdb+L3+hw2Go+gvPTeBPcyvS3GiFksA3ua+otj3AF5DIgjGxVru+n+aAiGtkrtwFHuDOmEvqje5hcCQovgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786125355; c=relaxed/simple;
	bh=12sJqdxy9IotdEnclseUIE+dbDIBssR+aQkrLUZ6XDs=;
	h=Subject:From:To:Cc:Date:Message-ID:MIME-Version:Content-Type; b=fhL7+618HVyi51H0gBd8cdoWtu/bfivV9sVq7JByqhb7Is4V7L0GcWCXsfpEd3KuRj5BxAEeKvC7Q1aiLjRBco+bsnh025FVSpVKLeP7hBc9lMUjHZONlIDsvLvzBw0a1YfAVLseoyqVQjUbi7MHwZZsWHwMIl8AV4CHcl+vp/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=lw6gPQK1; arc=fail smtp.client-ip=40.107.208.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="lw6gPQK1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h6WUyf4di/1AXkl6P358/lOqZVUbLX8J9GCxMkSOAXxg6LKoTib9aiWr2qrXhiTjxFIN10A35oMQ8hag+zuBP5OoLz/uvJq3iegQJ8AWqbW8d9HDp9Gwm04E6+5QyKOBRlDjMKdrqeDW1cXkvD47AQqMPjg0HLVGeb4ZYfOOReyKrJk2q1ctNf+MU46V6c1WZzt8DRqwddHcJ9qaAg3+LNGtTVgzjBRjOlhUg09g5dRmRm1QoE4EYE//8ZAFTjwwotaai4LXPvM0Ce2eAtauM1BhxNXiQTnF1+UFBebpgAJ+20EjQeunbVJ+1ry5A6amIOysbTWCYnYlKZ93xDgzOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Y3bGs6Eca87/wr5znFkSKDITPwZyAtXr3XEjGY8Pg0=;
 b=OtcDz1w48LbRnc9NFHE6fW+fID6yjr4In5yCjB06C9iNoS4JDbF2kkvhWdMZozhxNcJqdznGs/eqcduD81IYjWL4Ia77NuAs+d8S1/u6ESsPsmOM3C1ho/4Zkt1e4r+MSC6IZrC7e6usYmAiwAzdTLUvCP2fvKvzh/RPCRtbg99LvsY9Dxcq/97aoxYOrcI1TdNBjsuSyOSsP9JpfHc5FiTgn6mKVgcBJE1++jqx+X07ib325bK5Ic8qZDkkuOkfhVUhRqWlXNwWLMSNsOuLZjE+67MbZg5LsUo67S5V5iMln9Zz2RDLqc6SKT4hWUe2ekvHPbhgHhkRnXKQlY7fPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 50.148.235.34) smtp.rcpttodomain=arndb.de smtp.mailfrom=cornelisnetworks.com;
 dmarc=fail (p=none sp=none pct=100) action=none
 header.from=cornelisnetworks.com; dkim=none (message not signed); arc=none
 (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Y3bGs6Eca87/wr5znFkSKDITPwZyAtXr3XEjGY8Pg0=;
 b=lw6gPQK17n/KZ64tiCl05/gOuh10mfQPjD3KVaGuwlxzWEMo3RtPlTbWQTWFKDE6P6dtFosB6NB59c/yyK3SbnApDrQUG8p4no/xgT7BaCZY34Q9YC5feqnz7yCv/Z3ZzuX0AuTgKEsa7e+UFpyDbbyOh3VGug+Mg/PbEAJfBixb5fLgMrJOo/9JUEunytStRBBkZeB6SsDCYg9/LnlunHen1By3E6mKfvciRybq8D93whFNWJetfZe/jnVJrAqHM0FgIm0+z/gZzWIue9275Q6Oq4sXFFZmg6nPXx11FvjjvG6Vr2ANoAORq/Ak0ibTMTrca0YBA/S8QBs7YBAbhA==
Received: from CY5PR20CA0012.namprd20.prod.outlook.com (2603:10b6:930:3::16)
 by DS1PR01MB8745.prod.exchangelabs.com (2603:10b6:8:216::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.23; Fri, 7 Aug 2026 17:55:47 +0000
Received: from CY4PEPF0000EE31.namprd05.prod.outlook.com
 (2603:10b6:930:3:cafe::4e) by CY5PR20CA0012.outlook.office365.com
 (2603:10b6:930:3::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.23 via Frontend Transport; Fri, 7
 Aug 2026 17:55:47 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 50.148.235.34)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=cornelisnetworks.com;
Received-SPF: Fail (protection.outlook.com: domain of cornelisnetworks.com
 does not designate 50.148.235.34 as permitted sender)
 receiver=protection.outlook.com; client-ip=50.148.235.34;
 helo=cn-mailer-00.localdomain;
Received: from cn-mailer-00.localdomain (50.148.235.34) by
 CY4PEPF0000EE31.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.6
 via Frontend Transport; Fri, 7 Aug 2026 17:55:46 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id 39D391DAF27;
	Fri,  7 Aug 2026 13:55:46 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id 27AC4186A3082;
	Fri,  7 Aug 2026 13:55:46 -0400 (EDT)
Subject: [PATCH v4 00/24] Migrate to hfi2 driver
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
 Dean Luick <dean.luick@cornelisnetworks.com>,
 Breandan Cunningham <brendan.cunningham@cornelisnetworks.com>,
 Douglas Miller <doug.miller@cornelisnetworks.com>, linux-rdma@vger.kernel.org
Date: Fri, 07 Aug 2026 13:55:46 -0400
Message-ID: <178612534584.3164235.5428549372904350681.stgit@awdrv-04>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE31:EE_|DS1PR01MB8745:EE_
X-MS-Office365-Filtering-Correlation-Id: 9af41265-6064-4f0f-d570-08def4ad1c01
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700016|23010399003|82310400026|55112099003|18002099003|10067099003|56012099006|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	2/AOmSmD4/QyvmdmFqlAh4si/oA8YlmDU4O/tN5LSXHHA0uaZ/EYGdY257dJjIh+s3UBr4Gypx2uX+oJXRoRHLROve0E1xvwEYc7AzVLua9G5kfSDiSFagtZkxcP3MxcCG/DCewFNffRA3W7goxpKlVOCzBd1EKiLHCWlGOqRyRD1z9u+g/1ePmKs46fompr4I2HygiB60aE9OY/fyoLAW9VFUXm0u5onjmF3i2GMYqUvrPLQl6yRZg9l1EIOMSWFS/sHieshW85gaVk2ptfOuEhdNb7H3iPn861OVhGNJkacbt7aPD8wKkZbnqYRiN/uz2+OQOCDaZLUyJtLdjqTafVfpSnKYPK3gkMde7Sc21QOQWws+ftiVW3RZe9RlblbMfEn4g123fcGdfXiLOJjRkZCX8UEdKplt1Y1AV64C/Q57JE5NZwr7TojCrkx6oMAiAWvEdfiYcZ64KwwmvmS8+BGFJJSD29vDJuqbx7Nr2Q28m48nfBLhD7W8t7ImSLsGUqT6sCoppMS7gHff3/tt0ILVdQ46aFHTb/viptoizgiraWctSN7AobEK5Yx4xcx+jywZ3+oKblgaz2SkqlKYMoNkDs2eIuMrRq7wx9BSwBu5EIr23mOg4X1G065rVwpUlNZmImnOdWcKFb+NkyhsJjgcV4BvkPahZCiWg4JoShPK51h0ryDgCOuhQFewooip1cad7b4aP870zECvvYfw==
X-Forefront-Antispam-Report:
	CIP:50.148.235.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700016)(23010399003)(82310400026)(55112099003)(18002099003)(10067099003)(56012099006)(6133799003)(3023799007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ojPa0YktgLgPpgxeeDcnzptNEqEiTpDSeHJBmlEa/AiGba+eYNECM5T9gwOvgPSt5cKkxdlkXS5mAIsIMDadn+J0k2DJCcMuvRiLcdhBra2j1qX3ybEbdKdLWbjZrYm064VqBPc6tOr/vf6Z3yQIXUIaDAVQwY/nG8vuKFTLjx7kBHQ6vsR0n/UhZhkuh3wkKkWtVQwenUaxqi5JpKE4WNlM/GOijLQ7r0m4pMU60ODi374NBaHJZC/Sucn02z9GCCPC8xHeaDtTDCmzSqPhwQiQbpoBKS4p80YGTYmog96lSn4Bvh8+zi9mZGixNXFNvlz7LuNGOaefCV8FA5Jam8qZCM6zAc70w5Yt5E4Fuz1KlCa0gpoioiEBBj8yQgxqBS6EAZspkF5YUXSIXWCI2SZH/IZsl8TN++jdTl6NmwVYWdVDm+1TXZJIws3+/aWn
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 17:55:46.8143
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9af41265-6064-4f0f-d570-08def4ad1c01
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[50.148.235.34];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE31.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS1PR01MB8745

While sharing similar bones, the chip for the Cornelis Networks next
generation fabric technology has some fundamental differences that
resulted in a near complete re-write of the driver. It also does not
use the private cdev interface that the hfi1 driver exposes. After
discussing this with the RDMA maintainers we have decided to go with
the approach of moving to a new driver and declaring hfi1 obsolete.

It is desirable to keep hfi1 around temporarily to let user APIs
catch up to support access through the uverbs device rather than the
private hfi1 cdev.

This driver is designed to support future products as well.

This series applies on top of the rdma/for-next branch.

Changes since v3:
- Folded in the "Sync with upstream hfi1 fixes and cleanups" series and
  the MAINTAINERS entry addition, applying each into the patch that
  first introduces the file(s) it touches rather than carrying them as
  separate trailing patches.

Changes since v2:
- Address Sashiko automated review findings (Critical and High severity):
  - pio.c: drop spinlock around sc_wait_for_packet_egress() in
    hfi2_sc_disable() to prevent 50ms mdelay under IRQ-disabled lock.
  - sdma.h: add bounds guard in _make_tx_sdma_desc() to prevent heap
    overflow when num_desc reaches MAX_DESC.
  - user_sdma.c: use wait_event (uninterruptible) in free_queues() to
    prevent UAF when a signal interrupts teardown.
  - uc.c: fix RDMA_WRITE_LAST tlen guard to use extra_bytes instead of
    pad+4, correctly handling 16B headers.
  - rdmavt/cq.c, rdmavt/srq.c: add synchronize_rcu() before vfree() in
    rvt_resize_cq() and rvt_modify_srq() to close free-while-mapped race.
  - ipoib_tx.c: add iowait_sdma_drain() before hfi2_ipoib_drain_tx_ring()
    in hfi2_ipoib_napi_tx_disable() to wait for in-flight SDMA completions.
  - cport.c: use spin_lock_irqsave for lost_mctxt_intr; timer_shutdown_sync
    for lost_int_timer; cancel_work_sync for mctxt_work; u32 for new_ctxts
    with overflow guard; bounds check in hfi2_cport_resp_set.
  - firmware.c: fix HM_TIMEOUT (10ms->100ms); add NULL guard in
    check_meta_version; add bounds checks in hfi2_parse_platform_config
    and hfi2_get_platform_config_field.
  - mad.c: add OPA_16B_L4_IB_GLOBAL and OPA_16B_L4_9B cases to
    get_mad_offset(); fix cport_mad_handler len check; add sts=0 for
    no-op attribute IDs in cport_subn_set_opa; add len bounds checks.
  - init.c: fix hfi2_mod_init error path; add rcu_read_lock in
    hfi2_lookup; fix hfi2_register_cport_trap error path; re-dispatch
    IB_EVENT_PORT_ACTIVE after HFI2_INITTED is set.
  - intr.c: hfi2_go_port_active() uses signal_ib_event() to add
    HFI2_INITTED guard, fixing IPoIB no-carrier on driver load.
  - verbs.c: fix double-free in hfi2_verbs_send_dma(); fix txreq leak
    on pkey check failure; timer_shutdown_sync for mem_timer.
  - qp.c: add INIT_WORK for opfn_work in hfi2_qp_priv_alloc().
  - uverbs.c: remove old mmap entry before overwriting in
    hfi2_mmap_entry_insert() to prevent leak on repeated USER_INFO calls.
  - netdev_rx.c: fix resource leaks in hfi2_alloc_rx() and hfi2_free_rx().
- Add hfi2 to kernel build system (drivers/infiniband/Kconfig and
  drivers/infiniband/hw/Makefile) so make produces hfi2.ko.
- trace_tx.h: fix UAF in hfi2_ipoib_txq_template trace event by capturing
  sde->this_idx and sde->cpu into entry fields at trace time instead of
  dereferencing the sde pointer in the deferred TP_printk context.
- sdma.c: fix trace-after-free in sdma_flush_descq; add bounds check in
  hfi2_sdma_set_cpu_to_sde_map to prevent heap overflow; add synchronize_rcu()
  before freeing rhashtable node; add cancel_work_sync() for three workers in
  hfi2_sdma_exit to prevent UAF on engine teardown.
- user_exp_rcv.c: fix TID/page leak on error path in hfi2_user_exp_rcv_setup
  by replacing broken tinfo->tidlist=kernel_ptr + hfi2_user_exp_rcv_clear()
  (which fails SMAP) with a direct unprogram_rcvarray() loop.
- verbs.c: use spin_lock_irqsave in verbs_sdma_complete() since it is called
  from interrupt context; fix AHG branch in build_verbs_tx_desc() to include
  extra_bytes in the tlen passed to sdma_txinit_ahg().
- tid_rdma.c: add missing 'return false' after rvt_error_qp() in the !tidlen
  error path of hfi2_build_tid_rdma_packet() to prevent use-after-free.
- fault.c: guard 'data[size-1] = newline' with 'if (size > 0)' to prevent
  OOB write when the opcode bitmap is empty.
- ipoib_main.c: remove manual free_percpu(dev->tstats) from ndo_uninit;
  the netdev core owns tstats lifecycle when NETDEV_PCPU_STAT_TSTATS is set.

Changes since v1:
- Broke up the large MAD and verbs patches that exceeded 3K LOC.
  Machine-generated counter accessor functions are now separated
  from real logic into their own patches (Leon Romanovsky).
- Removed all TODO stubs (e.g., jkr_handle_link_bounce()) that only
  printed a warning. Cleaned up unnecessary casts, unused parameters,
  and other minor style issues (Jason Gunthorpe).
- Removed dead declarations from system core headers, including
  hfi2_cdev_cleanup() and similar functions that were declared but
  never defined (Jason Gunthorpe).
- Modernized hfi2_rdma_mmap() to use the rdma_user_mmap_io /
  rdma_user_mmap_entry infrastructure as required for new drivers
  (Jason Gunthorpe).
- The opa_vnic removal is being submitted as a separate independent
  series per reviewer request (Leon Romanovsky).
- Replaced the writev-on-uverbs-fd approach with an anonymous
  'hfi2-sdma' file descriptor returned via ioctl. The data path
  write_iter is registered on the anonymous fd, avoiding any changes
  to the uverbs core.
- Audited all commit messages to ensure they accurately describe patch
  contents; moved changelog notes to the --- block where they had been
  incorrectly placed in the commit body; fixed minor typos.

---

Dennis Dalessandro (24):
      RDMA/hfi2: Start hfi2 driver by basing off of hfi1
      RDMA/hfi2: Add in HW register definition files
      RDMA/hfi2: Add counter accessor functions
      RDMA/hfi2: Add in HW register access support
      RDMA/hfi2: Add in trace header files
      RDMA/hfi2: Add in trace support
      RDMA/hfi2: Add system core header files
      RDMA/hfi2: Add driver and interrupt infrastructure
      RDMA/hfi2: Add initialization and firmware support
      RDMA/hfi2: Add in MAD handling related headers
      RDMA/hfi2: Add cport management
      RDMA/hfi2: Implement MAD handling
      RDMA/hfi2: Add IO related headers
      RDMA/hfi2: Add PIO send infrastructure
      RDMA/hfi2: Add SDMA infrastructure
      RDMA/hfi2: Implement data moving infrastructure
      RDMA/hfi2: Add verbs core
      RDMA/hfi2: Add RC protocol support
      RDMA/hfi2: Add in support for verbs
      RDMA/hfi2: Add misc header files
      RDMA/hfi2: Add the rest of the driver
      RDMA/hfi2: Make it build and add TODO list
      RDMA/hfi2: Modernize mmap to use rdma_user_mmap_entry infrastructure
      RDMA/hfi2: Support ipoib

