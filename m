Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6035D4A6CCA
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 22:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792017033; cv=none; b=RzGeaKjmvwJji801YbYujX5kki1lVAjVRefYQKj18adRn63k8DaZXj+GpC7TTT8l6ZbyEomsR5y0va1KRWHUgApG+4OhReT+0Vt5U8xQIHE2JDTnxkrawFn5jAggGVGWG6R3ty4OrnTZENEbGaPuFYV0lvG3+LndCGDCkTaJQOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792017033; c=relaxed/simple;
	bh=Yh0ualUJ6qa/Mwv1OekGGN8oBzLC5PTag5fpg4Tw9og=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=eXpJYEX5V50Cka8hz94R807yCzEk61Ng/B0eNtdHnkgbOM4jw+GK8RaASZajtUx7IvTDu+i2PJp/ej3mCtBUgWkBVN55qmshYYYgK9o4tqv/wUZcU2K8kl8LWY6L+a+Mq7Ijdtqu8dmylrlYGN0oA8QzyXKov0Wht+U91abunOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ccJC7C1R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ccJC7C1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B23C1F000C4;
	Wed, 14 Oct 2026 22:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792017032;
	bh=Yh0ualUJ6qa/Mwv1OekGGN8oBzLC5PTag5fpg4Tw9og=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ccJC7C1R1jDihqj0e7Joq0o/KT4+K6oN3T/3n5VfTt7RC3c4ScqLwEuuXdPGK+6sA
	 PVIP/6k1OUulxGVp8GuWP+I2nUcnOhTFZQ1V0rBuqHvi9AkyRbnwHRRVo5c4DnM5x6
	 DpTHgggGIAykhVwkLZz+qYWHpF/gycSKp1tr/0EwHQIOBJ9bgEbf8nlnaLFmbDbGX8
	 s0CtB94pGXyU+CkJmnGBgc/S24UelRmrkHtqgyKuh5mrM64lu7dn4WrJxNby7PY3D0
	 awpk5d6Bt2j5oKM1dbOVROgp4PDgptU9dWfSl4I9QqsHMJEpKAvg2hwg3pwMCXJltS
	 XHQdnZ1+FAekQ==
Message-ID: <sashiko-outbox-171972@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 08/13] RDMA/uverbs: factor out the queue pair
 attribute copy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014-uet-ib-core-v1-8-a0e626117113@broadcom.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-8-a0e626117113@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 22:30:31 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> modify_qp() validates a set of attributes that came from userspace and
> copies the ones its mask names into their kernel form. Queue pair
> creation needs the same work for a transport that is ready to send as
> soon as the pair exists, so move it into ib_uverbs_copy_qp_attr().
>=20
> No functional change.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014-uet-ib-cor=
e-v1-0-a0e626117113@broadcom.com?part=3D8

