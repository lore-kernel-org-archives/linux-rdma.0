Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792682844;
	b=x2GWCq31KESHdcDpt8dJMpuKU7JCWaWARkFM98CUW4s18bIND/VY38FcpMSP43u5N0rU
	 qIY4x7XGPMs4udHdmsBN3O6rxdXjQeyX9SeYw7V7po2BCTgg4hYbz9rEbptc2JR0VBVTG
	 TKVRLFEvWCOXuwPuOtBDTAOVlxEwOvWHBoRG3kgjfRBP1H2wBvpzkqyilDs6VkrXR4a0d
	 d3imPaArXIyhFkvYltlUDYsY6RQ3a9cA9Wew+dt514h0gbo0JRYroYRp9zaa18PDvunkv
	 IoOZpO7RkrY8epxo8HsKuDw4wO+J/Ixtwak3oLAIeQd95jCejLPrvnJhLQ6lxWtUvFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792682844;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yH8As+NcrjkHp+YkiMZ78rIKFlBcftu/7KRfnzwilYc=;
	b=hXI7RbUml7uR02qNx1CfBA8Tzfyvnc86p4e9+yadKn5tx+1sviCbfZ0f8ob+qcC5lVQz
	 mPwMCHjSBgAFZJKD1eK26LYh7LgebQ867byQLuoX7sMZc+hJroKp3NT444WLlZZ4buBEf
	 IixSVfh1gbrS98DUJ2+BhmxV/Nrn7CCadhsucU8s5Yo5KFtMDv/MbbGIOnPvwcTjQHN3B
	 2w/gSGZasda+w/woO+ibsGqzzdW369hY4bQ96b6pKIURfY/7THY7Lf2RhU4xVQQjmOdiO
	 hjQwpN52fsX323kJKXITs81Y4IXqyWHNnn3//GaLqnnR2qSjmNus1b3r2m8sPdqIhVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U7Oe5sIK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3A2606A319
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 15:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U7Oe5sIK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FCD1F01825;
	Thu, 22 Oct 2026 15:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792682843;
	bh=yH8As+NcrjkHp+YkiMZ78rIKFlBcftu/7KRfnzwilYc=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=U7Oe5sIK95CDOXgwrEK3+wQL/DPO700DMIIXE0b6h7fXXg/hJSPklcaauika9iEeG
	 ysYXssaDZ5x3UBZ349YgCOzhxz1EGzuIpu5CFss/yxS2zHDEpchKSaFfsnAizs79yT
	 BdtdartYEolhMx83zFJz45nqiH5Pskc2DIJagSSeq9Qj7rLMN3EH01OFPjCKosX8Iy
	 NnX2ZQK8QIeP85zwH3zPZBYvkb6O+7t9rblEj3+nrEtf9cMXLPBI6xz5ULx1AL8WIc
	 M8FndSYfCTAKdSlJRdRNJB+Hf4TiG4cqjH0NViJ/seMfEMyg7VfUWwnqozo2X2hbuY
	 Hxni0C8Sqzedg==
Message-ID: <sashiko-outbox-181699@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v3] net: mana: Add support to process throttled EQEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sahil Chandna" <sahilchandna@linux.microsoft.com>, linux-rdma@vger.kernel.org
In-Reply-To: <20261022145428.323576-1-sahilchandna@linux.microsoft.com>
References: <20261022145428.323576-1-sahilchandna@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:27:23 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> When an event queue nears full, the hardware coalesces the per-CQ
> GDMA_EQE_COMPLETION notifications into a single throttle EQE (type 4)
> that carries no cq_id. The driver does not handle this event type, so
> it falls through to the default case and is dropped. Any CQ whose
> completion notification was replaced by the throttle EQE can remain
> unserviced, causing its queue to stall.
> The issue was observed internally and following Tx stall logs were
> seen:
>=20
> 2026-10-03T05:29:01 hv_netvsc eth0: VF slot 0 removed
> 2026-10-03T05:29:23 mana 7870:00:00.0 ens1: NETDEV WATCHDOG: CPU: 45:
>                     transmit queue 1 timed out 15133 ms
> 2026-10-03T05:31:05 mana 7870:00:00.0: HWC: Request timed out: 60000 ms
> 2026-10-03T05:31:05 mana 7870:00:00.0: Gf stats wk handler: gf stats
> query timed out.
> [ ... ]
> EQEs count.
>=20
> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network=
 Adapter (MANA)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sahil Chandna <sahilchandna@linux.microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022145428.3235=
76-1-sahilchandna@linux.microsoft.com?part=3D1

