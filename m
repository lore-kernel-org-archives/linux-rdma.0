Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792470651;
	b=zn5SKflZ2gz+OClLxY37gxa3EnLs924VhG/dEMtHXB74IOjGFMPxLRvhLAJ8T9jLixlJ
	 4FXR0df8Tvwsdw6F4lf6cQScwnlNSZVzg5aFt4NluAqbc9kpB281V9cUEEcnQLPB4GMY3
	 tEGTktH9nKYfSvR+V/z7bc/0A0Qqj8cq0FbuqpEl9wJ5zxbYlKiJ+mJCbxMo60G0vE36j
	 3Y3rRdOqmsC5fM1EBMivGA2/tPn1FouNpJdN48NOd96yiCx06x/mXr2ThJy57xzGoa3CB
	 M8XbvZGB1cO6+nOsNIUB9RQJGU7KAQC7P5lT/UOlZVosK6SR3KT980DRKKbaq2zPdKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792470651;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=KwfIC9w5+Dsb3Z7ZsSlMvDgkuO9sLeD+ol8gOYO/XGU=;
	b=K4MobklifO1cVdo/dBvWqJ0hZzacF3ZvXBGA8HjPprhK3m5VSYCVvS7tk97vGNEtIsI1
	 9YiJXsoDBDZ/mdD+/AEN3SLYWmy5rPIN5TgyahdzzSzditpabjIhAk017e8LR+kTmpRFA
	 vwQvnAvfdTMgS2sqrBAHSoRjsmOY5fhXkVbJgdaKMlCs1dSoyM0/9vXtPxAEm6/GmHgPA
	 anT0nypua5SOslbvDIpNpFjg/47xzBDH/kC1aO6d3UXZgpjZJloJRg+Oig7IBKKHJ2WVM
	 E1tiVkh5n/QXJFfon2qC2Ok/8VnxzO2OpHsep6BaiM+5C9NXD74e6HcpryX6p0Ds7UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b="q/0//lIs";
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE232606A32D;
	Tue, 20 Oct 2026 04:30:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AE232606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=q/0//lIs
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id B6E9220B716D;
	Mon, 19 Oct 2026 21:30:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B6E9220B716D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792470643;
	bh=KwfIC9w5+Dsb3Z7ZsSlMvDgkuO9sLeD+ol8gOYO/XGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/0//lIsfhOVPJayY/cmdILeb33ChMX0PqCRqec6HLrFm6vXr/QtCIUrlPPymkKEP
	 m/9kaKQBjJp1ds+9U4Xfsj50HA4aj6fOe0m792CKotlYwolHbQccbbJC+gAxFqAihB
	 0poLefqDKI7jsnU/Gb0JJFSNQxYBELIZ/Rm7KaP0=
From: Wei Hu <weh@linux.microsoft.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	weh@microsoft.com,
	kuba@kernel.org
Subject: Re: [PATCH net-next v7 04/13] net: mana: swap queue sets in mana_set_channels
Date: Tue, 20 Oct 2026 04:30:40 +0000
Message-ID: <qset-v7-sashiko-04-v8-plan.20261018.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-175604@kernel.org>
References: <cover.1791710735.git.weh@linux.microsoft.com> <ec57f3853ef344a7d5ec8907ba530313b0163bae.1791710735.git.weh@linux.microsoft.com> <sashiko-outbox-175604@kernel.org>
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

> Does mana_xdp_xmit() require a lock when updating tx_stats->syncp further
> down in this function?

I will leave this counter update unchanged in v8. Multiple CPUs can map
to the same queue, and the aggregate xdp_xmit update is outside the
per-frame send lock, so lost increments are a real issue. However, the
same writer-exclusion gap exists in both unmodified upstream bases.
Moving the counters to port-owned storage does not introduce that race.
I am keeping that independent statistics fix outside this series.

The claimed sequence-counter corruption and infinite reader loop also
require a configuration this driver does not support. PCI MANA requires
X86_64 or ARM64, and CDX requires 64BIT. On those 64-bit configurations,
u64_stats_sync has no sequence counter and fetch_retry() returns false.
This does not excuse the baseline lost increments, but it does rule out
the reported 32-bit hang for supported builds.

> Could this u64_stats_update_begin() call deadlock a preempting softirq
> reader?

I will leave the folding synchronization unchanged as well. This second
report depends on the same unavailable 32-bit sequence-counter behavior.
There is no odd sequence counter for the preempting reader to spin on in
the supported 64-bit implementation. Adding BH exclusion to address that
specific scenario is therefore not warranted.

Thanks,
Wei
