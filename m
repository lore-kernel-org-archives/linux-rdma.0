Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E484F390E
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 11:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891971; cv=none; b=jjj9UM+a6z9KG70oajLmt+GryG9n13yLStonWxoUjTQcSMjzya13jjq0KdYXducn0R+pnVXnNgbu6CNA7B0rpHuUpuz+R6WsP1MI76I19Im8l1JT1VXLVS4rffnUw6xw7+S7kcLjbEniJWQ7sD5TV1YfTt4FV4g7///MhwI99HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891971; c=relaxed/simple;
	bh=jTkYP1LL11mNrYcffNm9iCfXUdDO2dfy8/pVMq8AMGc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=aIG6QOcYe5ayOEmkejhZrPstRczoNN1AECyhfCeiXbdrEoTZOhw2mVSMpDSxWBggDJ6u4NgqHDq5f3nT7143FVgkZAoStEHt0ypSEfPKIT2aKbjZXi9gSOAxCNabYcQDgVN6MkpGs63pqikfgK0jhzwwktSS0s6G1L867M++S/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JfypmdSF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JfypmdSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED59E1F00893;
	Tue, 13 Oct 2026 11:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791891970;
	bh=jTkYP1LL11mNrYcffNm9iCfXUdDO2dfy8/pVMq8AMGc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JfypmdSFEo8zb7yzxMf2DP6wMr0QEXzRFnJrr543lpJlOvLClE8UURXKA6jB2EUVz
	 GQilCa7IN/IyJxkgPu9vVwLxriJ18s+PJqYe1+upaFh165FqK9L+3GyiDa2hRXiLvl
	 PUTdxo1jIqgP0TBhij5LSVKVGyaf6iggkjR10tDMIvjbHCTTUMg6QSXQDmaeFKwJda
	 TK0U4BNt1S1RyMKyUY/WdIwLGOVRyTUzoLAkcSJqWpu9RtV3TnEn6lYQwEO15XjaJn
	 YOdllUi9isR1m/gh+hSYxT42txl66kKA2q88GLjTUSKJDNr8cl3NbRh+eJJ8Xd6MqV
	 GVRAh0E0mYofw==
Message-ID: <sashiko-outbox-169643@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 03/15] yunsilicon: add the command queue
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012114356.2471317-4-tianx@yunsilicon.com>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
 <20261012114356.2471317-4-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 11:46:09 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 14 potential issue=
(s) to consider:
- [High] net: yunsilicon: UAF and double semaphore release on command timeo=
ut
- [High] net: yunsilicon: kernel panic on kthread_create failure due to ERR=
_PTR
- [High] net: yunsilicon: deadlock between mode transition and workqueue
- [High] net: yunsilicon: index bounds check bypass and NULL dereference
- [High] net: yunsilicon: DMA API violation for continuously polled command=
 rings
- [High] net: yunsilicon: missing dma_rmb() before reading polled descriptor
- [High] locking: ABBA deadlock and data race on cmd->cq_cid in xsc_cmd_use=
_events
- [Medium] net: yunsilicon: CPU hog via mdelay in kthread polling loop
- [Medium] net: yunsilicon: infinite tight loop on owner_bit mismatch
- [Medium] net: yunsilicon: lockless access to global board_info array caus=
es race condition
- [Medium] net: yunsilicon: signed integer overflows in bitwise shifts
- [Medium] net: yunsilicon: semaphore corruption and hang on xsc_alloc_ent =
failure
- [Low] net: yunsilicon: dead code in command header version validation
- [Low] net: yunsilicon: min() macro type mismatch causes compile failure
--

Do not include the diff headers (e.g., 'diff --git...'). Do not copy-paste =
code snippets from the prompt. Just describe the problem conceptually and p=
oint to where it occurs.commit 2019eb79ab2f1a25c0ab805fcdc1f2dc6fc6691f
Author: Xin Tian <tianx@yunsilicon.com>
Subject: yunsilicon: add the command queue

This commit adds the hardware command queue for the yunsilicon driver,
including the request/response rings, kthread-based polling, and the
initialization sequence for HCA capabilities. It introduces the `xsc_cmd`
API functions and the internal hardware setup logic.

[Severity: High]
Can the timeout path in xsc_cmd_invoke() lead to a use-after-free and a
double semaphore release? When wait_for_completion_timeout() returns a
timeout error, the code jumps to err_sem_up where it immediately calls
up(&cmd->sem) and xsc_free_cmd(ent). The pending work item is never
canceled. If the work hasn't run yet, cmd_work_handler() could later
dereference the freed entity and block on the semaphore. Furthermore, since
the entry is not removed from cmd->ent_arr, the hardware completion handler
(xsc_cmd_comp_handler) will eventually process the timed-out entry, writing
to the freed structure and calling up(&cmd->sem) a second time, which
corrupts the driver's flow control state.

[Severity: High]
Does xsc_cmd_init() correctly handle kthread_create() failures? The code
checks for an error using "if (!cmd->cq_task)", assuming that
kthread_create() returns NULL on failure. However, kthread_create() returns
an ERR_PTR on failure. Since the boolean check will not catch the error, the
invalid pointer is immediately passed to wake_up_process(), which will cause
a kernel panic.

