Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793779839;
	b=iLJKftu/t0MKHmgHhOeokkQCy1XVGcq4F5PISaHzWIaAOsHY43A08zPWSXfrCSwq7bFP
	 6K+iUxzx5bVYxOcQ9DkKGpIYGf2I/ZB3DccSBNSiEDnc24Kt2lzquHvWoGVqOiULdloCG
	 oN1cGiEKh6tNyGTJuWMP4u9BrOwCvq7mF1d3C6qlYfE0OAtusAQRUjdMzQ2vGWA9TQkgE
	 doGRCWM1YECDw+HgYV9HF16GhjL1XryAkcaU6hlzqCoGy/6XpicNoxyBfDQa9O7f/PUtr
	 uXIPoNAiH4AeAWoMO7UOIl6SyKWdXVIUVeIYE54KJlXgLTYQvU3E3tlIg88o4NCSiDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793779839;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=IFTh5cCO17Vcw+c6VhopZ+zktn2/wFMn7xA6x6BaX0Y=;
	b=SJXn4VNjROO+jgART2K44qdKxLI9uLqrO0j9LIU8YrScPc2S1wCafZreqCkKLqBLqd8e
	 Guji/uKSedqD4HnMOIt+2q4ayEyD1wLWvPA4/NPEQyWLMGdMaUeeDciDTawrI2HhyUj89
	 16aV+mkxoARg4l5c1ccV/xKWHXkdSVEQsB3eX7OL1wIW1MtHFY0w7d5xnaGR4Ge1W/HOu
	 bDTfIOC9h0e81CVCDI5p93iPsXdlG0yKTSdOtcXRogttjClhvZGyAafAnt3bj5eZUmD/f
	 7MfHVYS+I07+7LmgyyOQkaeJ+RoiH+vFwoqp2diUxTNqyYBrrj//+z/9FsHDMVcxwJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h6zJye9n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB252606A31B;
	Wed,  4 Nov 2026 08:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h6zJye9n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BF61F000C1;
	Wed,  4 Nov 2026 08:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793779838;
	bh=IFTh5cCO17Vcw+c6VhopZ+zktn2/wFMn7xA6x6BaX0Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h6zJye9nAH1AhxVSbDz9keqRZhB+gEZFLCFymRqHw/ColIc06fCf+ObHOXH+cQTbJ
	 WXAODvuE7KbW98QB0Wf1ngYZyLwV7s6c/p1V+LiRlXtGKzWveXarhzyJIoV4ohJNx/
	 B0OXvK7J7qYGCBadUm11mbP8/NqFQlj81odpPzHiTI0VH+VJr5xZf94UtAOSwlbQZ9
	 JwppK60Yz43spOXB5FVO0SgWamLMWG0bGbCXgc74Xbxuny2glyhMx8vdHEiAO7R7L3
	 yQ+3v6rEEMiQBB6jppIDm7INGzKtyua5OorduD2uRdJGgjt4Vs2wzz+ehuA0SEBdTh
	 mnpAPG7SWJi0A==
Date: Wed, 4 Nov 2026 10:10:35 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Wentao Liang <vulab@iscas.ac.cn>, linux-rdma@vger.kernel.org,
	mkalderon@marvell.com, stable@vger.kernel.org,
	linux-kernel@vger.kernel.org, jgg@ziepe.ca
Subject: Re: [PATCH] RDMA/qedr: Unwind user queue setup if doorbell recovery
 setup fails
Message-ID: <20261104081035.GO264423@unreal>
References: <20261103081732.1144512-1-vulab@iscas.ac.cn>
 <20261103-ordinary-legendary-mandrill-172e1d@quoll>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103-ordinary-legendary-mandrill-172e1d@quoll>

On Tue, Nov 03, 2026 at 10:21:41AM +0100, Krzysztof Kozlowski wrote:
> 
> On Tue, 03 Nov 2026 08:17:32 +0000, Wentao Liang wrote:
> > qedr_init_user_queue() pins user memory and allocates its PBL before
> > initializing the doorbell recovery record. If the last step fails, it
> > returns directly without releasing either resource. The CQ and QP
> > creation callers treat this as a failed queue initialization and do not
> > release that queue, leaving its user pages pinned and PBL storage leaked.
> > 
> > Free the PBL on doorbell recovery setup failure, then use the existing
> > umem cleanup. Match the PBL allocation mode: RoCE uses the populated PBL
> > allocator, while the other path allocates only the table descriptor.
> > Clear the freed pointer as well.
> > 
> > Fixes: 97f612509294 ("RDMA/qedr: Add doorbell overflow recovery support")
> > Cc: stable@vger.kernel.org
> > Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> > Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> > ---
> >  drivers/infiniband/hw/qedr/verbs.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> 
> 
> 
> Multiple things here:
> 1. Your team ignored completely previous feedback. Multiple times.
> 
> 2. You use multiple identities with this email address, thus I doubt that we
>    speak with an actual person.
> 
> 3. Your bot does not even bother running checkpatch, right?
> 
> 4. Nothing of this was reproduced nor tested.
> 
> 5. Finally, the same feedback:
> You sent multiple independent patches, to multiple independent
> subsystems. The amount of these patches clearly suggest this was
> AI generated and most likely not tested.
> 
> More importantly, you sent all this work without properly organizing
> relevant patches into patchsets. This makes reviewing difficult
> and might cause multiple reviewers to address the same issue.
> Replying to the entire set is impossible and requires handling each
> patch independently, instead of applying or discarding the set.
> Maintainers also won't see the bigger picture of your work. Quite
> worrying.
> 
> This is on the verge of hostile patch: bomb us with so many
> contributions, we won't be able to handle them in efficient manner,
> like responding ONCE to ask you to slow down.  Considering all this
> is untested and LLM generated, I have even more doubts whether this
> should be considered for review.

Same, dropping it.

Thanks
