Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51BC4825CB
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 20:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791578593; cv=none; b=pVYIybOvtt7aQu2uOJ6sK85mrySY6wJcrag8rbW4BkBB7pcNg2PAV8f+Qzyg5j27dLvgQKyOqQ4RYlRgvoGwCOabB84exRM7Cp/PJDyAiiEvuC/NcQ/H6/xH5NlmiVgp2t86C2QNrQQo/HthmTFdqtqvzbbAErGWaZWH2TFa+zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791578593; c=relaxed/simple;
	bh=XdH/cPV+yINmGmGrN60Y1j/XGWZKYcLd1+VzSFvaUcc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=CBzejptdjMlbEQmez4x739nlh3OHhpiKkcFcXjgUsB6w9+4RLmnLrsKCaGIl+kr4X714BOLzeJhcGOE8naqDFYOtlmY3/3N6VvgMVb5c1VyL9doRzrs/fVMb893IE2dkj/lkJsM1g2KeUjzPEGQfE6QwXNGoP+zouEwGegfw3fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i91lPrDY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i91lPrDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4FA1F00893;
	Fri,  9 Oct 2026 20:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791578592;
	bh=XdH/cPV+yINmGmGrN60Y1j/XGWZKYcLd1+VzSFvaUcc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=i91lPrDYtWLoauuR/GCegFergkZ39LWMTRjFFUgyg/Zj/erRPb9k2Eoce3eB6d+Uk
	 hFrGpfsgppywYwJa6xaeLEzWkJcazjkJhurw4PUWgspFTaY330N7P9T73MjlXSan0T
	 AE/+JxAHMQtcdMXxwyAwWiO5ippiRhHF2wWZYdHRC/ZY0lWGHXUnDJtfgjAjOQM4xP
	 S/i90ZHy+Mm60q/GI7ULdLrp9tPze1Uj7wCrqUWxyPDXWzYJJQeczotcvskGCwK312
	 ztet5qz+esNYYZYCXmWFJmtARoWYBIMANCYmu/ow1W6hoZ3os2Nr4UwV5iGUU6hf/b
	 rIOPip8VOtRtA==
Message-ID: <sashiko-outbox-166054@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 1/2] net/mlx5: HWS, fix reformat pool creation race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alexandre Cassen" <acassen@corp.free.fr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008204230.3222198-2-acassen@corp.free.fr>
References: <20261008204230.3222198-1-acassen@corp.free.fr>
 <20261008204230.3222198-2-acassen@corp.free.fr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 20:43:11 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> mlx5_fs_get_pr_encap_pool() inserts a new pool when the lookup misses.
> Two callers allocating the first reformat of a size at once both
> create one and the second fails with -EBUSY. TC serializes these
> allocations under encap_tbl_lock while RDMA flow actions on the FDB
> don't.
>=20
> Sashiko AI review of an earlier series spotted this issue.
>=20
> Tested for regressions on ConnectX-7 with firmware 28.48.1000.
>=20
> Fixes: aecd9d1020e3 ("net/mlx5: fs, add HWS packet reformat API function")
> Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008204230.3222=
198-1-acassen@corp.free.fr?part=3D1

