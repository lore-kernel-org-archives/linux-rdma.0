Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793776314;
	b=5rtuMg4icCAn29O7OdENvt9ivrRxpFfQjdl3m3ncBJdzMivxEFI55LwiHLgD3t2dYKjI
	 xMHferIzJce55iuXMSItxYoHwWIhrsfhE40uAGXQNzGcCu3EKHau0rHpofZUXY8gWDTcH
	 CCRveVPHTQ6ge57FHL1WYu51rA7L6Fc0bYLgp2IOb8Qn5fAo1imKmdMsRL4UffjQADSDx
	 fS2tOcdSg44jc/IjzS2dwEb8I2CEZ4yDjkjESpomNdQqksvFIG078CXAavuEZ3ew8Y0bZ
	 RZvz+Dxa/56Qbs4fPkcAwLX4lai3cvzIxiyqHf/JBHKPLOzcafzcPyEUpCSgP7qUFqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793776314;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=b8As2EoG9x8Tl2CWTFOn4J47dWkvfEM0iQdBFybeGCQ=;
	b=xwNp6BPTdHwpvSiur/0yE555U3z/tTcsYdLmxS5do02n/9UqcYpnsKUev13M/PMCYiqA
	 yI6mZvvR3xtcrpIIwT1rPLpdR1KiTsyLsmk6XpVmnPxjElzN8Q4/JKk/EoA1c4a+4B4qN
	 v17Rp/eKxesmLjeBBbvx2OJU9WsQXco9gUmEQAb44j9aBMqvY4lYJn5drAu9xqVAqd2hd
	 u2s4MJeXiaThsofrd119/UDaIYpQge929lgnnfpAAx19hpbeHFszETX7CIfz80zguiWWU
	 OxSs5FYSBFKm1AuyapcavrI4bMnTlxQJHXsrC1ahZ5yPEftaR+27YKnogw38XptaSIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AYih+uwX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7844A606A31B;
	Wed,  4 Nov 2026 07:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AYih+uwX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094921F0093A;
	Wed,  4 Nov 2026 07:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793776314;
	bh=b8As2EoG9x8Tl2CWTFOn4J47dWkvfEM0iQdBFybeGCQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AYih+uwXmkzj09KGHDETie/kyqpTI2WQIjdZHIlpyfIiZyvDdbTf9XDp2eA5HIseo
	 ltmVAoG9K1HXAcLT/Yib/DyOVdCi3U/eyoqHI/QvYJ+CiiH/heX6x5EQJeMr2XVn2U
	 5A9+IHiti5y9QOqzK48dFAv0+7xuQ7hk8x3hb//v1i4k400eAJ342MwLAvyVGWKOh0
	 XpizxtSN52iAP0xV6WFCo60UQrbfgm8n/Tzh/b56NKZYcpUrN6LhdLjHJpaBNkBO6a
	 VkOTAXM8uUZ9L3JW4BY+5i2UXKMkg9yfEmTU0obgl2AJSfsb8jTjGZT15MOahsNKJJ
	 BwYYdgLAP/gHw==
Date: Wed, 4 Nov 2026 08:11:50 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Simon Horman <horms@kernel.org>, Paolo Abeni <pabeni@redhat.com>, linux-rdma@vger.kernel.org, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Allison Henderson <achender@kernel.org>, rds-devel@oss.oracle.com
Subject: Re: [PATCH] net/rds: drop the device reference for ODP memory regions
Message-ID: <20261104-invincible-flying-agouti-fbecd2@quoll>
References: <20261104022810.1484182-1-vulab@iscas.ac.cn>
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
In-Reply-To: <20261104022810.1484182-1-vulab@iscas.ac.cn>


On Wed, 04 Nov 2026 02:28:10 +0000, Wentao Liang wrote:
> rds_ib_get_mr() takes a reference on the rds_ib_device with
> rds_ib_get_device().  The FRMR path stores it in ibmr->device and
> rds_ib_free_mr() drops it when the MR is freed.
> 
> The ODP path allocates the ibmr with kzalloc_obj() and returns it
> without recording the device.  rds_ib_odp_mr_worker() only deregisters
> the MR and frees the ibmr, so the reference taken for every ODP MR is
> never dropped and the rds_ib_device can no longer be released.
> 
> Store the reference in ibmr->device and drop it in the worker after
> the MR has been deregistered, which also keeps the device and its PD
> alive for as long as the MR exists.
> 
> Fixes: 2eafa1746f17 ("net/rds: Handle ODP mr registration/unregistration")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  net/rds/ib_rdma.c | 2 ++
>  1 file changed, 2 insertions(+)
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




