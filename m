Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585F94078C2
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 10:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789639381; cv=none; b=EvV4o61AaqqSOZl9QvttyH2jTQL9KHdEoDwKHLUfrZqNvAFq6nVyY764LsbE0x8z/i6FVq495e2+0S9FNBE8tmMfqfP6ymuFks0i5otKTuQUYI6wUKPZik02cB36MORUYm/UB9ijcoqDZxchJ6LeJgKIzfU3jnBF+uVs3wJ4ojU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789639381; c=relaxed/simple;
	bh=hA20IORVq45CHdw1S3PAK/2rVru+Vwh1Bn5f/q2okz8=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=fBdStlaCTSaIMG1spMTnq4OdhqdmfNMcTpfEWC5YtdAOsnmz9b5/KUMBu+Kc/uHt1uXqYkXsC+rAhGf1Vf69STnXU3z51yd0JSKhsYrsgDDdoAE4eg1tY3NvJ1nhd7dW3rwIbGotd/WhiQu4WEpUASm53qMfE1eYu32+pfskUbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=h6OZ5jUl; arc=none smtp.client-ip=185.125.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="h6OZ5jUl"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 8C01C3F241
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 10:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1789639363;
	bh=hA20IORVq45CHdw1S3PAK/2rVru+Vwh1Bn5f/q2okz8=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=h6OZ5jUlfSJVoDiN4TdbnRXyv2pUyaYcFUwxjRGQIlfmfL5gOr3lDSdMAflJbUETo
	 sQKkP/BeuklECjzGt55iQB2EMKOF5u1zZg5mTv2AaTjxMdXH2Xt0ZTAansp3kfunh9
	 GzGAJkmyebB0npHuzKzIsClii+YwNBajGBbhY8TiDTJY1LMAG/JkIZwcphuzU5+RbE
	 1IGrYO2oyJXvB5qvX50MQ74WGl7lhiBxRdNNthC57V8zwIO7EQv2QH4SLSAlwDTD94
	 IKJGljrjJNUQjBYxmFn3sCIVwmE3DhgqDa6lOfbfhX6Cuhx/Gc9vmN5GEA9F7PXt7S
	 X+1vpkoYJ83bQ==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 32B55BD8B1
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 10:02:43 +0000 (UTC)
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
Subject: [recipe build #4090843] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178963936307.3835662.7758936660233159550.launchpad@juju-98d295-prod-launchpad-51>
Date: Thu, 17 Sep 2026 10:02:43 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="6c05f5b586acbfd5d3a5f5142777242f41e711b8"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 4e516ca173b9a429cf674ec477bd62edc098ed3e

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 2 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4090843/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-063

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4090843
Your team Linux RDMA is the requester of the build.

