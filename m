Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793776254;
	b=kburW82RxIQbhcRkYvSGxFUanzM1Eb3dJmeDCBXFdNPNPJnVSCXyYprx0Qm9Weamy+do
	 Qsol1sLh+JhlJaAoo0DH8uiVW6GwG/ow8kwEEV5vdkc2tD4/5L5bBgN8wITDchkd/N4y/
	 3C3lJZR3XjcO54y0Y1EC4riBem/YywJNQerV8NsUN8JrER+A7rq7b0b7GUuRniwXgl0Fx
	 HnZG4M8mQNx+2NfW/CIPbjwM2UBfr3q+CCl42uIefZL12p9EGKLw7hOZIoxa28at9/BV7
	 U0SaaiknwmTpEOajsj163zP34Za+VcY06SigzKND4QSd7vSB5G1fIw9nuDgas05ih8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793776254;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=z3q2IkefJaWfFlzMYoDigzLTDZNhXOuXydgsuUKwg8U=;
	b=tbzqixgWSYvL+B502cxa7xx176GKAKOEZ0ybG52rymSaDJ395TNPC8XiTVuJEFSyfa1K
	 Gs89M7+5Hg5CqqehK8ByrY7foodMgeJetdxsP22sS4/VkkN8NRstMAZX9KDKgfP7clPZY
	 WnbBc9EW+pVAZlvaqTqpzV+kCOPa48nUvRvniaXap1i3/C8VKD4R3EHqpcS2IIcXGgGiE
	 bucJRxG7L11/qIHqr5K1F/JJo8Ka0jWCuOOOHafQABAGirS6Y+VezOZbG7C5ov+1TgpOW
	 /dc290sgsd9Gz57YPH+r3HPShtwaA7UcEQu4+8oaFcoApoDGTGCCxV6QP5x1MIJRjEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Aoxc9Mk0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3773F606A31B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 07:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Aoxc9Mk0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F931F00919;
	Wed,  4 Nov 2026 07:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793776253;
	bh=z3q2IkefJaWfFlzMYoDigzLTDZNhXOuXydgsuUKwg8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Aoxc9Mk0/U6uHwzs6gbNZywGzQYQw04gNh8IjNx3L6UtWSBWZmq0IXkWYDBJXIJOZ
	 /IMMxGWueOL3hZeDPNFB/8cN/2+Og8Glqhp1rkDsEiLfXW7f7mCuSxbh6cEnbz9Ke8
	 EXKEcKHVzESZa3fQrfQq5DXkGIjshv3zFr2+1dBNhEid6Z8GAQMNdlqVreGmJ70qGv
	 LCJJWz0t4oERFwFHnutYpbXYnojEoWcNjBXMT6GmJoE9+LH60jKr8zWWzH42ZQYG2y
	 wPNGef/mUdfaop89D2UlZr5fy3/TLajkhuXhqGD88YA2njF7X99VfByNeFBGn4CVvZ
	 gSfDTsfDjH6rA==
Date: Wed, 4 Nov 2026 08:10:50 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: Tatyana Nikolova <tatyana.e.nikolova@intel.com>, 
	linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] RDMA/irdma: fix double free of close_entry in TIME_WAIT
 teardown
Message-ID: <20261104-eager-innocent-elephant-23efad@quoll>
References: <20261104025347.1527584-1-vulab@iscas.ac.cn>
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
In-Reply-To: <20261104025347.1527584-1-vulab@iscas.ac.cn>


On Wed, 04 Nov 2026 02:53:47 +0000, Wentao Liang wrote:
> irdma_handle_close_entry() drops the cm_node reference held by the close
> timer before releasing cm_node->close_entry.  If that put is the last
> one, irdma_rem_ref_cm_node() runs irdma_destroy_connection(), which
> still sees a non-NULL close_entry and calls
> irdma_handle_close_entry(cm_node, 0).  That nested call frees the
> close_entry and clears the pointer, and the outer call then frees the
> same object once more.
> 
> Free the close_entry and clear cm_node->close_entry before dropping the
> reference, so that a release triggered from that put observes a clean
> cm_node.
> 
> Fixes: 146b9756f14c ("RDMA/irdma: Add connection manager")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/infiniband/hw/irdma/cm.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
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




