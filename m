Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F2A257452;
	Mon,  8 Jun 2026 10:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780915761; cv=none; b=NzLodJlsYaxC2Rsm4LS9VL+Fh2hk/tflFZ3bEcifvPrrmOlP82F4sCLQCuvDHXc84Hz3a3CRyaddPK5TQ7OEkpBn5mBjZN2VMhy96cXLP8dUJGI7tibSkatHBjlq+FslynH4g97pXgoqPbhMv+XuKBcnZ7FH5ptzvpE43jF21S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780915761; c=relaxed/simple;
	bh=6z5TwCvxmR0oWhUIZDHw7icnAILN1BrQclLdwGydBNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QCrbOivNQz3XhnYybTaHD0Ny9BqRmZwuWN+tsgzttac2uNYesDRbAGOTiOrGEZvW8SQUFgxzkYfMAb6fAftMPF6C33q1e4FL9inN2+wD0/Gq5XZy/f8mEpJZp+gnlIdFXXjXg55ze+Oo0GeHZQ+jjX355m4q+heA46in286OnOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=Ok33r+3S; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="Ok33r+3S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+EQqr05hh9fgha9YNXLz45sYz2lpixlHYNaQiqO6rYk=; b=Ok33r+3SNj5issGl/MqqWKjyrb
	pqT7KiM4ZQwh1ai+OFt3w0nA9/TsxkF1CZBkx7Pl/M2iEeCSmIz87a/YlUcgmcg/1cz2b+Wvy3dHL
	sY2Tmpje0aQ0cy4GHko8mVtc8Lfzl3HDQONY3R8bGJN9smS5hw5PNNi4cUzUR4Utqk4ep89TQdjY+
	ulgvF8bydEciMhkWE3cLv5gQSQA57G1JXk7FUVGuLfCQzn0DkHr/tsJnDDBm/2GH5AGgzRF4IB3ft
	F8BBzTPc883o8adKD1TTmurpy79pZzC0YTu8EVA/scww2nrgf5vJliSNVKo0eH3jawJFLQHjPpAcO
	2y6Q9uIw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wWXXU-007ZTp-2L;
	Mon, 08 Jun 2026 10:49:04 +0000
Date: Mon, 8 Jun 2026 03:48:57 -0700
From: Breno Leitao <leitao@debian.org>
To: "D. Wythe" <alibuda@linux.alibaba.com>, 
	Dust Li <dust.li@linux.alibaba.com>, Sidraya Jayagond <sidraya@linux.ibm.com>, 
	Wenjia Zhang <wenjia@linux.ibm.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>, 
	Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Shuah Khan <shuah@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH net-next 1/2] smc: convert to getsockopt_iter
Message-ID: <aiaeBuPC6e-rsaxY@gmail.com>
References: <20260605-getsockopt_smc-v1-0-65da62fa44c4@debian.org>
 <20260605-getsockopt_smc-v1-1-65da62fa44c4@debian.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260605-getsockopt_smc-v1-1-65da62fa44c4@debian.org>
X-Debian-User: leitao

On Fri, Jun 05, 2026 at 05:13:25AM -0700, Breno Leitao wrote:
> Convert SMC socket's getsockopt implementation to use the new
> getsockopt_iter callback with sockopt_t.
> 
> Key changes:
> - Replace (char __user *optval, int __user *optlen) with sockopt_t *opt
> - Use opt->optlen for buffer length (input) and returned size (output)
> - Use copy_to_iter() instead of put_user()/copy_to_user()
> - Add linux/uio.h for copy_to_iter()
> 
> SMC is a proxy socket: only the SOL_SMC level is handled locally, while
> all other levels are forwarded to the underlying CLC (TCP) socket. That
> socket's getsockopt() still operates on __user buffers, so the
> pass-through is limited to user-backed iters: optval is reconstructed
> from iter_out, the original optlen pointer (preserved in sockopt_t) is
> forwarded, and the length reported by the clcsock is mirrored back into
> opt->optlen so the core writes the correct value to userspace.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Damn, this is not building. let me send a fixed version (v2).

--
pw-bot: cr
