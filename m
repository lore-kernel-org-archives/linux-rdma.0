Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793697705;
	b=0poNHwAzr88JuPFMWDtsTTj5Guowogo99HZfqzAfeFp1N0iARaHkSv8cqbV6oYSgI1Fi
	 gT/EwMWlr1DONsITBD8A+AluS75RJK2+h/OKp1XEWzfidUdOgT4NXkHcpWwJABSog87lu
	 9xUQku/GLH2lAjpDAz9dCgGUvz6EjBWA5BirkQETjKxl/UDoLzDju36wgRqKqPRnOWSaq
	 V40ZbAkRZf04wi42AxaROgln6NKD8knD2XI4MK1tOAaBkJmdiZU4vsXvJu6TeUXaFqVDX
	 tpwU4jdin6NqYxPOk71LdjBhYRkGPhKvifotR4Staa4zE+HpVM4Oi0OsD4FQTCUr3qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793697705;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wSoJrenZh1B9DPRMpx5CpcbMj5JwpEhHMk8T5omwlek=;
	b=o5D1wrW24GzqtKcnhWo/8QuxnV8nFdS4+at+/vBIP3wfiQeJmrjEvBjzCySxX/mTu8Pb
	 SJcNPB6gTHiPch0QCUWxjkp6VsQ90k3xZXRPW5RZ9iq6gr9EQIN+M0Iv8MJXT67z4QrZY
	 jU2h++ZbzgdSNCMlLdXVNORwxFYScfY9hxIeL7e3skct6HUxm+LulJLGqrpPsBfQ0W80B
	 PKHyWnCGIGHFs1ACLwes55OgFVjdEyw3F92x2Ea3EFJ+7Tu5Zy72tuF8Czwf7mfi9YzMH
	 6gMJxVLui6u/oQZx/OgaMBCVpjh9Ktv37Y2ETiqRmcYrFDFAi2WZjUE4mWkaNVYI22w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QgdVCDX5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CEB606D820;
	Tue,  3 Nov 2026 09:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QgdVCDX5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A261F00A1E;
	Tue,  3 Nov 2026 09:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793697704;
	bh=wSoJrenZh1B9DPRMpx5CpcbMj5JwpEhHMk8T5omwlek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QgdVCDX5qs7Hvg6Yx/iPUjAss99AQteWsC6hliEo8XgZyip9fVdu+QqGhT3VmMJda
	 a1t/b22yM20rtlFP2fvkw57cobgP2uqeKs2/xARLLGglN5YP/pPJI2kiAZRKosxq/i
	 bcfB3DUMnlLk1bRQnrOT+NElV9BVA7qoUXiaThTDQ/5UUrA/TL9iyOYM99sSTeTiwc
	 KokiObWZhSy1l+lHTHmeDRv0LJwEijACsx3lPrKCLBPlR5WDBUjrjtisPVY+hUYXa3
	 kGzd5rugrjUNflA8Vh1VK9aResFOII1/awlTnrQ8qWVS1dnFUBlEQg2R2DegenwiXI
	 pXJzwGhy2bEiQ==
Date: Tue, 3 Nov 2026 10:21:41 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: linux-rdma@vger.kernel.org, mkalderon@marvell.com, 
	stable@vger.kernel.org, linux-kernel@vger.kernel.org, leon@kernel.org, jgg@ziepe.ca
Subject: Re: [PATCH] RDMA/qedr: Unwind user queue setup if doorbell recovery
 setup fails
Message-ID: <20261103-ordinary-legendary-mandrill-172e1d@quoll>
References: <20261103081732.1144512-1-vulab@iscas.ac.cn>
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
In-Reply-To: <20261103081732.1144512-1-vulab@iscas.ac.cn>


On Tue, 03 Nov 2026 08:17:32 +0000, Wentao Liang wrote:
> qedr_init_user_queue() pins user memory and allocates its PBL before
> initializing the doorbell recovery record. If the last step fails, it
> returns directly without releasing either resource. The CQ and QP
> creation callers treat this as a failed queue initialization and do not
> release that queue, leaving its user pages pinned and PBL storage leaked.
> 
> Free the PBL on doorbell recovery setup failure, then use the existing
> umem cleanup. Match the PBL allocation mode: RoCE uses the populated PBL
> allocator, while the other path allocates only the table descriptor.
> Clear the freed pointer as well.
> 
> Fixes: 97f612509294 ("RDMA/qedr: Add doorbell overflow recovery support")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/infiniband/hw/qedr/verbs.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
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




