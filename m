Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=44.246.77.92
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422561;
	b=IRHL+sZWH5BE4aX6HnfGvVeq9E3ekokHGTs6QsckPL1dUFw3DsrHiaxXcX53zmHlEZ8a
	 S/lg/0V21VQTQGiqpxlBH9zB3E0UaoeIwyESBLlMPDzday7HuNnUXlYJLNAinz14TPScI
	 6H5IQ6rHazQXwo/th5Taz2lSbiTxqjp+KiWymttnpg619hmCiNm9cKty5nrdWnp7d6baE
	 w4HJ9eNkZw9k5pkA23BmVBhPusWsZRWiNaKCN/gBwgyRR6rhgw/zHXK14uIoEf/eld4W/
	 QrvU48P9X9j27mMj/kcFvG0MlwAWHrTQX0zCOuS5uGe0HRbORHnUjSvWrI0fVBA50OA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422561;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:Received:Received:X-Farcaster-Flow-ID:Received:Received:
	 Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To:User-Agent:X-Originating-IP:X-ClientProxiedBy;
	bh=WrrR15jRnWUAVDJRDzl05AVVs6tL+gb6m5MNmqs+X7M=;
	b=JAN8Xy/IeJMxgiII9f8J/w6A4obXueEMrxz4MQlpg30cqjSqlHI93JuftTX+oPMQbNnn
	 N1rPL5hjYtMCUPkscgcbKNHAJcBgc2PxLRKwFAw5XwDdxOqzwCqgc9EzwoV3cHK06eYlx
	 XKrQv8PqfDgxx2oHblK+Jkc4cibMWeuX2gf0/EvrqkR+JorOE/m1+vr1uK/MfWbh1JqfG
	 vcNjZnCsIG5bSmqK6PC3p7J+EMsoGN2iIvfUdz7/zl80mYKyxvHqVZt2qKqgz+VX6P8B7
	 k8vxJ2gaPX/kZAqtDiTJ/RuGHu51A30CVtEhwl7GG3hprJAuThsNTq83Fzz3RbBwvcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amazon.com;
	spf=pass smtp.mailfrom=amazon.com;
	dkim=pass header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=YYslpHhW;
	arc=none smtp.remote-ip=44.246.77.92
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085BA608607C;
	Mon, 19 Oct 2026 15:09:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 085BA608607C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=YYslpHhW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1792422561; x=1823958561;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=WrrR15jRnWUAVDJRDzl05AVVs6tL+gb6m5MNmqs+X7M=;
  b=YYslpHhW4BgBxyslhWJrpdWlb2lN7wz+gicuO3xesGtlpNcmVd5b4QSB
   pzl127xR+D5KQrJxlNiVV5uVMCd+rAcJO71CNXZUXfNh7UFNWig5IdrTb
   SrlHs/v4aJpOpOjq4MSh+i2HxcAubOLYNTp3XBiu/y5Qi0y+NHkEclxVj
   HReX0neidwDgpuAcWWEjQHDxS5FLFnNOR2rQiUAJ+AkZd54kx55ks6lnv
   BPEnYhWp1ppzGzMU6EBk7n7S3I10plk+r0a/OICwh3ZQvZJjOLHvujdKD
   zn3oVGnZ/pT4AK57Ykalbfg0FCZSm8AMOPL3ydRs0mu+J4DbNBjgQP5+U
   Q==;
X-CSE-ConnectionGUID: zjZifBsoSMuFw4Yv8V/ezg==
X-CSE-MsgGUID: bSOnYweBTQSKr3wdf6qB+g==
X-IronPort-AV: E=Sophos;i="6.27,167,1787011200"; 
   d="scan'208";a="31648770"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 15:09:20 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:24734]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.54.1:2525] with esmtp (Farcaster)
 id 325b1013-9340-4195-af8b-eb18188487d2; Mon, 19 Oct 2026 15:09:20 +0000 (UTC)
X-Farcaster-Flow-ID: 325b1013-9340-4195-af8b-eb18188487d2
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.49;
 Mon, 19 Oct 2026 15:09:19 +0000
Received: from dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com
 (10.253.103.172) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.53; Mon, 19 Oct 2026
 15:09:18 +0000
