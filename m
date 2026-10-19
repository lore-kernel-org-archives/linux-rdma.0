Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83872496D49;
	Mon, 19 Oct 2026 07:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792396583; cv=none; b=UC0zBFJAnl4UtkjJX6ECyMl1tQUoYwEyX/YtJeT1WySYCv1qRRNtpHSR4jEuEto3q3Tue5Nbnbsd3gOdKn/1s/tkJoe4xUFvqv/5GgxfDWg133SZm9WEW7Qm6ZWY2FKnrqVCHUdbI7W6nAgJssTC2le5zHDOMjD+dIA1SgQZL6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792396583; c=relaxed/simple;
	bh=TgCp11TS45jPwnOT9kcVqhH23ZeASbRV/tVwNFU3PP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H0MNAb5efhlUTEvK9sXy2XBx0uy1W8tGkBhSVT+jcprcwxASTqVgusKAqLax2ueavDO6T2vzgVSaKLLC7IPn+j/MHl6wqbb9S69FE9MWdc2vVAPOXn2484FSPeAgVHVGpanL33LtA2l28W84KFiHQlEKbDSOkw6N+hhpmzHz4GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=lpPC92ZQ; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="lpPC92ZQ"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792396569; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=TgCp11TS45jPwnOT9kcVqhH23ZeASbRV/tVwNFU3PP4=;
	b=lpPC92ZQflm3dCz6D4bR+Sf4ZZnMCPRvM7ppuJ2BKDhz1WLqOVAArGO8A+QiVwZwGKmX9uA8oBoKZSysCwU+87uWPUjS/Y+NfVxFlBmftRXfbd5CGg9Q+F+/UcJtrgdwtEuzKSREs2pxG71x1ABHbTdbHW3UBpxY2kaQ/xC3LJs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XD1w5KN_1792396569;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0XD1w5KN_1792396569 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 19 Oct 2026 15:56:09 +0800
Date: Mon, 19 Oct 2026 15:56:08 +0800
From: Dust Li <dust.li@linux.alibaba.com>
To: tikipiya0531 <tikipiya0531@proton.me>,
	"alibuda@linux.alibaba.com" <alibuda@linux.alibaba.com>,
	"sidraya@linux.ibm.com" <sidraya@linux.ibm.com>,
	"mjambigi@linux.ibm.com" <mjambigi@linux.ibm.com>
Cc: "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [net/smc] clcsock_release_lock not held on fallback
 poll/sendmsg/... (follow-up to 64a6b36b)
Message-ID: <atXNGOXEMZLlaRFH@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <Raqdw_agFcPtAnTmvvz2owgVpblVtRzIrVJdEpHDL4PYX7qC9ULPfcFRyimT6NUQmTf9f17Gp_nawYoiqOwPUM45xtk8G9OK_LjiTgZxG7s=@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Raqdw_agFcPtAnTmvvz2owgVpblVtRzIrVJdEpHDL4PYX7qC9ULPfcFRyimT6NUQmTf9f17Gp_nawYoiqOwPUM45xtk8G9OK_LjiTgZxG7s=@proton.me>

On 2026-10-18 14:47:41, tikipiya0531 wrote:
>Hello,
>
>Please find the full write-up attached as report-en.md (same content
>summarized below for quick triage).
>
>Summary
>-------
>Commit 64a6b36b0e18 ("net/smc: protect clcsock lifetime in smc_getname")
>added clcsock_release_lock around smc_getname() because link-group teardown
>can call smc_clcsock_release() while the SMC socket is still open. The same
>unlocked smc->clcsock access pattern still exists on several other paths that
>touch the CLC socket in fallback mode (and in SOCK_DIAG fill), without holding
>clcsock_release_lock.
>
>I am not claiming a reliable exploit on current mainline; I am asking for a
>small hardening sweep similar to 64a6b36b and c0bf3d8a943b.


Hi tikipiya0531,

If you are asking for a patch, please send a patch with real bug evidence
in the commit message.
The report you sent looks like a mess of AI-generated things without your
understanding.

Best regards,
Dust

