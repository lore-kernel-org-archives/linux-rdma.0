Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11022095.outbound.protection.outlook.com [52.101.43.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406C82D8DA8
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 16:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785772872; cv=fail; b=dVm9w7D4A4sINEpHyWGorltlLhbTNKCgPXSiD8Z/49Awnw/SnBQDCYOAO2LlggD7sO6b3Rrv4l0ZrB4B706n0Wb7Opp9uNH5idn701cPiJ4Gn2Q68yCt9IWHvoRMHRV7RdeK2a1L1NcNPFyI4DtzlLsOw/JRHTryHlJhZ5Zkh6E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785772872; c=relaxed/simple;
	bh=hI14wyWHsGj3Svf0NnK9KYqFSKXQinSQT1L6osFmKzY=;
	h=Subject:From:To:Cc:Date:Message-ID:MIME-Version:Content-Type; b=hTkga+Cx3k/4yiNP5Orqi34BBO42f+7XSEwqtvehGQbt3RJAWm5bAj86axgxkNfP5E0SZad83LkX1h3w82oTltS4q6MAqGgAtIKmB3cZn/+c0Nplg7LnvSXDLyPiVq8mbH+eOT1w18HoHdTwrOx5Hv8X4PqI6xlxvLMfkGQukA0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=fJFM8eTF; arc=fail smtp.client-ip=52.101.43.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="fJFM8eTF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ACv8cjcjfV+C4wbKDWC5YWHwJMaNvdJW6JYakYoyaoQLeK6iqU75Msr8IYkATqwzCFtRONB4axcb2pxLN14uCmTWaybHqaom77QVObKWmv4j69U2o5CerZrphdnSbBFmSRp/13iPogGrI46WkD7fUL55P2kqG3oeKP7Z+6h9/8EUt2+yNJpTQC6Ga3mQqEbJKDK0I8ZkfSZ9fyTYXVrFCbaZU9s6MNCpkx+/a5QoHZcSRyNmqXsnTBKaDDjXqOOLpkyoD38iBn8Ha/XjFJcSxaNGNCxYUM0p3YFICzU16Ub6dk41aE6rvLhWbn9oz9Sr0E2dFCelvqZwU7X0+Tn0Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Yt8kXs/5rz8wYOZOqLwllppkqOhX49q1o9mpsXvGcQ=;
 b=HXODeWZA6zWbOa6Xt4LezeNfn763NM8ESJiTcQDcLraYcq4sdDjGwB1tFvS+X/rdji8cgVPLNICxuF+nzSFTk4ghFaJKU13HHIK84qYterowVt65ClXuw5DU5Vab/g7gytc6f0wD2e9HO8NFE/c1ic3sFrR1loyqtEkOxc80DMF9/V3yYV21WCoyRbI6IP5xvbxQ3Vv0kPXkQI/lfTTIr7agjrp6gv0gyky1whAzJcEaGyeh5Hn5hCe/k1SlqE3AD6ZSuc9E0QIa5fnFEfcADRyvJXKzrho+FXUK/P7B8hdYXYDbUr6OkflrN7uO6yefzKmEyWNV8n8dENpFWfNWRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 50.148.235.34) smtp.rcpttodomain=arndb.de smtp.mailfrom=cornelisnetworks.com;
 dmarc=fail (p=none sp=none pct=100) action=none
 header.from=cornelisnetworks.com; dkim=none (message not signed); arc=none
 (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Yt8kXs/5rz8wYOZOqLwllppkqOhX49q1o9mpsXvGcQ=;
 b=fJFM8eTFdTPjnYZddTwnZNfCofq/tkjgdrzdkeD7et0Rs1v4Lsft9Y7gp2yUtj0jFEL1ApCtvo5YzNxk3bjwxIuexw+BUwtI3+5OiXGEx+yI4ceheT+a5ZBW7SrG9QaV5cMLsDZe4L8xkYgkkNn+4eTvUJJXxbVUxzJQ3XXP14TKW9GKIF+kGxem4nIYSmhO7PfX4jXsxlgqLAXTLhvVxDrfoiYma33NmLPJ8VxTPRMeS4tV6WBQO3hCpI0Ys1QlGPMkN9zFsxRyyOp988EcfBi0eIHS1ZPR1Z+A3kewxUGeGgziteshZbpzRAQirU+zth4DfSnGXtWh+I38u/6tOw==
Received: from MW4PR03CA0026.namprd03.prod.outlook.com (2603:10b6:303:8f::31)
 by SA3PR01MB955511.prod.exchangelabs.com (2603:10b6:806:52d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 16:01:04 +0000
Received: from MWH0EPF000A6735.namprd04.prod.outlook.com
 (2603:10b6:303:8f:cafe::57) by MW4PR03CA0026.outlook.office365.com
 (2603:10b6:303:8f::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.18 via Frontend Transport; Mon, 3
 Aug 2026 16:01:04 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 50.148.235.34)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=cornelisnetworks.com;
Received-SPF: Fail (protection.outlook.com: domain of cornelisnetworks.com
 does not designate 50.148.235.34 as permitted sender)
 receiver=protection.outlook.com; client-ip=50.148.235.34;
 helo=cn-mailer-00.localdomain;
Received: from cn-mailer-00.localdomain (50.148.235.34) by
 MWH0EPF000A6735.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Mon, 3 Aug 2026 16:01:03 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id 0C6EA1D6F73;
	Mon,  3 Aug 2026 12:01:03 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id ED1191810DF01;
	Mon,  3 Aug 2026 12:01:02 -0400 (EDT)
Subject: [PATCH v3 for-next 00/24] Migrate to hfi2
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: Douglas Miller <doug.miller@cornelisnetworks.com>,
 Dean Luick <dean.luick@cornelisnetworks.com>,
 Breandan Cunningham <brendan.cunningham@cornelisnetworks.com>,
 Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org
Date: Mon, 03 Aug 2026 12:01:02 -0400
Message-ID: <178577280181.1792062.14134152769069940570.stgit@awdrv-04>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6735:EE_|SA3PR01MB955511:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e76d14b-9848-476e-53c8-08def1786bf2
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|1800799024|376014|36860700016|6133799003|56012099006|10067099003|3023799007|18002099003|55112099003;
X-Microsoft-Antispam-Message-Info:
	upKOO0Kym1MBUY/oouRSZ0CxRJDlGpATB6SDKZLU1kHzOAVIiSpC85dFtmsdEKfxCm+AJyvDDsP/EtlRlpJE97esXJHHcyinN7jmaZ0GfL5sR6CCJzPjsZlCWCUf25x38pNmAuNn+Hkd5QbhbExQeaLVRomhm08fTM8UJSsW7RMPF9n+kuWQQ0XPT97yLS4Bf+qnu9lSJcemZvwy2JFCV5QJA7ozkyMmcPLWBSVqhoSYXyDlxw1oYAEn1m2c+AZ8AP7ua6Efqd7TaIrYZj7MJ0Ilju/ZalET24Cvnn5pW0rv6IYSEjWtfZf+skovICEvYHwMON6XupORhOUwORTVJq2jgFGQUdJjawt+dI0tQ0TTK/sRmKZ4ArHaETcJ2HUhfkcU9qNHQtINZsgIgksX40OLNuj1bMVIgkYIY0DMmd5niF4BrP2PCI++VVpwU/PWllrf8XAxYpT+GCQo6kCM23mOOXShQt04laTQAqgWFyXaitix6HjcJ64L4wfxJzOmcFliHt/FqJYY05o99KpPewpJ5KBn6wIj84ayAMkQz8fOmJSc0Jm7ugotTtNsOrd57gXwU51rAnHi0zU2zPbfZIYvVFZO4n0UkMAZd2+vfqhU2LUtyl+RLQ8BYjOuKdOP4h+k71Dg9zjCP9hl5/Itd4tPAp8Rp/7GLOLNKYtTNWqz3FmV6TmI0AOVVgDbjXPRbtkKbHVNYMcvhZXZPodEng==
X-Forefront-Antispam-Report:
	CIP:50.148.235.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(1800799024)(376014)(36860700016)(6133799003)(56012099006)(10067099003)(3023799007)(18002099003)(55112099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/py8tqS2odcVEsksujJ4mUIUYdYZfqEXxdRR4yqZmdd5AjIbGRTLUHarYqqdYDgcQXhP0RuHhIhe+jhhLERLqcBlTvN5uF7apgLDDVGIXlvdCThP/IzYPXqZP9LN+MRVU1Re4r3hGZ6A4wS5UNY2V0zSQzUUba3HW1mxGBmt1ZkNMW97jF+gVDzcLjd8K1OlH1ldIudpERss+ZsOa3aZG2DY4P0W272igB51mDXjoCIx2xZahmRUcSBVyKphw2XaSpcnvTqm/3xHl6RUQ9uTHdnbvL5xTnogl03iOJfWwEfrUbvDlTlVN/knrtrZw27D3KzAe+nAnxTXXeI3X9ruExGPwKqIDDI4qlmQVVy0O+4IdLhRl5pG1oCE2ym5GMX3hPrK6l+m2PjZ4UngPOhfSdaDDVKWFHJlTDYGNggP2H5xzKIflwUhzNphR/iCDkoI
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 16:01:03.9792
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e76d14b-9848-476e-53c8-08def1786bf2
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[50.148.235.34];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6735.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR01MB955511

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

This series will be followed up to pick up any remaining changes from
hfi1 that were not yet incorporated in our internal development tree.

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
      RDMA/hfi2: Add in MAD handling related headers
      RDMA/hfi2: Add in HW register access support
      RDMA/hfi2: Add in trace header files
      RDMA/hfi2: Add in trace support
      RDMA/hfi2: Add system core header files
      RDMA/hfi2: Add driver and interrupt infrastructure
      RDMA/hfi2: Add initialization and firmware support
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


 drivers/infiniband/Kconfig                    |     1 +
 drivers/infiniband/hw/Makefile                |     1 +
 drivers/infiniband/hw/hfi1/Kconfig            |     5 +-
 drivers/infiniband/hw/hfi2/Kconfig            |    32 +
 drivers/infiniband/hw/hfi2/Makefile           |    75 +
 drivers/infiniband/hw/hfi2/TODO               |     6 +
 drivers/infiniband/hw/hfi2/affinity.c         |    75 +
 drivers/infiniband/hw/hfi2/affinity.h         |    26 +
 drivers/infiniband/hw/hfi2/chip.c             | 12948 ++++++++++++++++
 drivers/infiniband/hw/hfi2/chip.h             |  1445 ++
 drivers/infiniband/hw/hfi2/chip_counters.c    |  4162 +++++
 drivers/infiniband/hw/hfi2/chip_gen.c         |  1151 ++
 drivers/infiniband/hw/hfi2/chip_gen.h         |    44 +
 drivers/infiniband/hw/hfi2/chip_jkr.c         |  1017 ++
 drivers/infiniband/hw/hfi2/chip_jkr.h         |   128 +
 drivers/infiniband/hw/hfi2/chip_registers.h   |  1301 ++
 .../infiniband/hw/hfi2/chip_registers_jkr.h   |   251 +
 drivers/infiniband/hw/hfi2/common.h           |   331 +
 drivers/infiniband/hw/hfi2/cport.c            |  1029 ++
 drivers/infiniband/hw/hfi2/cport.h            |   275 +
 drivers/infiniband/hw/hfi2/cport_traps.h      |    43 +
 drivers/infiniband/hw/hfi2/debugfs.c          |  1535 ++
 drivers/infiniband/hw/hfi2/debugfs.h          |    66 +
 drivers/infiniband/hw/hfi2/driver.c           |  1917 +++
 drivers/infiniband/hw/hfi2/efivar.c           |   139 +
 drivers/infiniband/hw/hfi2/efivar.h           |    17 +
 drivers/infiniband/hw/hfi2/eprom.c            |   451 +
 drivers/infiniband/hw/hfi2/eprom.h            |    11 +
 drivers/infiniband/hw/hfi2/exp_rcv.c          |    79 +
 drivers/infiniband/hw/hfi2/exp_rcv.h          |   157 +
 drivers/infiniband/hw/hfi2/fault.c            |   321 +
 drivers/infiniband/hw/hfi2/fault.h            |    70 +
 drivers/infiniband/hw/hfi2/file_ops.c         |  1168 ++
 drivers/infiniband/hw/hfi2/file_ops.h         |    49 +
 drivers/infiniband/hw/hfi2/firmware.c         |  2310 +++
 drivers/infiniband/hw/hfi2/hfi2.h             |  3461 +++++
 drivers/infiniband/hw/hfi2/init.c             |  2946 ++++
 drivers/infiniband/hw/hfi2/intr.c             |   298 +
 drivers/infiniband/hw/hfi2/iowait.c           |   129 +
 drivers/infiniband/hw/hfi2/iowait.h           |   458 +
 drivers/infiniband/hw/hfi2/ipoib.h            |   173 +
 drivers/infiniband/hw/hfi2/ipoib_main.c       |   249 +
 drivers/infiniband/hw/hfi2/ipoib_rx.c         |    93 +
 drivers/infiniband/hw/hfi2/ipoib_tx.c         |   843 +
 drivers/infiniband/hw/hfi2/mad.c              |  6541 ++++++++
 drivers/infiniband/hw/hfi2/mad.h              |   442 +
 drivers/infiniband/hw/hfi2/mmu_rb.c           |   344 +
 drivers/infiniband/hw/hfi2/mmu_rb.h           |    78 +
 drivers/infiniband/hw/hfi2/msix.c             |   422 +
 drivers/infiniband/hw/hfi2/msix.h             |    32 +
 drivers/infiniband/hw/hfi2/netdev.h           |    94 +
 drivers/infiniband/hw/hfi2/netdev_rx.c        |   503 +
 drivers/infiniband/hw/hfi2/opa_compat.h       |    87 +
 drivers/infiniband/hw/hfi2/opfn.c             |   324 +
 drivers/infiniband/hw/hfi2/opfn.h             |    88 +
 drivers/infiniband/hw/hfi2/pcie.c             |  1444 ++
 drivers/infiniband/hw/hfi2/pin_system.c       |   539 +
 drivers/infiniband/hw/hfi2/pinning.c          |    66 +
 drivers/infiniband/hw/hfi2/pinning.h          |    74 +
 drivers/infiniband/hw/hfi2/pio.c              |  2251 +++
 drivers/infiniband/hw/hfi2/pio.h              |   307 +
 drivers/infiniband/hw/hfi2/pio_copy.c         |   733 +
 drivers/infiniband/hw/hfi2/platform.c         |   982 ++
 drivers/infiniband/hw/hfi2/platform.h         |   372 +
 drivers/infiniband/hw/hfi2/qp.c               |  1055 ++
 drivers/infiniband/hw/hfi2/qp.h               |   112 +
 drivers/infiniband/hw/hfi2/qsfp.c             |   788 +
 drivers/infiniband/hw/hfi2/qsfp.h             |   202 +
 drivers/infiniband/hw/hfi2/rc.c               |  3276 ++++
 drivers/infiniband/hw/hfi2/rc.h               |    60 +
 drivers/infiniband/hw/hfi2/ruc.c              |   622 +
 drivers/infiniband/hw/hfi2/sdma.c             |  4006 +++++
 drivers/infiniband/hw/hfi2/sdma.h             |  1177 ++
 drivers/infiniband/hw/hfi2/sdma_defs.h        |   113 +
 drivers/infiniband/hw/hfi2/sdma_txreq.h       |   105 +
 drivers/infiniband/hw/hfi2/sriov.c            |   418 +
 drivers/infiniband/hw/hfi2/sriov.h            |    34 +
 drivers/infiniband/hw/hfi2/sysfs.c            |   878 ++
 drivers/infiniband/hw/hfi2/tid_rdma.c         |  5488 +++++++
 drivers/infiniband/hw/hfi2/tid_rdma.h         |   321 +
 drivers/infiniband/hw/hfi2/tid_system.c       |   481 +
 drivers/infiniband/hw/hfi2/trace.c            |   536 +
 drivers/infiniband/hw/hfi2/trace.h            |    26 +
 drivers/infiniband/hw/hfi2/trace_ctxts.h      |   116 +
 drivers/infiniband/hw/hfi2/trace_dbg.h        |   119 +
 drivers/infiniband/hw/hfi2/trace_ibhdrs.h     |   458 +
 drivers/infiniband/hw/hfi2/trace_iowait.h     |    55 +
 drivers/infiniband/hw/hfi2/trace_misc.h       |   109 +
 drivers/infiniband/hw/hfi2/trace_mmu.h        |    73 +
 drivers/infiniband/hw/hfi2/trace_pin.h        |   201 +
 drivers/infiniband/hw/hfi2/trace_rc.h         |   126 +
 drivers/infiniband/hw/hfi2/trace_rx.h         |   112 +
 drivers/infiniband/hw/hfi2/trace_tid.h        |  1687 ++
 drivers/infiniband/hw/hfi2/trace_tx.h         |   772 +
 drivers/infiniband/hw/hfi2/uc.c               |   536 +
 drivers/infiniband/hw/hfi2/ud.c               |  1037 ++
 drivers/infiniband/hw/hfi2/user_exp_rcv.c     |  1023 ++
 drivers/infiniband/hw/hfi2/user_exp_rcv.h     |   404 +
 drivers/infiniband/hw/hfi2/user_pages.c       |   106 +
 drivers/infiniband/hw/hfi2/user_sdma.c        |  1671 ++
 drivers/infiniband/hw/hfi2/user_sdma.h        |   261 +
 drivers/infiniband/hw/hfi2/uverbs.c           |   800 +
 drivers/infiniband/hw/hfi2/uverbs.h           |    39 +
 drivers/infiniband/hw/hfi2/verbs.c            |  2042 +++
 drivers/infiniband/hw/hfi2/verbs.h            |   463 +
 drivers/infiniband/hw/hfi2/verbs_txreq.c      |   101 +
 drivers/infiniband/hw/hfi2/verbs_txreq.h      |    98 +
 drivers/infiniband/hw/hfi2/vf2pf.c            |  1106 ++
 drivers/infiniband/hw/hfi2/vf2pf.h            |    54 +
 drivers/infiniband/hw/hfi2/vf2pf_int.h        |   181 +
 drivers/infiniband/hw/hfi2/vf2pf_lb.c         |   967 ++
 drivers/infiniband/hw/hfi2/vf2pf_lb.h         |    52 +
 drivers/infiniband/sw/rdmavt/cq.c             |     9 +-
 drivers/infiniband/sw/rdmavt/mmap.c           |     7 +-
 drivers/infiniband/sw/rdmavt/srq.c            |    20 +-
 include/uapi/rdma/hfi2-abi.h                  |   678 +
 include/uapi/rdma/ib_user_ioctl_verbs.h       |    47 +-
 117 files changed, 92193 insertions(+), 44 deletions(-)
 create mode 100644 drivers/infiniband/hw/hfi2/Kconfig
 create mode 100644 drivers/infiniband/hw/hfi2/Makefile
 create mode 100644 drivers/infiniband/hw/hfi2/TODO
 create mode 100644 drivers/infiniband/hw/hfi2/affinity.c
 create mode 100644 drivers/infiniband/hw/hfi2/affinity.h
 create mode 100644 drivers/infiniband/hw/hfi2/chip.c
 create mode 100644 drivers/infiniband/hw/hfi2/chip.h
 create mode 100644 drivers/infiniband/hw/hfi2/chip_counters.c
 create mode 100644 drivers/infiniband/hw/hfi2/chip_gen.c
 create mode 100644 drivers/infiniband/hw/hfi2/chip_gen.h
 create mode 100644 drivers/infiniband/hw/hfi2/chip_jkr.c
 create mode 100644 drivers/infiniband/hw/hfi2/chip_jkr.h
 create mode 100644 drivers/infiniband/hw/hfi2/chip_registers.h
 create mode 100644 drivers/infiniband/hw/hfi2/chip_registers_jkr.h
 create mode 100644 drivers/infiniband/hw/hfi2/common.h
 create mode 100644 drivers/infiniband/hw/hfi2/cport.c
 create mode 100644 drivers/infiniband/hw/hfi2/cport.h
 create mode 100644 drivers/infiniband/hw/hfi2/cport_traps.h
 create mode 100644 drivers/infiniband/hw/hfi2/debugfs.c
 create mode 100644 drivers/infiniband/hw/hfi2/debugfs.h
 create mode 100644 drivers/infiniband/hw/hfi2/driver.c
 create mode 100644 drivers/infiniband/hw/hfi2/efivar.c
 create mode 100644 drivers/infiniband/hw/hfi2/efivar.h
 create mode 100644 drivers/infiniband/hw/hfi2/eprom.c
 create mode 100644 drivers/infiniband/hw/hfi2/eprom.h
 create mode 100644 drivers/infiniband/hw/hfi2/exp_rcv.c
 create mode 100644 drivers/infiniband/hw/hfi2/exp_rcv.h
 create mode 100644 drivers/infiniband/hw/hfi2/fault.c
 create mode 100644 drivers/infiniband/hw/hfi2/fault.h
 create mode 100644 drivers/infiniband/hw/hfi2/file_ops.c
 create mode 100644 drivers/infiniband/hw/hfi2/file_ops.h
 create mode 100644 drivers/infiniband/hw/hfi2/firmware.c
 create mode 100644 drivers/infiniband/hw/hfi2/hfi2.h
 create mode 100644 drivers/infiniband/hw/hfi2/init.c
 create mode 100644 drivers/infiniband/hw/hfi2/intr.c
 create mode 100644 drivers/infiniband/hw/hfi2/iowait.c
 create mode 100644 drivers/infiniband/hw/hfi2/iowait.h
 create mode 100644 drivers/infiniband/hw/hfi2/ipoib.h
 create mode 100644 drivers/infiniband/hw/hfi2/ipoib_main.c
 create mode 100644 drivers/infiniband/hw/hfi2/ipoib_rx.c
 create mode 100644 drivers/infiniband/hw/hfi2/ipoib_tx.c
 create mode 100644 drivers/infiniband/hw/hfi2/mad.c
 create mode 100644 drivers/infiniband/hw/hfi2/mad.h
 create mode 100644 drivers/infiniband/hw/hfi2/mmu_rb.c
 create mode 100644 drivers/infiniband/hw/hfi2/mmu_rb.h
 create mode 100644 drivers/infiniband/hw/hfi2/msix.c
 create mode 100644 drivers/infiniband/hw/hfi2/msix.h
 create mode 100644 drivers/infiniband/hw/hfi2/netdev.h
 create mode 100644 drivers/infiniband/hw/hfi2/netdev_rx.c
 create mode 100644 drivers/infiniband/hw/hfi2/opa_compat.h
 create mode 100644 drivers/infiniband/hw/hfi2/opfn.c
 create mode 100644 drivers/infiniband/hw/hfi2/opfn.h
 create mode 100644 drivers/infiniband/hw/hfi2/pcie.c
 create mode 100644 drivers/infiniband/hw/hfi2/pin_system.c
 create mode 100644 drivers/infiniband/hw/hfi2/pinning.c
 create mode 100644 drivers/infiniband/hw/hfi2/pinning.h
 create mode 100644 drivers/infiniband/hw/hfi2/pio.c
 create mode 100644 drivers/infiniband/hw/hfi2/pio.h
 create mode 100644 drivers/infiniband/hw/hfi2/pio_copy.c
 create mode 100644 drivers/infiniband/hw/hfi2/platform.c
 create mode 100644 drivers/infiniband/hw/hfi2/platform.h
 create mode 100644 drivers/infiniband/hw/hfi2/qp.c
 create mode 100644 drivers/infiniband/hw/hfi2/qp.h
 create mode 100644 drivers/infiniband/hw/hfi2/qsfp.c
 create mode 100644 drivers/infiniband/hw/hfi2/qsfp.h
 create mode 100644 drivers/infiniband/hw/hfi2/rc.c
 create mode 100644 drivers/infiniband/hw/hfi2/rc.h
 create mode 100644 drivers/infiniband/hw/hfi2/ruc.c
 create mode 100644 drivers/infiniband/hw/hfi2/sdma.c
 create mode 100644 drivers/infiniband/hw/hfi2/sdma.h
 create mode 100644 drivers/infiniband/hw/hfi2/sdma_defs.h
 create mode 100644 drivers/infiniband/hw/hfi2/sdma_txreq.h
 create mode 100644 drivers/infiniband/hw/hfi2/sriov.c
 create mode 100644 drivers/infiniband/hw/hfi2/sriov.h
 create mode 100644 drivers/infiniband/hw/hfi2/sysfs.c
 create mode 100644 drivers/infiniband/hw/hfi2/tid_rdma.c
 create mode 100644 drivers/infiniband/hw/hfi2/tid_rdma.h
 create mode 100644 drivers/infiniband/hw/hfi2/tid_system.c
 create mode 100644 drivers/infiniband/hw/hfi2/trace.c
 create mode 100644 drivers/infiniband/hw/hfi2/trace.h
 create mode 100644 drivers/infiniband/hw/hfi2/trace_ctxts.h
 create mode 100644 drivers/infiniband/hw/hfi2/trace_dbg.h
 create mode 100644 drivers/infiniband/hw/hfi2/trace_ibhdrs.h
 create mode 100644 drivers/infiniband/hw/hfi2/trace_iowait.h
 create mode 100644 drivers/infiniband/hw/hfi2/trace_misc.h
 create mode 100644 drivers/infiniband/hw/hfi2/trace_mmu.h
 create mode 100644 drivers/infiniband/hw/hfi2/trace_pin.h
 create mode 100644 drivers/infiniband/hw/hfi2/trace_rc.h
 create mode 100644 drivers/infiniband/hw/hfi2/trace_rx.h
 create mode 100644 drivers/infiniband/hw/hfi2/trace_tid.h
 create mode 100644 drivers/infiniband/hw/hfi2/trace_tx.h
 create mode 100644 drivers/infiniband/hw/hfi2/uc.c
 create mode 100644 drivers/infiniband/hw/hfi2/ud.c
 create mode 100644 drivers/infiniband/hw/hfi2/user_exp_rcv.c
 create mode 100644 drivers/infiniband/hw/hfi2/user_exp_rcv.h
 create mode 100644 drivers/infiniband/hw/hfi2/user_pages.c
 create mode 100644 drivers/infiniband/hw/hfi2/user_sdma.c
 create mode 100644 drivers/infiniband/hw/hfi2/user_sdma.h
 create mode 100644 drivers/infiniband/hw/hfi2/uverbs.c
 create mode 100644 drivers/infiniband/hw/hfi2/uverbs.h
 create mode 100644 drivers/infiniband/hw/hfi2/verbs.c
 create mode 100644 drivers/infiniband/hw/hfi2/verbs.h
 create mode 100644 drivers/infiniband/hw/hfi2/verbs_txreq.c
 create mode 100644 drivers/infiniband/hw/hfi2/verbs_txreq.h
 create mode 100644 drivers/infiniband/hw/hfi2/vf2pf.c
 create mode 100644 drivers/infiniband/hw/hfi2/vf2pf.h
 create mode 100644 drivers/infiniband/hw/hfi2/vf2pf_int.h
 create mode 100644 drivers/infiniband/hw/hfi2/vf2pf_lb.c
 create mode 100644 drivers/infiniband/hw/hfi2/vf2pf_lb.h
 create mode 100644 include/uapi/rdma/hfi2-abi.h

--
-Denny

