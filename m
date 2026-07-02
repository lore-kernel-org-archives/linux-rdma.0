Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF5737A85B
	for <linux-rdma@vger.kernel.org>; Thu,  2 Jul 2026 15:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783006719; cv=none; b=NLPhpun444k+inZF+ykNBT8+amONyTcMQ5G0yUrgBiJf1Y722qUhqyY80eP+3bv7AAcC/9AwwWD+yVcOxV8v1hT6ku1lCqGu/wtwy746zOsb+SV+bRFjThTpBES9/AV02vPUrp3m1G8G8VVBZ48LJZA0n2qrviPfM9WAUlaJAiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783006719; c=relaxed/simple;
	bh=Yykn8FB2MY3aJoAZtlnrXDWXPAtviaFggtQCDxBkX/A=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=A6ky+5Lng2nIu+PoiWhcmLz+SxAc8vq2e1ULcBQaF2GZxXrD/Xw26F0/9skcCxS+dzYel15ykHf3UslVAvDvarNiY2jOgbIet33ts0xg8tEF0rVMBDnu0jJDZF2F52Rb1lwrBCt9vnuQL1Z17w49HSK4Lr5BPMH40G6ECnBs+3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=MwMT8aGX; arc=none smtp.client-ip=185.125.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="MwMT8aGX"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 1F31C4246F
	for <linux-rdma@vger.kernel.org>; Thu,  2 Jul 2026 15:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1783006709;
	bh=Yykn8FB2MY3aJoAZtlnrXDWXPAtviaFggtQCDxBkX/A=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=MwMT8aGXh1R6Z7mzasFu++3ftNffuM1XnJT0lfM8FrGCwLTEFNZKH5cC+xnU0Cxjl
	 mfmGiaPlJkoOLq8CsYj05uPqknY4AWJdPPdbhM1jXBCjD7+h/vUtYK4LzoJ0YDfAZS
	 pvbcEenV1MP+us1r8wAHA6G9fx09fK1BI6ZN0ZUv72g59WIPI8PiEtvTr45C8IaY4/
	 MKcJbQjQ5SvtWrvzYTBXsFLlKtt/1casf1gxs7jC/PXkwgSeIsuMKRLlFWQlbWhFAa
	 eAuJzoPNbDO3w/xckBG53xlEXdqdZOaXsYS0qrmxFqCiLOy4m5pvMGnH8AZh7qmB5Y
	 FJgbj4NEM0eyg==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id DCCB0BD3E2
	for <linux-rdma@vger.kernel.org>; Thu,  2 Jul 2026 15:38:28 +0000 (UTC)
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
Subject: [recipe build #4060663] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178300670881.3391778.9077992282733880329.launchpad@juju-98d295-prod-launchpad-51>
Date: Thu, 02 Jul 2026 15:38:28 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="c38ea58da9d7185c4996adfc854ab433551cdcdd"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 806b5ab67a017f8df3b9994ebe88ac6c1ad63060

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 5 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4060663/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-005

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4060663
Your team Linux RDMA is the requester of the build.

