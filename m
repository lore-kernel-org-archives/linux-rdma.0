Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27E8481FDD
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 12:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792238808; cv=none; b=EphYL3MWbvTfbFzh9H5G+hN/uIIvdRIo1bHo4IshyWtD3MwF7PP4E3Db2KMtvAbcpbpgibtsdDfncSX2q+tnTTA/go77UVtQBdMi2/+kQcklf0ZuOCTXodOhGjDFafidzjTzCvfCQ8EJZgEvUAp55zjfzBg3KQr5/e03J2Yi3Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792238808; c=relaxed/simple;
	bh=taAvXbusQLv6veFyHOTMtn1Stk1AejwM65kMsneweXE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Gc2rBDzpfhmrP9kvtDt11tvhVmNlmWyOKD30rQO6Pf5WZxDAIinw6CtSrf6hzxOCa/uBmcgHyk/iBZb+83Y89k7eBcFnCF798NdgbR/T61ur/hvXaIJJ2m/a5pgsDd1UEVQk4MguvRQ9YKkB/om+Jc6xZ8lLyKF2HVYQ+lIDQtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OZ3Dapcq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OZ3Dapcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A8A1F000C6;
	Sat, 17 Oct 2026 12:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792238807;
	bh=taAvXbusQLv6veFyHOTMtn1Stk1AejwM65kMsneweXE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OZ3Dapcq7mfBcXtLOoFAL9CITOE+lPpkEy62B4w9QLU3eyOJMRyvbuyIWKuRSl8yY
	 7oqEQcYCr8JMfDgPtRXRI+F5fh8XOeVHsI1iZ8YgiJv5sYHvGRqhtz2W8Z6e/KLB3n
	 JhUeGjwRIPym9C9WZ0/RNTTzSjcJOKeekJluKJ3lPSNxH8Gcs+rWg6sIaqjLfQi44t
	 D3VpG84gfAKXPk85Spm7ZM6gz5v9T7YE+Z3AHHq7W8JrDOIrstBIropwDWJLz/qpFt
	 hsvFmD7ueaVXxxJ5Qb4UJscUVPs5JmJ4sw41fdAqn3R/2LxNwVzHzfqg1pUVIdaQlP
	 OZ3hluAYQJ9aw==
Message-ID: <sashiko-outbox-175501@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v8 3/4] net: mana: support concurrent HWC
 requests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <983b5719644379806ac278b45cfb7cb70d2935f6.1791998462.git.weh@linux.microsoft.com>
References: <cover.1791998462.git.weh@linux.microsoft.com>
 <983b5719644379806ac278b45cfb7cb70d2935f6.1791998462.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 12:06:46 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Long Li <longli@microsoft.com>
>=20
> Give HWC message slots separate sender and response ownership. Initialize
> each slot under the inflight resource and per-slot locks, publish its
> bitmap bit last, and return its admission permit after both references are
> released. The per-slot lock also excludes an older duplicate callback from
> resetting or consuming the next caller's state.
>=20
> Serialize SQ posting so concurrent senders cannot corrupt the producer
> state. A posted request which times out keeps its response reference and
> admission permit until its late response arrives or teardown cancels it.
> The bootstrap channel remains depth one here; the next patch negotiates
> and allocates larger queues.
>=20
> Return -EBUSY for healthy admission pressure, but preserve -ETIMEDOUT when
> [ ... ]
> Link: https://lore.kernel.org/r/20260908035201.402424-4-longli@microsoft.=
com
> Link: https://lore.kernel.org/r/20260914175044.2a26bb46@kernel.org
> Link: https://lore.kernel.org/r/179196575640.434549.9102950927041409151@k=
ernel.org
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1791998462.gi=
t.weh@linux.microsoft.com?part=3D3

