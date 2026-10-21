Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792542207;
	b=LdyE49R65l1YHF/sTW71Ty2Z+4FKun3rrwjR4JqquyxZp4+SW9+VNhxDsVPuJyaV36SP
	 zcKIwBsCUT+b+PcOamnySb++dAJJoX4UUu6HjCKjQrijzhkFfFLMXMYpiZ4wPcYmIFFXu
	 HCf8nDwVHJNNiAc8VDuDBkDde3YNYjBFQFdak/ATxbC01DK1w4Dw+ooQKhdLAV+L9loTn
	 920P6KQUsejJRN0ayd5hyjDaCflwXfhqwshzwRAyjJkK0JPmVw0zcKkrxG6nwv0jUC22U
	 6EiSphwYZaEXVUHQjUcAuLCIFN7WojcJWT7AbolsMndodgvdaKOS2c6vtYVgAWKCdHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792542207;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lrFJc4rz699fN3rUmp45jsAkSM2tjOCS7q31OfOP720=;
	b=EIeEQ0MVJTVXdZbmn/9SsNlVzKjuW6mtYRp85pvIIi868T76VGKLsoZWkaMeimnaiVe/
	 tD9emVVjEgX8tOLqEDT8iQC73pURhJ5XyYMuAtrsryaC3TR7QrBkehf1WB2aMmyeiq0iU
	 uxGcszd5c+k89lvY1LRJpm3u0SR7T+q9oOGb5pFpDaS7m2dno3smZSmvE/HfbBDaZGdWC
	 4dDqFgb1m4j7KMWVElMsPbjxXN0octsA4inCw83CACbhoNi8/1IGh2BCP2HqHWBhVzlC8
	 8qL6uaCC6VAAlGFwYA7rJoNAqcvkGXtewoOZw4+EcUCweRzi1vjBJbqOdYd7RICigIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BnjUOcW9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03896606A319
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 00:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BnjUOcW9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E571F000C9;
	Wed, 21 Oct 2026 00:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792542206;
	bh=lrFJc4rz699fN3rUmp45jsAkSM2tjOCS7q31OfOP720=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BnjUOcW94n01m8ky9Klr0l1ujYz0l8KXtEluH1KRdqL1m0ICj+sznVS2EWLv2CYvs
	 4PL+8lZvqLAUDmmIvsRNDeAKmQP+27IgRQK7Bd65FbIg4OefkvR/nhO2x5A3nJvdRq
	 frq/1fsHECg+jyRjbQ+aXLAVgTKKXGvUAPFoy8qO0B6r5/4obofUaw0SL5en7BMBbQ
	 XsjJFeEiOOPrgKhzW0iMvBKVd0O8LGZG3hOgiHApsQyVfCRPM6jlG06t/7vIlFDtFo
	 eEpuFzBain/6k/v+TLJpCXJtdgGKPI9vWID7ltb03rXT9zPkugKUWzPLhiabq0dnne
	 yQj3ccRLUv2Yg==
Message-ID: <sashiko-outbox-179634@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/srpt: bound the indirect descriptor table and
 widen the counters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261021001854.2343027-1-yhlee@isslab.korea.ac.kr>
References: <20261021001854.2343027-1-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 00:23:25 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> srpt_get_desc_tbl() bounds the number of indirect data buffer descriptors
> by the two counts the initiator put in the SRP_CMD, and both are u8, so it
> admits an nbufs of up to 510:
>=20
> 	if (nbufs >
> 	    (srp_cmd->data_out_desc_cnt + srp_cmd->data_in_desc_cnt)) {
> 		...
> 		return -EINVAL;
> 	}
>=20
> Nothing checks that the header and those nbufs entries are inside the
> information unit that was received.  srpt_alloc_rw_ctxs() walks
> idb->desc_list for nbufs entries ending at
>=20
> 	sizeof(struct srp_cmd) + (srp_cmd->add_cdb_len & ~3) +
> [ ... ]
> that fit the IU are accepted with every context freed again.
>=20
> Fixes: a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021001854.2343=
027-1-yhlee@isslab.korea.ac.kr?part=3D1

