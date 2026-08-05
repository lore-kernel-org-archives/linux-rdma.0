Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435C9306486
	for <linux-rdma@vger.kernel.org>; Wed,  5 Aug 2026 09:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785922931; cv=none; b=NSCKvqiYxEsmiN9kCNRSpH1wGTRDzt/texsyKj0gHC8jhhYyhLvn5tqMZOcRDWMEzIx5JGpaeSajeAZ8o0u7B/XCT33GYpjFE64fMeSM212YImprGXN2w2xR3q450K3nE++eGKQBVon2Vk8En67KwPIHRJLzx8RRTEqYpA8pfDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785922931; c=relaxed/simple;
	bh=dFhWw0DCx1fKmtZ9R3Pf5hmR/Ln338J6AHVsGz9crCs=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=Cd3pbItNrXdLiJMMy+y1ghQ4UNY0XHFc9qRp9FSFkslGIWIBLVQ9k4yH0dDqvYNKLUcCLk5bD6fEU3BZ4oHuaofBI8g6MBRFxDmOI9BnvN82DjY2FvK/IiCKfyWjkQMZQZaCxpfArTtUCmba/BM5YLY0PK0AWux1AXL/kS126rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=Upqxgun/; arc=none smtp.client-ip=185.125.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="Upqxgun/"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 420313F16D
	for <linux-rdma@vger.kernel.org>; Wed,  5 Aug 2026 09:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1785922387;
	bh=dFhWw0DCx1fKmtZ9R3Pf5hmR/Ln338J6AHVsGz9crCs=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=Upqxgun/UPUWMS4w4Pz5kFD9Sg0aWioK6BLgPa1NBthCwyssRG5cS0o92t1z5DAVf
	 bvEoUVy+E9YMwkuKEXYZ6JflVmxOT5WtKSUi9lEWAcwuz4MGelMtUBhYz9b7TGLuqc
	 rMgepRUo5cLALwQikN8qGRDSJNuVrVpLg6tquzI0BcU0dXwc2AEBDRxglicDu6qc9G
	 ArxnIp6duRmcg6IO9j7Iol4fEa8vzvegkpszoHsrG+tjMlCO9QTd+Z1nluVTBQXmqr
	 MJiROUKNl5WcE+c3JHP6/B9R1HL77EyN6XCpRll5Gs4uX0W40Sqd67O6yUgg6f4ycA
	 uJ9sb8SInTexA==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 24499BD3E0
	for <linux-rdma@vger.kernel.org>; Wed,  5 Aug 2026 09:33:07 +0000 (UTC)
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
Subject: [recipe build #4073779] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178592238705.1455614.13328718569967291021.launchpad@juju-98d295-prod-launchpad-51>
Date: Wed, 05 Aug 2026 09:33:07 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="b042f2deb3ecfaa583e2ab7763b0e6f8b706ff27"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 58c7e5fbf5b79acf93edbfce9cde52fab89d7675

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 3 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4073779/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-032

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4073779
Your team Linux RDMA is the requester of the build.

