Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D443822AE
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 08:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784623635; cv=none; b=Fr5T+63YUCaFwfpFv4/IL+NRl7m/OylU4EXAGYCFyu7aEpNHoPs0DXbJGzC2gwYNvtqc1FtMzYmm7/QIJ/KnreFheWPyGJIHyZtup14CpIlMCTiSvbaKBgF/Q6zcY6WMPPz25gevLG3z0woGIf1tfGHs/mpGAA+937RGaXvf1Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784623635; c=relaxed/simple;
	bh=2n2fOcXRHZz62U4SzSiBdlA61zbYmODjahC7ztlWl54=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=Ldr9i3kxRqXF3beJAeJfEbL+hASuAEojkXmuTkOpkcEZ9n+42+35Ip4B4Zr1PBWuyStCLLDmFFFQqLRp9Px8vG6DMFAcuT4jWUa241fOPcau0t2B6DsgliPUPJd6H71w2wgrpq22J75IrsX8LZ1+uju9ygQR6tv8kcGbOGMzslI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=mPohkTSu; arc=none smtp.client-ip=185.125.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="mPohkTSu"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id A9F353F035
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 08:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1784623204;
	bh=2n2fOcXRHZz62U4SzSiBdlA61zbYmODjahC7ztlWl54=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=mPohkTSu15ZnVRw7xZBFaw8FjhWvQdQC6XeX1kRR1sLhaTvgcD+yyxfqLoRqBhc7B
	 DY4y52hznBGJuRfw9HzWhlBFI4+A9URq/oPjXisBdfB0ZQM3B17J7p5AeGgS27YbNt
	 gY25l2iY0Ksk0/Dfr7iyD6kThtJCS6CnEpISv4t8w7aqCGrn/a6/IIYwaAgnlBGHSy
	 WTHkoicczES5YZSjcKwkEl9cy92TkYwMHdoAAZw8vbCbsCLPoPquUcZ003xyE8Q6I/
	 lhOcm3PuObM7cj6iyHiXQxWOgAd8eHiKtJp0djV1sxAdi8mNEMt/MoWlXoxn2jzw5i
	 62HyxqiXdLBog==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 8855ABDA8E
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 08:40:04 +0000 (UTC)
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
Subject: [recipe build #4068141] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178462320446.3977663.1346246526542785128.launchpad@juju-98d295-prod-launchpad-51>
Date: Tue, 21 Jul 2026 08:40:04 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="774348fdb24c5c7c9b709dde2a8f044a871f127b"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 2904752b29d49880747ddf1cb0c9beecacf14347

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 9 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4068141/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-113

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4068141
Your team Linux RDMA is the requester of the build.

