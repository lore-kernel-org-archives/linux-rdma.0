Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0845D440622
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 13:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791551519; cv=none; b=iLJMO/H/1LtMHZGzpFAH24gajLZFSdCzWVdE/JbBR7Zpzoeburjt7R7/XwUZRPeEABC8Rmm8o/lMuJ6nYklMQxWDGQu0zu0zpZsxOnblBTbzXDF56UwenL+b+sXIc4iBy2oeh2ieq5KnP1p2Mfec6fmNx1HGJc0G6u3tM7YuE6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791551519; c=relaxed/simple;
	bh=Ra1V2MuWObZad42hlYnNF/Ltwjz0101oiT0FvHKcPD0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=pWYg1rKSvsYk7FmC0Zn3SaZ27NK0DUkIYJzcDgXJRGZBGn00+DHAouSdCVKmTVbb7Y4XrZq6qyj5CBcq+Q+jC63HsOYOMozFyaEY7CjTYGJbkTXm01INuAyYKy0Y29JF7U73ps27YgiAJ4fTXPEC/Tn8mUM3awC4AFoNZPciyWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=csAYiMwK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="csAYiMwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B161F000FF;
	Fri,  9 Oct 2026 13:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791551518;
	bh=Q+Dd/OrRao1rmjtBZrCzbokd7E85cBSgv3HORkFetp4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=csAYiMwK6xslkt6/ZCki+uDYBWtxH9Jv/DR6Cevl2+EBF8uoCgZcdBUm0kryCrcrF
	 zLXT7mMImYlhbWamrdkkwzeQYaNonHYziEZqvviD/6t6sYLorIMonjLwBUVqCYq0kW
	 AGZV9bbYAPsjDfGBxMWTU8IkC+MJASl0niVwio0EjL4dRuQQv+NsC/n+zHbhy5SG9X
	 UpUmv4alzQDRS5mJN5ccysBzs2rbYKuSiqIPgdzL74AaQYeV5J4yv0mtIfm2yEEwSJ
	 r0CBPm/SdMUF9f8WU7KwExc7d0pT3iRY7mtASVUuRIrZ13zzekWeLUyZ5o/6FtTnCE
	 wsmd4IQmZLl3g==
Message-ID: <sashiko-outbox-165606@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v1] net: mlx5e: Fix use-after-free of the MACsec
 xarray entry on RX SC deletion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Binbin Deng" <18983559317@163.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261009130050.37694-1-18983559317@163.com>
References: <20261009130050.37694-1-18983559317@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 13:11:57 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> In macsec_del_rxsc_ctx(), the RX secure channel is torn down with:
>=20
> 	list_del_rcu(&rx_sc->rx_sc_list_element);
> 	xa_erase(&macsec->sc_xarray, rx_sc->sc_xarray_element->fs_id);
> 	dst_release(&rx_sc->md_dst->dst);
> 	kfree(rx_sc->sc_xarray_element);
> 	kfree_rcu_mightsleep(rx_sc);
>=20
> The comment above the sequence claims that "xa_erase which uses rcu to
> sync" hides the RX SC from the data path, but this is not sufficient:
> the RCU protection of xarray covers only its internal nodes (making
> xa_load() safe against concurrent erase); it does not extend to the
> object pointed to by the entry value.  A reader that has already
> obtained the pointer from xa_load() is not covered by any grace period,
> and the bare kfree() releases the entry object immediately.
> [ ... ]
> Fix this by adding an rcu_head to the entry object and releasing it
> with kfree_rcu().
>=20
> Fixes: b7c9400cbc48 ("net/mlx5e: Implement MACsec Rx data path using MACs=
ec skb_metadata_dst")
> Signed-off-by: Binbin Deng <18983559317@163.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009130050.3769=
4-1-18983559317@163.com?part=3D1

