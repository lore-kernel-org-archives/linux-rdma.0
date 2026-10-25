Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792929567;
	b=WDbG1WGyCfVKAXnf38BClZpQA60m5HXZEKPj71Q0TOfoGhUPEaX80lAJuhwFKWugU2od
	 PnIQIuP0uLQd9ep+TS/NnQQMUPL2HQOeDttVVfCkEmYpdooMe8REMW7E+nQw9E4KFp1lL
	 whEKAq19HYw8kV8uqBTntvwfitvmnznSVdlJitgRf41MDBVcAGQQJXCikY6j/uvSMQSo5
	 g+aqhwWItevAbJmbQqfgqgbXjSv9VSKZNhctSqQTJMwyRJEI5ehniANPormTocZoII5p8
	 9jWv5RP7gwwjnWBEnmJop8c4iNtIducPKgBQyZa9gu1VNErdfa0OCVt6IqAkkSF6ntQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792929567;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Erc+ZGrxH0i24aCGh5xLKb7j3oxCPK1bFcBbkVeaLKs=;
	b=pXv+pCPtASVCAOZrDq0mBUZybArErQIQ5zsXL3FlCpPp6/KnATFQBZ9pFnHs8ZbqvgX1
	 5V7WQ+s6+Z0wCOvq2hpIcFyWR+WHZgapUHfOJuq/5hN/karQnh8ugZfeX9WwcMlBRPZM7
	 aivo6SyuBuFnEFye1jMCeemAcmDYrc04AqG4epaS5QT1TSloVy/5e32/oiMm3lGvEX7PF
	 36fl1ylUPeD8SFkk1DkVGplh3ECTo1e7VPea6Kkc/TuZa8f5RzseqZlI6fE/jqiym5miK
	 eE3q/gubjAlF0HV1Q4aToK0N29uDuUwbSCMXHVS4bTS4iKnKm2PzDgPLZhvOfp1jqOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TXHe4b+Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49005606A31A
	for <linux-rdma@vger.kernel.org>; Sun, 25 Oct 2026 11:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TXHe4b+Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB28C1F01825;
	Sun, 25 Oct 2026 11:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792929566;
	bh=Erc+ZGrxH0i24aCGh5xLKb7j3oxCPK1bFcBbkVeaLKs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TXHe4b+QlAFTqQ971GIvgv3WwKKT/11UQ8uWqz4vm5x39p+lVMmz4SdyN7Qi8CoI1
	 ujFw4PN2qjXXmJ/39oYgTZXWHeczOEowpD/T9+P+yXqMJL7p5nqBmzAWJG3q/rzld3
	 +rNufM1P79L3ZYZX9xpdEJkh4q1a9WdMsrrSiCBHieDSzgDS07eQjP3W6oCwH+31nQ
	 NK9YsHTGX1EwLP6W09PRL3zbrrzhFDX12qVWIykjw/a5pjASCmJBY/HvcF5huEnDmX
	 fcZhUvqetLa+YLrlpCDWn09wkiXd2d31dVYtaM0XHDN10yjgoKmm5Y34pcQ0Ia+4o9
	 bG1RCkELqmlCQ==
Message-ID: <sashiko-outbox-184200@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] RDMA/srp: refuse a target that cannot receive an
 SRP_RSP
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261025114155.4007867-2-yhlee@isslab.korea.ac.kr>
References: <20261025114155.4007867-1-yhlee@isslab.korea.ac.kr>
 <20261025114155.4007867-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 25 Oct 2026 11:59:26 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> srp_cm_rep_handler() takes max_ti_iu_len straight from the target's
> SRP_LOGIN_RSP and srp_alloc_iu_bufs() then sizes every receive IU with it,
> so the target alone decides how large the initiator's receive buffers are.
> Nothing enforces a lower bound.
>=20
> The initiator parses a 36 byte header out of those buffers. A target that
> reports a smaller max_ti_iu_len gets undersized buffers, and the header
> reads in srp_process_rsp() then run past the allocation. A report of zero
> is worse, because kzalloc() answers it with ZERO_SIZE_PTR, and on a
> transport that maps addresses virtually ib_dma_map_single() returns that
> pointer without looking at the length and ib_dma_mapping_error() reports
> success, so the buffer reaches srp_recv_done() and the read of the opcode
> is already out of bounds.
>=20
>   BUG: KASAN: slab-out-of-bounds in srp_process_rsp+0x757/0xbe0
> [ ... ]
> cannot speak the protocol, so nothing that works today is turned away.
>=20
> Fixes: aef9ec39c47f ("IB: Add SCSI RDMA Protocol (SRP) initiator")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261025114155.4007=
867-1-yhlee@isslab.korea.ac.kr?part=3D1

