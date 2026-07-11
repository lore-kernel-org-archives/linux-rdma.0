Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB3472D0C89;
	Sat, 11 Jul 2026 04:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783743283; cv=none; b=qk+qq55XOkfhSTxobobOx3sV0fQSMEVy9qxpuW9I4KVI1jEpAVW4+R73Xgx0k6pTWSnF50fxWL9smjkbDdc2GyUI7SHftLADCcwEs1ymgJ5+/C9Fc6F5c7l13y/+XkddgwZXq935okSVZegNkrR+Nzry7ENWATWLchmrMEdNsGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783743283; c=relaxed/simple;
	bh=an9xkeuT4N4k301iR3nhL/8C4OiSpyPgbZmbQfUebno=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=gpD8nAq/YgU22PskalCQ8p/2i3XxXRFkSDkg2WdOkImASwicaL0InlwQ65MhoayN1poD3X1YbTKLJFaVhb/K2PXbtAbi3Y9upLcYvfegrDmRICtJfuN+H9YizMvKVWl85n2ej7ljx7TB5m6304uuqY8oQ948Fif0CdMsGHkCxZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=IMFui4qN; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="IMFui4qN"
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 8E4FC20B7169;
	Fri, 10 Jul 2026 21:14:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8E4FC20B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1783743272;
	bh=kHpLmZ//rsWAkpJYMVDT1zWDarg+LT6a1vs+4pt/K7k=;
	h=From:To:Subject:Date:From;
	b=IMFui4qN4+42C56HpZHh8qh6XL8grsTrv2+v52JLmbVZ4KjOt0Bq/+AWmhyaN8+T/
	 Zc/ypGFZpOw7pOqj0naWYLcHKenh3LYwIfM8TSY2/atXU/w3S+7byLolY8uiNRTKcN
	 aaEN/Nkrl7B0EFnvgkn3bcdC5+r8iBuO9xzIiiUo=
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
	shirazsaleem@microsoft.com,
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
Subject: [PATCH net-next v12 0/4] net: mana: add ethtool private flag for full-page RX buffers
Date: Fri, 10 Jul 2026 21:10:20 -0700
Message-ID: <20260711041415.3008868-1-dipayanroy@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On some ARM64 platforms with 4K PAGE_SIZE, utilizing page_pool
fragments for allocation in the RX refill path (~2kB buffer per fragment)
causes 15-20% throughput regression under high connection counts
(>16 TCP streams at 180+ Gbps). Using full-page buffers on these
platforms shows no regression and restores line-rate performance.

This behavior is observed on a single platform; other platforms
perform better with page_pool fragments, indicating this is not a
page_pool issue but platform-specific.

This series adds an ethtool private flag "full-page-rx" to let the
user opt in to one RX buffer per page:

  ethtool --set-priv-flags eth0 full-page-rx on

There is no behavioral change by default. The flag can be persisted
via udev rule for affected platforms.

Patches 2 and 4 harden the detach/attach path so that ethtool
operations (ring size, channel count, priv-flags) can recover the
port via the queue_reset_work handler when mana_attach() fails,
instead of leaving the port permanently dead.

This series depends on the following fixes now merged in net-next:
  commit 17bfe0a8c014 ("net: mana: Add NULL guards in teardown path to prevent panic on attach failure")
  commit 5b05aa36ee24 ("net: mana: Skip redundant detach on already-detached port")

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

Dipayaan Roy (4):
  net: mana: refactor mana_get_strings() and mana_get_sset_count() to
    use switch
  net: mana: do not bail out of mana_detach on dealloc failure
  net: mana: force full-page RX buffers via ethtool private flag
  net: mana: recover port on attach failure in ethtool operations

 drivers/net/ethernet/microsoft/mana/mana_en.c |  26 +-
 .../ethernet/microsoft/mana/mana_ethtool.c    | 223 +++++++++++++++---
 include/net/mana/mana.h                       |   8 +
 3 files changed, 220 insertions(+), 37 deletions(-)

-- 
2.43.0

