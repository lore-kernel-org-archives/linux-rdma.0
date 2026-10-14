Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286294AA1DA
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 22:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792017157; cv=none; b=FEy8892M2CCmZfn4Gpsq61tztkULx1zp/usUpmHqb1Im3EX8AJUVQi38AzNLQXdg+Lf7iG7AwOudzq+ZA52+cSmzFIByYqqREXUoklaq8QxIUpSh+UsxcRbU3fxZ26JfETNhg+yLYQypwikByndAgzjvMyjSOEdzrmoyuH24Ufg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792017157; c=relaxed/simple;
	bh=5T+he2ZSSFvN1H07cmM6Dmv4ET9p6t1VVqpQ+Ie6Ee0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=LEx+r4T2TE5Zeaqhmy1xVU6vrHcf3iFVBgm5CcryMXLllpqzt6rjnrj30o5WfZqRM1OKMER2aFqOONl3jN7nsVlfA9/Z6NQgXK+/FWH8HkUvj0fTeD5BqThMgdk5PrWw5HJ5cp/XL6F8iF7ynq2pPK5Se8uCjrQHb+4sDcnTiZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGRrDfAD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGRrDfAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D151F000C4;
	Wed, 14 Oct 2026 22:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792017155;
	bh=5T+he2ZSSFvN1H07cmM6Dmv4ET9p6t1VVqpQ+Ie6Ee0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kGRrDfADu1K7Bazx/eGSIRzep3DC4G4ZeHUSYlUVs1jnngHmIbrCaDQQ1QExqAfFW
	 I29tLBJ+35EjDJR+GQSAgyN0FsLRRae+g6MCZ30e3c+f66HdxV6IL+Uzw/VnC/W31O
	 dkJxBkDFAaB5+/8egcf80IE46yPgitU0fSUxqZZ6C6hoKQe6yDm/VE8L06m/MDtc1y
	 PYo/vCgTGh8IOVWLP1o3MXgNBb2bH71fmqP38TJVoaU7/RhM6x8BNDzeh5M7HOoMCx
	 BXBeFSHZYn1b4KfNEeehSHaPu6PubVSeSl0nCj7IFV+ia6sOztYZFfZxo8skBTYHx0
	 hX431Qj1cdHBg==
Message-ID: <sashiko-outbox-171974@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 12/13] RDMA/core: 64-bit memory keys
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014-uet-ib-core-v1-12-a0e626117113@broadcom.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-12-a0e626117113@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 22:32:35 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> A device whose keys are wider than 32 bits has no way to name a region
> through lkey and rkey. Carry the wide pair on the region and return it
> from registration when userspace asks for it.
>=20
> The attributes are optional in both directions, so a kernel that does not
> know them ignores the request, and a region without a wide key answers
> zero.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014-uet-ib-cor=
e-v1-0-a0e626117113@broadcom.com?part=3D12

