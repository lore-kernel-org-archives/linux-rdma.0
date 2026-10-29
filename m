Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793316536;
	b=AmUjvlm0lJtHz7iJAUwpO8dtxEMI1Uisz58Vt12sjmz5n3ns64v/6Dv/qZIT1VVmTKUf
	 v2CdXixT4FsqYql6wd4+JFrP3t+fyKkmCIZsyRGejWxT5DvGuIM5FjNOO3wUIV0wMHRmp
	 l63x6Ycxs96bBKlLuPlNX/M5TtT24xqUHWovLgoPXwlb59u44mWsOrNyIB/p3kNiShNsj
	 GXFTa8r7E/xrhk47xH4bbgjCGG1/4Me9uPhsROv1HP3ra2B56+X7Neux4Xf8oNIPz4UjZ
	 gHQp9i4FgnV5DAl9sGnIx0ct/b5rwp6bDg7stAYVNcFhZY8Zo461I7zlVrA4HVhHiIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793316536;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:To:From:Subject:
	 Message-Id:Date:Reply-To:Sender:Errors-To:Precedence:X-Generated-By:
	 X-Launchpad-Hash;
	bh=DKLpEKaY/X0Fun6OHj26dN2+ffdXyzFYEY6jIwtdT2Y=;
	b=RBPwcV4EuVl72WZ83qn7HzHSk0/hndW/G+PXOkrDQQufS5RPcnktDsEIWZaCktc9ZTNc
	 b9kwTudzeqQjbmIX1b4gnrFT5gTXUj33ffWhJG7v/qdUk+IbuiIRcklbeYuCw3pikLoiL
	 lwiH9sPytx3xS8FJAn9Irgn2WTTCUyiPCjZxyCRug0sGO8p83+KIcpBjOvvLKQUSE9PgG
	 ooFdkx20IeRexvnw1JoyTVK5jLEqDhQQSDMPTA9DS/FHTbQPfGotO5Md6ZVkmYz0ML4SX
	 p4UmHzkw8FWSUg8hMqwnfgRbc6k5rgTKCQLa5TbeLP5g0kkihE4FmBaMTlJphtxgLvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=oD05+erN;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA599606A334
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 23:28:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CA599606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=oD05+erN
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id ADEBF42BE4
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 23:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1793316527;
	bh=DKLpEKaY/X0Fun6OHj26dN2+ffdXyzFYEY6jIwtdT2Y=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=oD05+erNRK5gssdHIFjFlaiiksqqDdExYP8V689QE6UspfvGO9FMFjtqHDiTcm0CG
	 3bMg57HEj5qFzzEUN1sjn1C9Zsc2jcJc46L+7ug/ZmNhM9p5aN4R6+dX/s4VvMi1OP
	 QwQbCTeyF2XHfvvnhGO15zjmOsel4EnUrNSXYMf3YJDxmX73S9LeESso+ha6fTdUns
	 5qkoBdu7kMxJi9U2cbnOOhOQeJjXSw78rV0us4wlbTkJEqYtkv/5mKo/Pbg1Bi2Hm1
	 h+/66BdJht7OOt+ONLcG69TTcEsnD6rSt4MEOK06GltP5xzV1FKJu3Cmk4ihePnAAs
	 u+bKblG/x61Ug==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id A3190BD8BB
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 23:28:47 +0000 (UTC)
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
X-Launchpad-Build-State: FAILEDTOBUILD
To: Linux RDMA <linux-rdma@vger.kernel.org>
From: noreply@launchpad.net
Subject: [recipe build #4107488] of ~linux-rdma rdma-core-daily in bionic: Failed to build
Message-Id: <179331652755.3317829.292398772824242217.launchpad@juju-98d295-prod-launchpad-51>
Date: Thu, 29 Oct 2026 23:28:47 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="8aad169d2e22e99bfd86998a2cf0f0a07502f5e7"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 09946a0dd4bc368805d3cf615e2cc4feee0f0c5e

 * State: Failed to build
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: bionic
 * Duration: 1 hour 10 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4107488/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-005

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4107488
Your team Linux RDMA is the requester of the build.

