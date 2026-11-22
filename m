Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795375006;
	b=vEnmEyOLPu6muR4rv3LcQ9R0QtWrspgHUtKvMl3RFDgbk2s0OiyGRa8XUXZkLvpYVvTa
	 zU8170bgDVNJlvFyC2+hkD8BvK9jLpDiC/J2bwW2LlayeAn+aIx5Q+2wt1N2Ot82OOBrZ
	 EL+d8hs2y3BxuYWyr3AG8XWkLukftm74i1B/KsDu2b9kAHZ3ta1hcV/eaC4G1zcT1cr2f
	 CmR+GB4lVrjBmNcR+QIyen3dTQ67auBGvzvHMJfVD1oYIWN2XCIOXmPjPDM+IVPVHOpxV
	 ltstV3jN2zUNtwMru39cDr5JPZJYnAdaqv79xhgr4byL/tU45Aom5MOpK8BQ7aVSvnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795375006;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HnOKfNn3f7T7XbXPGzfC2rRDRodnc0Y97hR8YVH0bK0=;
	b=r2npg7GpJK5k1EJocsWyF1qdgJ37PkxsPdeW7HOIAlvQ1PA3T3um56RyOCFaxOtW/bJi
	 LkOXJPmqyLMgARWszfy7dz++poogqnCXrbE3/EeAI6AkCH7Ec0bPxMPtG1EK8yBe2oKpE
	 iEvXpdW/4CrpwC3D3lBXH8mXhjVp2efUAhCZJKTGCD2AOoXOqIBRXyJKh9P4XdGR2Yiy7
	 7Plr3TXjqQK5UkPWb3t23RIJwk0hz2GNku71dtcxymltQgID4E6AMtuaEVtSM7hEJJ+hV
	 ctvkXHsPpCuXcjY3c3XBKjHF6OS5DRRg6AgD4pqhApi8G8OlGc1rdyNII+90uEFc+Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ivhav+q6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11B4606A31A
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 19:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ivhav+q6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265AB1F000C6;
	Sun, 22 Nov 2026 19:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795375006;
	bh=HnOKfNn3f7T7XbXPGzfC2rRDRodnc0Y97hR8YVH0bK0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ivhav+q6CiZx9EQaSHXtssNk1sLvq1fQiYGAa4BOyuwCzXR877BdwLn1HJpc3jxYg
	 4ot0E82lsiVqmPoSfhc8TQBlyt1BONh4M8NxNPfrCMmPTooan+ml7ro5MdydR+rSrR
	 NRY1oP+e9weWgeQKvLzBHazmZlNfmVXQ5xLVEW4aKLTl3XpjJj+R+0z6ivvdokmt/P
	 Biz/REJDGKOZLfRCVDpI8s//OAPhg7Kz03+d1uCV9abBredi1BOUK2o2K1oZ7vz7J8
	 ZJMmEDErz0XkT0Ps1Hm7WQwPmM6qQOPkm4r4GGhAaOgRkm04aV1fOjHcd+Prs8cLyz
	 M6r1lo5NQzqgA==
Message-ID: <sashiko-outbox-228240@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-rc] RDMA/siw: Honor the sg_offset in
 siw_map_mr_sg()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrew Stellman" <astellman@stellman-greene.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261122191128.65369-1-astellman@stellman-greene.com>
References: <20261122191128.65369-1-astellman@stellman-greene.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 19:16:45 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> siw_map_mr_sg() builds the first PBL entry from sg_dma_address() and
> sg_dma_len() of the first scatterlist entry and ignores *sg_off.
> ib_sg_to_pages() includes *sg_off in mr->iova, which siw stores as
> mem->va, so siw_pbl_get_buffer() resolves an address in the MR to a
> location *sg_off bytes before it. rdma_rw_ctx_init() passes its
> sg_offset to ib_map_mr_sg(), and isert can pass a nonzero offset.
>=20
> A test module registered a one page buffer on siw with ib_map_mr_sg()
> and sg_offset 0x200, which gave mr->iova at page offset 0x200 and
> mr->length 3584. A user space client then wrote 16 bytes with an RDMA
> WRITE at mr->iova. The bytes landed at page offset 0x000 of the buffer
> instead of 0x200. With sg_offset 0 they landed at page offset 0x000,
> as expected.
>=20
> Start the first PBL entry *sg_off bytes into the first scatterlist
> entry, and reject an offset past the end of that entry, as
> ib_sg_to_pages() does. With this change the bytes land at page offset
> 0x200.
>=20
> The issue was found by Claude Opus 5.5 running Quality Playbook, an
> LLM-driven code review tool:
> https://github.com/andrewstellman/quality-playbook
> The fix and this changelog were drafted with Claude Opus 5.5 and
> reviewed by me.
>=20
> Fixes: 303ae1cdfdf7 ("rdma/siw: application interface")
> Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122191128.6536=
9-1-astellman@stellman-greene.com?part=3D1
