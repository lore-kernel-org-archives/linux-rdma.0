Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA2451AFEC
	for <linux-rdma@vger.kernel.org>; Fri, 18 Sep 2026 18:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789755157; cv=none; b=bjdHJ9gS1ywZ3Y1aAErqVFMaRkEpJfV0l0XWhFziDb0Vl+BYBz7RC9nlaLoxP3DEwakh1ObEcNr2lR44JeIvK+fdzWumP8HgfbAq2VVZXeFEiZVNKjwbyT/BsjKibhzufOwCEtMjotzghxg7fIzqw0wOs3EC+GqM4oaWHWLdx0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789755157; c=relaxed/simple;
	bh=5BF+wSJY2B99T8EjQ7Bwz2uFa7Bz5LayYD/FACRRTt8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BPHh+zSbnVUOUVMAl/fiJ0W5qevDno4CaSiHlyv+fXx73YRpjJ7pyvMiyC95dyVPQxho1lhlYmh6vibPICwwIFE4xxo8BiyiTHzg8hJjh/JAshRpCNfre3rhn2ld0tKCVi67UnluwE2YrSQwxgKWtnoo+T90HAE4Eiw/j2glaW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=atvfHmdU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="atvfHmdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3371F00898;
	Fri, 18 Sep 2026 18:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789755154;
	bh=5BF+wSJY2B99T8EjQ7Bwz2uFa7Bz5LayYD/FACRRTt8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=atvfHmdUpCZGOKb5FpcUT1uCytCkckQ1TQmNtcvDWWgF/fPFVaDla+pk1iSlONGCE
	 DsEUGJVIcydUur1KiZvdyz0LCZkGP7DOzTU/1fYfw+gybBSrMCJPaSoHMOKyWSchnC
	 fFp5BkSkV/u7ZxPKcXbJ/AcyBUtNG4oLNI0ctrWxJZ7eJfdz0Gpc1yJNowwIZvW54S
	 p8Gyhq0LskbPnE8qfxQTfIAJd10nSheusQDbsGeaxFvNonnlrWA9de+vDa1/M0/+Gn
	 YEIDjMLNiQejQX2M/niGErXM9s1GZ5JF53lGo4n2ZWI2deDcgB7m0pyZKSB2BjyPTI
	 nuuYq1XdyAZ/g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net 5/7] net/mlx5e: macsec: Delete remaining SecYs
 during cleanup
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tariq Toukan" <tariqt@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917175433.4090878-6-tariqt@nvidia.com>
References: <20260917175433.4090878-1-tariqt@nvidia.com>
 <20260917175433.4090878-6-tariqt@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 18:12:34 +0000
Message-Id: <20260918181234.7A3371F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Cosmin Ratiu <cratiu@nvidia.com>
>=20
> Suspend invokes MACsec cleanup without unregistering the netdev, so
> offloaded SecYs may still exist. Cleanup frees their owning context
> without deleting them, leaking driver state, encryption keys, MACsec
> objects and steering resources.
>=20
> This change deletes all remaining SecYs, which releases all HW objects
> and avoids leaks.
>=20
> But this only fixes resource teardown. On resume, the macsec driver may
> still potentially have a lot of state it considers offloaded, but the
> resumed device will have a clean slate. Fixing that is outside the scope
> of this patch.
>=20
> Fixes: 3fd3fb6b6b88 ("net/mlx5e: Move MACsec initialization from profile =
init stage to profile enable stage")
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917175433.4090=
878-1-tariqt@nvidia.com?part=3D5

