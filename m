Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792470654;
	b=ZWDpx8YfOTORgHNQlqenKOXwJbWiM6hhzw02UtrkDUfbfvMlXpEERAcFTX1KyCCzjWem
	 NsWwLXf3vIMoo+8Gk3qf+QvAWalVs+k0i6tfnQjthWVC8ICGK373e/0kNeZyCZffpXIqF
	 gdXPYHVhA/WjdTk1dqFYvI5lRekExTKKiQnBSMV3NkLvIW/b4hL8k2VVcYRmLxvMdysO3
	 DlPJWxWzdzbV6Lmbfab38/UDH+BcMOXCqU4mp8GeBwsTg7jcqFGmkrl940IInNAuIRmUA
	 HFpnC2lU1/p1eArkJ1gGrvezk6cUEJnvvrtfh5EMfbgtdrqiyEy0lYDpNLZ1u9q9spA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792470654;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=3UvhX2apNd/qnNqj12GKek217Nsl8pRDNQhnNCUM2Fg=;
	b=HxP0I4msK9bZsLPMyigowQfm5hpO+Nh8bp16BnV2x0UySscsfAZpOGpqmnxia9BLcQN6
	 lGs3YujrsppIyp56rU7COjcu6Un5yvGPMzTPtLMoDRiT+QnnyXjSpQUTG+jHWfFp2OP4o
	 buxzuMjrd4MNOrJmOv6lBq538P5wevNvwdxw9D2i9L0kh+4tzGSHqMpSVAEzVaZM0hsNH
	 emvd1xCtL3ZtXqlJTMplVwYQpYyCd8rnyek80P4SHBkdyWgfvoalcLddLxn9AT2JOrwj0
	 2oBWJclqPtrVJ43xiVQW3e1OuAAL6GX4MIaoxa2lrzZ4mtWFyxS3uPc3peSTS+EsDFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=G2VokJw8;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 517E8606A33B;
	Tue, 20 Oct 2026 04:30:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 517E8606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=G2VokJw8
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id BB7BD20B7185;
	Mon, 19 Oct 2026 21:30:45 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BB7BD20B7185
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1792470646;
	bh=3UvhX2apNd/qnNqj12GKek217Nsl8pRDNQhnNCUM2Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2VokJw80Albs9KNiIGir3mmnO7536BzfkYg+6PbLtj7RYQYNC99u5FU7wEzQ6GQW
	 j77lUEQrFvGV6NjND+Zp0Q1iqwbKhVQgS2nD1WChXRoFLMCE+H/Xeyb60p5hWdANHb
	 jADk2CtzZHjJvp15s0UEEydqJ4qXQHpdUd4WpAek=
From: Wei Hu <weh@linux.microsoft.com>
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	weh@microsoft.com,
	kuba@kernel.org
Subject: Re: [PATCH net-next v7 07/13] net: mana: swap queue sets in mana_change_mtu
Date: Tue, 20 Oct 2026 04:30:42 +0000
Message-ID: <qset-v7-sashiko-07-v8-plan.20261018.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-175607@kernel.org>
References: <cover.1791710735.git.weh@linux.microsoft.com> <87e016ed7479a33be87128b01bb07d2e1807c87d.1791710735.git.weh@linux.microsoft.com> <sashiko-outbox-175607@kernel.org>
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

> Does this stats update in mana_xdp_xmit() lack mutual exclusion when
> racing with other CPUs?

I will leave this counter update unchanged in v8. This is the same
baseline lost-update issue reported on patch 4: CPUs can share a queue,
and the aggregate xdp_xmit update is outside the per-frame send lock.
That exclusion gap predates this series in both upstream bases.

The seqcount-corruption/infinite-loop consequence requires the 32-bit
u64_stats_sync implementation. Supported PCI MANA configurations are
X86_64 or ARM64, and CDX requires 64BIT; their implementation has no
sequence counter or fetch retry loop. The lost increments are real, but
the more severe claimed consequence does not follow on those builds.

Also, the submitted patch 7 does not modify mana_bpf.c. The quoted
counter-pointer conversion belongs to an earlier patch in the series.
Neither that conversion nor this MTU change introduces the existing
writer-exclusion gap. I am keeping the independent counter fix out of v8.

Thanks,
Wei
