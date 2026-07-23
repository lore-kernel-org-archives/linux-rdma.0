Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D986772622;
	Thu, 23 Jul 2026 14:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784817135; cv=none; b=DpQhdHSZzEkPt9m+iWwHQKy16goMZEN+sdr25QATcIsTf/q2IblzmTR6CZe6U0RH6Jcw/QKbHwJXAE0MAyEorjUKQWEcvG0jsvQYKjLSjvf6LcTtOEfpH7z0UPVQd7eomPbv1fxFv1ifaNTXZ/FGfOK9MkuI8WMkrprDv+USgnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784817135; c=relaxed/simple;
	bh=mCNea0V7U70nuT8+uBMyESudSsPmcb2xuMUW+oEWscs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DIQTnNwSxApmgaqSTf6Wo8HsvS7FQFXmivgk7JDNi1MiLTIGzcQ8nKz4VOMewg0QDaSjMcjPcKCrw6SVPwg700RAjiVTmuKI111bSzZItFDbB/lDikZMWmsNsATSkwuTXQ+0qKu7PWmsmrm9ZLfOpLHom1M7CXp5nIL2qQEUoGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1559C1F000E9;
	Thu, 23 Jul 2026 14:32:14 +0000 (UTC)
Date: Thu, 23 Jul 2026 07:31:53 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Cc: hexlabsecurity@proton.me, "D. Wythe" <alibuda@linux.alibaba.com>, Paolo
 Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, Mahanta
 Jambigi <mjambigi@linux.ibm.com>, Dust Li <dust.li@linux.alibaba.com>, Wen
 Gu <guwen@linux.alibaba.com>, "David S. Miller" <davem@davemloft.net>,
 Sidraya Jayagond <sidraya@linux.ibm.com>, Wenjia Zhang
 <wenjia@linux.ibm.com>, Tony Lu <tonylu@linux.alibaba.com>,
 netdev@vger.kernel.org, Simon Horman <horms@kernel.org>,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3] net/smc: order the CDC receive path against
 buffer publication
Message-ID: <20260723073153.1b7fabd9@kernel.org>
In-Reply-To: <20260716-b4-disp-aa52955a-v3-1-03a4411a7549@proton.me>
References: <20260716-b4-disp-aa52955a-v3-1-03a4411a7549@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Jul 2026 08:50:45 -0500 Bryam Vargas via B4 Relay wrote:
> No Fixes: tag -- the rmb_desc ordering is foundational (predates the git history
> here); the sndbuf_desc hunks additionally cover the later SMC-D DMB-nocopy path.
> Happy to split rmb/sndbuf for a cleaner stable backport.

:/ Fixes tag should point to the first commit adding the code if it
"has always been there".
-- 
pw-bot: cr
