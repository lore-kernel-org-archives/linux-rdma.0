Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795171690;
	b=cmVa05UIkU7KC99Nw8SfNri0Pr8mc2UdD6GjgZ2iJNZVM6N2xXenGnxURZscN2Ev8crX
	 ZAvqeMV3wo0ayWfxrs+uwnMnjAKYgAz4qzEjtZOVRUyatPepMvGKvenX6bsBis7qlyOQP
	 slNKBIpVPW6ZC3Lhx2mLGeIAtSF7HCUO1d9NBXzScCEBbeoPN0GqUApgEmuBMQii7NNDZ
	 p88dyx0+50IeWxMTVEBGOztym7NOM8rcMOMD4OkcDfgdLQGV4gNQzAapfbZ/vGKa20vK2
	 DjI5zM7o92YoRgn3/IA3wleFk2SgOjMPiQL1rKc/F6PIfwJD04X0B//eXnG6mmo6Rlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795171690;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:To:From:Subject:
	 Message-Id:Date:Reply-To:Sender:Errors-To:Precedence:X-Generated-By:
	 X-Launchpad-Hash;
	bh=whO49HEq7sgYpIp8ld62lRt/nvhhz9E7KXm9lf2BRl8=;
	b=Vz9T44+P5TTV3xXfaaPCWr/TnHMnjTm2m4nklUWXZnDcJBpedTbmCyqedpsVxdEbxT39
	 /doM7ahR5f0WpNcHbULDpaxxOIT3dghBQP/UDfIZAImBbTkyMXs7y5JBS5Hp7e8+k3kwv
	 p/kvdoEsq5cShtVmCJgzshCaDC23s6jKMQ1Ic53/q5ROAIBCxxZ7MTlcvPUjwNwaWRB5J
	 p0sY9ITnkUccP3EAB0WoSY71OHwp1EGJFD+o5D24k1pHj6Q7Ro6BnYQ19PJII+zw0HEVB
	 WahajlWih8/s8DFgR6+7A2r2VyIK+HwKPL4f1UulkpUSXGJ/QkAJUzeBitpq8+RiLsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=W0EtufVe;
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00420606A336
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 10:48:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00420606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=W0EtufVe
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 30A2641438
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 10:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1795171688;
	bh=whO49HEq7sgYpIp8ld62lRt/nvhhz9E7KXm9lf2BRl8=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=W0EtufVeybkY1bOiDiXsxlzv8paq3E1cxF8zqUWV6WEzVTYRzxdwQEHxev+CK5PJx
	 xrd1jntcPrli6UC8Lw4ZI8AZDHDTWphrDeMePvCVPI/itaKeo2vj7gNiVeiE97sstK
	 8Sx7EosDrvx8jnpXPbw2Imtf638lg+AEqPnUcIG0u9bRasjScgEL/4IXsjtc8hN3om
	 q3jFV6/ZDfWO6ZH86yt/ziqRKwWEa8zoqH/zslNhQ2ONLF03RdRvBRxKkBJj8W+2bU
	 Nt623g2xxxQ0gHiN3V+ApuhbLAZkzk3a2Q4T+tAGt6jJYYXgKBzTT/GuNeOjPC8QnY
	 NbhafEgFdtB/Q==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 12C6ABDA54
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 10:48:08 +0000 (UTC)
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
Subject: [recipe build #4117505] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <179517168804.3108509.11224198895103304882.launchpad@juju-98d295-prod-launchpad-51>
Date: Fri, 20 Nov 2026 10:48:08 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="5893e20085ddb97aea2534e1b2a802438957dea5"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: d318c9886eed27d0b57564fa0e8250c72519d3e9

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 3 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4117505/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-034

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4117505
Your team Linux RDMA is the requester of the build.

