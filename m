Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792786946;
	b=oKzvTzkx5xNJA2zIRBsL/1tgs6VY0bX3DpmMc2CT7H88K/0OKX6PWRO3ridGnczwaYWd
	 SGS/yZNLmzh3xnMGX0JjF6z5TOorrmvFNLQflbUitOxXQ0+NURZb90DT9aSffcDq097Fq
	 wPYTwRHTwfAPoPSJ7HiBHWleIm1UTWM44s26RDpAky6pCFor79hfOp39iHj3hPnBrN7tr
	 WalhOB1uiWUP5UHb1usPf2HDg85Kl903ypwoTL9j9Td8go7vt1sK98hfoP86D39AwwHce
	 x+TcdXeJMIeUpMP+OQcBVyvpRNML13LjXzzZXVyDoOpDyK3hnQBrOW9O7V12VJVFA7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792786946;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=BtxaH+7chG+vnkZGfTZiXIS78H4ytuiUvECpNDERrok=;
	b=1XcQEKamVxndmPuY0HS6BRx46cSnHymEt9ioJqtd1HQK2O5e0RWilFPbZjViPBc843HN
	 l7iaFgnzXzrWrE/4AALjTQbjvY21I5qFGlps1zviW4TDIS1lKojIvCzunrnOcuBL4rwgM
	 VkPgQqROn9iFm+anJZ9AOe3ITCCZdAQAkPM+WJvSOw48mm3L5W1yMZ7lATMZjTJ7VMLFo
	 4uIhE0F7Of/QAhqFmBxQ6PUYQxeOxx7lBjZNCIfH4tiujWyaxDLF5V8qkls/VlCVOQBz5
	 iOj914jTqsLe+AtbehVmYA38miO+swSUpbnOTC3jWTxWIuXiQ+eaXs9GuHz23377NPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=wyUKPuCm;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98D9606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 20:22:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D98D9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=wyUKPuCm
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id EBD2B40A98
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 20:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1792786943;
	bh=BtxaH+7chG+vnkZGfTZiXIS78H4ytuiUvECpNDERrok=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=wyUKPuCmhFan1FAs7uQx5NlbBhDUEIGwHEwRJpkaXLVEN1r3SbWuRG4eRBtlODRmR
	 /CwTBrJ6brC8RZIzORjlikmSFZSc1mjfdounVaRaXfmzANAbTRwbjnD6VFSZEBzN73
	 vXcFvfvrWcrfNkbul21t3dbDlO5HA5s2GPqwv6c5SQlVb/p9bqg/A7xgI/iJToGYcf
	 oW8HJMxzqNhFp7q8pNvM8zZhwb3gtgkKCzxUC8pfl0g+azZtTkpTXSjBqMSX7h5aVn
	 Fkii8gIoaA+09TIHYZpXiBWELsCOzlVJAd3X749vtorOj3SUOqAXd8h3CZF52TYPji
	 blEVGHadDBstw==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 9502EBD8BB
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 20:22:22 +0000 (UTC)
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
Subject: [Build #33868023] armhf build of rdma-core 66.0~202610231640+git8009440e9~ubuntu20.04.1 in ubuntu focal RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179278694248.1684904.17150423954280067757.launchpad@juju-98d295-prod-launchpad-51>
Date: Fri, 23 Oct 2026 20:22:22 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="8aad169d2e22e99bfd86998a2cf0f0a07502f5e7"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 426b9bac7fbe9b00c1fca34bfd092533b14d1c45


 * Source Package: rdma-core
 * Version: 66.0~202610231640+git8009440e9~ubuntu20.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 6 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33868023/+files/buildlog_ubuntu-focal-armhf.rdma-core_66.0~2026=
10231640+git8009440e9~ubuntu20.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-081
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 66.0~202610231640+git8009440e9~ubuntu20.04.1 in ub=
untu focal RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
868023

You are receiving this email because you created this version of this
package.

