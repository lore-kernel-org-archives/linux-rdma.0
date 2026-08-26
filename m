Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BBB399D02
	for <linux-rdma@vger.kernel.org>; Wed, 26 Aug 2026 18:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787769158; cv=none; b=s/2E6fCbCH6n9iu70Pbk/u5DAaBiDmZSjVuObTEB4KYcLg17e0ADMGvQ8yIC8o8spRTMAi3s+/ogPXUEjK8gNHBFEh86uN516eXz56o48WpNQ1h5hzrqO16r2r6mMt1ybi/R5Kx/6KHZ+Krh1w5gwumFgJFCWyqWZ4sJCnbCYgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787769158; c=relaxed/simple;
	bh=j3mdQFCOraRxsmRrQ0DhXrxCRwYLZj/vWXp6mc4U/Po=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=NssRiO4EOe0ltu9Ec1DNkV5V2/fKOPVPTQf4eYY8men3UUzLvruZOWYD4FHcg/JVNbG5XWnV+vyAsHG63DbPLNPPGiSSoPfFw1KCmbA07GtaI3rcJDC8l1jVRRC7TbOWstjxyazgMVVKG/o/o8I43jF9dGblz4IxOoRiNew+6YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=SLaQw0Mg; arc=none smtp.client-ip=185.125.188.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="SLaQw0Mg"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id C1E9F3F073
	for <linux-rdma@vger.kernel.org>; Wed, 26 Aug 2026 18:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1787769142;
	bh=j3mdQFCOraRxsmRrQ0DhXrxCRwYLZj/vWXp6mc4U/Po=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=SLaQw0Mgo+1PGOJptS9P2fP3bad5pvHVSMrMj4uuWFQ/hVqcZO2YN5Soh3iCpZuoc
	 tBNtQhRSXV8z+0/Q+HqLoW1olDVamr8dhMBDvjozJQTd+HrTZv+sLnzgAhaNlSG+d/
	 6DJLpZTiAWeO3FZs/aMCSLzv+i0cW73Ttdjw+Vh2sPw+vf1JYt5HVigpadv1Nx6Bn0
	 GkVLR7e+tM98LRRYi7oI84gcprsIJ59hj4vS/DRTq5XVEhUhlYSX6e5xFAIHbTyPje
	 w/Fsf3JRAUeTTzmL38sKJ3gnVmSZ2v7fmXucWwxgI3p9tVXTnZLijOThiZYTSxMQ0v
	 JZ/yfA+lcVdnQ==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 56790BD894
	for <linux-rdma@vger.kernel.org>; Wed, 26 Aug 2026 18:32:22 +0000 (UTC)
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
Subject: [recipe build #4081975] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178776914213.1251807.15039263933592808419.launchpad@juju-98d295-prod-launchpad-51>
Date: Wed, 26 Aug 2026 18:32:22 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="30a649def1ae8ec0c26613e441aa3ab155268a45"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 55f6a9d4fd2e79b8d0d1b49a521784c083e5991e

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 3 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4081975/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-077

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4081975
Your team Linux RDMA is the requester of the build.

