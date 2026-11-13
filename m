Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575405;
	b=ELFitTe4dKsOjf/dh+IQaIVuFq+M1XHfzJgdJ4U1+r1gmzibmXQlM9+WvqHpkvKCO+w4
	 djNj7FdtilBa+23RxfddFFcPBwUwQxuWfsH+Q+cIBUQlGX/hvxGV9aqqhRuEnuC/IzNBm
	 /uSG64aiAzsUPakTEdxRh2Z88E71aXsnd/M2rT/Gj/2LPmT6Mf1oe5FmZrRluEdTNMeCH
	 HgFQV5SJHCTDxeQoh2o2ra0paRedP3MIkdC/fCHI5Uz9Y3YRCYnW5PNa4Ml8/fh4pQ08+
	 wOm7a6YHl2GMLlWPKA0XeKaaq0iZ+KpvbXaOxjBIkDqJL3SJvb4rQv6RJrtGYubFhMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575405;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=hK3sL1yQj0gNbL4oBPfv7uJoZJdxDxhPSuy0jOvcxSg=;
	b=joGy5oSd3kaz6VRgH+EwmUeMpnpoeTz9lPwfNAQiyMVIpM/uI4FZAo3qJZT3dGurGwSj
	 qEtt7HTZPepQNJe5K0tACZnJSt78m1kltCr7MpfGs08OHfjc9GUU2vdR6Xv3LFHmrDkA+
	 a6lIyZw2YRu7zK5abLLsa0bDjJnBTU4BlumyIiauMC17trPYLGfZwJ5PSr7ZY+Xw9/CuC
	 /F7WI4MD7zy8A0WtXV2HYoEhF1n3smzt4B0EnCop/SMEMCDJp+5cc/hA7eJXg1n1Gu1Zc
	 C6VwtcVDCnE4UQ2WQ2D227vwBjrf5F3pq5iOirotD035vfNFskZL9qwIRkkHOnoKldg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=hCzYrUQF;
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D497606A32D
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 13:10:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D497606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=hCzYrUQF
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 344283F151
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 13:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1794575402;
	bh=hK3sL1yQj0gNbL4oBPfv7uJoZJdxDxhPSuy0jOvcxSg=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=hCzYrUQFp11ldVXJIhfGl8EX3e5EL/osge0SugkDLUdDmLzJOg8qy30M58zcyQlZE
	 6WANKxsXUrlX9D3NvvQwzHHYqsSXkcopACpddqD2IQ/TQvUw7PZR73X2+KdGXs26Rp
	 sKCQM+0HJuARa3IE/eO5Oz0kQDDZW/Y+b49mw7WGBIaOU4Sc4mhK18oYgg335/QExF
	 zRthBok0U6YFN4E28W/V+PAn2HhccB8z3UJ5lxI5XsDIzp8t11gpuSOi6xUb+Yqh/h
	 rsqYXeXMi0EoumsiTJgtX5EyYI31c2s5D9WtJoPWqreNCH7xXobbmXAppUnYC76JZQ
	 Pe8bwwIL1Pjuw==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id BC7F7BDA64
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 13:10:01 +0000 (UTC)
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
Subject: [Build #33966243] armhf build of rdma-core 67.0~202611121121+git997f2a6f1~ubuntu18.04.1 in ubuntu bionic RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179457540166.2919559.4362172230127150719.launchpad@juju-98d295-prod-launchpad-51>
Date: Fri, 13 Nov 2026 13:10:01 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="72ba15af7e009b17d4aa1467977127ac8392a4de"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 81ce4daaef64f963b561ff3169401442872a98f9


 * Source Package: rdma-core
 * Version: 67.0~202611121121+git997f2a6f1~ubuntu18.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 12 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33966243/+files/buildlog_ubuntu-bionic-armhf.rdma-core_67.0~202=
611121121+git997f2a6f1~ubuntu18.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-037
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 67.0~202611121121+git997f2a6f1~ubuntu18.04.1 in ub=
untu bionic RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
966243

You are receiving this email because you created this version of this
package.

