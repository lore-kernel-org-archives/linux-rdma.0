Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1721849F12B;
	Sun, 18 Oct 2026 12:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792328125; cv=none; b=JaGXQXMfHTMa11CmsXSzXaw5vYzvpWmO5WPlCseMu4C/jRVFXZ1W3r81uibBXx5YfXuWRymKVkrtTMtaTGcu6nm1lQcplwlTic9Eq7SGup6oiCGL0xREMgWOn9LX/rldYStIOVJP1Fq50rzJ4AVy0F+3QhvOy5rWQB8wL4gGSF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792328125; c=relaxed/simple;
	bh=680s3p/4km2avW6oqRYoU9OZh2xsbUZBPuIMcApqAqE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lIdP9Yc3Mcj7Irc+832hWLRVVMchX9acn+XSbxODqSSfyi9k4vCaEYQiwLpdYaISKIIuo/95R2qa8fUjoacT1Eur7gUmNmTaZC8qtqx67T0RboMZ0NE8NO6R7Vs15cB9J//ljPTkvrDvtZQdYTBfaYARgAcc4UhZnoEGVbeopso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iNPNue4I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iNPNue4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD331F000C6;
	Sun, 18 Oct 2026 12:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792328124;
	bh=tPZvxr18psUo+iJLn+gqHxeX1JtATabu4FfpskVFjaM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iNPNue4I+2PgEGfVb9x0HKZWcr2XUgmQ4K7+eiu9Yz0Ia+N/UAz1y2pWPmhA6/V7/
	 /z+K1Yk05twGPBwddFSIn/L3tJ2n3ww5Hsh09cF6lU6prZN+5Gf/nr1ACrOCDaC6E6
	 iIBRfK5jHxpzTuICWJKKcVMbkQRC00tuO6R+YjJUevNi1isIAyOX1I/L8DSoyzzd5V
	 Fe4QYvfnKUdbykXntvxulDygzMb0cMwNZuwzbUDVgitcNudvafrVWlWFj96b9z/05L
	 ja1XhUYS2tEwqUvfDfrIxhVHbbChEaOhSO8OBwoITXrX/OBbziHPcRgsCEINci3rlI
	 nb0yOInkUJPrQ==
Date: Sun, 18 Oct 2026 15:55:20 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Yuho Choi <oss.patchbox@gmail.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Ariel Levkovich <lariel@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>, Alex Vesker <valex@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Itamar Gozlan <igozlan@nvidia.com>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 0/4] net/mlx5: Don't free CQs whose destroy
 failed
Message-ID: <20261018125520.GE64621@unreal>
References: <20261016045849.813696-6-oss.patchbox@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016045849.813696-6-oss.patchbox@gmail.com>

On Fri, Oct 16, 2026 at 12:57:45AM -0400, Yuho Choi wrote:
> mlx5_core_destroy_cq() can fail

No, it should not fail. If it does, the firmware is completely broken
or some other catastrophic bug.

> nd when it does the CQ may still exist in firmware with access to its buffer and doorbell record. It
> also returns early in that case, without waiting for EQ handlers that
> may already hold a reference to the CQ. The four helpers in this series
> ignore that error and free the CQ buffer anyway, while their teardown
> paths also free the object that embeds the struct mlx5_core_cq.
> 
> Keep the buffer and the object that embeds the CQ when DESTROY_CQ
> fails, as the regular mlx5_ib CQ destroy path does. The HWS send ring
> CQs are polled and never armed, so the HWS patch keeps only their
> buffer rather than passing the error up through the queue open and
> close paths.
> 
> The issues were found with a static analysis tool from ongoing, not yet
> published research, and confirmed by code inspection. None of them was
> reproduced, so this targets net-next; I can resend for net if you
> prefer.

Please drop this series. The flow is impossible in current HW implementation.

Thanks
