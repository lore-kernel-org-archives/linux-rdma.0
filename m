Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC4937B407
	for <linux-rdma@vger.kernel.org>; Wed, 17 Jun 2026 18:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781722619; cv=none; b=ecx6WXTvY8BONd0dt4G/ZSjIeosqH4Jkq6Ki+2slwYf6UDYGoCvQA+2gV96pnfQKilZ33hh9kIBIUPkUCSpnRZ75cFKMEs3wVNNnd+gsRXliVj5iG862Vi6MJvwp3zF+1yr6I9D2MK/YZr6NvfOjdy691An/b5OZf+xY3omPveM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781722619; c=relaxed/simple;
	bh=GqIiKnlay0A+e2M+zwVKbTjljmgaQwTbWxn9vlBpr5g=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=DMfqCVN73niOv4T1yQJKDPr/h4MlW9nhnYz7O3kjZw19+ACzIvl/I9RR1qdKHcdGiWdYCX/oaUzeEdmgvlKrlR/eni4ftijRpBOTS+tSDXDZumEb/dzgOL5SQyuin0/SoXc0ZQiGPuyH/wxtBv62SeextKVQMosSl5eExMU969o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=efEtbxAq; arc=none smtp.client-ip=185.125.188.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="efEtbxAq"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 82E483F18A
	for <linux-rdma@vger.kernel.org>; Wed, 17 Jun 2026 18:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1781722060;
	bh=GqIiKnlay0A+e2M+zwVKbTjljmgaQwTbWxn9vlBpr5g=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=efEtbxAqceO5KdrUc96hBSPFZnMIvl70d8dBIawAqc5CJlb21eG1L81bLnKg0CnwL
	 1N72yckaJV0IN0HyafENFBEu/lrJeYDj0bugS5UyHlKzrpeCiYXndW8f3ikH8njDJg
	 v0h4zUo0heGPtvc1/mpmx1MTo/b6sXmZd04SVIOVdx/YDKfO16tCe270WZihdS7ak2
	 RcNeDwPbUgkfteFJU9LW9nvGylfvJT7h3AfuOZJFt5Nb305Nh4syGcwdFeQne/vwxu
	 xqMwROq3i3ZdhowPgL5YdC8KEM14NwP5JgsdP1lGjw/6sUdgrzAtRJMasHNc0HTnd5
	 YKECsUGv3ccmg==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 2FD5BBD9D0
	for <linux-rdma@vger.kernel.org>; Wed, 17 Jun 2026 18:47:40 +0000 (UTC)
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
Subject: [recipe build #4053516] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178172205991.127449.14308662436117379240.launchpad@juju-98d295-prod-launchpad-51>
Date: Wed, 17 Jun 2026 18:47:40 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="81b3240738cf12f6bd4aac6593260fef8d7b0d96"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: ea796d26fbbd56f7c444068580d089492ddf12c5

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 2 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4053516/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-030

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4053516
Your team Linux RDMA is the requester of the build.

