Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794158606;
	b=rI1n5yukFrw5ZKigfGmLl8og9L1zncEEgQHRmzHTRx7yNE7yPoD6tLLWewkAVTDGwaZl
	 p2TE6ax23hl0jWVrjxBa+W8cPfriTtqx1o9GkjHZycyQ+XflzP82FygJIKr54wKDCDjb8
	 x3vxsWsUZ0mX0FEYDD9dTRja7h1DJjDGSnuEDakkEcOQ5v48hg2nPIsGdtt0s10CQiTR8
	 zyULy//a04qgXHMR2L/e/xr2Ea5x1KkfC0wKI560NlsYKx6fiMjpzM9u9IAAEmFFgJX0W
	 hLEhs4nR5A2IREUlHbZvkeOd9J3XxzBizRxCOuv1+jgoUAg8x/dZQXvbYJQlmWZk8tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794158606;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=SBiTS1elPKQM10YABbPif3T+7+vbRaXyHljRTKXFuRM=;
	b=YlcQ8v3VZBkaeIUcBYThz9SgcxcgaSGT7zoLLC9uIM9BGOYvV3vH0rrKLQDdRBrLEf/4
	 XM3/p54QGcjAA0rDVEatl3qAsc0foWFEpPw+zCBRqArMh2fXunOJUZkmc/Oj9bWbTg6Nt
	 UJqZN9WXEGB2n3vmaulB7kHas0PWb3ypY7p9zxtDuuUcG74OtNvMssA+aJt/DKrEre4gQ
	 Gt0e9+R7iwxcjtBAxZSX/riFdzMTH2nYo6Y+zDlQD3wTUpcUmZiKB5e0xMb2UxxPRA6f7
	 /p8H0w8OYZinkkIFmxmbd1LSY1v4J0XVJs4NZf5JwP8N0CevL3KOMX0sxCQmZJwAiZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=odvjudJJ;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA95606A31C
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 17:23:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CA95606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=odvjudJJ
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id DFFE1424F4
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 17:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1794158596;
	bh=SBiTS1elPKQM10YABbPif3T+7+vbRaXyHljRTKXFuRM=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=odvjudJJhKAz7A5TG6NqXR5r3Br4iiI/OnKptRMH4zrO70SfSDrnyRAFnMonOaCBj
	 ldQGR+VAOUWSD+OXPThc0Ga9GMxbLqTmSoma8c5EZxArSRX3oyD/w8ryyvomNRekVP
	 AT91723uvmjicSE331oQWn+4vgujTvsuVkPFEBJL9pHgEC6nf3Mas2wo3K5rDvHE01
	 8rhmC97VEQTcCHEjXEsfn8I8eKNNLVhtzo1vkGAgdG+j3TYOpbditkH9HHb7IpTl0F
	 H8SFeRso0OOULlqKW1DxkRYDMY3i2chbKKq0EHlprhjVUwCHI0RSyNFuTgSws14Egh
	 oZ1L/4jOPQIcg==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id CF6ADC2B6F
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 17:23:16 +0000 (UTC)
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
X-Launchpad-Message-Rationale: Creator @linux-rdma
X-Launchpad-Message-For: linux-rdma
X-Launchpad-Notification-Type: package-build-status
X-Launchpad-Archive: ~linux-rdma/ubuntu/rdma-core-daily
X-Launchpad-Build-State: FAILEDTOBUILD
X-Launchpad-Build-Component: main
X-Launchpad-Build-Arch: armhf
X-Creator-Recipient: linux-rdma@vger.kernel.org
X-Launchpad-PPA: linux-rdma-rdma-core-daily
To: Linux RDMA <linux-rdma@vger.kernel.org>
From: Launchpad Buildd System <noreply@launchpad.net>
Subject: [Build #33932697] armhf build of rdma-core 66.0~202611081441+git3ff8d6dcb~ubuntu20.04.1 in ubuntu focal RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179415859678.3544717.15404157326801411433.launchpad@juju-98d295-prod-launchpad-51>
Date: Sun, 08 Nov 2026 17:23:16 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="c0a367959c9c9b09a1b30cc94b3d52c142eaa123"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: b80e34a68276a3ddd3854a63b87e337c0dbd7808


 * Source Package: rdma-core
 * Version: 66.0~202611081441+git3ff8d6dcb~ubuntu20.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 5 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33932697/+files/buildlog_ubuntu-focal-armhf.rdma-core_66.0~2026=
11081441+git3ff8d6dcb~ubuntu20.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-039
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 66.0~202611081441+git3ff8d6dcb~ubuntu20.04.1 in ub=
untu focal RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
932697

You are receiving this email because you created this version of this
package.

