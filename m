Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFA7563295
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 18:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792003450; cv=none; b=i7HDO9blaROdXWanc7KFmOyajodfgYZ849KVK3M2RPoG74u2A39CYd0tQYNgby2DznFP6RnHp5yeyxoGTBkCCU7MHgCQ/G2618Ff/A0FnriI/wGbZ0E69FcF+KlzDNTcPNmmntR2khsIUrUhWnAHy8CQgnlT/l7yyZiifIg6uGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792003450; c=relaxed/simple;
	bh=fBgu9ZF51QPMUUkFYHhIQdKi9fN+LIIOshnz7jGuEKE=;
	h=Message-ID:From:Subject:To:In-Reply-To:References:Content-Type:
	 Date; b=jLAzOd38B5DTqsmn+7ZvvC30ktqwYOdK+pCH22++wvoZbk81diIk/iPImBeLxsDiX/UceErSgjPpoBGZnExjY0p68XBhX3g+rDFJLMgu2EFGdEDpDFEwDkwKwHoMoph9kc5X5nP23p6I9FCpFC1nPsTuWD8+jra/cIRyZ/xadhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J9yf1EjE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J9yf1EjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8511A1F000C4;
	Wed, 14 Oct 2026 18:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792003449;
	bh=fBgu9ZF51QPMUUkFYHhIQdKi9fN+LIIOshnz7jGuEKE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=J9yf1EjEP/iaqDEZRjN5EjbAZXIL2IvFBq3UVF8AknWoE+a2WtDwpY1sgACp247ol
	 MP7LO3G4/7mjvDibk7hgdtrLvTPE2JHNXxG7WTyNBiTZNuuV6dhW8n8x/hdlJo7itR
	 iBI7LNJUqc1X+tVpiayU6tvRdI0mAZLybTIBLchGu2D0tmJ3Fs/VCCOIm6KjsRMivT
	 u+/+3s6MJbnimrHFYDa2pqEstf/f1as/Ncr+N5xrfCTLPtA+3TzDmPyUw+2AX33aod
	 PvHFYWay7DW3lKe9jNS3zXdhsvwZhVIdGc4GazFRWjznFuhzqphuRWOx27Q1dynR0S
	 aDeFPttgoN4Zg==
Message-ID: <sashiko-outbox-171724@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 1/6] netmem: rename __get/__put_netmem() to
 get/put_net_iov()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261014173945.373295-2-almasrymina@google.com>
References: <20261014173945.373295-1-almasrymina@google.com>
 <20261014173945.373295-2-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 18:44:09 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> netmems carry both a non-pp backing refcount and a page_pool
> pp_ref_count. Make the non-pp layer explicit and symmetric across both
> netmem types: get/put_netmem() dispatches to get/put_page() for pages
> and get/put_net_iov() for net_iovs, always acquiring or releasing a
> non-pp reference regardless of page_pool membership.
>=20
> Warn via DEBUG_NET_WARN_ON_ONCE() for net_iov types that do not support
> non-pp references.
>=20
> Assisted-by: LLM
> Signed-off-by: Mina Almasry <almasrymina@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014173945.3732=
95-1-almasrymina@google.com?part=3D1

