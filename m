Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793779812;
	b=UPK10mXgHf3uGjGA3CcbHYwrIP0K2HXIO60yw7sU5pCXrpqB1WQTmJ5wRntlxUiasdOp
	 jUvvvM7qCBK7qrdQrTe+5oAmLo2kqjGoeHOQj1hj5bjhknJAnRK0jLSIyMb5EvQv3GJZ6
	 KjQrdOUoC4wdgaNEuXz4huuNRHd/gvaMONDjtSNR0AmGTRvrJOLeu/snyCsRgCVQILsDG
	 GiCrIDKqNbYaN/Cigmxa7601MIvdjf0v74rh2PNtfKVRNEHqxSpI0FLnr/ZCrNddbTf4E
	 rdcexHM2HTeTaRpDX4RW0IZkDCxsPProRwtWDb8jXKZY9vGFlQwk0Lc3DmUi+92DnKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793779812;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=0pN/UiSEiZTZEf/nEIpAfugAVv0D3hEkF/wqURLysQQ=;
	b=bTvCyqFQYWIkwrvgl2vSsYOlsTC/G3BqCUwx9I4V/W7BrLTDm+RNl96DvkVlqU1OeqOL
	 AHBE+4dJHSPSKBMwqeNZOoQVbBNS/Xi1a9Kau+MvREyFVzuiT4QaesLI91hVpQx4iKhDV
	 A/+xui4Yjd6sx5tfvcgwMHwDGlEDuxQK/502oFOUfCYP5MzfGJ0ESOU3Tgk1LUf0tbywa
	 3ayPc8StRW9944SXyGSCmowFC/Ae/siuonvmyoKp6SzOYRTRC0eSw1ra6DzBTl4n+Ho3l
	 pkwv+CP8QIyFHTUmN3BYuaeI/oaCqN3465wYlC4q+SNLwKBZpGgnWeR9n8Qh54hDKRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l2S7cjny;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76289606A326;
	Wed,  4 Nov 2026 08:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l2S7cjny
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370B11F0093A;
	Wed,  4 Nov 2026 08:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793779811;
	bh=0pN/UiSEiZTZEf/nEIpAfugAVv0D3hEkF/wqURLysQQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l2S7cjnyBl8IM15zl9kvALPts2a7RAHC6v2h+FzHXKkh5TFEnU8ALnqhKH0OABcd4
	 g1qW454YtYpayO038yBV/kT2yRveimPjALmITujrNuHJNkZlBf+k6lpJvO3Yax+ag2
	 /2/MK23EEnVoRyRy4Gb1wMflcC/thgtclSYyGhj7OxiVW2ISmn7fAKq4X10yVeMw48
	 qwAbAt5HbTETVs6gf4MeItb8/YErqVOqKvSx5I8zUU9FiVq3euS2gDQ+6Xovab3Kmm
	 yNtd6YypXDn5BfBoj0a8U55caLkQPq8OSAPB34K/zZAnEJDNX3BZ1l6RpYwWTzMBai
	 ClCQn1oHpuc/w==
Date: Wed, 4 Nov 2026 10:10:08 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Wentao Liang <vulab@iscas.ac.cn>, linux-rdma@vger.kernel.org,
	stable@vger.kernel.org, linux-kernel@vger.kernel.org,
	dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca
Subject: Re: [PATCH] RDMA/hfi1: Free the trap send buffer when no address
 handle is available
Message-ID: <20261104081008.GN264423@unreal>
References: <20261103081915.1147987-1-vulab@iscas.ac.cn>
 <20261103-peach-mongoose-of-charisma-dee123@quoll>
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
In-Reply-To: <20261103-peach-mongoose-of-charisma-dee123@quoll>

On Tue, Nov 03, 2026 at 10:21:38AM +0100, Krzysztof Kozlowski wrote:
> 
> On Tue, 03 Nov 2026 08:19:15 +0000, Wentao Liang wrote:
> > send_trap() allocates a MAD send buffer before checking the subnet
> > manager address handle. If creating that handle fails, or if the subnet
> > manager LID is permissive, it unlocks and returns without submitting or
> > freeing the buffer. No send completion can release an unsubmitted MAD.
> > 
> > Free the send buffer after releasing the lock on both early returns,
> > matching the other failures after ib_create_send_mad().
> > 
> > Fixes: bf90aadd630c ("IB/hfi1: Send MAD traps until repressed")
> > Cc: stable@vger.kernel.org
> > Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> > Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> > ---
> >  drivers/infiniband/hw/hfi1/mad.c | 2 ++
> >  1 file changed, 2 insertions(+)
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

Thanks, we will simply drop this patch. It is not worth to review it.

Thanks
