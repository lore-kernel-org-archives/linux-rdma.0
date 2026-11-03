Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793697711;
	b=GAQ2qpFwa0tzYIKGqTTWG9+BBVtQ7HlEpvIxZsqjyZZLcsvLqAk4taWH2Dq7sCBUc9S6
	 wxZ/CThAK/tUVpLxmfgzWuWzACEdl3Ca/Dkem3z1PwUGBOO/hTmn5g+45THfMj5BWTafC
	 XtI1OnLPqSpSfbHqAlYtd+evt3p3v0yKhmskFGrhgCbcD2pm9+94UXrTvh780DBbbleeT
	 b5rUMrbAQTgatjE+XeWb2aBwYfp+3NI3ApwAOjLSaJJgK/vyiCADDXGMRPQ90yOMSEp7x
	 KMIIp/EdzN4X5z872Q93fbhESk9TUO+KsNOvNlkeGwpmP3r8DlgRPt3oAYRw5mUwTEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793697711;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Dm6OMR92xAevISjMzNLDdpd0lsO0u5q4NStQZiJFruo=;
	b=EslQOHxp8CpOYPWW1NJ/jj6U3VJztz9+guCcwoFryXQw/UhGj259IiXv3TDJEF1wo5lQ
	 oYobmAfwxxctCnOpWoixFbe/U5U9mCT16Daz2wNIsH3QrjLa0ew2CrcJEYCTOwrzUF5Bs
	 U1sd8vHmisyI1LzY/fN95AM+7Ywc5H8kg328svmEtJv0smoB0/I3Wi0ip70BC3r9REivu
	 R/4qClXuwm1i6MtM4Ox8oPRxoOl4pX1IAQ9u/h5R3VAk3AivwMXH3qKujEIjyTTKQd5Jp
	 nKPuLpdn/Dq84wJAhWMug5ZiTKNoovXcrxzF0+o0J9D/ZFKx7zu9qfziDcNzFByAj4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gkndL+Tk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A4C6083617;
	Tue,  3 Nov 2026 09:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gkndL+Tk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E64F1F00A15;
	Tue,  3 Nov 2026 09:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793697711;
	bh=Dm6OMR92xAevISjMzNLDdpd0lsO0u5q4NStQZiJFruo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gkndL+TkokuC5gxc3W6193nSDBfRnsKAT1QfgWrfCgFtnS9r7pWhvMjYoxcJIcvVv
	 bj6MeZivoDiIR2OnqZPLUnmQjwLy/PrWSJocp0oQA/j5ju56NzrBxJRXoD+GdlACTZ
	 OkD9GLty6DUtNHA5H4gpJP6h+cr3Y9NAsHJSdQfr6jGyh5jhMNNhhjQCS8rfi910rV
	 FmEyjCfPw5iyxvezJmEwmbVEhRPuVoyaauC2EHTdykb79wvoAZFZVIdqd92GV2/hbg
	 EuvSMDTBa0oywJYHMl8trQ2N+9pbqbdT2nf7lbdo2hQPUoGwip5WiAD5b3DhjGsNpO
	 Dv2fwPj3tGWdg==
Date: Tue, 3 Nov 2026 10:21:48 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: stable@vger.kernel.org, jgg@ziepe.ca, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mkalderon@marvell.com, leon@kernel.org
Subject: Re: [PATCH] RDMA/qedr: Release user memory on MR registration failure
Message-ID: <20261103-artificial-delightful-beluga-cf9fda@quoll>
References: <20261103081615.1143267-1-vulab@iscas.ac.cn>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261103081615.1143267-1-vulab@iscas.ac.cn>


On Tue, 03 Nov 2026 08:16:15 +0000, Wentao Liang wrote:
> qedr_reg_user_mr() acquires user memory before initializing the PBL and
> allocating and registering a hardware TID. The error paths after that
> acquisition release the MR storage and PBL resources, but skip
> ib_umem_release(), leaving the user pages pinned and DMA mapped.
> 
> Release the umem at err1, which is reached after a successful acquisition.
> The failure path of ib_umem_get_va() still jumps directly to err0 and
> never passes its error pointer to ib_umem_release().
> 
> Fixes: e0290cce6ac0 ("qedr: Add support for memory registeration verbs")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/infiniband/hw/qedr/verbs.c | 1 +
>  1 file changed, 1 insertion(+)
> 



Multiple things here:
1. Your team ignored completely previous feedback. Multiple times.

2. You use multiple identities with this email address, thus I doubt that we
   speak with an actual person.

3. Your bot does not even bother running checkpatch, right?

4. Nothing of this was reproduced nor tested.

5. Finally, the same feedback:
You sent multiple independent patches, to multiple independent
subsystems. The amount of these patches clearly suggest this was
AI generated and most likely not tested.

More importantly, you sent all this work without properly organizing
relevant patches into patchsets. This makes reviewing difficult
and might cause multiple reviewers to address the same issue.
Replying to the entire set is impossible and requires handling each
patch independently, instead of applying or discarding the set.
Maintainers also won't see the bigger picture of your work. Quite
worrying.

This is on the verge of hostile patch: bomb us with so many
contributions, we won't be able to handle them in efficient manner,
like responding ONCE to ask you to slow down.  Considering all this
is untested and LLM generated, I have even more doubts whether this
should be considered for review.

Please read kernel documentation BEFORE posting more work. It will
explain you how to identify subsystems, how to organize your work per
subsystem (so a patchset grouping multiple patches with a short cover
letter), how to document the issue discovery method and what was
or was not tested.

Best regards,
Krzysztof




