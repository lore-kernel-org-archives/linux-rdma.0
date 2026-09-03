Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11022094.outbound.protection.outlook.com [40.107.200.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69583476CD2
	for <linux-rdma@vger.kernel.org>; Thu,  3 Sep 2026 17:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788458077; cv=fail; b=oInVAlamRVdY5Tr0EOZfklVJOVkzGxyN0IRQNQLtVu/qi10F+Ry7B6798/PlpUMK97x9wQtgHpHuftnZsTDHjNceNFjZtVuUzbH4iGxFPEpnXp63Ms5NHKQI0wlaWblQkPTkHk6tXkiXnT69cCpc4UteoixzhJny/A9MVTdl6H4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788458077; c=relaxed/simple;
	bh=cztlzV/2ry1O6AXbcdfvyHBZ89RVoBZ3CyKRBReKTUI=;
	h=Subject:From:To:Cc:Date:Message-ID:MIME-Version:Content-Type; b=W9XHNxV8wtNjId/19Qk33dnh4hKf8VGwpAH+BR3ikjQQVE0xxVU71q/m5fJ7A/xiXfPwFDQhQzsFD88xewmeoN7qlYqdoi11MqdJtKLVxQ1M8nFLitpzN3v1YQrEw+UIgowMO/MuLhCjULHmEx+Tsh0I07hvUFvGkpnRp0RpTHA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com; spf=pass smtp.mailfrom=cornelisnetworks.com; dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b=hGuKnnEp; arc=fail smtp.client-ip=40.107.200.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cornelisnetworks.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cornelisnetworks.com header.i=@cornelisnetworks.com header.b="hGuKnnEp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O7+1Vpd6cFYjUBkBxCEYCquLVAURvsTg42OIDcOovTOS2PXwf0L6SM3BZcAHQfBCWkAZN2OtlnMNHtqATDhKLNFb9ewK9+tty6Evibnes/wL1KfoAnKvCZzXkKJxEWswHpCfXUmwml7uv50te/l2TKi1QZ4QuWbAebixkHJhN+aOP5tRMuC48c9i0L9DIBsVpGcfXofsHYMyWvVyb5sNSfsAwGMwzBGW6zWawIURYJQgl4g+71QO45C+2wErZrNrZoQ/1VtOXebS1wGTGSsfm9HjTtRrG+eFscQpPaV8xQeJ2SJoMwrDdwRtzSgIi6z1PSVi7j2+X/C8H1lLHBcOuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IPD5fyakjph/gd43JMve/k12il8l9KGddetK1ZMGBn0=;
 b=BsvjBgDndrTxhteN1LBau2gKaMB2HTttKMNoVMxsuleaFX0AWP39zdCOzK0kCb094bLOG66dk2XAnlv+ODyVuhVbgdPMDWAK2iB3Xwde/hnjt080GmJMNTbXkQOqVvIAY6A9riN+ikE1AexnzIw07dLYcKR7oAmOsZ+mA9AdCM/NXEIoOfiPzLd4dTHtSTCglNQhCXBzsoUqoY35/RkjvjQRGMRsSzGobvO8Wbj24gL1qvKYUyA7wL0XEEkTOk7btm5cRGQ1tmXw/ywA5SFxM8wBeQ5YaqhhTHDOgrSBQNbBw+MxTN0aXUHGNY/jFO519YLdHbntDKqjNzI0i/aOnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 208.255.156.42) smtp.rcpttodomain=arndb.de
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass (p=none sp=none pct=100)
 action=none header.from=cornelisnetworks.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IPD5fyakjph/gd43JMve/k12il8l9KGddetK1ZMGBn0=;
 b=hGuKnnEptmperurDZyI7LNmxyS4sDT1tiARo2xulKnV6SLtiQwnX0czW9B7aofzJtmFieV9i+4Fv2elqYb97rlUqQNZSn/WCxcWCFe53wz4Yf4qXBMeVafCJdUqh6RjkU7gy+q9bR2ihNOp1skSs2I3iPhhMh6nWjZg2PgXD286ob4m2uPwuN6dTe6ExEhGthewFIHk2zGb6OjvogcQcZNj71KtY+M0OOuMM4gCFc8nqWFGF17AYR8mfEAvwjiRknA62w5EyZ6RzsQXC4N27YFr31E4UQu9yAXi4lz8U/raWpwvoXBE9aALGVsgWtkSfqMOmVDDJjWDT/JdM94QptQ==