Date: Mon, 19 Oct 2026 15:09:05 +0000
From: Michael Margolin <mrgolin@amazon.com>
To: Sasha Levin <sashal@kernel.org>
CC: <patches@lists.linux.dev>, <stable@vger.kernel.org>, Anas Mousa
	<anasmous@amazon.com>, Leon Romanovsky <leon@kernel.org>,
	<linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 6.18-6.12] RDMA/efa: Add EFA 0xefa4 PCI ID
Message-ID: <20261019150905.GA8110@dev-dsk-mrgolin-1c-b2091117.eu-west-1.amazon.com>
References: <20261019135441.1420968-1-sashal@kernel.org>
 <20261019135441.1420968-330-sashal@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261019135441.1420968-330-sashal@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Mon, Oct 19, 2026 at 09:50:21AM -0400, Sasha Levin wrote:
> From: Anas Mousa <anasmous@amazon.com>
> 
> [ Upstream commit 6a57af838b1a56405a9bde9030de16df901ae2ca ]
> 
> Add support for 0xefa4 devices.
> 
> Reviewed-by: Michael Margolin <mrgolin@amazon.com>
> Signed-off-by: Anas Mousa <anasmous@amazon.com>
> Link: https://patch.msgid.link/20260712134413.19226-3-mrgolin@amazon.com
> Signed-off-by: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> LLM Generated explanations, may be completely bogus:
> 
> This is a two-line PCI ID addition to the existing Amazon EFA RDMA
> driver. That matches the stable-tree device-ID exception, and the local
> 7.3-rc4 tree already has the driver and ID table.
>

The 0xefa4 device support requires previous changes introduced in 7.3.
Please do not apply this patch on stable kernels.

