Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795414998;
	b=pV3PvG98eybErJz7YXlNx1K6tZqRdEsCcrgrwunZlh2nIlKCzKYO5rdl768wsNioK8+6
	 JkEm70YXLAhvRpUGwMWkCF/BnfBoNh0cLv8U9/TjNhFOWR1Kfnm7/pLnYWRhA62ZEcCgp
	 rnCb7Xg3fue6tCNyYCk0IAFPU+med1ON1oXQHfZDtJ1e45+88FprvQi2cTetIMKVjVADL
	 e6d0TUe6/6cYieO2MbeHkmUgW43x2bz51h+ylkGqz8pQqS+RVOzzQGp05rg790zG32D/2
	 OfwSFyhsUn6PSGuJsSLVVaNB8E5Y2J5B9VpmYgsLDfS7vaIpSUNjXuOqUt3dzZSxVcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795414998;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:To:From:Subject:
	 Message-Id:Date:Reply-To:Sender:Errors-To:Precedence:X-Generated-By:
	 X-Launchpad-Hash;
	bh=WAaG63XwdMJL6V/eUFmdO+ZdLIGpjideqtXwiEvlIys=;
	b=2G6C4Ocy+2drtQVnTrKeRiUKlJDPDefKWwKkQr2dCfz34FHpYi+hJjY9XVnIDKlSfoQb
	 X/ry4ooBMg7ZXGxm1XToQUzq7pk6kGLGT34Je6HNzmXkYzTiKVtRDPt0YKn3IhnJU8H60
	 9ej+wuCjkqVuQmCwF+/lz5YQUc1qMElWkRyETFbuZGz2nyQE4WKAi/r6038eGSILh8gwX
	 hrdhOpbM7Uo8BBGLnzoIYmatF41COte1B3QljN8qWLq2Ukvst1s9SYvbB9D0wh81F/Vqv
	 bL0K2BYH2UVQIT+MBXdkK/1GM2C0usvE5Lm/yrVz/ep8uw1rWF2JaSv8YO45gta3kKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=gzd+NGPE;
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AD2606A333
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:23:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 66AD2606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=gzd+NGPE
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id DD23C3FEA6
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1795414989;
	bh=WAaG63XwdMJL6V/eUFmdO+ZdLIGpjideqtXwiEvlIys=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=gzd+NGPEmb3+xffvxJTgU9VRMIbRC0mk+B0plJKpYoG7pqf9TwNaYiRzEEIcc94BO
	 fQ1yu/aVsK49qKI+LArzw3FlruR3XBE/c6ff51O34hIOi8QqdxCrU3fq2c1SlNlkIa
	 A33/zFrkwIknDrBpvyt8Pg7CU5hx5znj2HzKuxIKgSmAhZ8uH181vJfPkUjRz/UHbi
	 SDh1F/LtR4Nr+36a3jBNzqlk50xgVFq/osp92dUXWrzkG+EM3GmfP70UzEZGiKhUnr
	 AtFzoBkW2uk3DPX0Vqox+YBv3bIh8JP2EdKTk1RqFl2xiZKSYfR3a9nRGzZt0+mDEY
	 ar0cmb3vTbLXg==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id C9B92BDA54
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:23:09 +0000 (UTC)
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
Subject: [recipe build #4118855] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <179541498978.3108509.4970482623146976880.launchpad@juju-98d295-prod-launchpad-51>
Date: Mon, 23 Nov 2026 06:23:09 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="5893e20085ddb97aea2534e1b2a802438957dea5"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 0bb4244649786d08e840063e426eb760e1df5a2c

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 8 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4118855/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-099

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4118855
Your team Linux RDMA is the requester of the build.