[Severity: High]
Is there an ABBA deadlock risk during the transition to event mode? In
xsc_cmd_use_events(), the code acquires all max_reg_cmds semaphore permits
in a loop and then calls flush_workqueue(cmd->wq). However, the workqueue
thread running cmd_work_handler() unconditionally attempts to acquire a
permit using down(&cmd->sem). If a work item was recently queued, it will
block indefinitely waiting for a semaphore held by xsc_cmd_use_events(),
while xsc_cmd_use_events() blocks indefinitely waiting for the workqueue to
flush. The same deadlock risk applies to xsc_cmd_use_polling().

[Severity: High]
Are there concurrent lockless updates to the completion queue index? Both
xsc_cmd_resp_handler() and the kthread xsc_cmd_cq_polling() update
cmd->cq_cid directly without any synchronization. If a spurious interrupt or
asynchronous hardware event fires while the polling thread is still active
(for example, during the mode transition window), they can concurrently
process the same completions and corrupt the CID index.

[Severity: Medium]
Does the polling kthread loop properly yield the CPU? In
xsc_cmd_cq_polling(), if no new responses are detected, it delays for 3
milliseconds using mdelay(3) before checking again. Because mdelay() uses a
busy-wait loop, this continuously running thread will peg an entire CPU core
at 100% usage without yielding it to the scheduler.=20

[Severity: Medium]
What happens if the hardware updates the doorbell but the buffer is not yet
ready? In xsc_cmd_cq_polling(), if cmd->owner_bit does not match
rsp->owner_bit, the code prints an error and executes a continue statement.
Because this skips the delay and jumps immediately to the top of the loop,
it instantly re-evaluates the condition, creating an unthrottled infinite
loop that spams the log and soft-locks the CPU.

[Severity: High]
Does the array bounds check in xsc_cmd_comp_handler() allow an out-of-bounds
access? The function checks if idx > cmd->max_reg_cmds, where max_reg_cmds
is 31. If the hardware provides an index of 31, it passes this check. The
subsequent bitmask check shifts 1 by 31, which triggers a signed integer
overflow resulting in zero, meaning it also passes the mask validation.
Since xsc_alloc_ent() only allocates indices 0 to 30, cmd->ent_arr[31] is
NULL, causing an immediate kernel panic when dereferenced. The check should
be idx >=3D cmd->max_reg_cmds.

[Severity: Medium]
Is the lockless access to the board_info array safe during driver probe? In
xsc_alloc_board_info() in hw.c, the code searches for a NULL slot and
allocates a new entry. During simultaneous probing of multiple devices (like
VFs or multi-port interfaces), concurrent threads could observe the same
empty index and allocate memory to the same slot, resulting in a memory leak
and corrupted sharing configuration.

[Severity: High]
Does the command ring mapping violate DMA API rules for polled memory? The
command buffers are allocated with __get_free_pages() and mapped using
dma_map_single(DMA_BIDIRECTIONAL). Since the driver continuously polls this
memory concurrently with hardware updates (checking rsp->owner_bit) without
calling dma_sync_single_for_cpu(), CPUs on architectures without cache-cohe=
rent
PCIe will perpetually read stale cached values and hang. Polled rings should
use dma_alloc_coherent().

[Severity: High]
Is a memory barrier missing when checking the ownership bit? In the
completion handlers, the CPU checks if cmd->owner_bit matches
rsp->owner_bit. Once confirmed, it proceeds to read the descriptor data.
Without a dma_rmb() immediately following the ownership check, the CPU may
speculatively fetch the descriptor payload before the ownership bit has
flipped, causing it to process stale or corrupted hardware data.

[Severity: Low]
Does xsc_cmd_exec() validate the correct version field? The function forces
the input header version to 0, and then immediately checks if it is not 0,
which triggers a WARN_ON. This logic is dead code and seems to be missing
the intended validation of the hardware's output response version.

[Severity: Low]
Will the strict type-checking of the min() macro cause a build failure? In
xsc_alloc_cmd_msg(), the code uses the min() macro to compare the result of
sizeof() with an unsigned int. Because sizeof returns a size_t, this will
cause a compile-time failure.

[Severity: Medium]
Do the bitwise shift operations invoke undefined behavior? In
xsc_cmd_init(), the entry mask is created using (1 << cmd->max_reg_cmds). If
max_reg_cmds is 31, this causes a signed integer overflow. A similar
overflow occurs in xsc_cmd_query_hca_cap() when calculating max_mtt if the
hardware capability value is greater than or equal to 31. These should use
unsigned literals like 1UL or 1ULL.

[Severity: Medium]
Does an allocation failure in cmd_work_handler() lead to a hanging thread?
If xsc_alloc_ent() fails, the handler prints an error, drops the semaphore,
and returns without calling complete(). This abandons the completion object,
forcing the initiating thread to hang for the full 60-second timeout. Once
it times out, the error path releases the semaphore again, artificially
incrementing the permit count and permanently corrupting the driver's state.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012114352.2471=
317-1-tianx@yunsilicon.com?part=3D3