> ---
> 
> ## PHASE 1: COMMIT MESSAGE FORENSICS
> 
> **Step 1.1: PARSE THE SUBJECT LINE**
> - Subsystem: `RDMA/efa`
> - Action verb: **Add**
> - Claimed intent: register PCI device ID `0xefa4` so the in-tree EFA
>   driver binds new Amazon Elastic Fabric Adapter hardware.
> 
> Record: `[RDMA/efa] [add] [PCI ID 0xefa4 for next-gen EFA VF]`
> 
> **Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
> - `Reviewed-by: Michael Margolin <mrgolin@amazon.com>` (Amazon EFA
>   contributor; 20 commits in this driver)
> - `Signed-off-by: Anas Mousa <anasmous@amazon.com>` (author)
> - `Link:
>   https://patch.msgid.link/20260712134413.19226-3-mrgolin@amazon.com`
> - `Signed-off-by: Leon Romanovsky <leon@kernel.org>` (RDMA maintainer,
>   committer)
> - No `Fixes:` tag (expected)
> - No `Cc: stable@vger.kernel.org` (expected)
> - No `Reported-by:`, `Tested-by:`, `Acked-by:`
> - Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
>   ...]` markers (none in the real commit)
> 
> Record: Maintainer-applied PCI ID patch; Amazon internal review; lore
> link present; no syzbot/bug report (not applicable).
> 
> **Step 1.3: ANALYZE THE COMMIT BODY TEXT**
> Body is one sentence: “Add support for 0xefa4 devices.” Cover letter
> (mbox): “Make a minor device interface change needed for new EFA devices
> and enable support for 0xefa4 PCI ID.” No crash, no reproducer — this is
> hardware enablement.
> 
> Record: `[Bug description: none — new PCI ID] [Symptom: 0xefa4 adapters
> unbound / unused by in-tree efa] [Version info: none] [Root cause: ID
> missing from pci_device_id table]`
> 
> **Step 1.4: DETECT HIDDEN BUG FIXES**
> Not a disguised leak/race/UAF fix. It is exactly a device-ID addition.
> 
> Record: `[Not a hidden bug fix. Explicit PCI ID enablement.]`
> 
> ---
> 
> ## PHASE 2: DIFF ANALYSIS
> 
> **Step 2.1: INVENTORY THE CHANGES**
> - File: `drivers/infiniband/hw/efa/efa_main.c` — **+2 / -0**
> - `#define PCI_DEV_ID_EFA4_VF 0xefa4`
> - `{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA4_VF) }` in `efa_pci_tbl[]`
> - Scope: single-file surgical ID addition
> 
> Record: `[efa_main.c +2] [pci_device_id table] [surgical single-file]`
> 
> **Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
> Before: PCI core matches Amazon vendor `0x1d0f` with IDs
> `0xefa0`–`0xefa3` only. `0xefa4` is ignored (no probe).
> After: `0xefa4` matches `efa_pci_driver`, `efa_probe()` runs the same
> path as older generations.
> 
> `efa_probe(struct pci_dev *pdev, const struct pci_device_id *ent)` does
> not use `ent` for generation-specific branching. `vendor_part_id` is
> taken from `pdev->device`. Capabilities come from admin query
> (`page_size_cap`, etc.).
> 
> Record: `[PCI match table: 4 IDs -> 5 IDs; probe path unchanged]`
> 
> **Step 2.3: IDENTIFY THE BUG MECHANISM**
> Category **(h) Hardware workarounds / device ID additions**. Without the
> ID, new EFA VFs never bind.
> 
> Record: `[Device ID addition] [Missing 0xefa4 in efa_pci_tbl prevented
> driver bind]`
> 
> **Step 2.4: ASSESS THE FIX QUALITY**
> Obviously correct. Same pattern as `0xefa2` (`b75927cff13e0`) and
> `0xefa3` (`346d2fc606a85`). Does not change locking, APIs, or existing-
> ID behavior. Regression risk is confined to `1d0f:efa4` hardware.
> 
> Record: `[Minimal, obviously correct] [Regression risk: only 0xefa4
> devices]`
> 
> ---
> 
> ## PHASE 3: GIT HISTORY INVESTIGATION
> 
> **Step 3.1: BLAME THE CHANGED LINES**
> ```
> efa0/efa1: d4f9cb5c5b224 (Gal Pressman, 2020)
> efa2:     b75927cff13e0 (Michael Margolin, 2022) → v6.1-rc4
> efa3:     346d2fc606a85 (Michael Margolin, 2024) → present in v6.11 /
> v7.2.7
> efa4:     6a57af838b1a5 (Anas Mousa, 2026-07-12)
> Driver:   b7f5e880f3774 (2019) → v5.2-rc1
> ```
> The table has been the enablement mechanism since the driver was added.
> 
> Record: `[ID table since v5.2; this ID added 2026-07-12 / 7.3 merge
> window]`
> 
> **Step 3.2: FOLLOW THE FIXES: TAG**
> No `Fixes:` tag. Not a regression fix.
> 
> Record: `[N/A — device ID, not a regression]`
> 
> **Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
> Same msgid series `20260712134413`:
> 1. `4266547bdce74` RDMA/efa: Extend page-shift field in MR registration
>    (`19226-2`)
> 2. `6a57af838b1a5` RDMA/efa: Add EFA 0xefa4 PCI ID (`19226-3`) — this
>    commit
> 
> Cover letter: 2-patch `for-next` series. Patch 1 widens
> `EFA_ADMIN_REG_MR_CMD_PHYS_PAGE_SIZE_SHIFT_MASK` from `GENMASK(4,0)` to
> `GENMASK(5,0)` for **>4GB page sizes** on 0xefa4. That is extra
> capability, not required for PCI bind/probe. `efa_probe` does not depend
> on that mask.
> 
> Record: `[Series of 2; this patch is standalone for bind] [page-shift is
> feature, not probe prerequisite]`
> 
> **Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
> Anas Mousa: this is the only in-tree EFA commit. Reviewed by Michael
> Margolin (regular EFA author). Applied by Leon Romanovsky.
> 
> Record: `[First-time author; reviewed by EFA regular; applied by RDMA
> maintainer]`
> 
> **Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
> Local tree already has `PCI_DEV_ID_EFA3_VF`, `PCI_VDEVICE(AMAZON, ...)`,
> and `efa_pci_tbl`. No new helpers. Companion page-shift commit is
> already in this tree (`git merge-base --is-ancestor 4266547bdce74
> HEAD`).
> 
> Record: `[Applies standalone] [No missing structs/APIs in this tree]`
> 
> ---
> 
> ## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
> 
> **Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
> `b4 dig -c 6a57af838b1a5` →
> https://patch.msgid.link/20260712134413.19226-3-mrgolin@amazon.com
> `b4 dig -a`: **v1 only** (no v2/v3).
> Thread saved to mbox (6 messages).
> 
> Key review (on patch 1/2, not this ID patch): Leon asked how non-0xefa4
> devices handle the extra page-shift bit. Michael: kernel uses device-
> reported `page_size_cap` with `ib_umem_find_best_pgsz()`, so the extra
> bit is not set on older devices; device also validates. Leon then
> **Applied, thanks!** both patches. No NAK on the PCI ID patch. No `Cc:
> stable` request.
> 
> Record: `[lore via patch.msgid.link/20260712134413.19226-3] [v1 only]
> [no NAK on ID patch] [no stable nomination]`
> 
> **Step 4.2: CHECK WHO REVIEWED THE PATCH**
> `b4 dig -w` recipients: `jgg@nvidia.com`, `leon@kernel.org`, `linux-
> rdma@vger.kernel.org`, Amazon EFA engineers (`sleybo`, `matua`,
> `gal.pressman`). Right lists and maintainers.
> 
> Record: `[RDMA maintainers + linux-rdma CC'd; Leon applied]`
> 
> **Step 4.3: SEARCH FOR THE BUG REPORT**
> No bugzilla/syzbot. External confirmation that 0xefa4 is real hardware:
> - DeviceHunt: PCI `1D0F:EFA4` Amazon Elastic Fabric Adapter
> - Amazon out-of-tree `efa_linux_3.3.0`: “Add 0xefa4 device support”
> - rdma-core: `efa: Add EFA 0xefa4 PCI ID`
> 
> Record: `[Real shipping device; userspace + out-of-tree driver already
> list the ID]`
> 
> **Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
> 2/2 of “Add support for 0xefa4 devices”. Evaluating only the ID patch:
> self-contained for enumeration. Full >4GB MR pages needs patch 1/2
> (already in this tree).
> 
> Record: `[Standalone for bind; series mate is optional extra
> capability]`
> 
> **Step 4.5: CHECK STABLE MAILING LIST HISTORY**
> lore.kernel.org WebFetch returned 403. `b4 dig` mbox has no stable-list
> traffic. No evidence this ID was rejected for stable.
> 
> Record: `[No stable-list discussion found (lore HTTP 403; mbox has
> none)]`
> 
> ---
> 
> ## PHASE 5: CODE SEMANTIC ANALYSIS
> 
> **Step 5.1: KEY FUNCTIONS**
> No function body changed. Data: `PCI_DEV_ID_EFA4_VF`, `efa_pci_tbl[]`.
> Consumers: `MODULE_DEVICE_TABLE(pci, efa_pci_tbl)` and
> `efa_pci_driver.id_table`.
> 
> Record: `[efa_pci_tbl / efa_pci_driver only]`
> 
> **Step 5.2: TRACE CALLERS**
> PCI core `pci_device_probe` → `efa_probe` → `efa_probe_device` /
> `efa_ib_device_add`. Userspace-visible once the VF is assigned (typical
> AWS EFA instance).
> 
> Record: `[PCI enumeration; bind on matching VF]`
> 
> **Step 5.3: TRACE CALLEES**
> Unchanged. Probe still does BAR map, MSI-X, admin queues, IB register.
> 
> Record: `[Probe callees unchanged]`
> 
> **Step 5.4: FOLLOW THE CALL CHAIN**
> Reachable when `CONFIG_INFINIBAND_EFA` is set (`PCI_MSI && 64BIT &&
> !CPU_BIG_ENDIAN && INFINIBAND_USER_ACCESS`) and `1d0f:efa4` is present.
> Common on AWS HPC/ML instances, not a syscall fuzzer path.
> 
> Record: `[Reachable from device hotplug/boot on EFA instances]`
> 
> **Step 5.5: SEARCH FOR SIMILAR PATTERNS**
> Identical ID adds for efa2/efa3. No `switch (pdev->device)` /
> `driver_data` generation quirks in `drivers/infiniband/hw/efa/`.
> 
> Record: `[Same pattern as prior EFA IDs; no per-ID code]`
> 
> ---
> 
> ## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
> 
> **Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
> Local tree: **v7.3-rc4-27-gf0100363d8c37**, `make kernelversion` =
> **7.3.0-rc4**.
> `INFINIBAND_EFA` and `efa_pci_tbl` exist. `0xefa0`–`0xefa3` exist.
> Without this change, `0xefa4` would not match.
> 
> `git merge-base --is-ancestor 6a57af838b1a5 HEAD` → yes (landed by
> **v7.3-rc1**). Not in **v7.2.7**. Introduced in the 7.3 window, not
> after this branch point.
> 
> Record: `[Driver and ID table present in this 7.3-rc4 tree] [ID added in
> 7.3-rc1]`
> 
> **Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
> Hunk is two lines next to `PCI_DEV_ID_EFA3_VF`. Would apply cleanly to
> this file’s table. No refactor of the ID table.
> 
> Record: `[Expected apply: clean]`
> 
> **Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
> No alternate 0xefa4 enablement. This is the only `0xefa4` PCI table
> change.
> 
> Record: `[No other 0xefa4 bind fix]`
> 
> ---
> 
> ## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
> 
> **Step 7.1: SUBSYSTEM AND CRITICALITY**
> `drivers/infiniband/hw/efa/` — Amazon EFA RDMA NIC.
> Criticality: **IMPORTANT** for AWS EFA users; **PERIPHERAL** globally.
> Not core mm/net.
> 
> Record: `[RDMA/efa] [IMPORTANT for EFA hardware, otherwise peripheral]`
> 
> **Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
> Actively maintained (completion counters, 128B admin SQ, IRQ lifetime
> fixes in 2026). ID adds are a long-standing pattern, not a new
> subsystem.
> 
> Record: `[Active but mature ID-table pattern]`
> 
> MAINTAINERS: “AMAZON RDMA EFA DRIVER”.
> 
> ---
> 
> ## PHASE 8: IMPACT AND RISK ASSESSMENT
> 
> **Step 8.1: WHO IS AFFECTED**
> Users of Amazon EFA VF `1d0f:efa4` with `CONFIG_INFINIBAND_EFA`. Older
> EFA IDs unchanged.
> 
> Record: `[driver-specific / config-specific (INFINIBAND_EFA)]`
> 
> **Step 8.2: TRIGGER CONDITIONS**
> Boot or VF assignment of 0xefa4. Not a race. Unprivileged users cannot
> trigger a crash; they just get a working RDMA device after bind.
> 
> Record: `[Hotplug/boot of 0xefa4] [Likely on new EFA instances] [Not a
> UAF/syscall crash]`
> 
> **Step 8.3: FAILURE MODE SEVERITY**
> Without the ID: device unused by in-tree driver (lost HPC/RDMA). Not
> panic/corruption. For affected hardware this is functional breakage.
> 
> Record: `[Device not bound] [Severity: HIGH for 0xefa4 users, LOW for
> everyone else]`
> 
> **Step 8.4: RISK-BENEFIT RATIO**
> Benefit: enables real hardware on an existing driver (stable-kernel-
> rules explicitly allow this).
> Risk: two lines, ID-table only, no API/lock/hot-path change.
> 
> Record: `[Benefit: high for EFA 0xefa4] [Risk: very low] [Favorable]`
> 
> ---
> 
> ## PHASE 9: FINAL SYNTHESIS
> 
> **Step 9.1: COMPILE THE EVIDENCE**
> 
> FOR:
> - `Documentation/process/stable-kernel-rules.rst`: “must either fix a
>   real bug that bothers people **or just add a device ID**.”
> - Canonical PCI ID exception: driver already in tree; only the ID is
>   new.
> - +2 lines, obviously correct, same as efa2/efa3.
> - No per-ID branching; probe is generation-agnostic.
> - Real device (`1d0f:efa4`); Amazon out-of-tree and rdma-core already
>   list it.
> - Reviewed and applied by RDMA maintainer Leon Romanovsky.
> - Applies cleanly; no new APIs.
> 
> AGAINST:
> - Not a crash/security/corruption fix (not required for device IDs).
> - Submitted as `for-next`, no `Cc: stable` (absence is expected).
> - Series mate extends page-shift for >4GB MRs; not needed for bind.
> - Author is a first-time in-tree EFA contributor (offset by Margolin
>   review + Leon apply).
> 
> UNRESOLVED:
> - Direct lore.kernel.org HTTP fetches returned 403; thread recovered via
>   `b4 dig -m`.
> - Stable mailing list search via WebFetch also 403; no stable discussion
>   in the rdma mbox.
> 
> **Step 9.2: STABLE RULES CHECKLIST**
> 1. Obviously correct and tested? **PASS** — 2-line ID table; maintainer
>    applied after review.
> 2. Fixes a real bug that affects users? **PASS** — device ID exception;
>    otherwise 0xefa4 never binds.
> 3. Important issue? **PASS** under the documented device-ID exception
>    (not a panic).
> 4. Small and contained? **PASS** — +2 lines, one file.
> 5. No new features or APIs? **PASS** — existing driver, new ID only
>    (page-shift is a different commit).
> 6. Can apply to the local tree? **PASS** — `efa_main.c` ID table
>    present; hunk matches.
> 
> **Step 9.3: EXCEPTION CATEGORY**
> **Device ID addition to existing driver** — automatic stable qualifier.
> 
> **Step 9.4: DECISION**
> This tree is **7.3.0-rc4**. The EFA driver and PCI table are here.
> Adding `0xefa4` is the standard, low-risk hardware-enablement backport.
> The companion page-shift change is a separate feature and is not
> required for this ID patch to be correct.
> 
> ### What it solves for users of this tree
> Without `0xefa4` in `efa_pci_tbl`, new Amazon EFA adapters are invisible
> to the in-tree driver. With it, the existing probe path binds them. That
> is exactly what stable trees take PCI IDs for.
> 
> ### Risk vs benefit
> Benefit is hardware enablement for EFA 0xefa4. Risk is two lines that
> cannot affect other devices.
> 
> ---
> 
> ### Verification
> - [Phase 1] Parsed commit `6a57af838b1a56405a9bde9030de16df901ae2ca`:
>   Reviewed-by Margolin, SOB Anas Mousa + Leon Romanovsky, Link msgid
>   `20260712134413.19226-3`
> - [Phase 2] Diff: +2 lines in `efa_pci_tbl` / `PCI_DEV_ID_EFA4_VF` only
> - [Phase 2] `efa_probe()` does not branch on `ent`/`pdev->device` for
>   quirks (verified in `efa_main.c`)
> - [Phase 3] `git blame -L 16,29 efa_main.c`: efa0–efa3 older; efa4 is
>   this commit
> - [Phase 3] Prior IDs: efa2 `b75927cff13e0`, efa3 `346d2fc606a85` — same
>   2-line pattern
> - [Phase 3] Series mate `4266547bdce74` is page-shift GENMASK only, not
>   a probe dependency
> - [Phase 4] `b4 dig -c 6a57af838b1a5`: matched lore thread; v1 only
> - [Phase 4] `b4 dig -w`: linux-rdma, jgg, leon CC’d
> - [Phase 4] mbox: Leon question on patch 1/2 only; both patches applied
>   2026-07-14; no NAK on ID patch
> - [Phase 4] WebFetch lore/stable: HTTP 403 — UNVERIFIED via HTTP;
>   covered by b4 mbox
> - [Phase 5] Call path: PCI `id_table` → `efa_probe`; `page_size_cap`
>   used in `efa_verbs.c` for MR pages
> - [Phase 6] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
>   kernelversion` = 7.3.0-rc4
> - [Phase 6] `git merge-base --is-ancestor 6a57af838b1a5 HEAD` = yes; not
>   ancestor of `v7.2.7`
> - [Phase 6] Driver added `b7f5e880f3774` (v5.2-rc1); present in this
>   tree
> - [Phase 7] `Documentation/process/stable-kernel-rules.rst` line 15:
>   device ID explicitly allowed
> - [Phase 8] Failure mode: device not bound on 0xefa4; no panic path
> - UNVERIFIED: stable@vger archive contents (HTTP 403)
> 
> The change is a contained PCI ID addition to a driver this tree already
> ships, which stable policy explicitly accepts.
> 
> **YES**
> 
>  drivers/infiniband/hw/efa/efa_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/efa/efa_main.c b/drivers/infiniband/hw/efa/efa_main.c
> index fdaf88f0122db..b1f3e7ce2c65e 100644
> --- a/drivers/infiniband/hw/efa/efa_main.c
> +++ b/drivers/infiniband/hw/efa/efa_main.c
> @@ -17,12 +17,14 @@
>  #define PCI_DEV_ID_EFA1_VF 0xefa1
>  #define PCI_DEV_ID_EFA2_VF 0xefa2
>  #define PCI_DEV_ID_EFA3_VF 0xefa3
> +#define PCI_DEV_ID_EFA4_VF 0xefa4
>  
>  static const struct pci_device_id efa_pci_tbl[] = {
>  	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA0_VF) },
>  	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA1_VF) },
>  	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA2_VF) },
>  	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA3_VF) },
> +	{ PCI_VDEVICE(AMAZON, PCI_DEV_ID_EFA4_VF) },
>  	{ }
>  };
>  
> -- 
> 2.53.0
> 
