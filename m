Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E48480DF5
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 08:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784709845; cv=none; b=CGzd1sTKQQFJcCaPNcizzSygv9y8bPe8OIvZSO0Wmhv2uS/8iW+GddO4PLGBBsQ/EtDoZuYrk+JPtHE+mdhCwbDZOBhTksVMhEd3iELdA+vxDCo5zp/stcWpQWUi+PbGqVdn7Is3hICBGukMTq/buDAT/9AnZ1xSyRaneeexrm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784709845; c=relaxed/simple;
	bh=+8fmwx8BsSe0V0jt4sV9BOIXxTtTF1GpWPAAOkRZrU8=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=g+eLqUC5qBE6zLTmqM5vuClqC7mIJ/HZMmOSjOyutQkmtqC2JiGmpcHTG966F9LFtu+0NmLiBZMKZEUfFXtTmR5YI34jN94UrxPAsXkbzI1DjhThs4i2BnZ88ASIsEiW0+mtOH+szQrCgWauMcut/vDu0XALZZQuET54gL5c6zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=UqsnoLgp; arc=none smtp.client-ip=185.125.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="UqsnoLgp"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 524223F46C
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 08:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1784709834;
	bh=+8fmwx8BsSe0V0jt4sV9BOIXxTtTF1GpWPAAOkRZrU8=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=UqsnoLgprvKX92KK51E/ftlYZJPy9X6A8ry0xqfAptkoyPMV2F9WdNj1+lX4Sfao7
	 aI6TL1LRlu3MdOfeYP9Tt2iN1oognIoHz9OJ4zfyYB5Mapf0e4ix+cXgtgum3zsEnA
	 GPehmYXyPzzQY5GHVjWSXwEw+Iq8IMBvQ57YLIa4RdwobycG4f6E1mqvcenKgODkXf
	 XjHmRXEWBSTGMI2i3Br2Kh3aJWV8DNijA7ZadofP+N0WQ7/CwNKj1q8k+P9ofqtekX
	 6C81NF6HAjtl1grB4kSN8CV1AYipMfzI0CagJYkPDauut1+PzXyGZRsmlZ/ZcFhxOV
	 p4y84WzexsTbA==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 35ADAC1180
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 08:43:54 +0000 (UTC)
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
X-Launchpad-Build-State: FAILEDTOBUILD
To: Linux RDMA <linux-rdma@vger.kernel.org>
From: noreply@launchpad.net
Subject: [recipe build #4068553] of ~linux-rdma rdma-core-daily in xenial: Failed to build
Message-Id: <178470983385.180546.17715675494499529201.launchpad@juju-98d295-prod-launchpad-51>
Date: Wed, 22 Jul 2026 08:43:54 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="774348fdb24c5c7c9b709dde2a8f044a871f127b"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: bf01525e661e52bdbb09c57836fd3193774f3ec7

 * State: Failed to build
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 13 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4068553/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-035

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4068553
Your team Linux RDMA is the requester of the build.

