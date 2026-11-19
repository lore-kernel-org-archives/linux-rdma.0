Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795089202;
	b=zIwa98q4JSze+hRUe7PH8CKcQVxx7S3XwwtUovFHx7QQ7GbuP4X9xWYfjptGmSYok0rV
	 MTzJveHtSRCxPpaEmiyyntwAyMOUJqh4LVTP4/5ug/47A35JdeokeLUedH6aL69inbwDv
	 aHRrps43f/eyc0oOETNPq9zK8wySE/TANlYKVi7aqHijY838c+QjhuXI2y4x4nJy74hQ9
	 O+Mgwngqc1oc44vzUj24oLOOET02iMaTRJtB5BIyAziEPyWPqIppymQmw8aOo371CnBHo
	 Kddg3BHph4h95Gc4a9CjPdE3HhTY+29HCAwGLv76CySvtdXjBNZBQ98w4SXHN3yBSHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795089202;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=K9lQVk9XlWyGyrP7yANaw+blUtCY8BQ/WbiHS3jnBHo=;
	b=UTTbYr/0+bx2ixXdiW56EL2sqdQOBjaVT15sZeXU8J/P8pjFk5YqG1N7unffxGQxvi+t
	 kTpjnO6kZQNx4XcPFtfQHjrVxQFuDDEvYklH5d6EVxEqUaZuFdq8JUHqiYsOCU2GNkSuM
	 bFllA8Y6JPVzQZEwZ8smvhRMZZCkYisbD39hhHDc9dQsPUByABMmObkjTmRqmy+Nt2hKC
	 BW51mHKAIKMuX/59t1NQK263KnrKtTHfWd/ET+xyD+IuZg0JQTq6RYkJV9OqttlXINcRM
	 RmjrPDkEWag8+o8n/eQCbkfz+e3rme3AwlAydp6PVPw5SI/chZsyB8Ut+mqMu08ZR8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b="quvT/i5p";
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0553A606A333
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 11:53:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0553A606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=quvT/i5p
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id BA42F3FEA7
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 11:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1795089200;
	bh=K9lQVk9XlWyGyrP7yANaw+blUtCY8BQ/WbiHS3jnBHo=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=quvT/i5p/MHR13fY2xURh25wwS7vtITK0HocWwwzQNwej/LVDtQruY6jr11AQnFhO
	 4WbGKbljJOh55TamzfKESyw2nNjWgL58dziJ7jG/PATM5emMdddvV/1eMtDWhx3n5M
	 NHUl5mWP05ssBXCutuR5l3VsW2c+XvAlw5YbTIEEtP0ytQ/TYG/Y6LbI9I7k/YDeAs
	 HIfSfsobXd4soeXceh+H8NlKm5YGZ7WgQajchrvNEglRAlg2XOnkgx8P1jMO9Nb3IH
	 VAYMorSFslya27Y/Xip0jS3Oq4eekNTEP1g+jnIBMKJgt4UpUxJQHpykO4EsK91xB9
	 P01wT5SIOh8pQ==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 7BD2CBDA54
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 11:53:20 +0000 (UTC)
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
X-Launchpad-Message-Rationale: Creator @linux-rdma
X-Launchpad-Message-For: linux-rdma
X-Launchpad-Notification-Type: package-build-status
X-Launchpad-Archive: ~linux-rdma/ubuntu/rdma-core-daily
X-Launchpad-Build-State: FAILEDTOBUILD
X-Launchpad-Build-Component: main
X-Launchpad-Build-Arch: armhf
X-Creator-Recipient: linux-rdma@vger.kernel.org
X-Launchpad-PPA: linux-rdma-rdma-core-daily
To: Linux RDMA <linux-rdma@vger.kernel.org>
From: Launchpad Buildd System <noreply@launchpad.net>
Subject: [Build #33988616] armhf build of rdma-core 67.0~202611190905+git601e47cf0~ubuntu20.04.1 in ubuntu focal RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179508920043.2685656.14891060503500650356.launchpad@juju-98d295-prod-launchpad-51>
Date: Thu, 19 Nov 2026 11:53:20 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="5893e20085ddb97aea2534e1b2a802438957dea5"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 927afb8b3781f60054e686b8485bc59eea8e0d93


 * Source Package: rdma-core
 * Version: 67.0~202611190905+git601e47cf0~ubuntu20.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 7 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33988616/+files/buildlog_ubuntu-focal-armhf.rdma-core_67.0~2026=
11190905+git601e47cf0~ubuntu20.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-033
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 67.0~202611190905+git601e47cf0~ubuntu20.04.1 in ub=
untu focal RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
988616

You are receiving this email because you created this version of this
package.

