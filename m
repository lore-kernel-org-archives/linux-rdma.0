Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793336050;
	b=p2ThFJgDdn8jS7uST333Lcv+RTvjjjqSafBnUf+lp1Vcb/dt3F+bfLubZMkyLh0WnfMP
	 OXkims9bQNB1NHD5j/Jf0gj2LWzBt7Zke9QWVbWr4ry2r1K7LoJ8C33nd1n6Tr5AZeuL+
	 td/ag52RjhQQlwEth9Zp/pGGO+7ACwv4mE9NGAwpqGuV+7QLBnQssXsqOKmlHasILVTet
	 OXDufb3eruFz78tZSltZFMYHvdqHJXQZWfszudq6E5QHaY1vWpgDEXwYORKKkvNVI4jP0
	 4HuOsSS7KoOyBkL7FjaZkNvHEH6aV+M1IgPRUztjm4O5XoDrkm2LjIiqgcpMGtSc1Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793336050;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=v0pYfKFReaJ4bPp6YaRbiVEYvBkyWX/I8eO9gO0Mw6I=;
	b=xNt2DYDMv1D99PtM2oH1988fmk6FromgFdA28WO8i6vUga5fYJv/XWnzzjixtNRdN9tV
	 JflhXMrNd2Rtj656DFrnnCX6wZqyk7ZjgQ+xHdaAldIdoqRSeUWdout3t9qvCfe8fdFfu
	 DX/ChRECLs/wUH6ne6Ms3qgfVtGxvQpj739QrKkLafaxx2vj7jsVvonrb6nuRDYwGFmMq
	 hPdqLFPQXSRcXPiYBp5jw/fhvTZlF8EOuM1Ob11YD0ZHk1L76zsH7MVZTL8k1Sw8THr7V
	 vG+2kdPqwoAOFFPXFdLr11DDStPEMhkWwC1JmJaxgn7iGyRxWOti02HIo5vhv2a1EFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hzALrEEz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F73606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 04:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hzALrEEz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEEF1F0093A;
	Fri, 30 Oct 2026 04:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793336049;
	bh=v0pYfKFReaJ4bPp6YaRbiVEYvBkyWX/I8eO9gO0Mw6I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hzALrEEzgt+sgsP1cK2hFzlPA5qANrr7WcFoXx1vjkcqSqW4spAnRS78S/gnY/MLb
	 0lxHDjGQVAx+mVjxM186JN7JxjBnQKC0D67+oE0tfR7WlYEvowdYiZ3VRN/QarcGvI
	 mDDxX6Y3jRm2OiEnAI8GdnvgX+XdKbWPVKFC/tcqWZiHmUmyY1srILrzmhF/br667s
	 VAATjAQznbiDm4vQTN11c1R2569wR/kgU2Fua9b5tsM7S1d6Ax9ZMMI+YR1UoLZCyi
	 ij5hhQKKEdEtOaRdkP73nsd6438KsX8ed6ZYZTuSPoFiQF+bDaMul2Sj2Tc06MZZe3
	 F4XkvMuRqiXlg==
Message-ID: <sashiko-outbox-190414@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 3/6] net: mana: Introduce GIC context with
 refcounting for interrupt management
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260508221202.15725-4-longli@microsoft.com>
References: <20260508221202.15725-4-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 04:54:09 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> To allow Ethernet EQs to use dedicated or shared MSI-X vectors and RDMA
> EQs to share the same MSI-X, introduce a GIC (GDMA IRQ Context) with
> reference counting. This allows the driver to create an interrupt context
> on an assigned or unassigned MSI-X vector and share it across multiple
> EQ consumers.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260508221202.1572=
5-1-longli@microsoft.com?part=3D3

