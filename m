Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415295;
	b=FFq+yh5Jjbf4xrJOQB5DjkD6O+6Nddn6KDzidoHPGf7WQXGQTCCwhnk12gHvNR4fDz3s
	 MeEhe40hr+IH7UtIBoR2T3medz+ESP9mP3gG0WjDi+9j8E9K+IdghHVCEpLm9Gjpl7Fi3
	 hHlA4hghPBQOD4/k5PazjVIAiZbMHcCSuOAcn0lyeEbxDWwkINOcBDs6DSYoaUWwFENcn
	 XIvUGV0UyXiHwVFUsdXeSVxRkvua5hoLETOHvkUfSVKfocMagqmLOuIS3SNRCMuhED7ba
	 aobON1T8jle4I6GSZO4hiFzF4njdj7yIXDF3+BPqsAUnVP/V/PriiSBaninQcCnYHsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415295;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=ghiZ0OkfjXkwtLBx9FpcUflrAp+7rLHUmmQH8bMNmZU=;
	b=QtAaU89+d43MUkzIjADLmPt6R670T/MILN6E0knjD/D5BdhD8xKgwHMC3zFC1aMh5qAa
	 MJJoxwt5nn3zd9gqRbn7vF3RGdkIgjAQh/PuzdvpsJDH4o6fXhvnXrRe37VpChQn6Vt4c
	 UZjjLM98PIGq673z1akP2cL6loLymiGOLL8la5bIR/6t/ALW+I65UYhpkU1vB95cogR/L
	 AlMdd59hk+oZdr/6BmJOqHvakY6s7wvQAA2/fuIJ5WmKg123lE6E45NFuCiQkJAl/0m8g
	 bXMoUNZEW5EcJNoLsm2xFODNhePX6ksV+HxINKFHNqCSv1zoHQiwhrGMzuTcnnpBhQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=TisPJsGn;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FE1606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:28:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38FE1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=TisPJsGn
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id E5D57401D0
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1795415293;
	bh=ghiZ0OkfjXkwtLBx9FpcUflrAp+7rLHUmmQH8bMNmZU=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=TisPJsGnfSR2sVxuNKKLjiN2l3ZvVWdbaOfDpL7jXE7uI3zgOI5ufFckknYHe+fsT
	 HBMHgjv3EM3YS9HoADzcRwo8PReo0rYbhbpIl09OgTgq1QTjnQmlBBE4WF+0HSfaGn
	 MrSUR3t0zsqmZplxy9ePMbEvNoUlFVmU4+1xor2/hthArjJz5f6lOY5AYq0u/KaxYD
	 NHjaPA7V3MasfTprGzYNpTU/GvNLXoTIVgenBEZC/HLy8Cffd2XMA7MtRIq4mk+Ky9
	 CK3zRSsPQnFCsUKE95D/hTvR4zLOf4TwCRcZnnNqRlWx9F9k6yQVusGH3uc886M8Z0
	 /2K6h8B+RQDMg==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id D2D84BDA54
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:28:13 +0000 (UTC)
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
Subject: [Build #34004228] armhf build of rdma-core 67.0~202611221306+git4b7b208c6~ubuntu20.04.1 in ubuntu focal RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179541529382.3108509.11272861133762571701.launchpad@juju-98d295-prod-launchpad-51>
Date: Mon, 23 Nov 2026 06:28:13 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="5893e20085ddb97aea2534e1b2a802438957dea5"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 8146f6a24f639fe8a25344284e6b1f478888cb47


 * Source Package: rdma-core
 * Version: 67.0~202611221306+git4b7b208c6~ubuntu20.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 6 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/34004228/+files/buildlog_ubuntu-focal-armhf.rdma-core_67.0~2026=
11221306+git4b7b208c6~ubuntu20.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-099
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 67.0~202611221306+git4b7b208c6~ubuntu20.04.1 in ub=
untu focal RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/34=
004228

You are receiving this email because you created this version of this
package.

