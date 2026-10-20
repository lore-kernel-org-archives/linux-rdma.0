Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792470649;
	b=FYtbxGdRGc1VrBj9lDcou459fV0Q20ZFaQzcqr+1ldN1lw7TrvqbndLBNQxA8SZRIbCl
	 qxtUWkvwnmA2Sg5dxgCimGNXROdB1wSJCywmABFrz0eBZO1P/K9zGhxTI5KXnDo4DclO5
	 udt0S8Y2Cnqzgeqv4l+rMbi0USCNu2vFEbFgMzaROWJusDR3GdCvmJqjpXxvg8Ghu1CXl
	 xbVsrKPDx4KY+yTN+85ZYeGbb05gdRWCOfiGSIE+OMO0mrTL4MzLDMj8xQxS23V08G4lg
	 t8R6X2W4Itc+k8aY0/GDZODojc10pbfmQnRDJeF/cMq0+bRYpyo78034WtYhs6rvQqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792470649;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=6DcGGOOFdce5ERyHzgW3XUEmRU7KpMeHrpytV7uK3CA=;
	b=WetTRKpso9GQ8MEIHY8TSdYQeOpd5NK5EYAwbDQD0gYEsACXilZS+CEI7Sq7cEauzwXT
	 38k424Eybo29z5gOPrmtzJOON2o09NatO9bZS0uZCN8MCeZ2uR9+d8RX7SkOVy06wTQ/L
	 xH3yaXsI0zxdrbMWhZLGXNyyYqhOBZAWSOS/cbWwaVS49+6gsgPegflWAbd4gicCJE2Qp
	 +64n7fHH5S7NHVr3iGCgFbICyny59isMpn/fCrx8nYImUxXQth/2+HB4uhcwsZocESg1V
	 UOif0Lfsx8cCbgPvayYqothEjLsKGxQTXBtIJ61iCb87nrkLzURTTL5T1ydnIhxJbgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=CS0kzJ6V;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C33606A31A;
	Tue, 20 Oct 2026 04:30:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1C33606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=CS0kzJ6V
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id E211520B7168;
	Mon, 19 Oct 2026 21:30:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E211520B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792470641;
	bh=6DcGGOOFdce5ERyHzgW3XUEmRU7KpMeHrpytV7uK3CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CS0kzJ6V5exZC/Oxw4HGYd9bVsqvkL/H90ftXt8pcPBtqIQ/M8Qx/lifmZM9Qdi/q
	 xxwLBbuH0aNiFGPq/S6kd98PZOel5zGnpeo6z/GqHRhatqm9oOKRMqBRZRpB7uWQIY
	 TKAgolw/uS086DhAngF5p05mv7pACCn6hSsEgEyU=
From: Wei Hu <weh@linux.microsoft.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	weh@microsoft.com,
	kuba@kernel.org
Subject: Re: [PATCH net-next v7 02/13] net: mana: share the EQ pool across a queue-set swap
Date: Tue, 20 Oct 2026 04:30:38 +0000
Message-ID: <qset-v7-sashiko-02-v8-plan.20261018.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-175602@kernel.org>
References: <cover.1791710735.git.weh@linux.microsoft.com> <9b7e62cc70138f8940a32869da44c1260748be14.1791710735.git.weh@linux.microsoft.com> <sashiko-outbox-175602@kernel.org>
Content-Type: text/plain; charset="us-ascii"
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

Hi,

> Should mana_ib_remove_cq_cb() use cmpxchg() and synchronize_rcu() for
> teardown, similar to what was added for Ethernet CQs in
> mana_gd_destroy_cq()?

I will leave the RDMA teardown path unchanged in v8. The callback-wrapper
lifetime issue is real, but mana_ib_remove_cq_cb() and mana_ib_destroy_cq()
already have this ordering in both unmodified upstream bases used for v6
and v7. The acquire/release publication change does not introduce that
reader/free race or resolve it. An independent RDMA lifetime fix should
cover the hardware CQ and pending events as well as the software readers;
I am not including that separate change in this queue-set revision.

> Can gc->cq_table be NULL when this acquire load executes?

I will also leave this initialization path unchanged in v8. There is a
window after max_num_cqs is populated and before cq_table is allocated.
A spurious or premature completion in that window could hit the missing
table-root check. That window and the unguarded lookup already exist in
both upstream bases, before this series.

For normal HWC startup, WQEs are posted only after channel establishment
returns and the CQ table is installed. I have not identified a normal
completion producer in the window described here. This is a conditional
hardware-protocol hardening issue, not a demonstrated new startup failure
caused by the publication change.

> Could this sequential mana_gd_test_eq() call lead to an unbounded RTNL
> stall if an EQ stops delivering interrupts?

I will address the additional per-CQ timeout amplification in v8. These
extra waits are introduced by the queue-set series and are already in v6.

The correction will stop the retiring WQs, keep their CQ callbacks alive,
and issue all required parent-EQ markers before waiting. Per-EQ
completions will allow one shared 30-second completion budget per RX or TX
cleanup batch. CQ withdrawal and the existing RCU reader wait remain
after the batch, including the partial-allocation cleanup paths.

One detail of the reported bound needs qualification: each TX/RX pair has
its own parent EQ. One stalled parent normally adds two CQ waits, about
60 seconds. The 128 * 30-second case requires all 64 parents to stall
while the hardware channel remains responsive. The cumulative delay is
finite, but it is still a real problem introduced by these extra waits.

The correction bounds the added CQ-marker completion waits, not all RTNL
hold time. Existing per-EQ destruction waits and hardware-channel request
time remain separate. It also preserves the existing best-effort cleanup
policy after a failed marker, rather than claiming new hardware recovery
guarantees.

Thanks,
Wei
