Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F09BE33F5A9;
	Fri, 22 May 2026 23:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779492988; cv=none; b=TBWm6kSJzhABsInVMPmx7iV1uqswUgCy430gc/LFNf3mKL0Rbr3G5QKx0UKavTYNjLuN/veK5mBzmfpufprBCp/IH8zMho9lgnjWrw9BmHEI4UUjgffJN+LemH8GtpcgnBR4x93AVUlxBKw/t5vAua5/u4/opCGwwrJdGS+w57w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779492988; c=relaxed/simple;
	bh=/jgttpWCN0tgh/4c8aZqcVtsOjdx0JQvRJVQZT6nq28=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=JdnaxhiducFV97q+ZQcklSM0DXxvB/lBrjzzY2pQlIlqYbG82vRl6bXmPyNqoe3TUVERg+GjPajiiTz2qkm95hu4pbxUG4gz3N+u5QHMPHkxN63mXKMeOE6bpAKqXigysp65IvtMa9F7bcfX/i07UCy3v+1sBW3x+dA+Sm4mY8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=nuGsUF0A; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="nuGsUF0A"
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id A500420B7167;
	Fri, 22 May 2026 16:36:17 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A500420B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1779492977;
	bh=xbYpCzgJzfzdNg3MGfAcTelwqBdFp1i4OWAH/4HYx/Y=;
	h=From:To:Subject:Date:From;
	b=nuGsUF0ADIfi1kKUPTNcwWSSyZvMLHOknCRs/6CokFmZAa2MZcQCR2+nDIBQqz14K
	 PlDUTpVn4dwvN/KO2UjHlrnpTNvT4A090iAgBqoCuNxlFYPK7Crxigq27FEupej1K5
	 05RqBhatEKw85+TZ0691dIcGMEr05JEfpTSsRFuo=
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
	yury.norov@gmail.com
Subject: [PATCH net v2 0/2] net: mana: Fix NULL dereferences during teardown after attach failure
Date: Fri, 22 May 2026 16:33:11 -0700
Message-ID: <20260522233555.1099342-1-dipayanroy@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mana_attach() fails (e.g. during queue allocation), the error
cleanup frees apc->tx_qp and apc->rxqs and sets them to NULL. Multiple
subsequent teardown paths can then dereference these NULL pointers,
causing kernel panics.

Patch 1 adds NULL guards in the low-level teardown functions
(mana_fence_rqs, mana_destroy_vport, mana_dealloc_queues) so they are
safe to call regardless of queue initialization state. This covers all
callers: mana_remove(), mana_change_mtu() recovery, and internal error
paths in mana_alloc_queues().

Patch 2 adds an early exit in mana_detach() for already-detached ports,
making it safe for non-close callers. This allows the queue reset
handler to safely retry mana_attach() without redundant teardown.

Changes in v2:
  - Patch 2: moved netif_device_present() check into mana_detach() as
    an early exit instead of using goto in the work handler 

Dipayaan Roy (2):
  net: mana: Add NULL guards in teardown path to prevent panic on attach
    failure
  net: mana: Skip redundant detach on already-detached port

 drivers/net/ethernet/microsoft/mana/mana_en.c | 76 ++++++++++++-------
 1 file changed, 47 insertions(+), 29 deletions(-)

-- 
2.43.0

