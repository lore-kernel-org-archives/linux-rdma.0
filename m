Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A834AFE25
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 10:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789553389; cv=none; b=byUucWYiOr120f1B6gSqPj9ebM81JcmK9UZNleZ6Idp9ecyw2eTab9WOQt6NwmQJt3c9g6ZjSKwkuRl2LT7UysAECLrZXOojO8/pBG/IPJ6/ddthuKpqKLRJBSvS9IbXuRyY5N5BA1PSCWR5nBWh+CQk/I57DDhlhzs0tZCKlEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789553389; c=relaxed/simple;
	bh=JEReCGSDZu2SD1skSsLSQx0UF15gEmhZhlUu6GSplSU=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=hsUyCHQecfDnyB1CrntccpX1y8Db3Yb+3CZvsvgwhm3F9GTFY3ctUYxWfOx2qZIv8x2cyF07+u8t++/gFmzjKsMLsjNNuWe207FcHMar8cQdZEVUhZ/qObCzw4kq5VMXwU/Hg2L6Z5dlfi2JXRjAJD7NcPaI5CiQxcf4ZAD8nwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=IDrPROT1; arc=none smtp.client-ip=185.125.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="IDrPROT1"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 86E1D3FEAF
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 10:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1789553360;
	bh=JEReCGSDZu2SD1skSsLSQx0UF15gEmhZhlUu6GSplSU=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=IDrPROT1AEWvxiRDbJIpUePXeuW+9G08jNmR1+sSFcn6iTt3taGIx5PxLRchvvjKB
	 oEH/0V4+a1g592ugaOHgDyVj0+moEaPwJi4GqJYaaeYue+6zI0YEh5kDYjdbxAoKyf
	 25zFldSgICgl+jnycDvv8hBW2mDPoU29ecMljEoOhdh/rcivXJ1sxqz3hB/dhaeruE
	 wrWbV211fGvN5shoB9+HBm1y51wyMGebgBaBlNpEreL7gR1MC7+zyf9J9BlSC8EMh/
	 ZWlL3WU86BMY8Xhuu2rwrL/7/kk2CDRQSqgTkd3yyjdCxPo4hGhNgAJsFxY8E8x4Q2
	 sIb3iSoK88+JQ==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id CDFA7BD8B1
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 10:09:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Launchpad-Message-Rationale: Requester @linux-rdma
X-Launchpad-Message-For: linux-rdma
X-Launchpad-Notification-Type: recipe-build-status
X-Launchpad-Archive: ~linux-rdma/ubuntu/rdma-core-daily
X-Launchpad-Build-State: MANUALDEPWAIT
To: Linux RDMA <linux-rdma@vger.kernel.org>
From: noreply@launchpad.net
Subject: [recipe build #4090382] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178955335972.3835662.5225590006010752959.launchpad@juju-98d295-prod-launchpad-51>
Date: Wed, 16 Sep 2026 10:09:19 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="6c05f5b586acbfd5d3a5f5142777242f41e711b8"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: e3f8072dd8b02be6d24de325b9b52b3da5d92937

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 9 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4090382/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-072

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4090382
Your team Linux RDMA is the requester of the build.

