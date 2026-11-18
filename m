Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794998944;
	b=DwE5IkY3GIoVMyzE7kEIGviWI1P0SotwMUfUns2hplhDYfK1vzsrxmD0buFGEawsbjYk
	 FDN2Gq7UK5oZMfo8RM6KdJpqT95nkHeRSV0UjMe3HEQeIPWzm3qSDz1mXgRC9JcFHlZAh
	 MzMA8c8CrHjsultejfNLavs7RTLV4zKJX/3rzx3gKNgYpAucBrWB39Cfl6xFT0JA/rlgz
	 W5LIzaMs0JtxzsdEfHaI4NDhV1Ai2FfRUl9uLrhUtmzkgepIXHoWOi2+jc053OEWl5ftf
	 WZhC76HmRIRgJbkWP6ViPLIv4a5XbJy5K9wiM6SSAcx0WCRG3G+FIII8cs51HKbx2JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794998944;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:To:From:Subject:
	 Message-Id:Date:Reply-To:Sender:Errors-To:Precedence:X-Generated-By:
	 X-Launchpad-Hash;
	bh=aBiWNCwd0pA2F85ZbxcnP+s3+wC1um7wNRf077N7D34=;
	b=MGC19oVs9q2uUdmlt5bW6K0kUeZzO64AMe6DRqOius2/KHf5mIDABc5gxp9tjoOqlJEb
	 2tLoOQAL6iVDkWhsTDx9+LP6o1cEXux5e7RRD5NEJq/uFzvcqdksFP9+tfy9T6YG8cCce
	 U+s93++l0LtF8ANokbA9SyDY9q1wtAhW6d+eFPyLwRRYrsoddGOIPP7blXTh11wLqOegb
	 ywXUCiJAXWC+w9wouF7lrLdRCW0My1k+0b7e6JWm4PdV5U7o8wjXPn9pTm/mLROVN3/t9
	 nH5e3RGSxfYmV4KDjQdpkksRprDPcX7ec86Gq9F1SrjydmE9nHKX7tUQVQafqN6oU1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=McybboIE;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE7D606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 10:49:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADE7D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=McybboIE
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id BE70840647
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 10:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1794998941;
	bh=aBiWNCwd0pA2F85ZbxcnP+s3+wC1um7wNRf077N7D34=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=McybboIEFlRbuKbmMklc7RxRc8pZeHL/HaC3XXoXOOnV3HvW91EOgxhPAno7Cereq
	 ex563HUmy/dz3AVkWl8OEhnT6Ee5QwyQ6FqEh9OU4c/K+4gtbPXUKkLDWSOehxkY0j
	 flOMikDwkBETQyesh4cksBWXOZMQVUxo7zYctsm1KAt+E34ZfsTSrJQBuMawD/egaM
	 s7ujHoI+9bnG6Pthb86ZcWzdggS6HV+Aa4CfTfjW91M+JbSlx1/4JUUD7qTveDhMMX
	 RuR98N195Imtwa/Kpbn6zROHE6gawhR+1F4AqLyod26Tl9Vw5Z7oMGoyTVv7IU4sCp
	 llOKQGGr7n/cw==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 7ECCBBD8A4
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 10:49:01 +0000 (UTC)
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
X-Launchpad-Message-Rationale: Requester @linux-rdma
X-Launchpad-Message-For: linux-rdma
X-Launchpad-Notification-Type: recipe-build-status
X-Launchpad-Archive: ~linux-rdma/ubuntu/rdma-core-daily
X-Launchpad-Build-State: MANUALDEPWAIT
To: Linux RDMA <linux-rdma@vger.kernel.org>
From: noreply@launchpad.net
Subject: [recipe build #4116425] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <179499894139.1826918.1016507024718650255.launchpad@juju-98d295-prod-launchpad-51>
Date: Wed, 18 Nov 2026 10:49:01 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="b97fa980824250ed53259e6e5dc13c2c57b8d4ec"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 968703a671590306739aa7f65c1ea562b88b765c

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 4 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4116425/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-060

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4116425
Your team Linux RDMA is the requester of the build.

