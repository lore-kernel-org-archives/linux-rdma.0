Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168247;
	b=JI4Tzo5bkJkbg0cT/PNezY9GM40kt4oR1ZEL/q3blDZ1VE/V0SJX7MTOGvn7+xuSDqPQ
	 CcPAL/zl+RAZTDiYn+DIFQ3TzoIyr0txJLeCMPDpJV3uOLS1AKk6UX3S0xn43S9NnFaTc
	 au/04jY0ot28GjBGS/wtgB53/1/9TU8RkG3jo8HkrDHtSXaZzB8NlVyifr5CjrA7qUY8E
	 HIrV74OKE4ZXIFqFs0ClLO2zRIhx0NDNOj4J51p4Htfq2ZC3MsKI5BbU8Ay4CW2DzHV6N
	 g+LkmB+hau5k+NB2QTgQhwCU+fAFYiIUdo2DKhJH5WMTuL//Klg2YujyaXd/NyDmMCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168247;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=58L4LHl5fuO+CE/8QMgK4uKZDPThmzyu0mgtG2KTAyI=;
	b=c52rVGaqgrpGhzFngFxqaIsC0tQU7gOHIjpSiyTGKwVOaGs2HAqRLaDliTNZQiszEpGw
	 kr8jOcb+2JeLW+zwkDgIURuSkbG5uqU1heQuq5h4Efrs/zLILHW0ZnyJ6YQ85GXO13o7M
	 nIOytLUkcW7ayl5IhSA+1p+NLTHSeGBaJwjK55yOrIbbh70i0HRfdWbw/eksNcJwPikFu
	 7ka6CF5CVuNeS05oUnVquVj7c1UPZBbBGlq4K69E5KM4lWm3Jmkj43iZ/hUDg3f7wfz0R
	 KoCfC59AZ+TUj3AyI8u937Vgq93xRoIfv7rHxT/Epg4igrsXk08iTU7pxCthuYeunAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XhAPlLjG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3AC606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 06:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XhAPlLjG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F9B1F01825;
	Wed, 28 Oct 2026 06:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793168246;
	bh=58L4LHl5fuO+CE/8QMgK4uKZDPThmzyu0mgtG2KTAyI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XhAPlLjGs9ZCVgUmP3R5WieG8v4LfkVzvCV5tSLuualm9NS6dkZtWoCcSPKYlZjy/
	 LXeBlsyafAAF5LX+hrYaF1zLi77MHO23+8pdK7N8s8oIuuHHNrmaLcFr6GuOZM/f5n
	 TnVoOgahiyp0pz0i80cwokE3tED7uN1mG+sy5wwQD+3LHoZZZdhVQ89pKxL4ecnoIf
	 ++SXwNinYb9tID7Ffk5/l+l6+uzkAfAphJjRultrBI3kP30+n8fBwZ077JZiHoWFMF
	 zXaZSY/+zBGoSZPpRf5WeWBpkVtZ17EpQv73lEFK5C4zsGb8n3ChJQKdBsE3Grgl04
	 82R05WPJmFgEQ==
Message-ID: <sashiko-outbox-187552@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc 6/7] RDMA/bnxt_re: Remove shared page mmap entry
 on alloc_ucontext failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261028113404.33289-7-selvin.xavier@broadcom.com>
References: <20261028113404.33289-1-selvin.xavier@broadcom.com>
 <20261028113404.33289-7-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 06:17:25 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> The uverbs core does not call dealloc_ucontext() when alloc_ucontext()
> fails. If bnxt_re_alloc_ucontext() fails after inserting the shared page
> mmap entry, the entry is leaked. Remove it in the failure path.
>=20
> Fixes: 24ce94782c48 ("RDMA/bnxt_re: Use the common mmap helper functions")
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028113404.3328=
9-1-selvin.xavier@broadcom.com?part=3D6

