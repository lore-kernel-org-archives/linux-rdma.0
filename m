Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD4033EB01
	for <linux-rdma@vger.kernel.org>; Sun, 30 Aug 2026 12:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788092855; cv=none; b=Q2eYHMAksP4Q/Ag0JETTJh4AzjHZ2yHHUFmFtASUbBBUcZ1Cdxq02axIjIjo8PgrGrM/VB/4vTfIfFb2j7lDTiXDT7V/G43Ulvb5AoAhyGOjdWVfn/mqNa1WUefGfbdXvu2hq0tbO5DfoOAmFqSMzBdATCoiYdqA8VlyySfWSjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788092855; c=relaxed/simple;
	bh=ZEbQ1LlslpP3Qu2NDNhjbIk7sBBxu4J5hsg3Td7EMN8=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=kZKBeh0lZlV3FjTkTwD1uyD1Le6cxLfzY4zXMPAJHRKLfXE4dnSomynWnCV1I7NTfXOifDKjzww5IlrVKG+aXb67+LaLGvo2ty1Q1tlw5WVsF5XwDCRDndp5305MDw9sXCrltjsJ9GL1NzvPzSxPL1gSXrpuvk45l4SokAETRr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=oA7fBy6j; arc=none smtp.client-ip=185.125.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="oA7fBy6j"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id DC41B3F048
	for <linux-rdma@vger.kernel.org>; Sun, 30 Aug 2026 12:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1788092317;
	bh=ZEbQ1LlslpP3Qu2NDNhjbIk7sBBxu4J5hsg3Td7EMN8=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=oA7fBy6jWNXo7ZWY2W5+uQ9arpQH9EMz5ieOjoRDIRPxWGe6pUa66+NAc0r1MoWcP
	 QOiOVE2o7pyglVbayaodlp5qt9GgbA+5mFAzCW48pjMsCb0oDxiTNtBBIL3A5/9hoq
	 z/wqJVY4Ft/Dg9JCGQDoQDdu2XTfSjEo28KUdWS1Y4smPjpi3HByZjsPFAmY7aXeLe
	 ZGtMVJF5kIiSYQrgqAX/vBq6XbqLgxO0Z+nIl5Tjwfs134r78+bEgRW6yCY5HQBayW
	 BtHwvAxP3mRcf6oP9N52ZOiMy4z2DmYrD7Wz7wNFB8WnPylpICn9uAEmCvFyNWKhM6
	 sXvL+hy5m1dSQ==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id BD322BD894
	for <linux-rdma@vger.kernel.org>; Sun, 30 Aug 2026 12:18:37 +0000 (UTC)
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
Subject: [recipe build #4083417] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178809231773.1169594.17684090992028235919.launchpad@juju-98d295-prod-launchpad-51>
Date: Sun, 30 Aug 2026 12:18:37 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="3ed87623691be60376ba08e476ac885a2b8feabf"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: c462fb87742a66a56985b818831b2b3cdf5d5a34

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 3 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4083417/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-024

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4083417
Your team Linux RDMA is the requester of the build.

