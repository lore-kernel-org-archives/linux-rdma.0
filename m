Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9695A491592
	for <linux-rdma@vger.kernel.org>; Wed,  9 Sep 2026 09:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788945022; cv=none; b=foFYZhiEjK3eSTJFPnKVkRv/oY9bSzMIHCSPweAgS2QJ/m8IPQvz4xI8zgA4U4NHHFeBgrot+twb/KAn8EUCpk+SByOuSEPdUrELFnDwNlUKS+nvSFT/P/ALmpXrGZDJtAXu74pL3F0h09ucntiF1B422MXiGjpig/SxoTGWxkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788945022; c=relaxed/simple;
	bh=NizAwEP8Azr1tAdSTKggg751Oa8q+y2BzLZH+yL99Vo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BAzSkEHpyfEpZBv/KhHYCOGV+AVqT4nJ1Ua1j8wT3KFHEbFSNJFHWfYpyoN4GZBUp/gfGbUhVFmjiQvatQ6GP34SGXa9WvuqB7yy+wtSkV4ke8v1OZHSJC4Hltpzl5/al54OxWazTVWaaJGumonWvYhewWM7bFysGMdzLMllKHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=busSxdFH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="busSxdFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37B71F00A3A;
	Wed,  9 Sep 2026 09:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788945021;
	bh=NizAwEP8Azr1tAdSTKggg751Oa8q+y2BzLZH+yL99Vo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=busSxdFHi8RsyB6xbTOnlOXBDIi3+CgE7CJ7dhb4OgSb4kn/HNfjlnXeTpxFCNq+/
	 sZ0Udl0OBus8aXZ2p2d6+faVbNY8roLKeHwcfEmJ9V2dW+yzWZVZFa3953cRsS9wem
	 u2+jzyiU5ugFS806BDePIuMpiYv8XjUgQsqXOSc3KC3E8zJ5UTbkE111am+QBQ83+t
	 Fk/3xnlwwPbW8q7pPFeStlTcPzUFXm8keXqyN/EKiGWi743lpNmJjpg+/lB607Fwhn
	 oR2SaclIRn1rzxpZJFeoLMY70AnBNWupYxH4uuHEtPEwkQjHvpyuY/SeJ5fUHI0CuQ
	 0sylsnvKo079A==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v1 1/5] net: ionic: Fetch qid allocation and SRQ
 capability from firmware
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260908090802.152142-2-abhijit.gangurde@amd.com>
References: <20260908090802.152142-1-abhijit.gangurde@amd.com>
 <20260908090802.152142-2-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 09:10:20 +0000
Message-Id: <20260909091020.F37B71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Read the qid allocation and SRQ capability from the RDMA LIF identity
> reported by firmware.
>=20
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090802.1521=
42-1-abhijit.gangurde@amd.com?part=3D1

