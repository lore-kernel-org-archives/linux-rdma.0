Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045D64A33E6
	for <linux-rdma@vger.kernel.org>; Mon,  5 Oct 2026 15:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791214104; cv=none; b=ZXH8bkqHlVm+OBh/mH6iqH9lgagz+bozDB0Ke5BKRbeuTHXBmmcQk/yTlZ++meuceWG6G1Qun2nFlqt3yfW/33H62uFTSbvdnVtQIyzO1soeFSuLAA9nlVjmoncWw+OG5cuBmoII/M3U9O7BZLHUkTNKo7JkO2ZlkyyzdXht6CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791214104; c=relaxed/simple;
	bh=eXTLplUUU5whPzKodRiKYtsT1NnKNaBiTPiO/XHOYwQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hOa5js19WIlJxDxWMMK0LgaX0NfkLB1oeYGpS7AU2e5WTmWtv4qZLaHm+MKNIq9SfraAN3ezMQvZGLi8U2tx4DQoVKudQcsFYqmeKboR4b0TdP3+NpKd4NjHW+10rHodZbgEQ+L+SW8HkcWH2YWcYuVLvATqyRvMuqOWFjKeP0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DXlnpeEW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DXlnpeEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8385D1F000FF;
	Mon,  5 Oct 2026 15:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791214102;
	bh=Ia4YrrODyDALK5mXRCR/f2OxRuT+2RbwJ6RCYoxTods=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DXlnpeEWj6i7qnpomyIshg30mXjnTVt4NDDmQOY4iS17uAXiA8UnN1saQ59s4GhWG
	 GbJeiuIC8nnNa6XD7j6C3ePxsbkuxvOmCEU9BWMnXlJxp7U1YbqoX5YYGXM2vmQhQL
	 LnGq5s1aDUKWj1wrWNdNu/13AW1fomuD/nuuRcN+6xhlosRoB2l+1Bto/uOpSsB6ti
	 Qr/ePnFMCJynXOMgk/uYu8vVuW+LMXSgwxyAdvpNv/O10HBuCt4rcZ3KeStemCexev
	 MOwJLBtHoS5g7zGinL32jjACnOoDFhY3mPfKxHmnPhEKrbCc5E3fSf9XB6STVtPE6H
	 HVuZqNKeSFeGw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 for-rc] RDMA/siw: Enforce IB_ACCESS_REMOTE_READ for
 read responses
Reply-To: sashiko-reviews@lists.linux.dev
To: "Haitam Lazaar" <haitam@lazaarsec.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <1a10ca50b82.4c79b9977088.8671544618706545172@lazaarsec.com>
References: <1a10973a2a8.17e04b672219.8760522594078806286@lazaarsec.com>
 <ecf307a2-e814-480d-8da8-1a7b76537d3f@linux.dev>
 <1a10ca50b82.4c79b9977088.8671544618706545172@lazaarsec.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Oct 2026 15:28:22 +0000
Message-Id: <20261005152822.8385D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> When generating an RDMA READ response (SIW_OP_READ_RESPONSE),
> siw_check_sgl_tx() unconditionally passes 0 as the required permission
> mask:
>=20
>     /* Reference memory to be tx'd w/o checking access for LOCAL_READ */
>     rv =3D siw_check_sgl_tx(qp->pd, wqe, 0);
>=20
> Because perms is 0, siw_check_mem()'s authorization test:
>     if ((mem->perms & perms) < perms)
> evaluates to (mem->perms & 0) < 0, which is always false. Consequently,
> an untrusted remote peer can issue an RDMA Read targeting any valid
> STag in the Protection Domain, even if the memory was registered strictly
> as write-only (IB_ACCESS_REMOTE_WRITE) without IB_ACCESS_REMOTE_READ.
>=20
> Enforce that the target memory region was granted IB_ACCESS_REMOTE_READ
> when answering SIW_OP_READ_RESPONSE work queue entries, while preserving
> perms =3D 0 for standard local sends.
>=20
> Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
> Cc: stable@vger.kernel.org
> Signed-off-by: Haitam Lazaar <haitam@lazaarsec.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1a10ca50b82.4c79b99=
77088.8671544618706545172@lazaarsec.com?part=3D1

