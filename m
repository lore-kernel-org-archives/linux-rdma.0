Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E92E17A305
	for <linux-rdma@vger.kernel.org>; Fri, 10 Apr 2026 17:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775842307; cv=none; b=aNsVrhCjnEFaFX13gO4etqBq8zs6NAfWQCfv0optRVBBVGXShANRV/COWvLAebdWw7tSlQPecNHiQ0ex8idRqoTCMW+2tQ3AkAivQkmlVXrZ12+iVaaugr+Gc7R16pZbCUTBkN48h6Nt/VKdQKekgyooy4CWK8+I1sQMR/54EMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775842307; c=relaxed/simple;
	bh=Ik0VdDH6xpA8V847JAy111boHdvjHOp2Or8/1YxuPo8=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=C70E6mr/OPJKBu/R9Dn0tEgY/KZeIVPQuA4ikeM+bQgTE+91kJ1QkHuS9G5Ot50Zm7nRw/VXl5r8FhB8rhXnPp31x8UFHdwRJ9c9N5zLe2HcuaK3L46rRI9MGR8ZcIbP5Nte7uVxTBopK5CZqMAL49/wIyVU25RBUFfe46Jx6fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=Vz+xYh5A; arc=none smtp.client-ip=185.125.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="Vz+xYh5A"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id AD2CA3F84B
	for <linux-rdma@vger.kernel.org>; Fri, 10 Apr 2026 17:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1775841945;
	bh=Ik0VdDH6xpA8V847JAy111boHdvjHOp2Or8/1YxuPo8=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=Vz+xYh5AC46AnQLoUBFyJoc5UZtN1oBKBhWsUuZJq6sdHTBGZ4u1qT6V1vdBmQnqG
	 nKcVL87XLoZLGUA/ZfcFMKflT2ZBLhCicUI8y5m1eFCUa/sgrnoAsFjWz6bWRg+EYv
	 sD3Dp5QpL6Hkc8ANAnU/0jbhy2VUO0gS98n15S9ONunqz3T7JSc1yAtTNSPm7r0AZo
	 8LhgU2ne9id1CXbG8pPQZmxcBmgzYhIiR5NHSxYiD82EC87UC56ex9m0iyXUza5eG1
	 QSsgeaxF7K8KCAxE+Vm3iXB7NfPpz5N9efV3FowdTiIxZbaFH63MlxU/QkNVOvfMfK
	 uHGPo2II897Sw==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 7E4A8C10CF
	for <linux-rdma@vger.kernel.org>; Fri, 10 Apr 2026 17:25:45 +0000 (UTC)
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
Subject: [recipe build #4028845] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <177584194542.1712119.7281477304772966104.launchpad@juju-98d295-prod-launchpad-51>
Date: Fri, 10 Apr 2026 17:25:45 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="63170d9f894f213bed2e467c153d97add655c51e"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 4c3454b3d16c04220ce22881da3932a7a0ee4781

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 10 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4028845/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-105

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4028845
Your team Linux RDMA is the requester of the build.

