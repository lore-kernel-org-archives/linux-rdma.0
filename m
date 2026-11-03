Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793701602;
	b=CJwC2Vcm/WNoySkCeAo5DyIY1/hhVjE43RkMtqG41BfACp1kruZlyeVWoG7nDeBAqTZJ
	 YbXtR8BVjXp5sAZvMEh0Pytwsk76AZBwQ0qenbBDwBcUTBhGl7SPjE19tWHyK8LxFOT/c
	 5kN2Ve9y2KLjssroHlWJPilXvE8KYOfENbWu5nXuIuVZ6y/Yh5t6ubS+6qblt3nChd5F+
	 KGV5Gsm6rom2Gsk2gY2TslAlLTmjxuZyw7btqyQYmJ1g/fYt973P4nW0uWIr+Ybch6Q2E
	 MOlrqHnPMZ0wD2n5fYXczo4TO6vq7fmMILWPFE2euMRDm+rGGXp4KUrK9C16TipvV/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793701602;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=kUc2Z59dq9gHOU963K+8gnhDmDxS1p9MxNfkqY/lsVc=;
	b=Fzk+m+UnynfGHIlmkpzEPoMn2vvA6h535mP0TAZGZtSmFOu9ub3MFhEqKRftSImvvSrx
	 ElzToPW+FCojJUIwEQ9uTtIKry/XGKoMU5+szl/2220nNG/hriY91A6tYEHpJprjxVZOo
	 Acxm71plPsuTtkApKHFb4H8q/6FLYxcAmvi97F38rpwFgGTpwyvvuHOSAyNQRJQ/w8UWg
	 kLQHs/7jbJseJ38+F40Q8Z80bSiN9wvW1Gmgxn+/MqavPpWdqk7ZZczI/AsGKOFTS+Qjo
	 vpc+vzq+IkCPMV03t0N1yJ/5B/xmMoeLn8JA/PM+pFvgOQ/asn7vWCzSdT2D+xKbQzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cr5t3Y6i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E391B606F7EE;
	Tue,  3 Nov 2026 10:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cr5t3Y6i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49CA1F00A17;
	Tue,  3 Nov 2026 10:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793701601;
	bh=kUc2Z59dq9gHOU963K+8gnhDmDxS1p9MxNfkqY/lsVc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cr5t3Y6iWHVOh7GU7fE7fLTZqrCgd/xd429ylD9lyGmRSBNrmMcL/vxaLhyPOsrs4
	 l0D+1xIuxLjncK21VVxlaeu9O5IIka7MTtLn9VIwc5WKWsqBwBzcHedMPc6I1YPR3x
	 Zk7I0feQptBi0NByVJ2+IRaURNZqjFF2OW3RKkQla/VSVvBx3the89LR9/rxZCBUob
	 XK+D3f14RRCaQEzvf3u/sKuThUOs/8mSfDFzEO2ifoO9Cl+IoCLEUtQhu4+gHBaIS5
	 4yLAm4HlW6yWGRH91qqq4Kg6cM0jPZlH9A1IKGxxBFypVZ2A29GrJgM//PO8b2uvkJ
	 ZhG33kp0E4zlg==
Date: Tue, 3 Nov 2026 11:26:38 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: linux-rdma@vger.kernel.org, stable@vger.kernel.org, 
	Jason Gunthorpe <jgg@ziepe.ca>, Potnuri Bharat Teja <bharat@chelsio.com>, 
	Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] RDMA/cxgb4: Balance the extra skb reference on
 rx_pkt() error paths
Message-ID: <20261103-admirable-ammonite-of-superiority-7ad409@quoll>
References: <20261103094642.1289811-1-vulab@iscas.ac.cn>
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
In-Reply-To: <20261103094642.1289811-1-vulab@iscas.ac.cn>


On Tue, 03 Nov 2026 09:46:42 +0000, Wentao Liang wrote:
> rx_pkt() takes an extra reference on the skb with skb_get() so that the
> pointer stored in req->cookie stays valid after the handler returns.
> process_work() frees the skb once when the handler returns 0, and the
> firmware completion path releases the extra reference through that
> cookie.
> 
> If the route, neighbour or L2 table lookup fails, rx_pkt() returns
> without calling send_fw_pass_open_req(), so the extra reference is never
> released and the skb is leaked.
> 
> Move skb_get() down to just before send_fw_pass_open_req(), where the
> reference is actually handed to the firmware.  The early error paths now
> leave only the reference owned by process_work(), which releases it when
> the handler returns.
> 
> Fixes: 1cab775c3e75 ("RDMA/cxgb4: Fix LE hash collision bug for passive open connection")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
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




