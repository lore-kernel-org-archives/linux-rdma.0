Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F6739524D;
	Thu, 10 Sep 2026 22:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789079129; cv=none; b=BWFEU0qSWB5IhLI7PxJ+ZdEbtvcHHzudHotuIscLxNAwVErK4STn04EBcHIkZBk0MLOEyiXiIvs6GseRJcQjmUIJ+13g6Z9uIwM0wdo+nzaeNeL0haOQ4FoSzhhr1kaQ5DgHiYg7UEF5Tnp0f2wdfor/SsFZb9IKeryvwYCRI6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789079129; c=relaxed/simple;
	bh=gRylLBUUuiUwel9kmkuJlElug/s+E1HGHrkjgkSgNpI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=siFrD9gGBTyjIvI/ZGRh6ZfnMtmjqqLsPznoFt7KwgsH0JXbHZp3wOHds2Fgre7XJA6BSmJJiVkZHllQo5KR5ZqWX/LeLF/E5O6O1ldbXKP/XCxaHXm5RArt4UU20LxxqWwjurfowfrzD2evC/Pe1+AFTDgaVbn+XWqdtyPVHWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I+5yHFJ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I+5yHFJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93561F0089D;
	Thu, 10 Sep 2026 22:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789079123;
	bh=gRylLBUUuiUwel9kmkuJlElug/s+E1HGHrkjgkSgNpI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=I+5yHFJ9mBqv+GsbQ0z2DqC5ytanyDJp6UjUvxrdNwtdKYHmPDyJbXE2J8tQKxLOz
	 T0PvoTP2A4xXC/jehnGI31i+hyKHw/xZDMrorJIBjUmteiVDeEf7BfUBt70FWIDd6P
	 12kU7s9qh6WHYKG8vEy3ADZVq05RyJa3pu1zV281/WVIN0iD1xBkC1OaZVHQnh2aTv
	 OOtQ/nQpbFSwxqFE2S62dE/bLn/cmTPowjELsKHpFLaffUaoDe5gZbZVyDgaaj9Fj8
	 VHJJ8NAIaG1cfs2o6HEM7cDNnjUCX9lOn0Mc62Bv83eUpX37aUw/1Puj23WEB7CHkd
	 K3quWIdNrbtpQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 05/13] net: mana: swap queue sets in
 mana_set_priv_flags
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260909222416.884246-6-longli@microsoft.com>
References: <20260909222416.884246-1-longli@microsoft.com>
 <20260909222416.884246-6-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 22:25:22 +0000
Message-Id: <20260910222522.B93561F0089D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Rebuild queues through the swap path when USE_FULL_PAGE_RXBUF changes
> the RX layout. Carry priv_flags with the queue set so allocation failure
> leaves the live configuration unchanged and rollback restores the flags.
>=20
> Retain the shortcuts for a down port or a configuration that already
> requires full-page RX. A failed rollback closes the port.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909222416.8842=
46-1-longli@microsoft.com?part=3D5

