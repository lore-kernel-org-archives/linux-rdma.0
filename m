Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26F4374A0E
	for <linux-rdma@vger.kernel.org>; Mon,  5 Oct 2026 23:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791243779; cv=none; b=BK94X4PJ0DAfyaMqoZEjxXnvZ2H++ugSfeR5cO2+ZX5x0gwZLyXQn/PtuMw8KxNjNLCBH/xzq4P2NsPwat1ccCu+KlpW7/T+mF1Fr7/ZW5PvwxFuLWFu4mI5EPjPmXvhv7mQRW/s9UJbBeT3cqq79iQvjkczg7Bcwoi4wv0xLi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791243779; c=relaxed/simple;
	bh=hsrsvt4/we+qt0vVMceJhMhVG0J6wk5qrO+6R2CI7ZM=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=Te2Ek4gHr+yAxiPUc/wpo5FRCcAOanc4ynrz2VQh2TFMj7dzVxVfcwCVVOgTAbjTLm/7ajvbBtPvPxoqb/vUe+cArB5UvD20Uu2CugUZM2wXRmdJ3Qgl1LrhiHNydesBzdYbZtOZKhuKcNOLKtHtn/2EIjQ4tbP/jNeJIGP9n+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=gQEmBlhN; arc=none smtp.client-ip=185.125.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="gQEmBlhN"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 4D16E419E5
	for <linux-rdma@vger.kernel.org>; Mon,  5 Oct 2026 23:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1791243312;
	bh=hsrsvt4/we+qt0vVMceJhMhVG0J6wk5qrO+6R2CI7ZM=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=gQEmBlhNoBjYRd1CA+/tcfn7SQN+75S5I6RPivMC9C5PLifEb7/SI0uwPY3yYOM9P
	 6ov5eMDE5K6OYn/pNIDCse2LpuT3Wu87dZVeVqGXp7IJGhxFteP18R2WLGyB5NLdSq
	 IMPug4uVYYSKwgqDFp8BeDxe66aTUF7Oc3qTzogHBQyR2wwRJxnhdlM6IWd5waLZ/e
	 aJVI73bQFDurJxAkkY2Q48337r2PSWId4oeUEoH7DAjoQoF/RTsfl2IfRT7C9wrFcf
	 RZ/Rlmb7srQzX/mhaEnWAslpaQv+DD2Bnfi+CvkLouKO/HcHD0s0Xh0avt5ffC1bDe
	 wB7oqq38919dw==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 08D15BDA10
	for <linux-rdma@vger.kernel.org>; Mon,  5 Oct 2026 23:35:12 +0000 (UTC)
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
Subject: [recipe build #4097252] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <179124331193.449914.3780562469945984585.launchpad@juju-98d295-prod-launchpad-51>
Date: Mon, 05 Oct 2026 23:35:11 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="ad10a72802faca6d6a2802f2e3a89ba90e7214dd"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: ca655e6c060ac09ca10cb169c43bf3a598511a2e

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 5 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4097252/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-105

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4097252
Your team Linux RDMA is the requester of the build.

