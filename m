Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794345457;
	b=SGc7z8cGvTsUsJYtSSDP5q6gpsJKT+rV2vZH4IcZpxPkgCoblGuTYl181M4qTxKilNFw
	 vQ1ONttt8HgtpgReYlKNDI3V3YGA+yM2WPAUFaUG2U50EqRGFsRy821IU3ahveCcjlJh+
	 AssVULLw33lrAWKkIRwKQGuFZ7euuQdZL56p55mQFWKMDuUCWW2HPHF83MDz3fH29EoLC
	 X8/hPBUHJ/kCxJJ31XWoVZOxCJVrTOb9YmWx6EKSr/84DPMYuEJ/WztyEnXBpU3oTj5Yj
	 kl7LBjyLXfiyEonTzVL2yjL0Hb3MeGrKI2Q++YwiTZVaL/HCSNgSOJ2Nf1B13z9TKrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794345457;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=jPZGJwxxWtFpsQvhEawblNhyjMkXp9NPd2c6TD7Q1hk=;
	b=jLgMcWrZhM3GAu14C0Qn5p4uBKVxPyk6ggIv5cCDqItgMmcdU1D3V1hW9eaR8fqiaIAl
	 H6DC3NQKpp1oP8tX4XUlIPhKHv/4NdzUp6foMQ7VEPb4OMR2hQ76AOKV7XxzdLDSQTkd/
	 cnagQ9UcjWmeRRJlS0ruXdZYLdb5rCP53rbr/fpt1+rMF7kcvdGXiY9szjE96m4g8SCwv
	 0IjuFYNLE/dnmURvGYb24ECyIWpJDDMMdbF3e1MAWPBoQT7VBA7PKkFPMbxR+a3WBT+em
	 nH+IQ1jebnqIlpWUQSUAP7v1qq3kNypERKW6EIjKc9vmcNgtmi7jdJ23zfNEeGl6dDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b="iDJJH/pM";
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4CEA606A321
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 21:17:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4CEA606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=iDJJH/pM
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 258C542418
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 21:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1794345454;
	bh=jPZGJwxxWtFpsQvhEawblNhyjMkXp9NPd2c6TD7Q1hk=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=iDJJH/pMyRLjD0Jgm1YUeSf1E0fXoDrKTiT2siwCWPLnq4JFfi9VXgBvrwKUDeJGm
	 g8Y4MEHCJ0Mdw3/G6JSirQ5NY9AbnYlRV0FMcPcaTSOzyARCe6Kq1pJNzUmlz+3hgp
	 uWNjh1yyFK9cKt0jvGsWXFCc/+kxSe0VwJgmkCSkTnMzkNKVbKFdV0PzCpPofdHgjA
	 xjk/w/ShX9Q1yEgzEBCGw2TLHYD63aZMiHZfwGHNYgzgDSHKpkAtx6amEBEdzmkVa/
	 ucUv9b2A/2QOZT6PXuBBMD0IP9Iup2gzPiJ7btky6okk6NsmhXWN4vC/x5+2wGwlcq
	 hPsim7jdVgREg==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 99C20BDA53
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 21:17:33 +0000 (UTC)
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
Subject: [Build #33959155] armhf build of rdma-core 67.0~202611100043+git04da5a049~ubuntu20.04.1 in ubuntu focal RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179434545360.1538602.4538380508477230180.launchpad@juju-98d295-prod-launchpad-51>
Date: Tue, 10 Nov 2026 21:17:33 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="72ba15af7e009b17d4aa1467977127ac8392a4de"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 9fb13e793d6c2bf6a9d3b92fad8f61db331571ac


 * Source Package: rdma-core
 * Version: 67.0~202611100043+git04da5a049~ubuntu20.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 6 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33959155/+files/buildlog_ubuntu-focal-armhf.rdma-core_67.0~2026=
11100043+git04da5a049~ubuntu20.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-090
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 67.0~202611100043+git04da5a049~ubuntu20.04.1 in ub=
untu focal RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
959155

You are receiving this email because you created this version of this
package.

