Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793698619;
	b=VmVazGntP2hBCRND/mQp1UmD0LInbof16OCDVoN1GVyQvgofh4GTInLvMotDThGksy3F
	 ruu9Jba6AU6QckEp+B74FqxV/0xssxq6ziE6VI847vZ5WYKW5Cagf3TrQO8cC9p/rDegM
	 6YobTAvNTH2ewXB1RnWVoZit6hsvYcLHL1YmUkhKH2u5CM6sKwMUzWC3sFEs+dIP0jtUa
	 pVk8QhfL0DVnpyFEg7m3pfVvjznInBDbVn9e6h6aeZgQvzKstdVPNhS/FbSOLI82sKpf1
	 07WXyftjP1GV50YGMLnyOa46Mt4XooqK9eKTVw6wuTO6+sSvK9wudS0IbEHaBUP3kbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793698619;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=r6XDQhSOHV595wj7jgH1rUKhlBFaqa+8NOHbPKuijK0=;
	b=hKJRDWgvgn56UoTVUYLLGgsd2CnApgQvB2/aJcCOQcEjWkkWDXaZJji52QIBMY7Lr1Uq
	 kU/wobUB5Ygfes6nuNppMOP2XDSgvbVIl94GvHBCkxkOZv4Ph6WHVxX99ZsEzusyJER1q
	 VobzoanUje8L7rqZnlhxNooTFU6AUenJIC3qLlRaje9px91dk5V22t0ru56WS2AwpiL1j
	 O90wkhBpUp1peaGUFJCscShgw9OdNUQup48zFgITBxY52IKnhjLagcAZsV0icEUeFrsKz
	 DaHBaUm9K9k1moK5z8nMaiS9pWo7fUnf+XTPy0oTx0vKW/KONZiTLbsrAu1HIJxzWBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="X/EBGoeG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA9B606A324;
	Tue,  3 Nov 2026 09:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X/EBGoeG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F3F1F000C1;
	Tue,  3 Nov 2026 09:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793698619;
	bh=r6XDQhSOHV595wj7jgH1rUKhlBFaqa+8NOHbPKuijK0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=X/EBGoeGe6cJgZ3EevbXm10ZcWlcHwLIqV/06zK/PlhZyH/6srKDIC2PZYJQokZ93
	 RZXQZ/XNo9ztezlPPfJA9of2FLIK2mnL+2SGwVDzzKqWQFQJ2mqoWlqXUuZj/7d1hu
	 g4yIrTC7+8J0EhyDP+04NjwXTIZLMnh3SD7l99JQxjP1tkngWvaGhEFuG9qnrp+OUa
	 84NwQvSVyDQWW++9/BtI4T5CML0iqwCuqOlVZftjJW8jr3LJMbBba5rg2g+LzzvI7N
	 ssvSXM6CvN2Dxcge64uQGwVZhUfPlNVkl2EKxRlMbz+v3PdVnzGFfW1VEapxC+N/aU
	 Kjew7D1aE1Z2g==
From: Leon Romanovsky <leon@kernel.org>
To: Nelson Escobar <neescoba@cisco.com>, Satish Kharat <satishkh@cisco.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Li Ximo <lixicaicai@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Wang Haoran <haoranwangsec@gmail.com>
In-Reply-To: <20261023073349.1287022-1-lixicaicai@gmail.com>
References: <20261023073349.1287022-1-lixicaicai@gmail.com>
Subject: Re: [PATCH] IB/usnic: fix wild pointer dereference in
 usnic_ib_qp_grp_dump_rows()
Message-Id: <179369861615.1707932.1037974418846118869.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 04:36:56 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 23 Oct 2026 15:33:49 +0800, Li Ximo wrote:
> While auditing list_first_entry() users we found that
> usnic_ib_qp_grp_dump_rows() calls list_first_entry() on
> qp_grp->flows_lst without checking whether the list is empty.
> list_first_entry() never returns NULL: on an empty list head->next ==
> head, so container_of() yields a bogus non-NULL pointer derived from
> the list head address. The function then dereferences it twice through
> "default_flow->flow->flow_id", which reads a garbage pointer out of
> the enclosing structure and dereferences that in turn, almost
> certainly causing a kernel oops.
> 
> [...]

Applied, thanks!

[1/1] IB/usnic: fix wild pointer dereference in usnic_ib_qp_grp_dump_rows()
      https://git.kernel.org/rdma/rdma/c/289ea23b7bdeea

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

