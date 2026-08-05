Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A894399CA;
	Wed,  5 Aug 2026 11:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785930495; cv=none; b=jf2Y7SX/7Jp7+KLBsC4F2rr3JBChGUGgz1mXNpMnQ92jiYJUIf6mGaEdoHijY8a64YlC0cV6hE71NmBOb5Y3bDkNQECdgnOSilBZ4me/bWwNhAuyPHxKUW3qAgX4muEySA6p+qK3lIkrlkfiBXZdNk+FC3T67JJBUeZxN9KgyAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785930495; c=relaxed/simple;
	bh=NJPRGsrrTAbHiHAiWOaYmamg+izygMMuuq/c/oSMCek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EJFIlq/xV6U7DCMtPg9b7j92/qDHu4u6CWHhuCoOwxUQgRmnAYw01rc+R3rQ+BadpgK84MpgO7otsWZdcn+TMdEr6CRcEJaxQCfc6krGSJ7kZ3pp44v+8I4hcjGemHVq3PB8wVXaH4N1vFm8wjza7mE+ftj5JcultqWf4lWLopY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=d1Tlrh9f; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="d1Tlrh9f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ns4L5hU6bxgeylbbqGllG2FVT8GWCxbYTLTimt/3ETM=; b=d1Tlrh9f3P48baAUJb4HSFfdoM
	CvOKQg4V+l2fxuCRO24pkrrA/YWnRmvAI+XycPQdsgejFExY3ruoVhIGRFow675lAImFok/+NCD45
	qdV/qW9UnMeG+GeklA1ZX8R5hj8BoXDEkAUidlh/FgxNk61Tt7rSSwZlVcisXfPvbCKhsXF2Yzjap
	jmTga2dpg8JdWFj6Az9b5tMp9KGlB0RAxwr8nq8q/Az27brFJbIxLNphn5fhgUCYJYu0fCC92DTB4
	vZmDogLdj/1fly5RGNwU58UxrhTmBDqPWg72E91JmZb/6NWmYkulBkLORSBSY9I5uM0ub+5dzXJ7u
	GJlo/ofg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wra6V-00DtVa-0A;
	Wed, 05 Aug 2026 11:48:11 +0000
Date: Wed, 5 Aug 2026 04:48:04 -0700
From: Breno Leitao <leitao@debian.org>
To: Haiyang Zhang <haiyangz@linux.microsoft.com>
Cc: linux-hyperv@vger.kernel.org, netdev@vger.kernel.org, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Konstantin Taranov <kotaranov@microsoft.com>, 
	Simon Horman <horms@kernel.org>, Erni Sri Satya Vennela <ernis@linux.microsoft.com>, 
	Dipayaan Roy <dipayanroy@linux.microsoft.com>, Aditya Garg <gargaditya@linux.microsoft.com>, 
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, paulros@microsoft.com
Subject: Re: [PATCH net-next v2] net: mana: Extend RX CQE coalescing up to 8
 packets
Message-ID: <anMikirGHvq7ne_q@gmail.com>
References: <20260731212306.4098773-1-haiyangz@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731212306.4098773-1-haiyangz@linux.microsoft.com>
X-Debian-User: leitao

On Fri, Jul 31, 2026 at 02:22:53PM -0700, Haiyang Zhang wrote:
> From: Haiyang Zhang <haiyangz@microsoft.com>
> 
> To support up to 8 packets per CQE, update related CQE processing
> code and structures.
> Update ethtool handlers to set this feature.
> Update per queue stat to show the coalesced CQE counters.
> This feature is supported on NIC hardware showing the relevant
> PF flag.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>

Reviewed-by: Breno Leitao <leitao@debian.org>


> +/* 8-pkt mode packs up to 2 packets per PPI entry */
> +#define MANA_CQE_COAL_PKTS_8 8

nit: The name encodes the value, so a future 16-packet mode would need
a second macro with the same role.  Wouldn't something like
MANA_RXCOMP_MAX_COAL_PKTS age better?
