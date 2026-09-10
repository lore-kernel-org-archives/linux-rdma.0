Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFE6348C50;
	Thu, 10 Sep 2026 22:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789079128; cv=none; b=DMgR8qDeDeqvCGtRAolXDAo1cSCAVuHENZGwSH1OBJ52ubbDjw5SIq2d8oHiah0JJ89VrHLBEodZejHkYH/BKfUD8N8GS5+KNhcma4Y6ehCAjJpPFUmYGCpgagECXoo0A9ECK3hdD38oDI7hoV5G7386GksG7kj2dG5NWca0zjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789079128; c=relaxed/simple;
	bh=vH9T/Qb7WbliQw4wQWjOytctYPlkJ7WIsOsNVm4DkGo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UHpDok4EkRJ/oBt4pKvyf4tt+Iry2/uqhvWc//Pk8jAt90W2jEAyMdG1fusW8PJ+OEFjMIAwANsn4G5i6mUO/M8MawuNuYLRjD6BdwTeVlv6jAHB5rkaoBHabkR8aIGgqxEDYAdQ2reQxMcqpW9HCt+7DtBuQ3MYg3O1gGA1fqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MgtyOtj3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MgtyOtj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6369A1F0089A;
	Thu, 10 Sep 2026 22:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789079121;
	bh=vH9T/Qb7WbliQw4wQWjOytctYPlkJ7WIsOsNVm4DkGo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MgtyOtj3QWBvZPxWkkKZobd56mF3Pa11ESEZEktWeRMooMl4lIBv8NRp7uuwltU7b
	 D3lAlPkzgDmKHnh2l7PD0UrZuyN0PAncGIcxopGHvPSK/ENCPmJZ5FFXw/Y8WB+Rar
	 BBQxwOHbkRDYUERHJjaIvy/I27yzBBwKaVVQGfphaSk4qnf15JAU+X3yCAm1y5fEJL
	 ZTYaHusaXPIls95w8zzAcI/Hzi4RbiArmmKz0bEFubALuVVjBko6SfhSCdI5iGc0/7
	 vJqFRIQvRNOEWnl6yesnjmv6vBb+fsg2moXJkIdY/X6V1W+UL8/A84kYULYMnzgZ2u
	 bzBCvdN/7Za4Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 02/13] net: mana: share the EQ pool across a
 queue-set swap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Long Li" <longli@microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
In-Reply-To: <20260909222416.884246-3-longli@microsoft.com>
References: <20260909222416.884246-1-longli@microsoft.com>
 <20260909222416.884246-3-longli@microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 22:25:21 +0000
Message-Id: <20260910222521.6369A1F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Make the EQ pool port-owned so overlapping queue sets share EQs instead
> of requiring old + new vector allocations. Allocate max_queues slots and
> track populated entries with num_eqs.
>=20
> Grow the pool before creating replacement CQs. Additional EQs survive
> allocation failure in this patch and are released at port teardown.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909222416.8842=
46-1-longli@microsoft.com?part=3D2

