Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8EE930214B;
	Wed, 29 Jul 2026 06:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785306876; cv=none; b=Dy9lvFYFMCZjPMPj3HeQssXGWjv33cwkpMwlC3W8GAxpQG1ZeAXPAScK87fQPaWwd5vJf8cFXdpyrlMKgSCOv3BpJgHYncyoeQbjSe+B8QBPjMIVxNXWnuxhbdoHqVJcoDH7rqC/Z3VH5GOPKW+6pU9u/DUTh8tap80QA/J9mg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785306876; c=relaxed/simple;
	bh=RLulCHli6NtQc0u/hfK7oen51Chb4TztYQJRBZWKoNA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=qT/cvgDse0suHl3+SAecHIpUpkGOaNpAy/N6mppoYLPWjnV7Fpx8hRBxUMPv/qCoc0H3yTPJXIrhsF1S6tkah38F8haFtJV770c6ITm8wpMg3okMkifnEDDVjRTLHoxcqBN3nI6ewMh/Bk7Y99G9Y41OIEm8HlD0fEDqN6paFUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Mgrr48l1; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Mgrr48l1"
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 701E320B7166;
	Tue, 28 Jul 2026 23:34:17 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 701E320B7166
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1785306857;
	bh=8KVi9RLx45DgbP7KCLb+C/3MH3jBqkU3kpDgerni8Ys=;
	h=From:To:Subject:Date:From;
	b=Mgrr48l1N5QtHprUqGTB6oC6ojwkqkTtUfA/Igi8C+G2pgOnc2+q3Pb65hPo3Kfyy
	 vKZT89yqoZY/Gfv6+/+8xTzPOnVqG12VvPkJInrWLmiRiKO4e1K1O6kaB4Ot9prcuo
	 WY8qi9Ps3WUv1hoW705e+CqwAysiCKdSbjz1p/lI=
From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	leon@kernel.org,
	longli@microsoft.com,
	kotaranov@microsoft.com,
	horms@kernel.org,
	shradhagupta@linux.microsoft.com,
	ssengar@linux.microsoft.com,
	ernis@linux.microsoft.com,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	stephen@networkplumber.org,
	jacob.e.keller@intel.com,
	dipayanroy@microsoft.com,
	leitao@debian.org,
	kees@kernel.org,
	john.fastabend@gmail.com,
	hawk@kernel.org,
	bpf@vger.kernel.org,
	daniel@iogearbox.net,
	ast@kernel.org,
	sdf@fomichev.me,
	yury.norov@gmail.com,
	pavan.chebbi@broadcom.com,
	schakrabarti@linux.microsoft.com,
	gargaditya@linux.microsoft.com
Subject: [PATCH net-next v13 0/2] net: mana: add ethtool private flag for full-page RX buffers
Date: Tue, 28 Jul 2026 23:21:27 -0700
Message-ID: <20260729063347.3388035-1-dipayanroy@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On some ARM64 platforms with 4K PAGE_SIZE, utilizing page_pool
fragments for allocation in the RX refill path (~2kB buffer per
fragment) causes 15-20% throughput regression under high connection
counts (>16 TCP streams at 180+ Gbps). Using full-page buffers on
these platforms shows no regression and restores line-rate
performance.

This behavior is observed on a single platform; other platforms
perform better with page_pool fragments, indicating this is not a
page_pool issue but platform-specific.

This series adds an ethtool private flag "full-page-rx" to let the
user opt in to one RX buffer per page:

  ethtool --set-priv-flags eth0 full-page-rx on

There is no behavioral change by default. The flag can be persisted
via udev rule for affected platforms.

This series depends on the following fixes now merged in net-next:
  commit 17bfe0a8c014 ("net: mana: Add NULL guards in teardown path to prevent panic on attach failure")
  commit 5b05aa36ee24 ("net: mana: Skip redundant detach on already-detached port")

Changes in v13:
  - Dropped patches 2/4 (mana_detach dealloc bail-out fix) and 4/4
    (attach failure recovery). Both will be sent as separate series:
    the dealloc fix as a standalone fix, and the recovery mechanism
    after concluding pre-allocate-and-replace approach discussion
    with the HW team.
  - Removed schedule_port_reset logic from mana_set_priv_flags();
    on mana_attach() failure, the old priv_flags are restored and
    the error is returned without scheduling async recovery. 
Changes in v12:
  - Added patch 2 to ensure mana_detach() always completes its full
    teardown even if mana_dealloc_queues() fails, keeping port state
    consistent for recovery.
  - Added patch 4 to schedule queue_reset_work when mana_attach()
    fails during ethtool ring size or channel count changes, with
    fallback values that maximize recovery chances.
Changes in v11:
  - Rebased on net-next
Changes in v10:
  - Rebased on net-next which now includes the prerequisite fixes.
  - Recovery logic in mana_set_priv_flags() leverages the idempotent
    mana_detach() from the merged fixes.
Changes in v9:
  - Added correct tree.
Changes in v8:
  - Fixed queue_reset_work recovery by restoring port_is_up before
    scheduling reset so the handler can properly re-attach.
  - Simplified "err && schedule_port_reset" to "schedule_port_reset".
Changes in v7:
  - Rebased onto net-next.
  - Retained private flag approach after David Wei's testing on
    Grace (ARM64) confirmed that fragment mode outperforms
    full-page mode on other platforms, validating this is a
    single-platform workaround rather than a generic issue.
Changes in v6:
  - Added missed maintainers.
Changes in v5:
  - Split prep refactor into separate patch (patch 1/2)
Changes in v4:
  - Dropping the smbios string parsing and add ethtool priv flag
    to reconfigure the queues with full page rx buffers.
Changes in v3:
  - changed u8* to char*
Changes in v2:
  - separate reading string index and the string, remove inline.

Dipayaan Roy (2):
  net: mana: refactor mana_get_strings() and mana_get_sset_count() to
    use switch
  net: mana: force full-page RX buffers via ethtool private flag

 drivers/net/ethernet/microsoft/mana/mana_en.c |  22 ++-
 .../ethernet/microsoft/mana/mana_ethtool.c    | 169 +++++++++++++++---
 include/net/mana/mana.h                       |   8 +
 3 files changed, 168 insertions(+), 31 deletions(-)

-- 
2.43.0

