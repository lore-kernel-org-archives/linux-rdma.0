Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3F849A3D6
	for <linux-rdma@vger.kernel.org>; Mon, 12 Oct 2026 15:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791818211; cv=none; b=FJBtuqMEhXcKaxnm1s+b+4StVsD9yfL7l7uQw9yDMoml3DiHZNt0JAOzyziSACxyrb5mLuKLhBKYfkvTKgceirXhk+pbucx32EoobhPAudf940vVyNp7uueyDOyV9sFy0BDb1DQ+oHUAkE8tk+g+42A4SZfW0/Nauhlj/li53Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791818211; c=relaxed/simple;
	bh=lhhudQwR9x8S8Z4R60Y7zpH1g85zL3GK0U70p4JB1sg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=o8yIWHJYHsMS08vtAikVK2AeEgy7aNS8X8GcfZhgIqJSBzq1P3SIu2Ki7t94NnzZ/uauALJQKbyayq/sCgXo/reLCmSdTBOQifXmWXx+Zfma5nobBKSTk6jSxhlt0EzgaJ2/7bzLhSak2pgwf36eMXIUnB8tJFExVVtDxrbVaJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kg7QF8BU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kg7QF8BU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E80A1F0089B;
	Mon, 12 Oct 2026 15:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791818210;
	bh=lhhudQwR9x8S8Z4R60Y7zpH1g85zL3GK0U70p4JB1sg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Kg7QF8BU2T/k0GLrvd38fdMI8QeyGu9wyzn6QR/VRwzuNBSpuP740ykyO1rS+PYdn
	 qLV2W7CxjVr7YpdMCk9Ey/486N1uDwyHuJ3fLfO3MCk/JIjc+QoR1uq1HiuvZLo8b9
	 ZSwAN3FmZvwYB44se9KjBdvBfzcskW28s4s3+fK4AMS4RarkS+6OF7VdWdXbjyo+1p
	 MFlMpv5VKbMIdb5Zw260Z9/uzIMe7NJvpaiYbZWLWz4bvHEp2D+F2UZ9floZ4MMRiM
	 hRkTSzm0fr/Yqys2uuL796lKu801X1sIVOn6UbB8FhGOI5UPLy4baAqA6XLxdQrM1O
	 VS5kGmKtF51GA==
Message-ID: <sashiko-outbox-168322@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next] net/mlx5: Remove redundant memset after
 kvzalloc
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sang-Heon Jeon" <ekffu200098@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012150311.555104-1-ekffu200098@gmail.com>
References: <20261012150311.555104-1-ekffu200098@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 15:16:49 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> kvzalloc() returns zeroed memory, so the memset after the allocation in
> mlx5e_post_meter_create_mtu_table() and macsec_fs_tx_create() is
> redundant.
>=20
> So remove the memset.
>=20
> No functional change.
>=20
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012150311.5551=
04-1-ekffu200098@gmail.com?part=3D1

