Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB9A404BC5
	for <linux-rdma@vger.kernel.org>; Wed, 10 Jun 2026 12:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781093067; cv=none; b=M39k9haxSXJuCkQZNRTpb7JoZ1sZ7QvRwdtCFN9XbOafoNs9Brr8scC9Md2ESEKIiL7uD5/Wlq9luG8U3lz3qoS2rUlyTwCTz4i1KRuK1QNo+zomjQeyVPpqzKZWEzn2EDXhP26fU3/qYUJHuDtzCqvUb+UAuw8sjMaVHOSTt48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781093067; c=relaxed/simple;
	bh=IGmNnb6pJ7N7jmDbw+BSuV64so0VfbVn0y0PbYR/4lo=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=SFKq2gCwnfigYRVKvQW3WCDylpumpKyafP7T9qHZ+OaEypY2N2T6EZYnOfDeStlRo5nxJBQFpldC8A4cCxJqSEXAb5pGThBUfCaPZY6z0MGIaINEJrbHtzIsuSmriVsIzlJvj1/MMY3yB9XPoZu3bpXomGSzS397EBvAIJL1G88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=iM2OoUoq; arc=none smtp.client-ip=185.125.188.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="iM2OoUoq"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 7F1603FAB8
	for <linux-rdma@vger.kernel.org>; Wed, 10 Jun 2026 12:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1781093057;
	bh=IGmNnb6pJ7N7jmDbw+BSuV64so0VfbVn0y0PbYR/4lo=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=iM2OoUoq54k5WSbStALpxK74vVrvmFEeLftyeq6qqxEsl3FToqga+1rUx2VVQdFQt
	 YNKdEObnRucgyjSFVzazzZ0dR9GLmIeYMoXvrhaqE/HtTTTq3ocRhRNTGEChUGLh0s
	 DU+UA3SJTxGBb65KRm96K09k3CXg/alc23rV9xrfxnbupql04n2bBPG7ZYWHSr9EF/
	 W47TkpUZ1EhBFxX6g4m73PEVMNRybN2xmY+2RIflQGo/cPVc+Wk6Dt6acNS8zjdcs2
	 UmAgoLM/JzTIJK27sctOd36bMgSpxzS44Csah0bcVuD+ZgRZ2cGExn/gKeDCC2JOJL
	 ydFLk/g1ArG2g==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 6D94CBD3E3
	for <linux-rdma@vger.kernel.org>; Wed, 10 Jun 2026 12:04:17 +0000 (UTC)
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
Subject: [recipe build #4050377] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178109305732.1192193.139238051061498197.launchpad@juju-98d295-prod-launchpad-51>
Date: Wed, 10 Jun 2026 12:04:17 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="81b3240738cf12f6bd4aac6593260fef8d7b0d96"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: d90838c7725f00f1be3fe7cfe84f50ccfa0e8f79

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 4 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4050377/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-021

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4050377
Your team Linux RDMA is the requester of the build.

