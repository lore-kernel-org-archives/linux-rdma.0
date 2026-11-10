Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794350234;
	b=r5U+v77JfqagBgL0k1zTBAdyhWF53fuHkW44k7RdQsq+fHie18qBWGm6sIoxj0Ao+IxW
	 ugSzvBJ8wTc93sa9TvLlpeYt1Bj+/IkJeOwrf8/AX0cIXYN3HATebndzTVJTGS5YymM2E
	 Yn/EVXRD1D9hjSWu7AUPPBHe+Qp+SvSqBwk6NE/RFmtIFWATcXJGayI+YSaik9GmGT1x7
	 biUwTd36r1inlBt64w1cH1ADvhs+HmWJJdZih6Wzcz0Kz0pfb86OALcuXgH9e+/uQnlgL
	 plM6/o9oPH6r/jlDYZxXdIuMFFTvOMugJZ/MrTfAC10CXnX6C/OwjPfWwu8/RVmAVAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794350234;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=iMS4Ufw6oLz0jxlRn0HZ4WRoRoCLrOY1iIoKp6s0bcg=;
	b=sAUWqXxr6unvyVyGtf1mctOdAUncQeMpTQ5vRRvlCTToNG+fyukPo7oJz18q79b1pIfH
	 IYGx1PuYrAzXB2Cfvab5gHHcVKy48ixd9ihdV9GCydPaIOnE+6gmvlbEkgR3BRTElm5BC
	 7h9lXgLg25Hfq3lt9M4mJsH7IFgC33CRAtjgK/yQC4MmT3G5Kn8clQrRoaMPH/cjbs7lj
	 8ctYdQKpApXIpUHQed0xnGvEaNV00WItkVfhy/+EzQ7i4SECYc68En4pfqzYpKgzN+4V9
	 H2Z4C7vlcJyNflxVRZtAKhv1H0t/NlacDKLSbA21ONQLAOkgYF4J8znt/bG9k8P/DsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XSrafjLU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2AE606A31C;
	Tue, 10 Nov 2026 22:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XSrafjLU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5561F008A2;
	Tue, 10 Nov 2026 22:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794350233;
	bh=iMS4Ufw6oLz0jxlRn0HZ4WRoRoCLrOY1iIoKp6s0bcg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=XSrafjLUY47PUGSIDCgHxp8gdbmVLU2OR2SY2FmhaEWsenRuM432FQAGVenZvU0D4
	 HTAFn1EOHS4zMJBVOWehiTkfLwhDZAxJ17Gw0xldhMGHo5fLsAnSCvGW+ZltKfq0jV
	 MQI0V1bMYEvaTD8SXU9RD8+88iaMymTzkoxpLpELe5zaulvAEKXIvBBOzWFcGFRgc9
	 mPHwpwEizkkJ2VQK6KkH61FnlA7GyGKRjOlAD7/VnUvfBF6GDLzmu00vNbyiEoO+5C
	 YPxkv/zbA+4kwvQwTpoFiAO5twLPjn1hc22xJFSdOgUL8YIl46hBCw4XTwzMW8HXOo
	 PC+GCdZjo93cA==
Date: Tue, 10 Nov 2026 14:37:11 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Stanislav Fomichev <sdf.kernel@gmail.com>
Cc: netdev-bot+sashiko@kernel.org, netdev@vger.kernel.org,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 andrew+netdev@lunn.ch, edumazet@kernel.org, horms@kernel.org,
 corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org,
 michael.chan@broadcom.com, pavan.chebbi@broadcom.com, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, alexanderduyck@fb.com,
 kernel-team@meta.com, sdf@fomichev.me, dimitri.daskalakis1@gmail.com,
 almasrymina@google.com, dtatulea@nvidia.com, bobbyeshleman@meta.com,
 asml.silence@gmail.com, daniel@iogearbox.net, razor@blackwall.org,
 leitao@debian.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
 leon@kernel.org
Subject: Re: [PATCH net-next v3 1/9] bnxt_en: let the stack segment GSO skbs
 with too many frags
Message-ID: <20261110143711.1421385b@kernel.org>
In-Reply-To: <e4def2839d68382fd50e4fe1e6b4f116@gmail.com>
References: <179418737248.994134.10509157155829463489@kernel.org>
	<e4def2839d68382fd50e4fe1e6b4f116@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 09 Nov 2026 10:29:20 -0800 Stanislav Fomichev wrote:
> > The commit message describes both problems. Without a Fixes: tag, stable
> > kernels that carry b91e82129400 won't pick up this fix.  
> 
> Will add a Fixes tag, but not sure it's worth the backports..

Either it doesn't matter and targets net-next or it needs a Fixes tag
and targets net. Ignore the bot.
