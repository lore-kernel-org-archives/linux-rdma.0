Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794158233;
	b=0sw8k8bsBpa8PpALT9SPvogVCG+HfzJKn80M0WBO0rtLqvA2e5g3VCA/N9uRldJ7+vLj
	 VLV+9s7Cm8itWmY1VPE/lDDBKUopdO8Zdn3EUJ5RnZR81oQdbs0DGlfcmZUayn5n4KQR5
	 ZSwypVv+Ydn0OSOE/1JWLx6oaRVyOqwYUu239vFkHbFiii8/2bQkHx2QOMIkSSk6DHXmr
	 JhUr/pDEn0RBi96q+OBZjfHhngvYIabP9WYd8YpTf6XnoGpRycw1y5KvCn/qPgip3I2Oc
	 7pcRW/3umOgiqlAHjfRx7BKn7KBgkphXHbYixF+EuV/u08KHvN3Upok1eKj6oEfp7JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794158233;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:To:From:Subject:
	 Message-Id:Date:Reply-To:Sender:Errors-To:Precedence:X-Generated-By:
	 X-Launchpad-Hash;
	bh=ShvZ4t82YQlSMWaOOQtboDFVJr9j6zAkCjrT7nGeCfs=;
	b=Is8wn2sjdhDBuKb/erweWORbtEg4rnWn/zfbHV5PEqHcpbxB5ojXlCkXHXoJE/lp6hdl
	 NdrocPWTcVu/N8kX3up5MaLs/LXlC0/Mhv7owCGsAh1L9UgGFpQq6zsoFVpMSqkNN93/o
	 /5K2c2RBmwzeC1wkTigf3Kvy9ao2DOZ9z3Ha54OAI7GWpZn52zFE1OkEswHFXaeWs0nvJ
	 LNto04txmx74cmfR9v/XiSbQXy0mBv5kb4ytb1yt9Q2mFduhvbNsogLwBaWji2QBYGp6K
	 GeUqY58B23wUMvHNUiIaGA3UYFLr4nBjAoij9fw6om5R1CDNGN03DFcP5h9IGtxKQnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=IC3+f0L+;
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F30D606A31C
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 17:17:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F30D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=IC3+f0L+
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 11D0B3FC19
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 17:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1794158224;
	bh=ShvZ4t82YQlSMWaOOQtboDFVJr9j6zAkCjrT7nGeCfs=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=IC3+f0L+9yCijnvMuqCEqejsNruGeXpf1oOO7pA6YF7RNt3/ZApuA5GARQkKLRb96
	 3XeUzN3H3AWZYTZl3ZLAweyIIDOXhZnbqRK/vpSLGX+4IfAPNtwuy0T0JgqDVEIeoN
	 ZUgdq6q/vUM3YXDuJtkRCPgmXqLs8ItONPX67lQthsH3ed7N99422yRH21sAjbsLNr
	 3Uf9H6m243MKlDRnDPwlsP7wcBEPOf5/QbqTd1z7bLywnYEsBA8yz3cl3sxEbpiPGN
	 I08MtF5wdZAoRW7rAL0KYdjCMdcfVPQJCwnqq3cAd4hslS96ltRPWRKCEZTPd1DOUH
	 D9Fr9RoN2ioAw==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id E290DC2B6F
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 17:17:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Launchpad-Message-Rationale: Requester @linux-rdma
X-Launchpad-Message-For: linux-rdma
X-Launchpad-Notification-Type: recipe-build-status
X-Launchpad-Archive: ~linux-rdma/ubuntu/rdma-core-daily
X-Launchpad-Build-State: MANUALDEPWAIT
To: Linux RDMA <linux-rdma@vger.kernel.org>
From: noreply@launchpad.net
Subject: [recipe build #4112006] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <179415822379.3544717.14651481651106226093.launchpad@juju-98d295-prod-launchpad-51>
Date: Sun, 08 Nov 2026 17:17:03 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="c0a367959c9c9b09a1b30cc94b3d52c142eaa123"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 06567e94e8632b9d4878cd990c2a7c72a8e9806d

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 2 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4112006/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-118

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4112006
Your team Linux RDMA is the requester of the build.

