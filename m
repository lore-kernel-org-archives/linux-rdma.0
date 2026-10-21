Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792591997;
	b=FuoBSOyoAubDi05SEjrzYBQoezIQ+s/Dz4sx7DlNd8xNDDutOwEy9Cv5ye+M8I8IJf3R
	 kr4f3/7h56ME1fagtanHfW/fpoBYVc0mFf4vkQWtYd1LbnOlMMNt0E1gtuFDJtSo8zQa4
	 /l7axl5joc+TgwlChAocIq5GDJ2rcradwRvvv44RawrXlteyB8SSlLebD8W1HwJwMyesg
	 Gj0aFCca0O9v5HOSNfsFp7Az5yDmc+xUZDWAbeBq63173L2ZYElirrfvG851IwqA0oMHc
	 2/esLWbOW6oDIe4Dbya12Vw020YX0Q7RpMRvgUqcd0NGVM0jkGszT0UaEPH0cpo54Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792591997;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=bmpn8ApfHczYXtbmvXk4MDNxDarWeNayVJShBtIlzt8=;
	b=SghvxJRnOm9Gj03VuzJ2pRMmwJ7zjclHB1FDqvnh53cCoEJPRvOMKEnhdON7cghhV0Gu
	 JeNT025SyWdRHSKCiDP9cgFIIGT9vT4WHtwU0rHjL5q5Xdp51Nwk0s9J/9zoM+ygCpPay
	 gAQw1HQh0fm6UqbjJ1Pun1XY8UAFXfYm0DAocffEwHi3ArdcJF2eyHsrZOpD7fN7y1jSN
	 ZCwiVuNmFmrquPv7+BEiAE8iHSq4/NqcqzCEzMCnzoKXj8k8swcTXnEioZH13fzyG3WEv
	 tHm2r4xiGjHL5c0dChChWIsc9gPjpu+RnTn5B7UnqcB5fA1R0enc/4UQeMD4mV2paQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=EcvOgQcj;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A68606A319
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 14:13:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 78A68606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=EcvOgQcj
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 09F1C3F55C
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 14:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1792591995;
	bh=bmpn8ApfHczYXtbmvXk4MDNxDarWeNayVJShBtIlzt8=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=EcvOgQcjkB1dA2KNrVJ0UtC43C/qW/W9i7utcia8M/C0cB1yH2CTJnZLdrZ/v6zmK
	 nvekz1b4FelY5GjZrpJgwuxgh75gjKZjEwSWtZDtKfYe025L25szxF86B+fVd+1qE/
	 oHV5vE4f05Hbwgv8wHOOoN8iQar2a8Zos+g2NjmcPvweU2RapMEunUDaLxTyRJR/d8
	 kT7uCFDgMejGoNCOFhZjiYOO5T8E+lfJ0oP31iyGwallksCa5CFK0VffK4lV9Ks/W7
	 douAdgkgK3iPOp3Px1Egb3pUc4uBjOYYnnJtirJ7RqiDGsGGqkUk/Qy82pClPSIvQZ
	 TUPmOBY0NAm0Q==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 620C6BDA1E
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 14:13:14 +0000 (UTC)
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
Subject: [Build #33861328] armhf build of rdma-core 66.0~202610211006+gita758c7ba0~ubuntu18.04.1 in ubuntu bionic RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179259199429.558687.12364252491440767314.launchpad@juju-98d295-prod-launchpad-51>
Date: Wed, 21 Oct 2026 14:13:14 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="56f1eb70c27d2139772ead22665134d9e7db3f2e"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: f1e3253cccb6be337f614234cc72d7e17472c339


 * Source Package: rdma-core
 * Version: 66.0~202610211006+gita758c7ba0~ubuntu18.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 7 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33861328/+files/buildlog_ubuntu-bionic-armhf.rdma-core_66.0~202=
610211006+gita758c7ba0~ubuntu18.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-096
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 66.0~202610211006+gita758c7ba0~ubuntu18.04.1 in ub=
untu bionic RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
861328

You are receiving this email because you created this version of this
package.

