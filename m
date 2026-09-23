Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC7A526AA7
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 13:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169845; cv=none; b=X3Z+NuYwQfVy+hygrXzjFw0OEI0tFFwYFk0II7AVNUFG1ZuevY3GzUNA2UOUjfLOoHyZTHTCQTmLDYsEJpVTgVVubKDsMULFAPb4nUhitr3rir3wDTxUcf01NQHvnB6fRA8xE4idVn7EO7/CMB+3+BLcQw/AvVe993kcjQle1o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169845; c=relaxed/simple;
	bh=v0Rp68A0D1LkJYiK+Bm1RDsbzzb+4NAHamqhVv1ZUDg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PMiK/E7zpmIIUdjKiJXbb/Sr1h02WyWKoWqZs4mg7GTiPXrU7zz25DzBDU/xV0ZEWU8vDfUuN3Er7LKKNmZDB74d2WFNbha9d5JEGKwulJRGI9M6O/vbR+Iz0fniqmW4pzd49YKbV/DlVIDNpOHSrDI6wFhvgCNuIoPyPt7Q1nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IBYGof2a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IBYGof2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0A2B1F000FF;
	Wed, 23 Sep 2026 13:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790169841;
	bh=v0Rp68A0D1LkJYiK+Bm1RDsbzzb+4NAHamqhVv1ZUDg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IBYGof2aYfHoCrbFDx3AGTRK0Sqxo2ZI99F7E/wwNyTBYPXIyvKjDl6lb455Ll1EP
	 aevJyKqQ+lY0YGP+GShW/DYeBjBuu5+Ud3Tu8X90DCpymv9uBAbGd0IepNx77Q2T1+
	 AKAtRE8pIZJVgbzM7OGSSYGU0zP+zrbG8q2eix8TiVo3oJ+IlG7t3T8K7JDq04iQzO
	 +29yHXFROL42vq+dsN6nlyVKnQ176/+GVJVihrgdnpz0cBFptiThlD+cupPjX368l2
	 Hut/i1KiFJRoR7zryMWi5J1IoGF0ph/62bP2ebc6Mx9j2XdKr22BkhflTnMe/fbbp1
	 Sn/cYkw6ky3TA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 2/5] RDMA/mana_ib: Revise UD send posting
 and WQE definitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923131155.4055875-3-kotaranov@linux.microsoft.com>
References: <20260923131155.4055875-1-kotaranov@linux.microsoft.com>
 <20260923131155.4055875-3-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 13:24:00 +0000
Message-Id: <20260923132400.F0A2B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Batch multiple send requests under a single doorbell. Move the send PSN
> to the common QP structure so it can be shared by all QP types. Define
> new WQE formats for UD and RC QPs.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923131155.4055=
875-1-kotaranov@linux.microsoft.com?part=3D2

