Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793365665;
	b=vRQzIPSzsDrV68BctgK0DQLSXSkVaPLni1wLCNz9EJd1q/icEaIw4/rC/7HagW7JKthu
	 y68gm+mBegVIG9gum9otjyXiSZp4cMhWYfI/jJfPG6bN/pumRXSftCvwbnfOM6Peyfm7Z
	 o18fLg67bYJyvjS5HYUZabej/UR7Z/CKsC7Qvt8CGL7xfswER5sZ3l2c3z66+39eze64B
	 bVaUOT2ap3NB6hh8FxkTTdP3SjPPqD+i6sOt26aSC+9qNz9LRNBHsa1jFK8FrhcgZo1Vn
	 Wk0Orr4aF0o6aowJdR7As/nlIZkOJamNEqo3tpR92u+XSRz9pFEDwO92MxX6re9w/fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793365665;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=9MOXhO2xjaichH+j2mRY8Y8Kn5D4747TrlleV0wp6Bw=;
	b=ChrhErw5vsJObc5kldlq3Q/kLMKJdCPXSn3UkcVaUPEY8ln1vzQ0oS+c+yTa1W0LQCCA
	 NKozkXtYlUiCQmmyvAicP3E8gKwR05xaOBWEzTxb2G0dP0ZIRQPGcX+3as93OvHvPvJ06
	 SK8p9ERqeA/XsTL0jpPzuw3GLYoGdnPsYcsEbyDIuX05d0f5owc+cSkSFup2NkRrgtAlG
	 yitNVJn7vKewFYj/mvOExRJB8m59ggwqS/K4Mmg2bqNgw0xkvAJUy2FOMEgQRMj1O6ugQ
	 caoIjdKgci9IDUYZObErfPzNZlifpyxDPwbxWhDqrB3NXAUe/2KWTziebG2Q8I3GRZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ENcDMFpC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E26360A2600
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 13:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ENcDMFpC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56A1D1F0093A;
	Fri, 30 Oct 2026 13:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793365665;
	bh=9MOXhO2xjaichH+j2mRY8Y8Kn5D4747TrlleV0wp6Bw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ENcDMFpCf3zpJpWRDcZrL7O65HnudnSweSpFOBGoCHFDFWu8rh6K5YdHgMzKqjCoA
	 sdxvEu7bDGOUxw4tZ/eScIbF7bABEuMujR4vOFBhRjrjDZd+aoI4Bpy1JvcBZwipox
	 vNZanz8IsEg+eT4WKwQ2Ak1nLZhbuVZwHjSwwJaT6I5c10fAloBpQyo/5q0DR/rjgq
	 UokFEthXrzntmAcnhNWDt3zT6C5BpHuX8ASbfD3kti3Awo9KqPbigZa4aHXMuqCf/V
	 PE+Nmx+8ZmoRicag1jT2HPgvXOU919BUk67i5TYW9rGabJNNv58n8z3F9rhadP8RlE
	 0UQKOCLJmrcZw==
Message-ID: <sashiko-outbox-191047@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v6 04/10] RDMA/mana_ib: Maintain kernel RC QP
 state
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030130038.4040789-5-kotaranov@linux.microsoft.com>
References: <20261030130038.4040789-1-kotaranov@linux.microsoft.com>
 <20261030130038.4040789-5-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 13:07:45 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Update mana_ib_modify_qp_state() to support RC QPs. Initialize the
> packet, message, and frame counters for use by work requests.
>=20
> Arm the requester receive queue at the initial PSN so that a CQE is
> generated when the specified PSN is acknowledged, indicating send
> completions.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030130038.4040=
789-1-kotaranov@linux.microsoft.com?part=3D4

