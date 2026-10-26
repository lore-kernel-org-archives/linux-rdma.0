Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793006046;
	b=bKK3rqcAMqbwVS2NUUawpMP67mZ1k8FyRBGs590giiR8rBTbf8yKy38oYcbFBg+6aWrY
	 /pBT/mT7YLmz6iaqMc0qzDK2LWMQ653BnRJug9xIzwSkLZ+A97tZMlY8g4ostxHICl6Nh
	 Z8NWXTKZMVdVFp62AlSjvbtzBFc1n6KBj52fu843xeEsz7iStVxsTfRu/DSSBjxkICPK7
	 b6q6q4jk8T28t1kmXPvK29xWgeK3EOSQS9jhj8gwZPy39u+wBMsQAjqZx7nswJyMSNlI4
	 ja6uPJLvlxt7p8452vaWd50WfmPr/TDkFnQaU8gjVP8FBVR0nywteykLVOzmHCWvzAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793006046;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=3jsEKhVIk0XDtyXeGj5F5FwNhSRQl+uijFkxZMJ6ExY=;
	b=mheW1P5I4dY56341WmG1RTMUtWhBd+S+7y6bMeGoKM39/0x4bxUP77TrlZO1lz45gREY
	 SwPmjiUn7ojGcmhQr3xKJIkdcBcIdwWZuVu+nsbE9CerKBgQFNdGXeChVunlJAwayOvu1
	 DSMORVbIs1eTHwZUMa1PtD9DkulR+u9CcV2kN3DIZQf1vLyBFJyr/zJADNbGSEXokZ/7p
	 oJzwE0hIO+qaq9Tnh8hR+Gjf1z15e9BR8QlhszLBNcdFEevJKoFhmK69A+pQii+I8u9Da
	 yzIWjmcNhg5Z3CpwWemEpDT+VGDupeh3SESyEsRxxakkSRASqOVO3eaqo+AzWsw3VQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="lZmRy/9q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E268606A31E
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 09:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lZmRy/9q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCB21F031E9;
	Mon, 26 Oct 2026 09:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793006045;
	bh=3jsEKhVIk0XDtyXeGj5F5FwNhSRQl+uijFkxZMJ6ExY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lZmRy/9qfqB/tvDCNdrw71QFvqXVug9sdzw1wE760TYjJbCEliaADWXjeII3lGZCy
	 iK8AcOD9vgkWfz7JMyW5VElk5J3ppn5xgf5O0ikOpnNHEVJN2yOMl2PIThSzLWNRWJ
	 LDMccWDjUNkfJCLmfVuTIAsbNy+H98GgWe2LLe0WKy0VPpuftUJdqQuqK5tC4ORnSt
	 xLraHd/Bwnh4abY/yvgxJyO6DOI2tUzG4yOdvObEjp8R7M//gGBBpHRo+lOPcMGbJR
	 gDa1Kyzz/afWMxluP/rQy1U6424t6A5rij3+FYfsDvW1wtzAewYcoUhQATrGL5/gsu
	 mJmDhBeYAzDsA==
Message-ID: <sashiko-outbox-184749@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] RDMA/srp: do not DMA-sync a receive IU past its
 mapped length
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261026052030.296361-3-yhlee@isslab.korea.ac.kr>
References: <20261025114155.4007867-1-yhlee@isslab.korea.ac.kr>
 <20261026052030.296361-1-yhlee@isslab.korea.ac.kr>
 <20261026052030.296361-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 09:14:05 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> srp_recv_done() syncs the receive IU with ch->max_ti_iu_len, but the IU
> was mapped with iu->size.  Those are the same value only until the first
> reconnect.  srp_cm_rep_handler() takes ch->max_ti_iu_len from every
> SRP_LOGIN_RSP while it allocates the receive ring only when there is none,
> and srp_rport_reconnect() keeps the ring across a reconnect, so a target
> that reports a larger max_ti_iu_len the second time around makes both
> ib_dma_sync_single_for_cpu() and ib_dma_sync_single_for_device() run past
> the end of the mapping, which breaks the DMA API rules.
>=20
> The HCA itself cannot overrun the buffer, because srp_post_recv() posts
> iu->size, so sync the length that was actually mapped.
>=20
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> Fixes: aef9ec39c47f ("IB: Add SCSI RDMA Protocol (SRP) initiator")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026052030.2963=
61-1-yhlee@isslab.korea.ac.kr?part=3D2

