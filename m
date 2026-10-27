Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793140320;
	b=H6b0SGgcRnPQAVT7hRwXRq0ZTn4RCnNjLO09z5PUfLm+FXfvyXz4xK5BSSl/uZepZm2a
	 xsImnHgRoaCvi+r+8D+4Jnfop9WQyaiZsyU5UJS8M13n/pSHRh8SNCuBLPOFJWMW2Ninl
	 G4RFJPPMDjkp+T/EsQ6ZQldw8ozFkTs6JFKaMBLEpIF1gYUoOj/rHivfaHeNdsz2qi7Vr
	 LvxL0Z4WUaDwMtOXqDI+8mbLm48g6V+8FrBpxZXRy0B8hOrMnCxdDfFiv2LfBZSrDzEO6
	 XWghPHpW0HC+sGxY5wNYE3/HazthTj8+OtQBjhMvRgJ2OLoY3B7EkeycYzVhYvimBIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793140320;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:To:From:Subject:
	 Message-Id:Date:Reply-To:Sender:Errors-To:Precedence:X-Generated-By:
	 X-Launchpad-Hash;
	bh=nzQfoRQE2FOmC8zOOTOkBdTPg2FVCtkNGh3aF2mPiok=;
	b=GYxHp4yjSrvZ/g9X/6nhtqsWfI948jwZiG/o55TwRw3itR+6pvENlDMfUF5QPyj/HyjG
	 G8fQC2RQ5iFpI1cIkr9fQaEY9Xhekz6Xau0vcXHNIhrCv4L9UtBEV+IXJXLDth0B5LKSt
	 xkEurfKMxGW2/EEi7I7PD3rOUc+qlF9jdvs+9QV64jR4CbVhv8nYfiNrq5IisAoFRFrAw
	 xzeoD+lGD4qYWFcYXW4TRgQZGH4QAzSfgwift50YWALHYKiQuWXqFpP5fKlGwtECMEzHe
	 L8rJ+/otXGKLG89mAdRF3TL3gMvuV3HgCLxjTQDMh6e+2QGoPsWigiJKMZ5GzQESe6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89362606A322
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 22:31:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89362606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id E1A323F297
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 22:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1793140306;
	bh=nzQfoRQE2FOmC8zOOTOkBdTPg2FVCtkNGh3aF2mPiok=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=iBvlOwxlgLwmKuXYauPnHQiUiyjRNBCFBhdJ3XKHKmuftMtnCM5wybLCHTwgu4o8P
	 LVwJrfKh5vVKGeyTTeEjp9+z3uSJ77YbPEVoSyEsfQH2x0sea9mpmCCoswsW7I4NpT
	 uEkvE3Jc0Laxt7WTubpQ6zIyc7BgB4Ok3j+vnk9UllqxSySbGpyPzJjkTkA3ImpETk
	 bJS/tEOaYEfWYe6DcsCsx9zCsIjQ7QznwuxdeZNETkstWKNp23IOSX7T21xK8bSTrx
	 j9KQyWUbVSSEV7VK4hMrtZcSAGRdX3RC0mJgU9pr6NE95fJCHd3ESN8VZXUu8TC8Ma
	 uitMDRpwfnT/Q==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 96D34BD8BB
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 22:31:46 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Launchpad-Message-Rationale: Requester @linux-rdma
X-Launchpad-Message-For: linux-rdma
X-Launchpad-Notification-Type: recipe-build-status
X-Launchpad-Archive: ~linux-rdma/ubuntu/rdma-core-daily
X-Launchpad-Build-State: MANUALDEPWAIT
To: Linux RDMA <linux-rdma@vger.kernel.org>
From: noreply@launchpad.net
Subject: [recipe build #4106686] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <179314030652.3317829.11411729596324997053.launchpad@juju-98d295-prod-launchpad-51>
Date: Tue, 27 Oct 2026 22:31:46 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="8aad169d2e22e99bfd86998a2cf0f0a07502f5e7"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: d1b810dad3f118369d7a8104b3e3fc68277ee1b7

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 3 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4106686/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-016

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4106686
Your team Linux RDMA is the requester of the build.

