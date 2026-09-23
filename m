Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2CF47D452
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 13:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169878; cv=none; b=CIl7ey+33mP8pzyo2ggo+kntZKS85EFoHEiy23obEOAyaGaE/42Azu7wgF5aLc7ftluW4g+3G9xKlzWfvTXj7S2fL90UJwbW9TkLXI+ACGhM5Gncnd1yMbZ3cRXWEzxZjt7ViAKNw2dXXtfrKby7U7hflcFuQEFngHtpcTSwyg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169878; c=relaxed/simple;
	bh=kajc6j9roQpb/ZQn5CXAcdt22wGabx841umi3iHOCX8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Qu+FWynIt4j7QFLqoE0u3USfMs33BLeqVwDJ/1/w3w4OTQ82CltoBkVyaKpzviuLst9xBgpC6iloAygZRUGDypfBYYLpC1PZHKhHjaRnoATc7wHat23OxrECw2tuVPVz2DB4xceSYys6JMJJ1cjeTCQ5NIyvSk3190jZqZhcnd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AQLCLAPI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AQLCLAPI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24CF1F00898;
	Wed, 23 Sep 2026 13:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790169866;
	bh=kajc6j9roQpb/ZQn5CXAcdt22wGabx841umi3iHOCX8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AQLCLAPIT4lMNbuuaRz5S2TW/Prj2wDsT9GvMMrQuch32ity4XK1t0iS3pUtOHpcQ
	 JHPQYiK2FB9EJy30xBlpyxUB1y1AZBeiBsoJYDlvoIxuA5Wt2wFikluuio6QWfi+t2
	 uBl6GCsYbrhvZmXsGXN2YJNUXV5IoWvqoNIJCF+RQ5ltZezdwQbynpVjKORGVMlTBQ
	 kKXrTUrhnfLdxX3mB7jKzPXIh42jtM0oX4J8eq+hu4XWnisNLp9f/6bqh+FT/7Q4oU
	 AvslxvXP2UcZH63LCHxfy+DgyL38RDFaEG7ZJCTpzbhMNaVGvIEcVx+Io5j4HjteuE
	 58TKXl1ShW1lg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 4/5] RDMA/mana_ib: Make kernel CQ arming
 robust
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923131155.4055875-5-kotaranov@linux.microsoft.com>
References: <20260923131155.4055875-1-kotaranov@linux.microsoft.com>
 <20260923131155.4055875-5-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 13:24:26 +0000
Message-Id: <20260923132426.B24CF1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Track CQ polling credits and ring the doorbell promptly to advance the
> hardware CQ tail pointer. The distance between the new and previously
> armed tails must remain below four times the CQ length.
>=20
> Expose CQ arming to mana_ib through mana_gd_wq_ring_doorbell_ext().
> RC QPs will also use this helper to ring special doorbell offsets.
>=20
> MANA hardware ignores duplicate doorbells. Calculate the arming offset
> from the previously armed offset and poll_credit to avoid duplicates.
> Do not arm the CQ if no CQE was produced, because the CQ remains armed.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923131155.4055=
875-1-kotaranov@linux.microsoft.com?part=3D4

