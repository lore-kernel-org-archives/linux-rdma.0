Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795447316;
	b=VsLS9ab2kImdrRfFcIAqBPeuibbbiQ1MbrWDCKw/vicqGXT8yj9hNauOdDa8vaieGPQR
	 mGGLDOqv1kJpAMKAQOXr40ioyY0r2vMed9ckzSBeri6hk0IKBHDtZMG7N+e0EnFGEfJ12
	 2+gRPvDNCNS7H7mqenBBnaFvtRZHv1ZLQWP6PK64PTGAKhzemzRKgoxvWZYIoPWmmxTkU
	 aVebmFrqUwmBT3cAL2cA5utxkJPniG4sapMuAHqRYxqa5x/eMMlAJRVM66HJDmMXvuxzJ
	 jOP00Ru0SZ5k3Nvb9Bt6b9SfGv63UYsxR1TsLyfUpxK2slCIfDgL7jgkzSXpfg6s9xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795447316;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=STKKGhMDLzI7yW9S72yonEXwLFCwhDpVjPRmQQOrHEs=;
	b=Hsq546nTrEoYoKdSqm0dNw1b9i4fJ24d1u3pIsKS5osGwlxvtttbCBjoT/nf114/2l9k
	 W0EhAgl7pD4bq/xNgDkwoDFFjtUxbEU+YK9O7Lq6v2Uk0akLOX9AveEWZgJ9+iZNANXBp
	 OLKQqYVm0SF7cNlrrCXe597AmVhodIPfHPnG6VTG29+MrnEgqW1lFV3vxlvmc9eHYJppe
	 AOBh+1zYoXeEdRCZGCuDdWeZJYrGfNT7ldgh1xrvv07Xvwt2Rb0JUTstkhoaJMITKKPnP
	 RUz08tCCSvW+d0/GWYeXve9K2p76zVhLba/yX3N+tzRz7XNekNJgOVCwuax0MVg6K6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=EVnfaTKD;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D46E1606A6BD;
	Mon, 23 Nov 2026 15:21:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D46E1606A6BD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=EVnfaTKD
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id AAA3A20B7168;
	Mon, 23 Nov 2026 07:21:50 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AAA3A20B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795447311;
	bh=STKKGhMDLzI7yW9S72yonEXwLFCwhDpVjPRmQQOrHEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVnfaTKDGMuYZQyhfGpkSIL81h4ys9JfX86fu36lJR4jCvAku98oTcIj8Q4LQKEIk
	 TxFH9eNN6ViklP+IAd82FgA+KiyklUnEy+UaRoiyGHCh/whGFYt51adLABKxxn6XXi
	 FO4KtEwu6jgz33lT0E+kAEa7BpKmOdl/9nRUYQQY=
From: Wei Hu <weh@linux.microsoft.com>
To: netdev-bot+sashiko@kernel.org
Cc: longli@kernel.org,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gargaditya@linux.microsoft.com,
	kees+treewide@kernel.org,
	kees@kernel.org,
	mawasthi@linux.microsoft.com,
	weh@microsoft.com,
	edumazet@kernel.org
Subject: Re: [PATCH net-next v11 4/4] net: mana: add dynamic HWC queue depth with reinit path
Date: Mon, 23 Nov 2026 15:21:46 +0000
Message-ID: <20261122064231.hwc-v11-netdev-p4.weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <179527857414.3135.3409829551491930106@kernel.org>
References: <100c6b7a71e86c8d7afd0c55f6b231f01db184d5.1794751992.git.weh@linux.microsoft.com> <179527857414.3135.3409829551491930106@kernel.org>
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

On Sat, Nov 21, 2026, netdev-bot+sashiko wrote:
> Could the doorbell validation go into its own patch with the Fixes: tag,
> and the dynamic depth work be sent without one?

Yes. Doorbell validation is patch 1 in v12 and carries the Fixes: tag.
The depth change is patch 5 and has no Fixes: tag.

> Can the PF meaning of MAX_REQUEST and MAX_RESPONSE be confirmed here?

Yes. MAX_RESPONSE limits what the VF sends; MAX_REQUEST limits what
the VF receives. With MAX_REQUEST=2048 and MAX_RESPONSE=4096, the VF
may send a 4096-byte request. I've kept that direction in v12.

> Does the PF know that the rebuilt rings are larger than the bootstrap
> rings?

They aren't larger in v12. The PF uses the same 4 KiB descriptor rings
after rebuild. The reported depth changes how many requests can be
outstanding, not where the rings wrap. If the reported depth would
require a larger ring, v12 keeps the bootstrap channel.

> Can this overwrite a timeout that the PF set during the rebuild?

Yes, restoring the saved timeout in v11 could overwrite a newer value.
V12 doesn't shorten the timeout for the private EQ test, so there's no
saved value to restore. If the candidate fails, v12 tears it down
before rebuilding and testing a depth-one channel. If teardown isn't
acknowledged, it keeps the HWC resources and returns the error without
trying the same destroy again on the way out.

Thanks,
Wei
