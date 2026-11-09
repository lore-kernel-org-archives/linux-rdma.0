Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794256253;
	b=1C6wYB2YmPVeo06vgX6ZvmqhrSZpUrPN4pWdU59bQ2NxGEBm/ZZyewqX+F3C1bTTjjW1
	 kVsa+tPHrAbJV+q8XFB+G1jjGDR9+W9M2lgFxNr6lAwU2okSLNiNpTzfOZ2xoIi+J51ma
	 gm90R9PxgCaA+2eZer04NsaKjZomxVhyi0t9u1dfSVhLrgqeU5npKUUYf/JoHTdvou/S/
	 +VRtFfnuBD0+C8j0OMu3d45/pTguUidbhgWcv/TREWfLOLZhVWUyc3pownJ0sFWVsw+C0
	 vTeSsE/mlQaPXK3IgrirVXeauiucQf3L+BnmFzrBr2MH/vztlT7T3ggY0snQn1MXBcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794256253;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:To:From:Subject:
	 Message-Id:Date:Reply-To:Sender:Errors-To:Precedence:X-Generated-By:
	 X-Launchpad-Hash;
	bh=h9XV8ETpP6R0B6dJFFqdJEAun7M+Yiw1MVy3VsWTRJE=;
	b=fRoWceQOo76W0vFkm4mN2YPbbJRbQ1zSB5XDindLDKgAnamsszTW+OmOgePRQm4W7KMu
	 Pf0z8o8/w2cxVwJzIlOqdlkaHth7lZ/RKb8roJ/EySiXa61s/dsvlVN6KfTLkIxOqj7YA
	 kZwO8SlhR/9GX5d/KzeCW/uxkWidpxXg/JlG8ftF9uKJxdjtySaSZv4xicdLMSeAIxRn0
	 q1QyQcxNQFeQh8jHWdWtf65kN7UttNSFFcNCjpFbHSYoZI1Obl1qeIYkBEtkXvGTaxoux
	 tBpDC3+zkejpRAW+Vdx7O6gUOqo2cf49ckl8Sh6c4dwcz3GtvT8lw5qHDXxuZymj6jA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=alsk0lT3;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BB0606A325
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 20:30:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B6BB0606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=alsk0lT3
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 2492F3F1F1
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 20:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1794256245;
	bh=h9XV8ETpP6R0B6dJFFqdJEAun7M+Yiw1MVy3VsWTRJE=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=alsk0lT3lWsXUT8MJwWpmYmDp3DI12ynbY/VIzuzTpXIFt/kw/OcZ1V4YZlfR5NHR
	 XBjN0ybBFFVXXNQrbfU+hq61GRogCSfqtO/3seMNNmKxh7JuaTZlPKF7c+bqgOSird
	 Cje4pAmeZFxHe1WJf27HWvSLNwSdrIlu53aeeRRPY1z6d/oNpHaTnd/RLs9b4T/WnK
	 oY4jfiC5RukL5AxdznlPWE/0IhYpL46ugMZ9X6sHkzEZRqmzWZIB9RMBIVOzgceIRf
	 1CvjZjojEMkM6UFt4C9aOKK8jxf7RqyRGkkwefFixPoJYWE5WLiDxTv37R5BAg9vkq
	 2wibEIRUDdNNQ==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 7807CC2B72
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 20:30:44 +0000 (UTC)
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
Subject: [recipe build #4112492] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <179425624433.3544717.6427684157056221214.launchpad@juju-98d295-prod-launchpad-51>
Date: Mon, 09 Nov 2026 20:30:44 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="c0a367959c9c9b09a1b30cc94b3d52c142eaa123"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 478d46e03506d624f018562e761a7419e5277c38

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 11 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4112492/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-054

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4112492
Your team Linux RDMA is the requester of the build.

