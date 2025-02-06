Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4551F60A
	for <linux-rdma@vger.kernel.org>; Thu,  6 Feb 2025 10:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738838851; cv=none; b=aKwPNgYddPV9Ipwp0q6jH/L7zqXpi0J86QDly9Vl+yurmE/kDuUaZyhZvVvq56btjjJXdeGrup9ONQjmr6QkyB1EMADK++g7029b5M9/0S+tqG0dit8gxt6iyYVn35Nx5N6yMTa9SGgJKYssHleQ3xvT8Y/khgBfroEni1vhcOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738838851; c=relaxed/simple;
	bh=RopAceXi9aHmprtKacEpSQc+T4UwwjYEGehCooy9m3I=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=eDiJNb2xeOFrAUupEvbZy0ZcgraMmpoihqNPj/BSiXrQFM6rf5BJ5ABUMcn8o5lMxfhIaB3mAc1AKItAcbcZxnyXuZGARLSgzXbY/x46Ho5tNIpjqsUu4khhFo2DBoIIOMPESMGhyW9k7xcQXthluYlZPhtIXb0ZkIb216djjSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=bxGWqY4T; arc=none smtp.client-ip=185.125.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="bxGWqY4T"
Received: from buildd-manager.lp.internal (buildd-manager.lp.internal [10.131.215.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 9140F4115F
	for <linux-rdma@vger.kernel.org>; Thu,  6 Feb 2025 10:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1738838847;
	bh=RopAceXi9aHmprtKacEpSQc+T4UwwjYEGehCooy9m3I=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=bxGWqY4TUG3tCBO6FMF+zh80Jev2wBQHm5e+PgqlS3FEo8vsWeE6yC9/h2Nsqq7Ad
	 W3VEtw6sAjLIOkGcZ4j52cSxsKXhNCB+0qFBeLzcCiFEv5UBaSomVf/+Ggg1yAG6Ta
	 KqtrXQ1wsU+WcNjDnQG4TQYPbpmzGeI4PrTA0L7h/Oadi2MWS7vu3xCbvu+jNsiFzF
	 ZCp7VMj9hey+S/KfUJRdiCajxBcMtVXPIrlleH13PjfgSnbAcP4SfyI4m1Ad9aVU9s
	 u3Im6edIgIXA9ogXerAk8Ymh15qcq+i2238LeicZ1JQlX01uApU6CCyhlHIf9S0Rm3
	 XEiaiZmbrHIFw==
Received: from buildd-manager.lp.internal (localhost [127.0.0.1])
	by buildd-manager.lp.internal (Postfix) with ESMTP id 876A67E248
	for <linux-rdma@vger.kernel.org>; Thu,  6 Feb 2025 10:47:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Launchpad-Message-Rationale: Requester @linux-rdma
X-Launchpad-Message-For: linux-rdma
X-Launchpad-Notification-Type: recipe-build-status
X-Launchpad-Archive: ~linux-rdma/ubuntu/rdma-core-daily
X-Launchpad-Build-State: MANUALDEPWAIT
To: Linux RDMA <linux-rdma@vger.kernel.org>
From: noreply@launchpad.net
Subject: [recipe build #3849775] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <173883884755.1817859.192559437389344980.launchpad@buildd-manager.lp.internal>
Date: Thu, 06 Feb 2025 10:47:27 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="b13dacce4a364151a813e3cdd6940bbff676214a"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: f0a75a35b54633cf60ff3ace12c4909af07356e2

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 2 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/3849775/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-044

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/3849775
Your team Linux RDMA is the requester of the build.

