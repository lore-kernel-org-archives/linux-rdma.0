Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792785851;
	b=M7hxOWkyxI2Afl14cJF64hLXVnJmvPhKwAVCE+x3JNALjAXmKfR8q9Zh6CQ+33bpABdY
	 vRXr+h7Qfq1louJdz09X4ZHCOM5muCCPc163eYwAaDGRACN/0dGmAE7tZrcdbPYjKzpNW
	 lw9Y5ChaGQJyROu1SKmJgcFutWL9uzieVYPW8dZc53L9r8mJKQ+VG0X10Ln+01kmCAeXs
	 7ZHZznJfgi7yo3iz3b6rpiwCInp+kyHpZ5DgYTNhfhRV+0lE/Vgr4/7tgwo6Zm/LIRg6v
	 hgLiPbF2BF4pkdLAKyzcwp0xDdNEpLuJuv9X/a1W/B9RKzyQ5aPfV/cq+Jmuzcq8kDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792785851;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:To:From:Subject:
	 Message-Id:Date:Reply-To:Sender:Errors-To:Precedence:X-Generated-By:
	 X-Launchpad-Hash;
	bh=X8gXZ4HCeSGVEGgPlr+YLElOHO8neeT+VgB7UbFKc0o=;
	b=PREvEH88gxeFgYvDbinjwftdHvlAqSCdPbBp9epIjVE/V8COzSUW4eJR9t4mRihz8C1P
	 E5321cTenRyZ4iFJ/gLBV/XFiP7c+FqxjWGHafDC1GT/3Z1rY4sRTQskn76owl07gWwvd
	 it3h9TxBdu1yI3kbw1ZXJsdisLupFnBNg00m3XuQXp5yDsJDeuugsVqEZ/1SVpUHr6yMR
	 c/k5pz+FKR60N2tDgUk1ltqAk50SCZY2+OpNm997+QPw4SelsTZjMr1+Th1ojC1Lasc2S
	 aTzsABAWjlhHY9s/hwNIJUv207Ako/AaAOOkBufvF1g0JuOHy4MgHygeezMYfeu9znQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=qoGdBWdw;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C94C606A31B
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 20:04:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8C94C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=qoGdBWdw
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 853463F073
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 20:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1792785848;
	bh=X8gXZ4HCeSGVEGgPlr+YLElOHO8neeT+VgB7UbFKc0o=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=qoGdBWdw9m//t2ZzivcgdGwNaMzkVbpfM8VT57DYvSibM5CWVjjT7uSgEDElOFwht
	 rkhI9M0N+dTnbLI77YXERbzjI1rQ2fYZ2mfwrTDD1bb0d6zRFOSG5VEAcnjGl1q+/f
	 ckJX/BzZuXBWM/AsOKcrqqTM5HJ3NhhLyLshPHddpoS0Q4kG89+JFVi6U0ysywCPk6
	 qwsJdb36W8EvAQiWsL9VvFQLIaC54I4BGUzVENXl0fppQxRSmuVtyQE0V/2GNLukSS
	 euEJyGmWwprz9zGKTuiqcWoZfFEhToO6UmNigWTMHCzXBw1GxVK1C50Io2ngJVtHXJ
	 ZuEOYs7rWlrgA==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 61283BD8BB
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 20:04:08 +0000 (UTC)
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
Subject: [recipe build #4105287] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <179278584831.1684904.2671340504535057636.launchpad@juju-98d295-prod-launchpad-51>
Date: Fri, 23 Oct 2026 20:04:08 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="8aad169d2e22e99bfd86998a2cf0f0a07502f5e7"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 2993e215f37c8df148bc5ad4b7334e403f62d4b4

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 4 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4105287/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-044

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4105287
Your team Linux RDMA is the requester of the build.

