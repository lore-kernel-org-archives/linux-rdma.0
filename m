Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA808451996
	for <linux-rdma@vger.kernel.org>; Fri,  2 Oct 2026 09:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790932386; cv=none; b=uDLog4Td0Br+LsSZ0WlE4KMTj48ltUhgEJKPAAEDksrsOmhafWbI1/+RAr8f9Ft2EesADIkoUDkbVaqvF3gSMLmWxlRtG4sVvBl1/EbDrww3vV4EPuCiiC1tN8qiCWLG63DyhbvLiIKI+f0/L8Cbio6PFbiC5Mu8EdfD5ieSEec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790932386; c=relaxed/simple;
	bh=0PIObkMhqvjiGAXoZFY8kAdLWk5YEXzf9P8AwAgywZA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=WMskaxZuD0er0pKx0YYverbhF6EHgUqyE8pJfz+5RzBo2nuk17Et6/aApz0mE77/2g1SCiwKw6RCgQGNXKYDkeCc+H+qXh9PvZMv0xyfUoLBAgAjVI88C5Fjv0I5+0VjfiuhUEhdAI/2c/bZWNVScpIBPfB6ZxWydvTAKn3k1uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PwSyS2JZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PwSyS2JZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772151F00898;
	Fri,  2 Oct 2026 09:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790932384;
	bh=0PIObkMhqvjiGAXoZFY8kAdLWk5YEXzf9P8AwAgywZA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PwSyS2JZCBOt22oWIRLHOnRLZV65LOKWEWvi4iNFKA4fnkcvYU2t8X3ThtnzTF7TW
	 hDtmUHgQ2b6oh5SY1y/Gu2kSmTYyA3VBs18RDD/dmQ3wh8ajeDgrsMdEqYsPjRa58X
	 87d1cH86Zg54rLC9TPCWSr3vCJK+IG/EYjfZXY7mkVupldx7OW26k32L5ztrbj9CXE
	 xCV089Tfifm9Ac03v1Tc5gHvCgL/QJou30lcx8vWCAWAiFgEJS+D+SpXMpU3PMZD0c
	 6zIgpQVsWLR62PalLVU7UHyo/1/u1ZDLuA67xu96Az0VDK5X7rWx3D7ADIJdkYzZNJ
	 YpwcoWKLlR49A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 01/10] RDMA/mana_ib: Allocate and map
 fast-registration MRs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261001182015.1757203-2-kotaranov@linux.microsoft.com>
References: <20261001182015.1757203-1-kotaranov@linux.microsoft.com>
 <20261001182015.1757203-2-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 02 Oct 2026 09:13:04 +0000
Message-Id: <20261002091304.772151F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement alloc_mr and map_mr_sg for memory-registration MRs.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001182015.1757=
203-1-kotaranov@linux.microsoft.com?part=3D1

