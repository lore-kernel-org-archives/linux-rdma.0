Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A21639151C;
	Mon,  6 Apr 2026 17:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775497898; cv=none; b=rcDShFXBpDaOo5hFfP3e1yKaMRiH66+utEfMsg2ZCqs4oadmwiPc1j7QWYrH00WR8JzMNxb/9xiKtO2y0KnLRDS7rxfKpN0p5Lz4YVf5E4fBMhRF+L50rkguagwWRLdkEfDGhyRUizDHeNK7ksTWJHTlVCd4FpJWIobmjeKrjXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775497898; c=relaxed/simple;
	bh=aOE7o6CfWDeEXlNasCvA6VtuO3c6A+iWm2BI/VVTy8U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QZsrjJpJxEn0K0q/04t62BzG9guSd5iiBaX6YCW0ZqP2Qkhm6Nm2EnM2GLC0eY4ErH0H1Iijm06CtFKC4/K31BXnI4YU/dGA7DDhxjUINtv4x0jnVsvTZNB/w3bpvuAo/A83qSJNHgxCnzO9Q2fgSvV5WU68mHZlAzo02TCJX6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RLWGHv2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RLWGHv2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB90C4CEF7;
	Mon,  6 Apr 2026 17:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775497898;
	bh=aOE7o6CfWDeEXlNasCvA6VtuO3c6A+iWm2BI/VVTy8U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RLWGHv2nHqR6OOlc3WD9/QohEKn5qnQ0C4IlpSX9N1dC2BeLGFibY+wyKS+IKcd3/
	 zmm5UPjEYYMXiZXlZ2pjNRmhki7GdfgVWCB4ok9RwJ40MQeSgIzG7a4D4b1xOov2RY
	 XlurxrQXxxFi3tcS9vXrGa0J7cldmy/HeoL6TIrl5ABZ92dcu/f8hwCyhUP60oyZu1
	 SZcVnOB1x/uxszZ+++xx/VeDJDyeQ7WGw05PkLndcURL1sXEovvBssdHqiKagVLyQL
	 Ua/8tOCgFLZ8gLpD9ZYnl1JBZrv9jrd1f5QGS6tazDVGFQIOslIxIiVvLsYOyumf7u
	 9cxsF0aXd0wqQ==
Date: Mon, 6 Apr 2026 10:51:36 -0700
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
 kees@kernel.org, dipayanroy@microsoft.com
Subject: Re: [PATCH net-next,v4] net: mana: Force full-page RX buffers via
 ethtool private flag
Message-ID: <20260406105136.5e02420e@kernel.org>
In-Reply-To: <adHTm2SvjDrezEdv@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <acrkwuIFyBXhwICF@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
	<20260330154755.6a8c73a6@kernel.org>
	<adHTm2SvjDrezEdv@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 4 Apr 2026 20:14:35 -0700 Dipayaan Roy wrote:
>   Function                        Fragment   Full-page   Delta
>   =E2=94=80----------------------------   =E2=94=80-------   ---------   =
-----
>   napi_pp_put_page                  3.93%      0.85%    +3.08%
>   page_pool_alloc_frag_netmem       1.93%         =E2=80=94     +1.93%
>   Total page_pool overhead          5.86%      0.85%    +5.01%


Thanks for the analysis, and presumably recycling the full page is
cheaper because page_pool_put_unrefed_netmem() hits the fastpath
because page_pool_napi_local() returns true?
