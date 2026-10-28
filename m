Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793155783;
	b=HkoFV0XHUstmpEbcgLVb1sxIukurHPynlIkm1EE06L29vjanaqXZ0U1mMXRdwFCU29U8
	 kF++cS0y4U4d5lmrJZMirEJUAxPZPlOGgzxWl2CNjS4DXeanbtT0GR4TQ99Rblcu5SDYq
	 QV9lCoXE8pCZSFj6FLGfFQNQnoGxLDFyWwmXPiLOGSeiSt+t8d5ZvVXxartJilmXmqMzh
	 oa3x2I3iBJshv1i9TpTcjs/H0CpyYNH0waDOkLgPa3MvLS3MtFSlSc6m1BvTMuuIjdjtG
	 44XJP/MKCtg+PTbvss024aDB4BHX/5rsgqm7LIg4XGEU6Udls1GAGO9Ru2m+leohW9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793155783;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=MsRtRHcUbuJ3dXdZnu54p4IZhn6FDpboiizcqboJd7o=;
	b=Hb0y7pi3Y3uI6uAIjjZIv0B9wycXKbCnG0UOZyUBZ/VV5ggQb6twzHiA3CbISrd+bh39
	 FKQQrIUqnINe6jkm6cug0acgJgu4FXgHgXux2BO45H2PBz6TySQOpZhIp/evB+1cZsa7h
	 zd7q8pmVHZfN6dBHiuTs7eGq1BqCL/AV2oRpCQE+PM1+aAQ9VtEfhF5Q4+CYf1ENAYmRm
	 h/hHFbhDUa7lBLN3Tj8lSuYLBbf5opnw+BrvmZFxdNi5z9fgN4KT5/roaRaBUbVRUGDrE
	 WRxvQuYjqrfzO66pb+RmyaEKINhPAdWUq+rEi3BJcTjENN+MUIZ3RHQ9cmp+MxoN85w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=s1qin2lc;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1393606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 02:49:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D1393606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=s1qin2lc
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id A80E33F629
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 02:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1793155773;
	bh=MsRtRHcUbuJ3dXdZnu54p4IZhn6FDpboiizcqboJd7o=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=s1qin2lcpn4OzCdJHLLWd6Vy9l67xnvrXB/4WYQ1kF9VbhkpEQlABEhurdMMZW0Sa
	 TSr/g5XOW/iDgIOS+i2UXObe0kBF2rMdX1E83rNs9/5x5UqdQQXV0Yz08TLnVL3OJi
	 roFlbYX+6X5iv48lUbQTG2Q+cNGe0ltMWsCwtlNr7s8OpC1TS6BMygP3zTjmEROIv/
	 4W04OrH15/I9fIq7SwqZcRgVAPpfn1RJ93OpD37BJ+8EM5usa1ui3YwwVMfawFhPgI
	 tGy5a4YFaV8x1LTmSW9IQN7QB3Ko3LUqLyso9drnPXMq1tfq8tDlYIKcvGPXL4vjBO
	 ZV8Oo6AoM1XrA==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 83F63BD8BB
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 02:49:33 +0000 (UTC)
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
Subject: [Build #33879548] armhf build of rdma-core 66.0~202610271821+gitc56edf7ca~ubuntu20.04.1 in ubuntu focal RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179315577350.3317829.5063137491362316429.launchpad@juju-98d295-prod-launchpad-51>
Date: Wed, 28 Oct 2026 02:49:33 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="8aad169d2e22e99bfd86998a2cf0f0a07502f5e7"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: f2f46d430134fb6ba0a2892349b0c1ddf16d9d7f


 * Source Package: rdma-core
 * Version: 66.0~202610271821+gitc56edf7ca~ubuntu20.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 5 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33879548/+files/buildlog_ubuntu-focal-armhf.rdma-core_66.0~2026=
10271821+gitc56edf7ca~ubuntu20.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-078
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 66.0~202610271821+gitc56edf7ca~ubuntu20.04.1 in ub=
untu focal RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
879548

You are receiving this email because you created this version of this
package.

