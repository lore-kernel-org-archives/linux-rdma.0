Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795536059;
	b=WwNnFO6h9U+ljmEODraSXP1Mnsw4nkLhIarwWiNHqVZNG2LNATSGUpItLZw0qYbRk2Tk
	 RVbuPXwEmnw4eCwRuQBydi2wYNtEs8P33020WQm8b+XPtIZIOauN2dlA/lnJIq3k8A/xN
	 ZuLXI6CztPb0mUfqFqc1Rr+Z4eiY/vRw0VDenM7SxtA+LlCSyOw0clyys9sThvOSBBHjQ
	 d30w9sOVWfsJpe1vU2swgkczbVkiIkz+2FAwYfaTF9HMR55X7ElLKyT+kR53QsSIvbCXR
	 iX18gIhQ8THH69rxSEgJtfJsLyV7pc3Q9oDXs0Zovg4lPw4GK+1nalSgs6krHo/7CZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795536059;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=MUtzdkl+QpeDISZ07EcrGkFOBND3mlxaluyfA+Eft5g=;
	b=B0YWOMrso9vQXb8TU3IN6/PGNFRAr3EWheOI9zGekhtzppEM2v01eNRDez3xguHJTD8d
	 HCi8lEX5kqy4XJ2g4o0Ozg9sdWfoUY/hAAREghmq4H1MC2SIqds+DVVeUETl/jw1jhVxP
	 hmShow2DihE6OHi7+z6/YzoRWxZHEbMGfoc0kLwci12IOhrTejiPK9nAMmDYoJAyCJoTf
	 NFOpIOHUGT15TN38Sm99+6gzuHMvkDG36yzq2p25v5dCcTZ/bfHLdMtCybQkLswmDW48c
	 uuDQE8Ml41hhESsOcH/CFgFqSNU4Y6RYS5Pg/ObMy8fullggOssfKlLY/NxlWyxbfQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LY6d9EUm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B508A606A321
	for <linux-rdma@vger.kernel.org>; Tue, 24 Nov 2026 16:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LY6d9EUm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3721D1F000CA;
	Tue, 24 Nov 2026 16:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795536059;
	bh=MUtzdkl+QpeDISZ07EcrGkFOBND3mlxaluyfA+Eft5g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LY6d9EUmluPHYCj7H5Ajumf4TcYkCoc8As70qJTID3Zd8uyICl/kDCglPXBd+XUKl
	 5gVd7ZqbSffSh2hmp5pxXRxW+ayRrpgcURA1gdBn4lPvgkitM0fuoTwtv4TD4H/cDS
	 vxW9F/hcJNDqp0INHjhpb0lIHHTt3BdB3HmoX3jpOsrRtoJkwGyL4v1XESgKyZiDok
	 Pn1L2DTFTo1078is8dzLdwh4hJwf27Ijh4xDwLQm5xSp2frokFkigGj4zjOS5mqKq4
	 hcHfleAH7XG1Z317ldu5qTnR68suZoZO+2tUKPRSgEKb2f02Z/f2jT3b5ngPrUpO/j
	 PL/r0zHhOSTzg==
Message-ID: <sashiko-outbox-231515@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v12 0/5] net: mana: concurrent HWC requests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.0@linux.microsoft.com>
References: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.0@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 16:00:58 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has reviewed this 5-patch series and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/hwc-v12.91ec3eff9cb=
647d5bc5cc932b3c6f60c.0@linux.microsoft.com
