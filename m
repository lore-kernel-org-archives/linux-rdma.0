Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794914463;
	b=vM6wYqCpl0ziPHp8+/sy9qvx2gROrO8U9Ex2grtUR4oJCwqUeTszOgDuONeal/Uf1T36
	 u+UMvrYFt7uEIMWy2K4gEmEPTlXWvFHTDDqvgUfz94uwxJBqNmdiJIORg0w25t7NmrTiv
	 wgcbRj3RweaYs5ih3ggEVYmuoB77TN66ByzXDnFw35B9ucsLJBP9oSMGsg/L7Fl4Ee16v
	 Biw8tAw7EpJ/GEC2xDVhF58pMa4dIcsyWECMW9eRKnj6MQ3q8xCfGEh6dM37xmxNub50d
	 wMUr90tVkUPhb8nmvko8wxHZlWn90bwoHD25i23hT6fzxMcC2glW+wfebX8EBIwnvDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794914463;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=yGEwlG659EdWLAUbJdP+pnVpNN1rKUY5WSablKF6RkE=;
	b=kZ6mTd+TFy1IUQk2Uf2s4y9aDZcF1w5d5FSOa99T1uXE/Kna5HzE1mGp3BqFOfYu0Or0
	 d1ffPQAnoyHj55xbr3DG+cf6f+5krrF7y+L9aTXaUKY4ra5UU02MC98JFhdBvM8a/Bis/
	 f8SnUKts+HeL+gIBfIuIrRJfCeW+GjbwV9OlgNmFU5kZ55CcKvrLa/lePxZbnEaMqHbM5
	 SOh8SVepPGgqmmPCNjSCOcG1r8O+exskapMTfk6YQ0Z3eBps2bTGODE2urNR0dwE+Nx91
	 +YBZFO6ZWkPmpD3cyerFwaEQGsFfGhHIUFf7uAOPPRyVChfTJxCAmCXBiZZ2JoT+Drw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=Lb1Ai++J;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DCD606A333
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 11:21:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 65DCD606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=Lb1Ai++J
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id BCB304079A
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 11:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1794914454;
	bh=yGEwlG659EdWLAUbJdP+pnVpNN1rKUY5WSablKF6RkE=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=Lb1Ai++JRJ19Y8JHBvbPOjDfYw5HoOMOjVwaJtAtViEqN/mxLOwThEJ4dNPKmddlY
	 O+qMKGWr4WsbA3U/umiv+n8jR5emFNYolZ4qMfulLoXC+jq4Qn3LGDjZ7pQB676xSP
	 NVUabtiXCwV74V7AyfvZlj13d/dQFkC8DazlMoDAtVJgUEloMQ63pg3AL1uiewzUoi
	 xgkT1z6VkvMm+5ugzsx8v8ibDu1nFPtI+zRcAsFFCUwawyOyxHqEUvTusTylv/CC7k
	 XYs4lHGsnKiRQ8gUCb0kFG8vB1+neuCIOCh/xl5W7qFdSqxQx6Uc95ovbgNabkHGEQ
	 4pNW4sKAF6/Ng==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 7EF17BDD85
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 11:20:54 +0000 (UTC)
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
Subject: [Build #33979591] armhf build of rdma-core 67.0~202611170757+git313215c80~ubuntu18.04.1 in ubuntu bionic RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179491445439.3474504.4673858905969040591.launchpad@juju-98d295-prod-launchpad-51>
Date: Tue, 17 Nov 2026 11:20:54 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="72ba15af7e009b17d4aa1467977127ac8392a4de"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: cce4f3a037640b2ac0e91198e6b34dcc702fd432


 * Source Package: rdma-core
 * Version: 67.0~202611170757+git313215c80~ubuntu18.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 7 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33979591/+files/buildlog_ubuntu-bionic-armhf.rdma-core_67.0~202=
611170757+git313215c80~ubuntu18.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-095
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 67.0~202611170757+git313215c80~ubuntu18.04.1 in ub=
untu bionic RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
979591

You are receiving this email because you created this version of this
package.

