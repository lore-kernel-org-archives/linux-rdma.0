Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794261983;
	b=Lz/6bCe+4MgUHQ9ggR5lUURZoXJnDqIXpF46kealpieGtoOC2m7Q5LPQ8yiuGc2mGmt6
	 nINZwjzem5EPufKQlJekNkLRojOwig9UML9r4KZu9euGiPuDd5vglzfyZytBIo+OSbu4v
	 /oazbrU0ejSeXkW+8nLo88BFXm7vyr60iqAFgoadNzIXuqSExHRJEGVRojbFvS8WUOsjE
	 o00f58qp4NWYHeXHbm0V57OXKlxPZAvXhhS0Rv2WO7N9GeFjfe/jMv0QxfFGuGJH1Bv4C
	 ZAEw2l3ZKXKjccDzp70EuNUKP6zNcX+hOYZqsbQjjHnqLG0KE5Du4nLy0o9YsHUyQGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794261983;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=Eay4G8sYeiJZmbj3CO5Xwlbe9GingexdCq2RqzXh/Uk=;
	b=iCkD4zQjuPK+g0aMJAl90OeRVNy5B+eldJIWRDq1h8ifKCZlesAgie0Z5n7truqoGhJL
	 +uNU1FLzqqrQtMFHoztbSQGIppSTlVW6B5MD5/irqWyepcEUBEkjFTardlI2ThLMeNOk8
	 RyTUMf56aQ3OchQ+emjPbpzcdycCFJdLCCIYVZK1kkASQhFYRKvzg7unJI+mVm8vnKj3z
	 8A7MzpGP9XwTzuJ8JIClblfBN1w8C8cn4eHUYiXyJXnsAZqpJhHT9ZFGZqwr1zTeKi4NH
	 Kc0vQpl1x+B7anqjLUb2uenVAgWyc9eFyREm87HCkf9KjhgSRnmSVTWV9io+JNkiILQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=F6KYaDAm;
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695BE606A31C
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 22:06:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 695BE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=F6KYaDAm
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id CFF914253A
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 22:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1794261974;
	bh=Eay4G8sYeiJZmbj3CO5Xwlbe9GingexdCq2RqzXh/Uk=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=F6KYaDAmW5L87CbWI/WKu5h9FboLWCDO7wzOi1YYPySkFqU1UFSsTrMUZTBK30/Ya
	 V4D8nJAVSIMnLmA0PUAtqR1ZPU0cSv+qoOZ+BOL7usuBrOtVr9pVMFyCmw2xSXh6PZ
	 3ts8eKwZpePh95uYzV6XI/Dsu1vkj5hKnljAkPNPZ97/8miBpOzDk+fjLFm8qQYd1a
	 OeQrf56mfrFKvfbP/AGUAWYIi92u7Si2pzVshDc1JB1e5D4VIVT5TItWhlDyMzpL1U
	 DT6HbcIVZX6UYdIcQxuj1yr5J6qr0ptu0sOC2Jps3AhB1FDdOh0vlryUSz/66u/czQ
	 DzojW2MIzmdkQ==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 8E9BACCFCC
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 22:06:14 +0000 (UTC)
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
Subject: [Build #33952664] armhf build of rdma-core 67.0~202611091236+git67aa0a10d~ubuntu20.04.1 in ubuntu focal RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179426197435.3544717.12719947109505936386.launchpad@juju-98d295-prod-launchpad-51>
Date: Mon, 09 Nov 2026 22:06:14 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="c0a367959c9c9b09a1b30cc94b3d52c142eaa123"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: bb7f04867597f29aaeddf913f13b9ca9679c3906


 * Source Package: rdma-core
 * Version: 67.0~202611091236+git67aa0a10d~ubuntu20.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 14 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33952664/+files/buildlog_ubuntu-focal-armhf.rdma-core_67.0~2026=
11091236+git67aa0a10d~ubuntu20.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-111
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 67.0~202611091236+git67aa0a10d~ubuntu20.04.1 in ub=
untu focal RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
952664

You are receiving this email because you created this version of this
package.

