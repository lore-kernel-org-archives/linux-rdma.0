Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE0C3DB63D
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 18:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792263193; cv=none; b=egWXi7VQCCU9Q8aSZRgsRQmnTDYV0g9emeGUzXYSrgOjDVB28fDWddDBALp6aTCMhL/+swYRVBTUdEodvrnLt3O7VAFqL/zGfo2oblJZskwmeYRj60218JGNuRx5N+Z7TEYnENBalBRl/IU9U2g6NCFpgLdllceBkEOTsmF9y34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792263193; c=relaxed/simple;
	bh=Khs7T0c8bRQSH9WR48HmDK13sBn8EwrvPj9QKH6pDQI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=WdrjqNs+MbTJrQoY5hyUELnZdE9UtLgdt6pZq4QSVTJsBnfZybGclokSjzqjEZQJ2hsr7Q7jnIbmI3xULvYRrPOe0/BM4yQl/XjSbTActb6UGeFUQrt208e2+pDAmVZ+wRQxLHrk/k3xjZYmlhQtG/CYIEDIJ3yx7fS3NnRmaKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IUwezrMZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IUwezrMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4E51F000C4;
	Sat, 17 Oct 2026 18:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792263192;
	bh=Khs7T0c8bRQSH9WR48HmDK13sBn8EwrvPj9QKH6pDQI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IUwezrMZ2vR3M7R5qdZ7ljAjopVPAy0r1wi3qOq5E69h/0lBnHW3PRO0M0ujAjABm
	 +DFHmqCgw4dDUGZ9SW/FIkK0eOT/67/n6L0wehE3nrKk9557E68ULmnqHX/ZofjFN9
	 RRJX2OvnvZVYiQ9haW82sheQscwIgynMWwVp/7jXhjkYVrQfCq9LfeoSWWKC0cZBey
	 oUI4UfHipeo5BZN37XSd0+XI7GlwKMYIQtqCGuoVk1zs3BLSq4Mh5piz/qYnuNtQqC
	 AdEPL6LuTrnYeJfDJHgLynsI4FMjHmpv3wE5/KOlUqyPeFoXyhzmD6KxnGp6PgF+XL
	 Q0nRV1NK7chfQ==
Message-ID: <sashiko-outbox-175764@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/usnic: Bound buffer size to sizeof(buf) in
 flowinfo_read()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Serhat Kumral" <serhatkumral1@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261017185028.1019445-1-serhatkumral1@gmail.com>
References: <20261017185028.1019445-1-serhatkumral1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 17 Oct 2026 18:53:11 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> In flowinfo_read(), 'left' tracks the remaining space in the 512-byte
> stack buffer 'buf', but it is initialized to 'count'.
>=20
> Initialize 'left' to sizeof(buf) instead of 'count'.
>=20
> Fixes: 9f637f793602 ("IB/usnic: Expose flows via debugfs")
> Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261017185028.1019=
445-1-serhatkumral1@gmail.com?part=3D1

