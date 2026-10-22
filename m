Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792702759;
	b=dnDAZ49ASot7jO8aOpyXK69CzWKreRzCG8TjWKtkkmxQHJ91FMSrFQMatoIK7cKGulFB
	 qpZ4/6SlD2+RLPFR8fLk8pprImgTeDXNHsMVwBSBKeDtjFKxkaxq9SeesJxooHS4qVzOZ
	 AOGvtynelNFecpo1UhaPhhg+F0ZFsd4vz3kAKoeVXsDUDnAOuP4cbh/1nPzEMyRHQhbt2
	 /5M+8bK8pIoAZEErShtvg/TCHYIDWzNdWz4jtR8R5sLPrZl4Ouw1KlHrgFguTSL0uyzZX
	 O7ziEZ07aKD84djFyEQdqx109x1ijlKFSItBPrFRIkAn8p9AUnpwhcN92NmNX8GrlYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792702759;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=c2IFe44mZENCbB0WgxYDPdYn8tc8vCj5gxPh6rS7gSo=;
	b=jRfP/CUbN1u5dlvstLCF7KytcVJeCG/QYguStGLTipzb2G0xotVHwoOvT883fEWcltP0
	 ZodmMcqCoeDB1cYECgczJvvDLSC+jCVxmhg/ttOnayjLftzTjBWMAinIe5b3jdkg41j8U
	 dNxnJhjOHkzWVRv50lTqfm4fcLTbxwGFMyXhDa1zSYJsspjU0g3MJcY/MHtVkvk0gsrBs
	 +Cxy/5dz69yqEVZPr5ndKYdy25un9XQUcTe7bi4StoFwXXwFdZFK4adGjV+ZGp/gU7sCj
	 qVsb7/JcSwzjPX/AxKOUcZuWRuWN0z4TQxbimte8tydIhOWBKXO7xnja9GtcjHuBLag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=pJbssO7A;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A35606A319
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 20:59:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84A35606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=pJbssO7A
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 9566B3F731
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 20:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1792702756;
	bh=c2IFe44mZENCbB0WgxYDPdYn8tc8vCj5gxPh6rS7gSo=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=pJbssO7AI03TCi1KtzLe1ChoHPlCnx3zXwJEjaoXwVY7/bcCx0NsrWds5yaMyYMpv
	 bASJwykIcEVpd3OaUZHe1AnKcTcB2kaKv/g3t8PG1j2I71AhLIhA4aHH7Xv29VOIAw
	 0tTKty+oPilLWL0oWBOLuUB9XIUyOCOmyQPcMxn/Y1D0QELl/no2TMnw9bBHIzaF6y
	 CdUHbLwkx3mDTI2015YLDGLlDsGrESsYvIa7uVoAUOzq0lucNF5ddPmQkj9RNmQG7Q
	 RGWoPhOnu07ek/UXyAbW/xHw8XZYw1ld5mnfl671XDcaNyfbV+ylVzEXpp8CGFRHGO
	 jfMzE2tbgWetw==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 2921ABDA1D
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 20:59:16 +0000 (UTC)
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
Subject: [Build #33865415] armhf build of rdma-core 66.0~202610221835+git144dc70bd~ubuntu20.04.1 in ubuntu focal RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179270275606.558687.15432618077056439979.launchpad@juju-98d295-prod-launchpad-51>
Date: Thu, 22 Oct 2026 20:59:16 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="56f1eb70c27d2139772ead22665134d9e7db3f2e"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: a6c93d4c28e89cf9db667bcd6fbc6691cbde7e8f


 * Source Package: rdma-core
 * Version: 66.0~202610221835+git144dc70bd~ubuntu20.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 11 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33865415/+files/buildlog_ubuntu-focal-armhf.rdma-core_66.0~2026=
10221835+git144dc70bd~ubuntu20.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-049
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 66.0~202610221835+git144dc70bd~ubuntu20.04.1 in ub=
untu focal RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
865415

You are receiving this email because you created this version of this
package.

