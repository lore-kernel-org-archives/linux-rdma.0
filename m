Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C80257F1F5
	for <linux-rdma@vger.kernel.org>; Mon, 19 Oct 2026 14:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792420352; cv=none; b=UWHL+YBgnfsCr4nUD3vWZXHHS0iWYuxhypkx9v1H5Onh7IgzJMzGIRA0odbGyGPTA2kw7oRcq0SzoxRvno0laftLqoCU357Oi8R6CicZwjxhjhZwPykwm8PcWvFQ/qiFx1vqpF/ZTktKDVhY4UVgchHLFw9Kqb2fTU02tA/uxEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792420352; c=relaxed/simple;
	bh=rqW63yZ9tBkDOdDHKdCESuMZFaEkDDnszFaMeYpMPSI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=dNAfDtat5HXAYoGw63Mtsc3tv80MgPi6jIFbU5nXTp0dQNVtO+Ax1skmRUU3r0FKboHCvwGWEOE2GvnobqNUldHYFDvg+6Epf7LV0Zfg/X913ZfFtXs5brfrcvkuHtcRmVz2tE3jz4VYvrnKbLmHL+A55qcwTpUZcdqUSjTNwbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jhfNwNpF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jhfNwNpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DA71F000C4;
	Mon, 19 Oct 2026 14:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792420351;
	bh=qg65HvrrH1bUH3b5KBew6nTZKKsiI+gJgvJb2YfmHyM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jhfNwNpFGp0ewkfcXB75k6Q8pvFurfIh/ccZ/XDAQf6eAfgZ7OK82mu5pRiLcs8/b
	 EsNcf0VomL7Cqa2p9co5pa6S4YCfp708YfXDyfd/1sVGErLibKsKQ+KvbUiI5MmbNm
	 2QK+Ea6HQ+gm1+F5sycvgioMz+XGxkN9/1kNu/0UxYCf07XrzVRRhIzIWnplG6pIoC
	 l1eOlujw+Nnn7X1Y/sHNB8K/minpv7A0TSbjhcGscgcJ/Ctz6Bzs22ddwRh3gi606b
	 oEFhJNWoZ2wszPzNDQ/VO3ue+LEOOubvOXnjtN07uEAKr2vG0Q6vfvXdlpVERopDWh
	 9zB9KQfNkpicw==
Message-ID: <sashiko-outbox-177419@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-5.10] net/rds: unpin MR pages with
 unpin_user_pages_dirty_lock()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sasha Levin" <sashal@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261019135441.1420968-172-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
 <20261019135441.1420968-172-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 14:32:30 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Allison Henderson <achender@kernel.org>
>=20
> [ Upstream commit a507023e6ff1d0b4e7aac49b2f547fed0c21ea4e ]
>=20
> The pages backing an RDS memory region are pinned in __rds_rdma_map()
> with rds_pin_pages(), which uses pin_user_pages_fast(): each page's
> refcount is biased by GUP_PIN_COUNTING_BIAS to account the pin.  The
> scatterlist is then handed to the IB transport, and the transport
> releases the pages in __rds_ib_teardown_mr() with
>=20
> 	set_page_dirty(page);
> 	put_page(page);
>=20
> put_page() drops a single reference instead of removing the pin bias,
> so every MR teardown permanently strands the remaining references and
> [ ... ]
>=20
> Signed-off-by: Allison Henderson <achender@kernel.org>
> Link: https://patch.msgid.link/20260730041629.3512480-5-achender@kernel.o=
rg
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019135441.1420=
968-172-sashal@kernel.org?part=3D1

