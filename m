Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795000399;
	b=zyUDM2MoPVIOLqzE2EvcdGqm1HgjA/hd6bT6el7Z47luU76vKuKJuv2z8yleeVudrJdh
	 h1mGqeCgeySWsuPcZZR+HSdNJUdUyOUEFxhGyxv3TT9LMsgRzJ249b+/Up7eHf9Z+NXxw
	 M+F9lTvG0NmisYvwwYN9rk2M4pDMpTRaA4QQMmqDj6ecod1doWyt7fp4hPV8kYFL926dO
	 C+0xZGdqTaktINz9e217nafYp4qnbDFfq6k3OldY3XZ5m9UYYXNBK/R3c2HBiW7ll2nKb
	 xYRTTzq2x89IGWYBcrhQPpfSZrYC8MN0mQ2xAyzAP2vKs9QSzI6ulPCfnMmEURw+kwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795000399;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=2qe+TrY2jGHd+hNr/llkPOMhiIsvXG2T6SbOXkWCB1Y=;
	b=FLBpTpkB3scbQywykCCDYfJ5utVUaJpITW5RkF3nVs0uwWfOnNp4uFxLdPNXihIYXCEY
	 rZoxAqOEcAHdXC1c/kUaFQRMnt7tafxxXokAExWTRnX8/2sppRP4bGBO3+U+khD40YQzb
	 LfmbgSn7S1FA6XDj/4UQRSpWlEkBIuXEkw/G1CfwJl6bMtcKhxcikEjREpx2V2seShjki
	 e9eEhxYek1zcNrMOz4Jv16i5hqreFLO/ye4HIV/yrf2HQUqwbpxaf4iMD2U1VxyNJ4Uym
	 DX1qJaCv0QphTFQEU3cVxhX/OTboiFzqn+TdE7Dgvan3afp7FZHR1T+gGgDm0Llp2yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b="bDQ10/OQ";
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FDB60A2608
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:13:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82FDB60A2608
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=bDQ10/OQ
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 5816E404FD
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1795000391;
	bh=2qe+TrY2jGHd+hNr/llkPOMhiIsvXG2T6SbOXkWCB1Y=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=bDQ10/OQbf0uott2cH95bMWcuKeooXD2CAoJyP1FulHkjkZi4d3hrO4k7bOPlT5dt
	 Q6nBED2pmY7YJUWSbNGMhY5+o+FxSA6QXPgPx4SnCDw54CP1MoMiKEWOqW+1aEbLqR
	 kbnKiBjUl55329pqIMphpN3+0/5EBfJ0hIa9mWBq3bBfA/Y+YrDSIwkMYdg7CvyxLe
	 HyR1hdaguzZVqPV4PmhHZqblu+K9zYeshFTQ8GNQDUMFzJps59R66tKE1EDItgTiPH
	 3ZYpk2l9NbxUqmb1J/D9a+DIB8zRsxjgycg9caxdHufDz3JaYTbnBwhuo+htlWzpjx
	 6/ke9jMpkVS5Q==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id B1D3BBD8A4
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:13:10 +0000 (UTC)
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
Subject: [Build #33984606] armhf build of rdma-core 67.0~202611171129+git0fa993138~ubuntu20.04.1 in ubuntu focal RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179500039064.1826918.8149201445606039673.launchpad@juju-98d295-prod-launchpad-51>
Date: Wed, 18 Nov 2026 11:13:10 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="b97fa980824250ed53259e6e5dc13c2c57b8d4ec"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 8a45c8b79f3d82321a1cc9daacd3f6da7e849b73


 * Source Package: rdma-core
 * Version: 67.0~202611171129+git0fa993138~ubuntu20.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 6 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33984606/+files/buildlog_ubuntu-focal-armhf.rdma-core_67.0~2026=
11171129+git0fa993138~ubuntu20.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-117
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 67.0~202611171129+git0fa993138~ubuntu20.04.1 in ub=
untu focal RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
984606

You are receiving this email because you created this version of this
package.

