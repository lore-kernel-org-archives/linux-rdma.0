Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2883D393DC7
	for <linux-rdma@vger.kernel.org>; Mon, 20 Apr 2026 18:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776709166; cv=none; b=br8eSL9f+haDtmPMOgUHzwDqPtPjEtc6YpfPxhG8H0mIxoVzWsWwymm5iZkwG7csgc0SJM67v7r6lbRqGWZ+9JJqEbWUmPiCVMDaJ5h79sqF52YvF1rBrhkG6yEngIcaXKEKygrvpwj6g4mNb4pqdpOJprY/e75zMRuNbdS3Bdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776709166; c=relaxed/simple;
	bh=p/Y7o2Q2FKEjSZ79li/D4RoBweiEPYzp5K+mq/e05qo=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=CJbc2yULKhfAvDfOge7k1yc3zm+ts4XfxJWgA0rzccxolFjuszk+804TX/41rqAo59jgeP1XlHyrt/HSFX4gzBRdwxAd19LtXzX/M/1bOsXTQY+GANr2KpByW7IS6KJbI3qv1Ldt69Wj26BdZnOHE4C3My+5eEu5MhLcBAkdl6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=FRFOXORl; arc=none smtp.client-ip=185.125.188.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="FRFOXORl"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id B2F9E3F486
	for <linux-rdma@vger.kernel.org>; Mon, 20 Apr 2026 18:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1776709155;
	bh=p/Y7o2Q2FKEjSZ79li/D4RoBweiEPYzp5K+mq/e05qo=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=FRFOXORl5D9/lmILyw1PnSEAJNRCWkksq8R5LCWt2Q/3VrEUeuW9nF6qahfQRgzpa
	 mUrzR4F8H+vbZByb7MC1Te3NYQ6MN916QoBaEGMyBEDtKadbaIWkY8pNl4vaQd+gDC
	 gYN4K8ZwJHMOfv3ERITmrxcvDHxw5Sg/4XVPs+njsmyMrCUqn4nS6fq+TNzRtImBov
	 WipdkDVLahdoqhpKlAGZ+MH3mOReNXVq5u2awrPljf9iPTHmuczR+uDvF3t4x8EidG
	 2n52+V374cvP2p0S7AnAIV6f2Ym6VPooIexy2JmpgqtfEtEMK3i9pc1pVEsOWYxzLN
	 qhBRx6fNpivFw==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 56FF1C10DF
	for <linux-rdma@vger.kernel.org>; Mon, 20 Apr 2026 18:19:15 +0000 (UTC)
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
Subject: [recipe build #4032262] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <177670915528.3282238.12112214181827895590.launchpad@juju-98d295-prod-launchpad-51>
Date: Mon, 20 Apr 2026 18:19:15 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="866d07beecca8ac2e3326342adf6c1740cd3e7b3"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: b159dd72b21aa3d57c920e742ca5c5139414b2ee

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 3 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4032262/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-040

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4032262
Your team Linux RDMA is the requester of the build.

