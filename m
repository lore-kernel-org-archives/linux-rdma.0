Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795415286;
	b=N4tsZHTpjU0bDLDmWdZXgEaaE8SFfpIqMgFWWZb6R4Kx0GvRy3/IoQd6EO5itrydjiSk
	 pK2Bps54ii0LoYzM83VxLrautpjZoIK1gd+cfQs1B5YDUhxlmj9nk8G/uY6kGj99L2Sl/
	 pO0yKSy9F9DBg8wt+UEBJRDglebIpbpJ6i/nQoHstNKPVA++tEOF5oIr10cpEo7z7Qkzf
	 50rpkmc9wCskl/8UiWf7HjknW+dLYWOCfdmw21rq1Q1nmEPuPYwSAAwhvXqfEyldtZXd9
	 Y6IZ7J65EBxc8a6KHMyAUIIKcd6GiwcE79SnXroE3EJOWiScP8NUnvLmEBRYKC4LmKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795415286;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=WyIk9KhkeeFlisS8ph80Q0ZTUZhFmmi0vqAPqiNO9BU=;
	b=RKIlaWQxAUsvXIdFwjyoGrivbcymuDEqkN7Q1SPr2pLkjz89in/umriTboAhLl89JeHU
	 2y7ZGB0FtvTpf/yvIDcV5KDyJ/cQClbZuKNDsRtutUuBKypPPWJGARXPimlSxwXuP7p25
	 OBNzQfABOP1JcNT1UH0s+Gx/iW6T0g+lF/aTLgB6Qut/ONkAS3TlJAmx+9VNpk3dpc3Et
	 VZNkn4mHaupxmNH9v/PxbD0msEg+vTF+OceIjDhXpMmUMkQRZ/LKJUz2ZvgCEOeXC3EWY
	 ZOtxmOPvq7HgeHRpp2qSMKQDLU7A1khMu0kVXrMEgcydeZrckGCwILNZ8vg+UAHF08Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=pNS0xrK0;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638D7606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:28:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 638D7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=pNS0xrK0
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 1B29E3FFA3
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1795415278;
	bh=WyIk9KhkeeFlisS8ph80Q0ZTUZhFmmi0vqAPqiNO9BU=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=pNS0xrK0U1Efv/3yDiSZh3CXYnzqhszbkCWhI2U3gegOuqCwHi2VtiTnXtJUw6BDT
	 wZoHd3BoFZRV+2CTgUzsdRJ2vGZ/ONydnyftpv9ZlE50OhY7Cie0mB4j9vuzeHNH47
	 lFIxPuIHWwzlvk5jrsYgQj62c3KXgZ7wf6AdxFEx16sTQVbLuGD02nwEw2cKwWn6fX
	 wlA/YpkY/p7YTRdpSbCkOnvtSiF2usHoorBK0AlLAcUrRVR2PVxnUE7vXEdUGIsYVv
	 kzQ6pFBTSOrnfg/lXYK8jKmdFbjPAUUvl7Awjcaf8KuXxMeYa0PEEFXm6iwj0MPica
	 O4G+qVg5qzrbQ==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id F0535BDA54
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:27:57 +0000 (UTC)
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
Subject: [Build #34004222] armhf build of rdma-core 67.0~202611221306+git4b7b208c6~ubuntu18.04.1 in ubuntu bionic RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179541527788.3108509.13628934643523873374.launchpad@juju-98d295-prod-launchpad-51>
Date: Mon, 23 Nov 2026 06:27:57 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="5893e20085ddb97aea2534e1b2a802438957dea5"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: f9f6a7d8b85cfe134ad6f4093dd142aa36c42972


 * Source Package: rdma-core
 * Version: 67.0~202611221306+git4b7b208c6~ubuntu18.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 5 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/34004222/+files/buildlog_ubuntu-bionic-armhf.rdma-core_67.0~202=
611221306+git4b7b208c6~ubuntu18.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-080
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 67.0~202611221306+git4b7b208c6~ubuntu18.04.1 in ub=
untu bionic RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/34=
004222

You are receiving this email because you created this version of this
package.

