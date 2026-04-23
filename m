Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5960F271468;
	Thu, 23 Apr 2026 16:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776962008; cv=none; b=TjBQn7lFrBmvcjaFasLAIpGX4RO5BzdBAIAJVPw30W7mTFcMaMerVsHVPqouQS4J6EMe9KKAmEQ0RK6WFGCjy5+fIlBW0mNA45xbpHF1itlGRSf7B4IfOH9LG21zn4ELvzrVf30h+YOkUNlu6XDosXCrCOC0qOYsiFvJtSms2/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776962008; c=relaxed/simple;
	bh=VwZwd42cMVAV0goCHlzMO4LTjbsf11gIqrR/qAoL6jA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d3trt6ZPuhUt2bBFQShI8W7Vo9g4IzWrSXZ3TTFS62akovcFRMVEu6eYxVGHxIDbc+MvaDl5yz2MKvSXi/XGrXcuXJH7Q1eSJdMjSQgjsD4UBDAZOhhVeP0iQLCaZMaOimocmPj8deiMxtn8j0t3SUrVZPFamW2h6RpZDabq4gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cE2G68Jy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cE2G68Jy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985BFC2BCAF;
	Thu, 23 Apr 2026 16:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776962007;
	bh=VwZwd42cMVAV0goCHlzMO4LTjbsf11gIqrR/qAoL6jA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cE2G68JyAF/4s0DiDGfSDhQmctb5RNqsHDZDDoaJWoX/o0/iBagP0h7nPqz/bZ6ZU
	 my2P48n2loX5biCxup24LkHeVVkMbUj/hI1GqehRHmuYlkfs/044KEV5iS9pAc8Xkz
	 sXilEui/bG8GuIGmXiXodIOfCle7JeEbZEctMX4XFP4BpUcWKeQ0fOathtt3UuvRd8
	 UHH4zB/+Lf1l7ZrczvA2r3YcpfoHzNiL+04EBh/qUt2MpbOnZTITZDULWZ7kKyGR8w
	 Qb17bY3vjofBEvpKuKkGdhXQUlpoVy/vjEy4iOtHOt2aeVA9HCxDf/WBWS3diVv7ax
	 9F2uyKGkDolXw==
Date: Thu, 23 Apr 2026 09:33:25 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, leon@kernel.org,
 longli@microsoft.com, kotaranov@microsoft.com, horms@kernel.org,
 shradhagupta@linux.microsoft.com, ssengar@linux.microsoft.com,
 ernis@linux.microsoft.com, shirazsaleem@microsoft.com,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 stephen@networkplumber.org, jacob.e.keller@intel.com, leitao@debian.org,
 kees@kernel.org, john.fastabend@gmail.com, hawk@kernel.org,
 bpf@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org, sdf@fomichev.me,
 dipayanroy@microsoft.com
Subject: Re: [PATCH net-next v6 0/2] net: mana: add ethtool private flag for
 full-page RX buffers
Message-ID: <20260423093325.775a4ada@kernel.org>
In-Reply-To: <aeoVC27mIzoKytqA@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260407200216.272659-1-dipayanroy@linux.microsoft.com>
	<20260409183509.0b24dea6@kernel.org>
	<20260412125917.4fa8fc8d@kernel.org>
	<ad5kuCZz+gR1TlSh@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
	<20260416083146.0bb94d2b@kernel.org>
	<aeoVC27mIzoKytqA@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 23 Apr 2026 05:48:11 -0700 Dipayaan Roy wrote:
> What I meant is that the atomic refcount cost itself does not appear to
> be unique to the affected platform. I see a similar ~5% overhead on
> another ARM64 platformi (different vendor) as well. However, on that platform
> there is no throughput delta between fragment mode and full-page mode; both reach
> line rate.

I wonder if it wouldn't be more expedient at this stage to just switch
to rx-buf-len rather than investigating in more detail. But we can wait
for more data if you prefer.

> Please let me know what David finds, and I can rework the patch
> accordingly.

Haven't heard back. I pinged him now.
