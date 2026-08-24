Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FDD37B407;
	Mon, 24 Aug 2026 17:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787593489; cv=none; b=Iun5ioQ0pqhw1yqbTYfrMY7Lh3c/3FxHQX20VcPkv+RptL9S1odRqfcj/DQJCRwQNPlFZEGCD42i3ZN/rB6hsf8iJyzHYDhMas+mQyIf671YMMNCEVx+WrrgA9H7W1aFY8iUqC6uLyty/2IbhF9yCPilzVlVgHxVV2bqKjir+Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787593489; c=relaxed/simple;
	bh=5RVUR7L0TAJrmEPRLJ47R/yFU6FVmwj1SlAhWvACNYs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NWhzW2PMgsqoNKPwGtIUEmiFND4qQFzF/9+hYpT1LGYztOEMoAT8uGcUZpFTNnkGPQgprTPzsx/VeJXdQNEwSlhDtmztHdGmNTJxZ66bPmhDWYpSLWtJRINDYfGvlhvqDCCJUJ4MA7ANt9PLRcQ3u/FNzF8U2F/sd7H621cM/CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TzxK/FXT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TzxK/FXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACA81F000E9;
	Mon, 24 Aug 2026 17:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787593478;
	bh=cwM75j6Ct06d8edJFVPqmdjfyWWFtH2RX/SZGqU7M7o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=TzxK/FXTk9/LwKjKVHKtCOBg2i+z8se3vWgp9CkvuA4mGrcMzc8lqyozqioeAvBZK
	 V7aetApjHfa1L5ZeYKaKZ4sIoRLbPQFBdsZ+3Ns8mYXgelqQXWrN1OnMLNeNzHFDj4
	 qYuFeKhqMOCBu3IirXxcMdYWuQu5uVGC5j7fvNgmQVX2ybZT1zzr8yLsDOGp5msh4v
	 W4f7domEL1vvnfs7jcyryNHypgMQaU/Anmxx+5lBrKF/q4g7vjM3arMp+35ISIWFO2
	 ElZ4n0bFQELjYqjpF8OryXeZ37gsCnCHdpw2Yrw72SKKUUQahKH29rV5WEqQOnzn5+
	 31h0cyGdC15YQ==
Date: Mon, 24 Aug 2026 10:44:37 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: mjambigi@linux.ibm.com, wenjia@linux.ibm.com, wintera@linux.ibm.com,
 dust.li@linux.alibaba.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, davem@davemloft.net, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, leonro@nvidia.com,
 pabeni@redhat.com, edumazet@google.com, sidraya@linux.ibm.com,
 jaka@linux.ibm.com, oliver.yang@linux.alibaba.com
Subject: Re: [PATCH net-next v2 0/2] net/smc: fix v2 slot clearing and
 reduce TX slot contention
Message-ID: <20260824104437.11adefb8@kernel.org>
In-Reply-To: <20260821091702.21458-1-alibuda@linux.alibaba.com>
References: <20260821091702.21458-1-alibuda@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 21 Aug 2026 17:17:00 +0800 D. Wythe wrote:
> This series contains the two reviewed patches from the previously posted
> "net/smc: transition to RDMA core CQ pooling" series (v4), reposted as a
> standalone series so they can land independently. The remaining CQ pooling
> patch will be reposted separately after these two are merged.

## Form letter - net-next-closed

net-next pull request for v7.3 has already been merged, and therefore
the net-next tree is closed for new drivers, features, code refactoring
and optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens after Aug 31st.

RFC patches sent for review only are obviously welcome at any time.

See: https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#development-cycle
-- 
pw-bot: defer
pv-bot: closed
