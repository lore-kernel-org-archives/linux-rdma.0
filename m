Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CB033D4E3
	for <linux-rdma@vger.kernel.org>; Sun,  8 Feb 2026 10:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770546210; cv=none; b=k2S2QpYrTCE62+S+MksU6bPEHjdjo30mhpgFLgADyLBOAq6taGVh/IwcpY4D5y/1c3LjeOv1lqXEFPbC/87l4F3Y0LlKMXi+Ghw4NMIiUxzJB6xQcEGIYvBWdAK15Os5tOhXPAlPzyE/IM3FE3hfxOeD+Bfs+C2IVBFSxrgbUUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770546210; c=relaxed/simple;
	bh=4aum1ZS4JMvjv8p/1CiglGP1QI0yu1/ruYPq+KDeR6E=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=lNunM2lUCbhL2LRviDZkVrnNcGAix7DYnwV/xxFs+OpnywmKvlPtRFFw7ebZy+PRJ+y40V0SVffWazcHRf8LPdRtz/hT1B9B/wzs7L+VvauAX0cauGya8cORrzTo9QXay85ARN5036eR8GHxxfsqyShteoquHownZRo/afEwY4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=UGVXPIbc; arc=none smtp.client-ip=185.125.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="UGVXPIbc"
Received: from buildd-manager.lp.internal (buildd-manager.lp.internal [10.131.215.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id C67563F416
	for <linux-rdma@vger.kernel.org>; Sun,  8 Feb 2026 10:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1770546201;
	bh=4aum1ZS4JMvjv8p/1CiglGP1QI0yu1/ruYPq+KDeR6E=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=UGVXPIbc7mcsJ9L15M2LvTTBYZ1DsoKRCDdOTjeSF2p3J+tHMMl3Scdm7L9u8Rw8f
	 S4V+5XBIM/TotGbshHfrd4ZitWWfjjPGYfHgfaPVX5MHEcIqa2zZOyDBXPyNjQ0ZYX
	 VhQwwfsbqqwWCOlq+Wm8lSt75tU5boO38yrbz4rIjjRXTRJClANYXRRBfhhxZReCR+
	 QdXvGU3TRBXhF+OF3mVvap8vNYoQsJgkHwJTfZD4Ranb9sbPaZA9PnGiNvC0uDF1qh
	 YMIEBCEa/hB9fhSSZSLNLG2B+f/Fk7G1JsydaqEScQFRiad9r0VSsvLRgAscDkQ3Gg
	 R9slHksCCWM5A==
Received: from buildd-manager.lp.internal (localhost [127.0.0.1])
	by buildd-manager.lp.internal (Postfix) with ESMTP id B5C087EA35
	for <linux-rdma@vger.kernel.org>; Sun,  8 Feb 2026 10:23:21 +0000 (UTC)
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
Subject: [recipe build #4006142] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <177054620173.1615174.2746152430828036121.launchpad@buildd-manager.lp.internal>
Date: Sun, 08 Feb 2026 10:23:21 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="4847db153920c8fbc330ac275b92a72279fa07a2"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: db97e970e3974fc4c84dc2e40fc3f1997970918d

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 8 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4006142/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-032

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4006142
Your team Linux RDMA is the requester of the build.

