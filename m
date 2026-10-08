Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1DC39CD0C;
	Thu,  8 Oct 2026 21:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791493894; cv=none; b=Gb6tIXnalS32+ztrcaDlfAIx6JWjkR2X6mNM5Hs4DwUVOdfTtI/SM7wahKVQT57szhYlmzLMm+OQSWY/I4uVSYI+EM+ptGWv4ENM7CAVPPmFCv92r5skUNB9VJ6d24B9iq+mI5K5/3qffdsmdTDkvcG74O2tB0CVzhWyYdte0n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791493894; c=relaxed/simple;
	bh=7/UEndRd74OcUhrKE4U3rZA33QYkjSU+ZBLqfYWJJvg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZJwQO5LuB9kMOc3VxJgevDYWM+DQt/Vs87pYn9KKSSipmR+5JBpUNcOxA1nKN3CGy3zKGSiOzRzPG+nEVRdudUx8d7qEQhsDduIaVjlWjljpn7acSVLv1gZvlbGjaC+cJiIFORDgRbb/+PUpuO3GkbqUPdXPUiDXvbBPzAj0xz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S706qOQl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S706qOQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0CF1F000FF;
	Thu,  8 Oct 2026 21:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791493892;
	bh=lO9Q2e8Y8FPOsNAN94Y+ZK3KJEQqlWXugM2M+fiTfDI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=S706qOQl1KAdCZOgdDVMYgOE4hYOCFoLj0OyQ4qoN9BspPLdeodADinWXSjmhRHPm
	 YK6++L4AqfMMStuF3wzAtgh6ofzYLZyTuNkxuyHRftbWxys9dfl71hAL2ADlumB2j4
	 Tlf+AacXZTvAllcV36WUE+Y/a0IFDRwSp+VV1bOhp608vbuhGe4I50uG/6bjXTuRbU
	 MgtwPQ9PON+9mJdWcdYRCA/L+ckiTY+6L5j/raZg/L3j8/d3+Hj0xoxEow7kB5Iox5
	 crTPl9+UhAUBLNXTGVR130JjQDVJHP9OplaEfsJcnRyehfe3Di3kCPBvhOprydKfRb
	 IRpNlHZe0yUqQ==
Date: Thu, 8 Oct 2026 14:11:31 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Andrew Lunn
 <andrew+netdev@lunn.ch>, Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan
 <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky
 <leon@kernel.org>, Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>, Oleksandr Tyshchenko
 <oleksandr_tyshchenko@epam.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, Manish Chopra
 <manishc@marvell.com>, Rahul Verma <rahulv@marvell.com>,
 GR-Linux-NIC-Dev@marvell.com, Shahed Shaikh <shshaikh@marvell.com>, Simon
 Horman <horms@kernel.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 xen-devel@lists.xenproject.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v2 00/10] net: stop calling __pskb_pull_tail()
 from drivers
Message-ID: <20261008141131.0ac356dd@kernel.org>
In-Reply-To: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
References: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 08 Oct 2026 21:02:47 +0000 Josef Bacik wrote:
> v1->v2:
> - New 1/10: skb_drop_empty_frags(). xen-netfront, netxen and qlcnic
>   relied on __pskb_pull_tail() releasing zero-length frags even when
>   there's nothing to pull, which pskb_may_pull() doesn't do (Sashiko).
> - xen-netfront, netxen, qlcnic: call skb_drop_empty_frags() after
>   pskb_may_pull().
> - skb_drop_empty_frags() checked with a boot-time test under KASAN and
>   kmemleak, on cloned and uncloned skbs.

Please keep in mind that we ask people to limit themselves to 15
outstanding patches per tree. You have 18 right now.
(200 active netdev contributors + an LLM) x 20 patches == insanity :/
