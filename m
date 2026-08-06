Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F264F38757B
	for <linux-rdma@vger.kernel.org>; Thu,  6 Aug 2026 09:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786009181; cv=none; b=ddsRh1xjl73bsx/+duk1KMUKZ0AiEbaUdvXajhexMP0pLp6GK3SN0kd/qWxFOhgcpUA0ECVwd7bvEGwJwDpXzValA+Bp++hzzei7H0Bu6DM+qOP1/+mUyul00C2B7fEJUGKl1MPbEi8BiiNokIdtl7CpM8l/XDSuz8TkGJmm4H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786009181; c=relaxed/simple;
	bh=fuRLc5mJyYNMaYz3Mn65fruG7h5Q7u5O7v7dloRuHWg=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=V7EsNdZkydgh/oIy8VJQNTx1/F0cDM3hD9r4B0RORekeMtY9nZcG+gyoBGY5tSnDsJNH8u4vTitMwef+FX76dU+2WoGb0rtUXI0msFFrSmZ9zk4kvYm2j7XTd/1cDm4BPAMqUxs+R+clhW+qjXrIPjKraeFmp1cKEzOvcUioDf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=EpEK11yK; arc=none smtp.client-ip=185.125.188.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="EpEK11yK"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 7B51D3F0BF
	for <linux-rdma@vger.kernel.org>; Thu,  6 Aug 2026 09:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1786009171;
	bh=fuRLc5mJyYNMaYz3Mn65fruG7h5Q7u5O7v7dloRuHWg=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=EpEK11yK6zqrDeaLV2QXAECWj9v5xNWKCQ9LURPreMOe2gyTB2k2ZzOMBw+ciFIRY
	 IF4kQZDgXsxPQmKbfWwmnBDKb5Dfl5S0IZIpI7eIGiZYb5wuA/x9Kd5nWRe0l0So2s
	 bgToK5Ez7mi97K/CR1IFvXQngC9kUOPo5+58UPEfB94ZuJKNXwIfO+5rbMMMC/geXU
	 cCtDcCouSillDKhp8Im2riEqav3XfSvte0kK6MV8tn7rayobNGy7Elf1Ku9GRU6A73
	 /T/fXcFQ37iw/zKgckb+YhzpPUrO+l4qx5iG4VgUPrFXJo+sVRcbASrFKDBgtOZ4fZ
	 oRWv+xuWhBKyA==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 63E3CBD3E0
	for <linux-rdma@vger.kernel.org>; Thu,  6 Aug 2026 09:39:31 +0000 (UTC)
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
Subject: [recipe build #4074182] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178600917137.1455614.8893325166074798156.launchpad@juju-98d295-prod-launchpad-51>
Date: Thu, 06 Aug 2026 09:39:31 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="b042f2deb3ecfaa583e2ab7763b0e6f8b706ff27"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 33d1b47cb7985d5f0cf75d88a6d667faee8772b9

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 9 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4074182/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-111

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4074182
Your team Linux RDMA is the requester of the build.

