Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A410D37418C
	for <linux-rdma@vger.kernel.org>; Sun,  6 Sep 2026 09:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788686257; cv=none; b=Ip/aX2Hk+qjHedJ/2qeWrxiSvnCX+5V2UDQF/Fu/wj1GlvDEe41DjML1rvWiAGWTKZYUIGbBMaiDrWSGeFv70qkiDqnF8TNaWOP5jjKpSfdqL6XBr+X89Tc7d9JM1x08Uvpph34UmpyEEstQiOgHWuIjIWtnw0dnd7llpZJlX60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788686257; c=relaxed/simple;
	bh=Gzc3MQof7gELxwRnUCJiCw/QbY2nYiA+BRtsnlvACRI=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=OqEVA6BvEgI7CncwgPFxc0MeZa/BEoeloyGds59KMVH0QVQBh4nrGsKpOvO9WlCtC73Je/vN7f1TLS0/6S4y2oq08L439KzUmC6DDzdQ1ZMg4DPdLao1JcQViRGVYM4jalTmrBuYQmoHj7EEKolNg9M2be+3AlcwN17C8I4xYlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=MX6bT+t9; arc=none smtp.client-ip=185.125.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="MX6bT+t9"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id CE13C3F077
	for <linux-rdma@vger.kernel.org>; Sun,  6 Sep 2026 09:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1788686246;
	bh=Gzc3MQof7gELxwRnUCJiCw/QbY2nYiA+BRtsnlvACRI=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=MX6bT+t9bwtI9f70axrZvSteoZwoUQ22h4nt/0aKBCeg59KKVEC5lQ9d2/ha2qVjR
	 WzIHt5n9eNyOa47gvJTtF4N9Uxx1h/M1z+Wl5ECRreM0Lclt2V81wkuXg93cfWr/YM
	 K3I9vWmEZoUZIegszRy+gvXawgBqVhI/ZpTFjw8sYRqW0ODf9QoHixb3rBRXzM47UC
	 Wu9eDovqQt6oOX+zpPTU9wLj5s44jJmcZM8znMbSNFdINASDaWGtC2JPk2zwQlOImz
	 CJS1VGNAZshBA06Ik+qKYRYNmMoSu+7ngSd/CkkOqNZQiJBG3FzJhAn9xjY5R5S30I
	 jINo0ND8LwKzw==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id B96CDBD894
	for <linux-rdma@vger.kernel.org>; Sun,  6 Sep 2026 09:17:26 +0000 (UTC)
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
Subject: [recipe build #4086229] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178868624666.411062.12555120205492502421.launchpad@juju-98d295-prod-launchpad-51>
Date: Sun, 06 Sep 2026 09:17:26 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="b0097495a28d09c3303dbd078ca616792464b9f2"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: c69f26aa6da130bd9548c28bb4e204cd5bf5f920

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 2 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4086229/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-032

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4086229
Your team Linux RDMA is the requester of the build.

