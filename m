Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46577256C6D
	for <linux-rdma@vger.kernel.org>; Sun, 31 May 2026 09:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780221258; cv=none; b=hkBN9yu8LO//mf2qRxFRU0GR7bLqin9cyHMHYjln96z6/78NcIlascT67rOanuC30KAp9ot45szaw8hGe7B5ifvFr471/UjuJ/a+hmbn7Hb0+hD9G5ELm3FMXZsASb/xaFw/FwSuX5d2dYYbpbfERPHygqQFOVJPvbshA92W1w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780221258; c=relaxed/simple;
	bh=nkcoY4uuVIg2d9/Jp1RSSD3CcJVKAJqffCVLSol5zpQ=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=pJ/QQzdzs29ZXg/pWl15nTlwt8Ksk96tI3VodOOxTNYzp0gQ3xzmImsKRrR8u6u3t2pUW6WRPjTXNVBaLDu3tUfyIqFwHhNasJFfvC9JbFDL3k3FYlauMdkScmK2cYYpp3ejRYOsvG6WlraTvb+A9+8NFZJz4wxHWNSv0HraBmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=pz9ApVVx; arc=none smtp.client-ip=185.125.188.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="pz9ApVVx"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 98A143F0D5
	for <linux-rdma@vger.kernel.org>; Sun, 31 May 2026 09:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1780220849;
	bh=nkcoY4uuVIg2d9/Jp1RSSD3CcJVKAJqffCVLSol5zpQ=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=pz9ApVVxei4GinLhkrx7NeJJyOooj4kl1PA5wANN0CiVCk9hF25K2s0zBHjKCarFs
	 +R+0qKfrpTIbSjZVeL2KbF832jXSqKttjCmU74KqdKycH3qO72QmvKqmLbpb5PyjZs
	 Ja5PGrutdCjMhR8aVnMjCgvr1DsBfKLaPhBx4Lpc8PZhA51HJkK+yZywGSKOC9PuHO
	 ZEWRXI4hwWTsTl4Srg552O0GwREI8JCR7BrnvYRGZmZ89TbS3CofmT8Eji4oEYVrcx
	 FeXTTFa2T14QbxeJWbMFaOcoVgTs6CxzUTnG6Al6WOHs7HWMQXriChrBjoG275HzUZ
	 bmYFVsO57Lm0w==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 5B15BBD3E2
	for <linux-rdma@vger.kernel.org>; Sun, 31 May 2026 09:47:29 +0000 (UTC)
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
Subject: [recipe build #4046532] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178022084933.3369015.4520799270948564652.launchpad@juju-98d295-prod-launchpad-51>
Date: Sun, 31 May 2026 09:47:29 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="e655887187b0b1e1a70625cd2d210bb3cf47cd14"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 6f0b55fca3fa4478c5db54d1ec0d7329d98a902a

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 2 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4046532/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-009

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4046532
Your team Linux RDMA is the requester of the build.

