Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6E34A49A3
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 22:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792017477; cv=none; b=syURSR62ZIQmmai9hsx8iDJIQgUsiL/fUP8Zb9/tOZ7Ez+OoHPgqDqk6xZAmIJOY3GxP9f8VCJN04W9kA0dpbUhn8lhzBSzElJlJza1Xv04j82jZZtELdhEU+6zINCszH9bh8HzHNqcfKI3WoBPi4IAj44luOHHotqBgCXhyPRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792017477; c=relaxed/simple;
	bh=vXimWZBpjfL7yEnkEgz8HCF6UlJRvHFDqJ9i+QwOUYo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=JenKZmgf/wtDHgSZdHDXtBbyn0xLZLJ+P6WmQTMkMZvUJMiDshLeOa8LQK1yYAMk0RtTQRgUnYEBMqGcsGRBejlhINRYRzmse+K2W2VpOqLAnhXduLUk3Q6atpA+DDGIgxwEqOIA49uxfTo72z+7tS5Qs6PSDXimP4IdiSaCvIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gIytTLFS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gIytTLFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA87E1F000C4;
	Wed, 14 Oct 2026 22:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792017476;
	bh=vXimWZBpjfL7yEnkEgz8HCF6UlJRvHFDqJ9i+QwOUYo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gIytTLFS0nv8AMzXhQ4vBaqhbcJtqQNXMqdfRndToYCdnIA1EYS3uQvm+1OyLqeVF
	 10iwD5vEDSkhbJIo61Lm6naqSc4djvYGD4gTBHQRpU7mJXeie8dnQCDZmobzu01J5I
	 2m28FRyavWIte1/acnE095BDt8fHPmtHt9Fe7PV9ax5Ep+QqETlBsUIyDbJaC2tVhe
	 rlydHvZLCRJCI0DDRZWvKUeyjgkvZuiYpn0BWouYE+GYiQlMYohWCi7wTr8gpYIZe+
	 OooGxA9HFjXkXM9z4bcPr/0QqmpznyKwCeSECke1w0uyyoQlDOuEX9bp/W6bDmfvJM
	 xiO3cBz4DCkKQ==
Message-ID: <sashiko-outbox-171981@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 13/13] RDMA/core: attach a memory region to a
 queue pair
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014-uet-ib-core-v1-13-a0e626117113@broadcom.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-13-a0e626117113@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 22:37:55 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> A region registered against a protection domain is reachable from every QP
> in it. When a device can narrow that, let a region be attached to one QP
> and detached again, so the network only reaches the MR over that QP.
>=20
> Which restrictions a device supports is reported through the memory region
> access capability bits.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014-uet-ib-cor=
e-v1-0-a0e626117113@broadcom.com?part=3D13

