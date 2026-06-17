Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC740313539;
	Wed, 17 Jun 2026 23:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781738697; cv=none; b=j9vtC96NDMIen1Qq66K/rFpOoLUAm3iglXz2gkzcSBhp75RsVEybcMEjKZom/gkli2As/KPYa3FR3qhP7BxhTfHG/gxzDd4pAsaweJw4faEXDRxgtBCYyBf7nTZR80aRINphllnWH5C+H4uqAjk8gOzjFfXVcWI2gEdgqIOAu3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781738697; c=relaxed/simple;
	bh=+eI17Fy+wVIe18UVPp034CydNAaGOahSn2tIGzBPJCU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VTgvhzpbe/7SwHf+yrtZXkSkB4ASDJ5Y6Jr8Vn0H3gMsKbwjSRW1W591GduKwz0xr9xewBt62sUfj/cDmZ+ZbkZgSAFY1FiaPwvjIoUjbBVu7oJtkLfSprNd9meJ/vHBeb1Qvr6PwjAF5gEy5hn49MXvdDQa+QP15vkKUBHxkuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YENY/Sh3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YENY/Sh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B561C1F000E9;
	Wed, 17 Jun 2026 23:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781738696;
	bh=r5uSA66J9ABM/9yH9MNLyLHNRWzKIhhr4br7s8vfmak=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YENY/Sh3Yed6hgB9DUIcwtRPpc0H+4BrXWXFxaL/P54FnFkM8icFFcQLmWtAvl4tJ
	 ldF2DhiYUCTuptBfefapfZopXADowAkgq71dMni6QSLpvEDkHSeN9qI3q3CzECu/GH
	 YOPI76roAKAOh6uBQgfYVmQXNlNPOWT95WlCX0d0oW8Rc6gKUSXV4HeA8owkpBu7k0
	 rkXneckPctgOlTl/SIv6YM9GtnDvOh6ndBw4kBDTB45zcW7UNzfvsTqbbEuiuD308x
	 eT3ebr5lWS+l1GGgtzxSXUwbMDQzi+hNVlz21ENIP/5Few58KctkEFHe+r36HmDZEP
	 W/RtdagPbHo0w==
Date: Wed, 17 Jun 2026 16:24:54 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Cc: hexlabsecurity@proton.me, Wenjia Zhang <wenjia@linux.ibm.com>, Dust Li
 <dust.li@linux.alibaba.com>, "D. Wythe" <alibuda@linux.alibaba.com>,
 Sidraya Jayagond <sidraya@linux.ibm.com>, Eric Dumazet
 <edumazet@google.com>, "David S. Miller" <davem@davemloft.net>, Mahanta
 Jambigi <mjambigi@linux.ibm.com>, Wen Gu <guwen@linux.alibaba.com>, Simon
 Horman <horms@kernel.org>, netdev@vger.kernel.org, Ursula Braun
 <ubraun@linux.ibm.com>, Stefan Raspl <raspl@linux.ibm.com>,
 linux-s390@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, Tony Lu
 <tonylu@linux.alibaba.com>
Subject: Re: [PATCH v3 0/3] net/smc: bound wire-controlled CDC cursors
 against the local buffers
Message-ID: <20260617162454.33e95c2f@kernel.org>
In-Reply-To: <20260614-b4-disp-edd64be9-v3-0-551fa514257e@proton.me>
References: <20260614-b4-disp-edd64be9-v3-0-551fa514257e@proton.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 14 Jun 2026 03:23:29 -0500 Bryam Vargas via B4 Relay wrote:
> A peer's CDC producer/consumer cursors are copied from the wire and used,
> without an upper bound against the local buffers, as (a) a raw index into the
> RMB on the urgent path, (b) the receive length in smc_rx_recvmsg(), and (c) the
> send length in smc_tx_sendmsg() on the SMC-D DMB-merge path.  A malicious or
> buggy peer can forge a cursor so each of these runs past the relevant buffer:
> an out-of-bounds read of adjacent kernel memory (disclosed to the peer) on the
> receive/urgent side, and an out-of-bounds write of attacker-influenced length
> and content on the send side.

Once again, SMC maintainers -- please review.
-- 
mping: SHARED MEMORY COMMUNICATIONS (SMC) SOCKETS
