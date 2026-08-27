Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F84437AA70
	for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2026 20:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787861425; cv=none; b=PNBXCieWwgmB6eBxBi/c5QXs2L7AGWy0lw2zFcxwbF9Y90fB/b0Jb4AnLzch3Cm0jf18QdAjE37RFeJ1Df1uWkQMd4Yk3wlwxYd3rYNTF/vUwLHpQzyCgKIk3B8EVZDn0JViZE9sbHBFokjEp+ZDyvKj2JVkircKKYgvNlMoOp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787861425; c=relaxed/simple;
	bh=/xrR9oath41GWRiVRl6pkFF/4YGHwAazSROuoddUg6w=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=WLc+c6z7unU6dIoqM5BmIvuMmz5pI/5I01bykPAcQHemAfdkFqdE3gp8mVqfHQTVe0Z58hwq5mnPWhonT3jOqdpLUO6sfIc2Nt6ct9DCD07f+46UujWmf75CqmdIm7qAHcKuWfCBbgTbcTjzoqOhQRvsrBTvhQqepD2z5RlHfJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=po8M8Saz; arc=none smtp.client-ip=185.125.188.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="po8M8Saz"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 0CFFF4603A
	for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2026 20:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1787861414;
	bh=/xrR9oath41GWRiVRl6pkFF/4YGHwAazSROuoddUg6w=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=po8M8Sazrzz7AUWQ399YQ56+g7vwmyLMhXNVGweYC1mN1SyGTESm5JDcPAmietaNs
	 XL1AJRc/wyfzkqYTu/DkBT3+pU2nHCbNZNlogULor8I6PH6luynkaWSENUprM2xx3B
	 r+rpZEKla0kuU3BgvSTSkeKxNQ1rPQVyuw25oicnlcIZ7NAemQhKHjmhKuI3VXT4RT
	 R2BMa0fd4znCvWRYfl4j1BfUkEFpc9T2bwumnJCMzQqIjqgzU1krWP/W0Uc3ZKJjxy
	 1rqo0dniSXfML+gatWEHJRxxdzRLj/a9yOv+RqCB5D1tg/JVMWCttbSfxrAxAqcbG8
	 aSjOZO0533F2A==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id DE14CBD894
	for <linux-rdma@vger.kernel.org>; Thu, 27 Aug 2026 20:10:13 +0000 (UTC)
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
Subject: [recipe build #4082393] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178786141385.1251807.15831511485260025992.launchpad@juju-98d295-prod-launchpad-51>
Date: Thu, 27 Aug 2026 20:10:13 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="30a649def1ae8ec0c26613e441aa3ab155268a45"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 202a24023d277934ada0c698368af6961d473b81

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 5 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4082393/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-052

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4082393
Your team Linux RDMA is the requester of the build.

