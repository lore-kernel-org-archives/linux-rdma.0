Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794345505;
	b=O39olVcKzDQbXJZiVrVBf3iVVh41mVgsBO81PLuMBtSFyuvc9fDja+T26ATMGZ5F7fyx
	 pOGjNg10APxwtt1TWuHAQlQcL4WK7cheEiOqeeFHyBG9CmTaffIxywYEL7y2+hmJ6Ku6T
	 FkmPgH5oOBlT4oSSOelxhrYpaYcaaEawCVPUbsCwdr1XyAaxJ72fkSMGVFtSOZuXZHaFl
	 fHpUZrp4CmaKl2VeFTgyk2hhujpbQy+BFEo/C9+8Etv06c7a0KpLh4i+lh6+HVprDM7E2
	 ukdx+ppWKFT4+mupiL5IAQ5+YM47CQx6Bg0pBk44k4+hahVC0PvWBd2b4iqN8JpmAGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794345505;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=2RiO1oQcpPqZqs4XOcF8xKpPCynjUTW/tgYxCSUg9Vo=;
	b=fVzXVmIze8iPexuCLS8SVLYsFaTyUeAyUx6P0yTST57xBijg70Dq2BGU01WstW2Ybg/1
	 GbxHmuaOmRvmzT2S6LApHO3eYsdLS8UJ2h54c5UyLmKxHi3o6M7j8Fz5U/6wD2u3CIKNU
	 CWhNCXx8MV3K5V9RuaM6bW7Qx6G7EC0jEPmFOyf63VW9wNtuUSkMSaAGyAmgwGUVAVFQ9
	 gxwrXYOnA+vyuPXGRc0fnGZkoGzdcWMc662IMSOCbiJcbpS6njWsT6Mn6ytF2YI/7bulu
	 PH8iy+OSLvoLEY0YWoZG5ppGnxWnTnDNvFHPDb+i+RzGB/FffZWuMOWJcup+/aJP5OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=bHoo5JDs;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F324606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 21:18:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F324606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=bHoo5JDs
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id EB8E0423F9
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 21:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1794345502;
	bh=2RiO1oQcpPqZqs4XOcF8xKpPCynjUTW/tgYxCSUg9Vo=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=bHoo5JDs8GrBPvyW2HFe+wu4XIrSb2UkWZapOUPPiUjZubZ4L0oIbtxMsx0/b/i3A
	 HZige6I3Bz1tN22X9LheBvrdrMH0B/aPGbLCt3KetL28yUefTRWDOPZaX9UW4oL4o2
	 NV36G+ErfqcepX1HTh4t6YIayxBLrVX5ZC/Ci/OyRvQRQKR196yFj3hsj/bDcCCzGs
	 RA78kPgA6t8TQyxVOj8/9LLnUMa/1nHxGl1tp69f6cYR6mtMPLWbsMCbxXJqlSpvMf
	 cQuZOMeXzRnYxBr/7OduC3lKW12U5YXI9hFNbRjaQmzMxAsHvpxTc6YV8lZc4GBqaP
	 JR8tvTb9vTUfw==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id C1296BDA53
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 21:18:22 +0000 (UTC)
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
Subject: [Build #33959149] armhf build of rdma-core 67.0~202611100043+git04da5a049~ubuntu18.04.1 in ubuntu bionic RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179434550273.1538602.7384334572045159835.launchpad@juju-98d295-prod-launchpad-51>
Date: Tue, 10 Nov 2026 21:18:22 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="72ba15af7e009b17d4aa1467977127ac8392a4de"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: db83e446e1794834d76f2ecc2a382bf68ce7a514


 * Source Package: rdma-core
 * Version: 67.0~202611100043+git04da5a049~ubuntu18.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 7 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33959149/+files/buildlog_ubuntu-bionic-armhf.rdma-core_67.0~202=
611100043+git04da5a049~ubuntu18.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-022
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 67.0~202611100043+git04da5a049~ubuntu18.04.1 in ub=
untu bionic RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
959149

You are receiving this email because you created this version of this
package.

