Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794343364;
	b=gL85nDsGY47tuV0V0yh+bJ4LwxN1Kt0gwWaYrFnSKL0/VFEjKZgX2KBwj0BnqglN+AF4
	 horG6J+kXmmjB2czjq0sf/EB7znD9rJgeY6dWoGqQAjXoNyxW3nL/AVSfCSQKLTbVp+cz
	 Mz+3PX23o4d6m1e4h/dqFdCZpFM5BuhTVH2atho7djqJGHlPJzW8+7BcitPMHcHRi+6Pd
	 MfjUxoUI9oX/1luqEDmkLOMlNLiAWl/lUkQ8Vybgzqmqth7ygaANbaC+9m9tSS1LGvXsr
	 h3vV0t/Dr0NMDC2SnfLjfxQzWEhtKemeGXzPdDrJKyOL5naHnogmDVPvSKRq/3xhPRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794343364;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:To:From:Subject:
	 Message-Id:Date:Reply-To:Sender:Errors-To:Precedence:X-Generated-By:
	 X-Launchpad-Hash;
	bh=zy+bEYxDlt5YVRgcY5VezNF987XBllxo8uWFXsLur/s=;
	b=o73m8EniDIfHrGSKz8Ujd0KuCFjz4a+QZVdEVNVT+PREPQF3DjPmkP5SaPXdkRgROjsT
	 rg1wYg+7WMyNmrktqfkjX18lyTR4EPtYuJkrcMnFqEAA8TSkzoHnhG2bm9oGQai9qiDO/
	 qhnUZVilggvoMRk+ci7Eq2nj53Gd4Yyue2LtqF5wApq3reO98GoTfRHysqNY7wgRrdLf/
	 QunQYjwRQ2mv9ce/ZVLRFFDs0Lg8gxMlzd8mVQMDGaWmEYpO2a9wwR5ZYfpKvX38cYyV5
	 FGJvcwlGN2yab777h3rL5Ldq+dE0SEhnqOyEpfTuFsTbxIGLes7Lo3wDrVrRQr6oI7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=QiPsU4CA;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FCD606A321
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 20:42:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99FCD606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=QiPsU4CA
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 042E341769
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 20:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1794343355;
	bh=zy+bEYxDlt5YVRgcY5VezNF987XBllxo8uWFXsLur/s=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=QiPsU4CA76a9AgZjemRibQCvezZfnBHdjZxu5w+r0Fv/Rqrshw/VdlzgM545AXiQd
	 k5G8MF1eXZ2wCCK0mgPxRq8AU3ge19TB7bmHfqG0ZV/S+RnJ5i76x88Rlz9tM17vTh
	 sIBpnNTJugHXjd/XVFwO+8XKm5JzOMsenUDnTbIEnB14SUJxpwMEejm1LEUHWYU+FJ
	 OQWbaxOh2hJgKRdPDmNMywCWDhdgx8e2uEysGD4Jo3ngBzu7QokMxLy0hjnuXa+riw
	 xGFPjFe+aEUv2rq5XrjePdlBKVgOTq9DSu3lE6D4CNUwc6DisfCWU1Gf3vCPP9uS8b
	 lIrPlEQSKzgEg==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id C829FBDA53
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 20:42:34 +0000 (UTC)
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
Subject: [recipe build #4113010] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <179434335477.1538602.17158589681730160418.launchpad@juju-98d295-prod-launchpad-51>
Date: Tue, 10 Nov 2026 20:42:34 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="72ba15af7e009b17d4aa1467977127ac8392a4de"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: c049435cdab3c370281788dab7513638128d434f

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 5 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4113010/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-009

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4113010
Your team Linux RDMA is the requester of the build.

