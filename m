Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793385056;
	b=1D7Wle+YrigjkpeDpHZUB/mC7u8/R35dlbL2Mzo6c74oNjbtDIv2eXJCKBv7xUqvkNdL
	 t9D5IfJQnquFo3tpb2B5p7XnwP9B+GnFF6sta4KDmwpXXnNYmVms/dPG7iK3AvSzb9gU/
	 ccvTOL6VDzDn+nyYvqcoj4HsLZTU+QJvW6rhxhvPZr6isT5SoNmQJRlHJ3l6q1mH0UHQK
	 91ySROYbG4VlUD5ej3W8zHJHPE0H04hcYZqTcq4D/smJPRdPGbBc5K77XcUgtPBWTmFfQ
	 ayklj7MVZbnah+BtGozSW8if3taFBHsDrISPsOzmbfGwVrHG1VTeObMJkKNWSDGEB/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793385056;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/YMq1FIkTCYBYfI7rhUazrw/uMPUfjMy+1NA4amUZ1A=;
	b=Sr5dt8VE2EoEr25veWNOvo2OY249KZt5qB3k2E6adh8agDq0KiEOMLrD5Or0TZbV5o/4
	 e0nbsl+1HgsbCAha+ZJ68Xo48XyzIBG+21HgGLr/eMwzbVdUZvwybusYm/TkCEBmSdCrW
	 MLv8sg95oDebpiJ5lD4KGZhGo1SnVE78V+Soq0qtR2jl0oWEeKbr7QFx8kO0imPS/78KF
	 kHfEBQn9MUASAFsb06Gsx9M3T4EuN1nhU2UiyEU68poJ7CxXmcX4hcbGyb5M6HIGhYkcw
	 obAQl4c6gJk4WPeqVoU457hkJSYCDXWtHJ6Nqh+P4e2HemuFzdNc7uUSQjvlbsrSeMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mHlTaoN1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8378E606A31F
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 18:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mHlTaoN1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56811F00A1C;
	Fri, 30 Oct 2026 18:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793385056;
	bh=/YMq1FIkTCYBYfI7rhUazrw/uMPUfjMy+1NA4amUZ1A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mHlTaoN1g7V+B48J+IDJy0ah3dzzDMWqytv7UxhYWrZeqVovpBck7ZOrrCulunae9
	 ZuQ1RS2kVqSwBQWbWbSIhsNYbbcYMq7HA0Ji0W4ysNCmElqkV7eBl2VJLjNuGb29G+
	 wT+sqYf70z5nFav+svDoQJTgopTGKjnv3S2JPv+wEhdGt30DiUnHUr/pgHt6KeAGIC
	 Ud3y4psPeyOIi5kfjaYJba9PZjfZj9CF6Y0UwQEDWCVY9Xf7kho9yYOvLf5lHcRZs9
	 C29YDvcg7IGsvSMNY1UFvqMI7+GjJEUhaVXFHRgP4EZvvPW42joTuplfHdH511dK0Z
	 lb0h8jU6OWXyw==
Message-ID: <sashiko-outbox-191410@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 4/6] RDMA/irdma: Split CQ setup to umode
 and kmode
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261030181512.2056056-5-dhu@x6u.co>
References: <20261030181512.2056056-1-dhu@x6u.co>
 <20261030181512.2056056-5-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 18:30:55 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: David Hu <xuehaohu@google.com>
>=20
> Add user mode cq callback `irdma_create_user_cq()` to separate out user
> mode creation logic from kernel mode cq.
>=20
> Original common setup logic is broken into shared helper routines, so
> duplicate code can be avoided. Core creation logic is preserved to be
> identical to original routine, however.
>=20
> Signed-off-by: David Hu <xuehaohu@google.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030181512.2056=
056-1-dhu@x6u.co?part=3D4