Received: from MN0PR04CA0013.namprd04.prod.outlook.com (2603:10b6:208:52d::18)
 by DM8PR01MB7159.prod.exchangelabs.com (2603:10b6:8:d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.13; Thu, 3 Sep 2026 17:54:28 +0000
Received: from BN2PEPF000044AA.namprd04.prod.outlook.com
 (2603:10b6:208:52d:cafe::8e) by MN0PR04CA0013.outlook.office365.com
 (2603:10b6:208:52d::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.12 via Frontend Transport; Thu, 3
 Sep 2026 17:54:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 208.255.156.42)
 smtp.mailfrom=cornelisnetworks.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cornelisnetworks.com;
Received-SPF: Pass (protection.outlook.com: domain of cornelisnetworks.com
 designates 208.255.156.42 as permitted sender)
 receiver=protection.outlook.com; client-ip=208.255.156.42;
 helo=cn-mailer-00.localdomain; pr=C
Received: from cn-mailer-00.localdomain (208.255.156.42) by
 BN2PEPF000044AA.mail.protection.outlook.com (10.167.243.105) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.8
 via Frontend Transport; Thu, 3 Sep 2026 17:54:27 +0000
Received: from awdrv-04.localdomain (unknown [10.228.212.218])
	by cn-mailer-00.localdomain (Postfix) with ESMTPS id 6BD591FA26E;
	Thu,  3 Sep 2026 13:54:27 -0400 (EDT)
Received: from [10.228.212.218] (localhost [IPv6:::1])
	by awdrv-04.localdomain (Postfix) with ESMTP id 585DC18129B23;
	Thu,  3 Sep 2026 13:54:27 -0400 (EDT)
Subject: [PATCH v5 00/24] Migrate to hfi2 driver
From: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
To: jgg@ziepe.ca, leon@kernel.org
Cc: Dean Luick <dean.luick@cornelisnetworks.com>,
 Douglas Miller <doug.miller@cornelisnetworks.com>,
 Breandan Cunningham <brendan.cunningham@cornelisnetworks.com>,
 Arnd Bergmann <arnd@arndb.de>, linux-rdma@vger.kernel.org
Date: Thu, 03 Sep 2026 13:54:27 -0400
Message-ID: <178845806706.2825126.2210865708266527909.stgit@awdrv-04>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AA:EE_|DM8PR01MB7159:EE_
X-MS-Office365-Filtering-Correlation-Id: 10a76fe5-f3e9-4c6d-9194-08df09e465f4
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|23010399003|376014|18002099003|55112099003|56012099006|3023799007|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	4HmjgIRFJdPP3QLvA2mPsYC6CAvC/zOLQw15h9TJb0D/uSR0AsDa+36BPihcKpvWkM7wPb38QwgH0AaISSQ0CDTaHEz8A/FgU2vR6uOvCvlSsbVq5GGbwQUXs8E9UTo32KjI7VpuZy9OPAH/7XDKEvsYo8TCv8Xl2lSGkmgT9zxulf7q8QvrjkOCNHrxet4gfmgHYlVkWTfjZZbLjArmtGgw+thJeuR5lKZmu2DxSNmm5lzFdoNOh1ZNt5f7toCZ0U/XJxAiJmTPJYU/RzRLl8pVcdIMjz1qfnmnuEjQcsZtzhgFduq5jvILwUuIEK0tkcrtExoK2yNsNRH9bRoBDBWguat72AIN0jbzwyA/6fNrjZF1pvmEx9Uqgb6qYIjETXb0VIbNgjGlUj1RwNDw0PraormohUvG1OuJtne4levIOR3/VNkzih28BzpcQZQZeVOTb1ZCNGbP/ToLQLA8D2VGt9UwGe5703JGqBfn94QPeAh1uHhc7qnRGLl9qkYp61ZZ5d4hCvwP+mbNjlteXsooJgXT4zpaC8cOnRkRFOVTgQDUUzoJOIE189GSHPZf2maGCpoZbGSqivv1O7abLY3t4tPw+aRfXZL3jUui7YR2+Cz5pnIEt/MmqaGK2KYyx9VH5/e5dlbtLUE3zNGwAuUbrSGJ5mExN1MZ+vyu4UJdF21n+GEQ1M8XyiTovgfcKrpUaNDE8mRlQ8oUil+fBw==
X-Forefront-Antispam-Report:
	CIP:208.255.156.42;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:cn-mailer-00.localdomain;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(23010399003)(376014)(18002099003)(55112099003)(56012099006)(3023799007)(10067099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	22B2omdxbnxWjo4dQeg8WlByCR8vlsU25uz0Ra3wkCQs3KIgxZ99NK9NAS5O5I2F23XIc6d7z0nT9mUSzFqWgTP5jZ9DDKWB/aKEtycocmdIvE7YgqQOw/cm4v4FDaUQjddsLZ/yFdnM8rBBNZOl+hCoDg0rpym372BLqA8lGLWiTbnKFYRuYnhZocKXYT20WkB6V3cQxpqGFuhlkRpqhZgpav2SfNMQTQkXFurXg8+L846JMGQcBFkIjOk4RlxFW7V3vDohHZZxhCd4Z3fiBeauFowuMJ/uuSHHHI6MhxyhEyY3DfpLLWcH/LBBEwwQvI4cTiAyu/PtBSjIiAwwPG9l0BkUc1CjXFfrlETcKYevAn+m1ZwoJ1m64lzIRyKvuVaqcvZyK1aIfSrNw3gwfYhm3MERVBgPLSlkldn7qi3iM6AvBDqVvp54FeJ3ot5B
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 17:54:27.6792
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10a76fe5-f3e9-4c6d-9194-08df09e465f4
X-MS-Exchange-CrossTenant-Id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a;Ip=[208.255.156.42];Helo=[cn-mailer-00.localdomain]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR01MB7159

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

Portions of this series were developed with the assistance of a large
language model (LLM), reviewed and verified by the author. Each
commit affected carries an "Assisted-by: LLM" trailer per
Documentation/process/coding-assistants.rst.

This series applies on top of the rdma/for-next branch.

Changes since v4:
- cport.c: rate-limit the "Op N SS failed" error log in cport_req_fn() and fix a
  use-after-free where msg->req->hdr fields were read after cwput(msg) had
  already freed msg, by moving the error log before the cwput() call.
- mad.c: treat undersized CH_OP_UMAD_9B/16B payloads in cport_umad_handler() as
  a normal, expected occurrence (e.g. periodic SM keep-alive/poll probes)
  rather than a protocol error; count them via n_vl15_dropped and silently
  drop instead of returning MSG_RSP_STATUS_INVALID_STATE, to avoid flooding
  the console.
- Updated the AI attribution trailer on all commits from
  "Assisted-by: AGENT:MODEL" to the simplified "Assisted-by: LLM" per updated
  upstream guidance.

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

