Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B1052CCDD
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 15:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790869047; cv=none; b=knjzcpAXo6kmCXgcGig/WgfUpIQ3Gl1bMJRSz74rqToXsEBa+PUbiPNUCJMGzKJuxRLXa24WpORPCDPdR7LGrl8tkkvLUG1LykyB3eC6VayxoccDswrUlC4wmBVhSNYS0ueORsKKHhtRh1H/h3DyTFxDWEjHch1c3l+8PSyc7cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790869047; c=relaxed/simple;
	bh=fkUwoau0YEVR0QzgMz9nYxCv1pe3o4DdpP4crLSvqxU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UfvCEqoUjVRnQV8RyzeC/tWgzGOCBXca2pxlWAjEyRaHY2MlTZw2gqge+7gfddkZqJUsLjGZINwoQJI482CIHtMnQiBifMKrlSCcoAEkdD2GbneKNPcUCnoh2KMmaUb1dIXs3k7GxCsc9M+ldk/oAtAJ8DYOuGzf7lbtq8n7eCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VFRDCwZj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VFRDCwZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FE51F000FF;
	Thu,  1 Oct 2026 15:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790869045;
	bh=npAqyAGFjg00sSOlSDI/VzbZi8aBLL+dd1GzKLzW6Lk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VFRDCwZjmr0i4yiDXe3KNh2KeFOTEXaJOKc/h0UX3wIDOp24USSo37/qWpoUEtTMh
	 qG2AJSBwjQBbVT0bucKWnFFauoZUZlL13uR8vc7VWvy2BjAcmsRGnEg11HyJohGUbh
	 Clb4qu/l/xVh1lI2enRP+1kpefDpR8GgqETo3aP6hH6C4CtRMofj1AJHEWjfq+GaP8
	 wAGkclL1VdiSv2jpGmYoa5pKZ1WSroh07oSRGAjXkWqJ3yVq47FYlecQyltRZqYr5O
	 wt8Vu6qJ5KbBR+tH07dpnfKF7PNIHVel9Dh4Q1T8akvsYtwK69jVPZ3xE/O5Y1NEZ8
	 CbCwQkiOf1RUg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/rxe: validate inline sge_offset in
 finish_packet() before indexing inline_data[]
Reply-To: sashiko-reviews@lists.linux.dev
To: "Youngsung Ahn" <ays511.kr@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261001152433.3259573-1-ays511.kr@gmail.com>
References: <20260930182216.2510953-1-ays511.kr@gmail.com>
 <20261001152433.3259573-1-ays511.kr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 15:37:24 +0000
Message-Id: <20261001153725.53FE51F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> For a user QP, rxe_post_send() takes the qp->is_user branch and
> never runs init_send_wqe(), so
> dma.length/resid/num_sge/cur_sge/sge_offset all come straight from
> the mmap'd SQ ring. In the inline send path finish_packet() uses
> sge_offset directly as an index:
>=20
> 	u8 *tmp =3D &wqe->dma.inline_data[wqe->dma.sge_offset];
> 	memcpy(payload_addr(pkt), tmp, payload);
>=20
> inline_data is a flex array whose capacity is qp->sq.max_inline, but
> sge_offset is a u32 from user space, so the source pointer is
> displaced arbitrarily past the WQE and the memcpy reads out of
> bounds.
> commit 126c757e4cd4 ("RDMA/rxe: Validate num_sge/cur_sge before indexing =
wqe->dma.sge[]")
> added num_sge/cur_sge checks on the send path but not sge_offset, the
> third attacker-controlled index in the same struct.
>=20
> Read sge_offset once with READ_ONCE() and bound it (and the payload
> that follows it) by qp->sq.max_inline before indexing, so the value
> that is validated is the value that is used.
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001152433.3259=
573-1-ays511.kr@gmail.com?part=3D1

