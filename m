Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C52345EA1;
	Wed, 22 Jul 2026 18:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784744843; cv=none; b=tuOze+J7I6F+iixwybkY44UlCm4KUAK7IKKU5ga+Kpno4rcnSHf8swdnm41QrDbWQzCDS6SC3JflvKb+Qwd5xnlKvZP56Jc6xSjBhJ9RWJB6CgAbUfJTL1pQKaSZxh3ux1/jn7u0bEbtjjCA5TKArpo7gccpRhFpoSRDPU3+Fso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784744843; c=relaxed/simple;
	bh=m7RlWQyZwmxEvzbvqPeZIbHq9jUYYT9BY1gImNuhV7A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=agfc5GdVKBo1ejCGT6Gyl4qtxxaCbdFcH2pKW+2hfRnad9QhDcbqLml8EMkU/XCr3EyuRsxxwDbAgbuo6QjdeLTVF7v+dhj7xpiV/nar4Om4cBFFhTOXTMg27VDTdBDqXGJi4hCS4edbF+n6UNTfTnxoeDsYPDAsG23rWZjrOw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k7EV3kzn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k7EV3kzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EF51F000E9;
	Wed, 22 Jul 2026 18:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784744842;
	bh=H9cFNwAJqa0gBqFQQprbWBfHHZcBOgNqRCurddijShw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=k7EV3kznvlEKagA2+k4/zgbQhPsm5/Sw4ebi66/xpRuNWmNYS7tAH/yKu0uYmb26e
	 4f5YEp0soAnWFXNa9QzVc9NBNHyZ6qyMGkMtAkzeCeA1hLfANI7nIC4VU7k1f+Hu0r
	 /1VvgXrlr1MFcfq1WhGcoybCQC3WClm02A+cymLv57T+QFxsHNVGqMI3/MDrMi5xF2
	 YNCv468lGJebx29mRsJibtUuzgK717jTs0CuxPWeuvvDgN11WLXrVIqJSn9/1poBAJ
	 Iu01vdxLZL0LgWWS0BIrMaO4HwVFYkEl5/ZjDCFVOnqx7/uvID7SFh1NuW9exFr8Ou
	 JNnUy1sm8YjhA==
Date: Wed, 22 Jul 2026 11:27:19 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Xiang Mei <xmei5@asu.edu>
Cc: Allison Henderson <achender@kernel.org>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, Santosh Shilimkar
 <santosh.shilimkar@oracle.com>, Ka-Cheong Poon <ka-cheong.poon@oracle.com>,
 bestswngs@gmail.com
Subject: Re: [PATCH net v3] rds: tcp: hold the RCU lock across
 ipv6_chk_addr() in rds_tcp_laddr_check()
Message-ID: <20260722112719.17665461@kernel.org>
In-Reply-To: <20260714212239.1511269-1-xmei5@asu.edu>
References: <20260714212239.1511269-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 14 Jul 2026 14:22:39 -0700 Xiang Mei wrote:
> Changes since v1:
>   Use rcu_read_locks instead of dev_hold/put
>   Rebased on [PATCH net v2] rds: Fix inet6_addr_lst NULL dereference when IPv6 is disabled
> 
> Changes since v2:
>   Add change log

Why did you(r LLM) leave this portion of the change log in here and the
rest in the correct place below?

> Fixes: eee2fa6ab322 ("rds: Changing IP address internal representation to struct in6_addr")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Xiang Mei <xmei5@asu.edu>
> Reviewed-by: Allison Henderson <achender@kernel.org>
> ---
> v2: Use rcu_read_locks and rebase on rds: Fix inet6_addr_lst NULL 
>     dereference when IPv6 is disabled
> v3: Add change log to commit message as Allison suggested

The patch does not apply, if it's still relevant please rebase and
repost.
-- 
pw-bot: cr
