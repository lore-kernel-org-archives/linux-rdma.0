Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794158620;
	b=G9XiQYK7gLh6AdD0HjTmb75a/CdYtSo97H0agg+Hq9V1fRpgBp4mq+bEZrHnRh4H5mk5
	 BP0rSutUbtdbMMe1D6gywnF6OyF22uYMe4/w1s44qLZj9qNM3sQHQW9l8WZCKaZKjnTq9
	 2wwO0xXQcfxq6z4Dfb9ULHM3kB8bbbb25LaFCe5Pr0xPLICrnpiesh3Diy/XfY59MRSut
	 NA1x2vs6ayscMnt27RU1QsiFvcO8skDde9pM5d2Zy1W66/i4YHuow4m74HrIMMa+PGUvx
	 ZGRRIgyn0WPWZcRSBl73Gef47pm8wqYhYrnBU+07PtLPGmkqG7mffXhADc0TahVv7mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794158620;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=KJnwXFJpWGtQpacKQG7BBh8ytQ0GLDt/XcoEPbrVeT0=;
	b=eBXdklcqAiuTSTFW9nWyiYWia0rxJAfkxyqfPxnZ9ESj4yIcgietXhArnwyq+AUXKF9a
	 l1R8jduQmZW3b0HoaqhskoQbrXfJbvH/8xxBrzlQ26GlC70ik3tMOvdgQ5x/B3cw33/lZ
	 VqRC9Ol2ptQFq5avBM6hi8AEkmacornExspRHqojUYbf6AfPEtO49COzg2INOv6YbMv07
	 z1FmyV+4XddIp2rVqaob2wxmIOKTyT3QLyL5z9AYvnl3NN00/BtDka/Dc/rHMzCrvHg5w
	 ATwt7Pg5muE69Lemq+JBYeQDduh/yidOeWuVyjsDaN1wdPX7h1bli/cWZu2Gwj+DDGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=A9P0Dn+H;
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D05C606A31C
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 17:23:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D05C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=A9P0Dn+H
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 4121B4008A
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 17:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1794158617;
	bh=KJnwXFJpWGtQpacKQG7BBh8ytQ0GLDt/XcoEPbrVeT0=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=A9P0Dn+HwT563SOn/aHPK4Whr7zVwFzUQBR9sF94hJgMwAHSauCnMqWtbAeg8Yrs1
	 x2DPgIGjFdd9Ycl+YTypnwY2encAKcOWubux0y71bjXS7gWaN0BJ434EJXILvUwbQh
	 iNx8DO9DIPji3sIUlmqysq/cPdT+uRazp3+t2w2SjX1yChhfrBLag1GLqE2IuJ0prM
	 asroOWOTv2YkfOKcBkE1eRrVbaNW2zBPSZOz89posvm9f05WTKi4MQXdyibi4KRTcC
	 r9WWto+X4dI0fV5zMs5WaWuyjLfQjtzv74VE3UnMwYJCrEbVgrqAauSNq1b7YGYNN6
	 pC78iQwCzX3Ig==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 23486C2B6F
	for <linux-rdma@vger.kernel.org>; Sun,  8 Nov 2026 17:23:37 +0000 (UTC)
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
Subject: [Build #33932703] armhf build of rdma-core 66.0~202611081441+git3ff8d6dcb~ubuntu18.04.1 in ubuntu bionic RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179415861708.3544717.13764798185170618451.launchpad@juju-98d295-prod-launchpad-51>
Date: Sun, 08 Nov 2026 17:23:37 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="c0a367959c9c9b09a1b30cc94b3d52c142eaa123"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: ff2fa102757d836440cc0d0e4bf520d92bdabeec


 * Source Package: rdma-core
 * Version: 66.0~202611081441+git3ff8d6dcb~ubuntu18.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 5 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33932703/+files/buildlog_ubuntu-bionic-armhf.rdma-core_66.0~202=
611081441+git3ff8d6dcb~ubuntu18.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-020
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 66.0~202611081441+git3ff8d6dcb~ubuntu18.04.1 in ub=
untu bionic RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
932703

You are receiving this email because you created this version of this
package.

