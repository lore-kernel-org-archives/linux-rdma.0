Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C86345EAB
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 07:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791010912; cv=none; b=EgBb4rdQVbSYwZ3TFGqgFuZUSVmDDIlRrqNfFhXuh/9Nbk0/3IUgG8G3EWSSy6PpQuEzDB9ciVGGpcA3fK7o0dp10hF4GJLWzGvFxyIMw4vNpA444sl6M2NK2WIkH2nQdia551rRNETDFheriEdW/CV8RceAbhKJBG1r7k4IxYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791010912; c=relaxed/simple;
	bh=lQOjPdImG4ly3StPkqCTIvMMKPVNwEE/LTpRZ6hYD9c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cxVyv32jRwDjxf329oKW+vI6vAmzzzIXaFzLjqJecijwpdDRAls8oVIbF4TH7y7MH2UDD3IeAiRjmMP+W8Ca31oqnlUxw5plSpuWA+NpyYoHkVhcdufgC02BUEJBv+vKYDrmuOP4hTk2RUHr6KzNIXFD9NkoH3ExmGlT6FoM77U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Itsfxl+2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Itsfxl+2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AF41F0089B;
	Sat,  3 Oct 2026 07:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791010910;
	bh=lQOjPdImG4ly3StPkqCTIvMMKPVNwEE/LTpRZ6hYD9c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Itsfxl+2xD305imiAGhqmIbWuHIp393a++XGow+9k0VQ0/KRlF0+sx2t+gw0Ws5pM
	 uc2KY82tO679DPkJo9jm9QpE7qWCI4KhsTv7diJBeeFE1vsOsgwUdzzE4reHEZaAKV
	 3p8EDPS2K539n+U9GOFRhy5+tEozudyT6NwTd9wKeMNzgUWqVanqDhSFQJC8Xb51dn
	 EEYe/pBdqWCv7A/s2hVgU3Qk1JHc1FT5cVDnDeB/puYNgs5PfBcgmhDyx2vjR3gw/Z
	 0og5011KP8uirQ/8gQJVf3uBla+AewN+0h1pEUY5hMxyeUirRaEB5DK8+Vnqqfp+xC
	 m5IKwRPjPFtCA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v2 10/10] RDMA/mana_ib: Drain kernel receive
 and send queues
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261003064037.2092669-11-kotaranov@linux.microsoft.com>
References: <20261003064037.2092669-1-kotaranov@linux.microsoft.com>
 <20261003064037.2092669-11-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 07:01:49 +0000
Message-Id: <20261003070150.48AF41F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Implement the core drain callbacks by moving the QP to ERR, posting a
> completion-bearing marker, and waiting until that marker is flushed.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003064037.2092=
669-1-kotaranov@linux.microsoft.com?part=3D10

