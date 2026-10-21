Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792591940;
	b=i13i/OUMuDX5WhrCsHUkY1uit+uNMqGQbe0JyxYa9g7rDNInKcYQbOdKDWRpwx+2G9pn
	 MGiGvaNAL/liakr6FBWlfzLWZDDjMBBTlzn/07Yw6jldK+1HeWEWiqieLEGeibYAOzL8R
	 DB7bTSPNxTmqwnOe3JNomrqnr64MNMaAExIucFHWMHEoIUoVMl/VhAj14eZmSHpW7jzGX
	 M7CM2CIJZSua54osLeck/e8IXYgUs8yCe8ge+czBXGasuqPDKVJrp3CZq8ZwqJbtSX9NU
	 8hGkDGs1dFum/5HIPNjPGqWYHccszpkSGsdN3f1Ju+bbRKJ6waLkEqI+kd3xqPvEgpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792591940;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=Cvy4PT0AsEsfVCrYd18EOuWwIOQIW6CcB8fQaOU4aVw=;
	b=Bbj34qCJhUw7vcMQNGSud+Vni2cMElyKrDStHFoXlEiICcD4ClxlQFgoRBf91U6XZXpy
	 Q1m2XpoJpUhL2CoeflN61cn2HcDpIF5G6XG4VFDcvs8U0fs3y9GxPvzrMtRtDM0HTF8eC
	 rXfuf3beGFzTPUt8NnFrd/KqWwo7p/+Rrcle+eOD2jCBHwMZPvY7rtDa0rAOEDMB7R4am
	 cjXBLH4KtuwKW1yfRiGtBH5d2kn4Qcybyx/p4p2EsLiDyvMHjhP7Pv8qoLxyBU3DdbI71
	 pneBRpuimbfx1SYqTlvbmKYOoe4yFuDqAlK+L5r3oYWcL/BmLP3SMd6nwjW0mpY/11Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=oBvndkqD;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BDE606A319
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 14:12:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 83BDE606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=oBvndkqD
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id B71423F55C
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 14:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1792591937;
	bh=Cvy4PT0AsEsfVCrYd18EOuWwIOQIW6CcB8fQaOU4aVw=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=oBvndkqDy+rEIrTWCi0UkbXeeKz/D/QL2tgn9z9mYghr1s3XMLgktyXdw0yEbOQeA
	 AXge0azU9gUuZsDh6O5ZebwP9LGVSbz38dcqfNDD6UZ6YS6tWeHndI0KSE+TRKExJG
	 L7NdJclErMOhxU0Wafk22hgVGo4wIZFGlLn09VW880qdSndO6zdmDAsHNgqoLY02r9
	 HRSK5x0fZHBuZypY6AyfKYhTsoU/4Ncy5FnbSXt41DFhfzMKxIn7OMTum7he/mCnT8
	 uVYqPINRbZtDcyRvpPMC7XRoAGG4INFLY9kSbwOEyLcA4NXNRKvGpakl4vhMlEuZU/
	 0ghzdK+4mI4PA==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 16B9DBDA1E
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 14:12:17 +0000 (UTC)
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
Subject: [Build #33861334] armhf build of rdma-core 66.0~202610211006+gita758c7ba0~ubuntu20.04.1 in ubuntu focal RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179259193689.558687.16798343898783564422.launchpad@juju-98d295-prod-launchpad-51>
Date: Wed, 21 Oct 2026 14:12:16 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="56f1eb70c27d2139772ead22665134d9e7db3f2e"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 4599423ea5d3b1fdcd539f7c384ee5dbeebca9bb


 * Source Package: rdma-core
 * Version: 66.0~202610211006+gita758c7ba0~ubuntu20.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 6 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33861334/+files/buildlog_ubuntu-focal-armhf.rdma-core_66.0~2026=
10211006+gita758c7ba0~ubuntu20.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-039
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 66.0~202610211006+gita758c7ba0~ubuntu20.04.1 in ub=
untu focal RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
861334

You are receiving this email because you created this version of this
package.

