Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92D83DC4CC
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 05:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790139916; cv=none; b=Zoar3m0/p/7T+7KiTZo1HU74cvra/YqnkH7rDZGkwtuZaOcpMk/z3r6qFuay5R2jt/IVAnuh72QZTBBnl4lR5TxtSQcGAsQ6IPeMKs3glpxrUD/l+kEOxrbMwfVD7DUcm8J9k0dItsk94T/FICWrJZrkblun2A7/qHLvUpvfKSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790139916; c=relaxed/simple;
	bh=m0e8Lzp+qzDLfSXwTEIjAkaaQvFzJ5GKeQINsG1kdy8=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=YSsCmBVpsaml4L/7Hi1qAeb8a1PLiBlOq2UyCqVTvOFiwTnGvuEDfJlWBXR39Mwp9gwb+2gKqDOZwfmiIh9mqhTkIq828EeV31JExwgAm5KLRtsaF8XvdT4piLNwsgYHC+x06ZopwHNxnHtG30+KKtkTqw84cn3DsHi91zvHRto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=ITCwAWXI; arc=none smtp.client-ip=185.125.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="ITCwAWXI"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 114F53F032
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 05:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1790139906;
	bh=m0e8Lzp+qzDLfSXwTEIjAkaaQvFzJ5GKeQINsG1kdy8=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=ITCwAWXIcpsPD5JM8v/ZQIPqvlYJm9rivhga0TsPmSetDk8abu4DyTb+5KgHB/nST
	 ZXE3ChdPgazEP3tMqvquBB1Md0WKZX3RpzJ8EWRmuZ23kZK3EvvDY+XDSoGIc/ZsEY
	 0pRVtnhQXEeId3oS81u2UiiewrP8SxMJ8EWpFPlKTzi+7251QKMDvQV8F3dFd3XysW
	 a1mWW9cZIhPJ0TZpsbJDM0MJ/NOV+Qb8r3t9Mj8iPn4tDY5gxOiK4WCH3En7FlSjq6
	 ucre1t9/RIzotuplWAzown+mALva2UvBQO//6ABpl3wbVEAqkEX89X62JyTyh9dbD7
	 0+DZpMwWTF2wg==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id CC9EBBD8B1
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 05:05:05 +0000 (UTC)
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
Subject: [recipe build #4093364] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <179013990578.3101366.6950103545266143945.launchpad@juju-98d295-prod-launchpad-51>
Date: Wed, 23 Sep 2026 05:05:05 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="6c05f5b586acbfd5d3a5f5142777242f41e711b8"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 6c04d064057ba0777fff46c0c6e0df973f56c813

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 5 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4093364/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-008

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4093364
Your team Linux RDMA is the requester of the build.

