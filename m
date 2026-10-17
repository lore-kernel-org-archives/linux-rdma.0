Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0629636AB54
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 01:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792200499; cv=none; b=s996FruiZb3tXhYFaVm/XXcAWCQbbNgkaHTZkXX7nOhiK5EivVMkJUhMUBeZxnx3RLwoIU27yHyz8Sm9DejAzbgop7GX1DV4LxR9Fyq8bbGKlUZ7dL6gE6mmHbor64bAYDg5aVvKZw5OKRL036XVSatU6emypkmG9L0R/CLFDtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792200499; c=relaxed/simple;
	bh=0mjkyYEUngwHjfAHjSum0/O69y/J1Lrer/CIfPsTUJo=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=QAzk7C3bJKU1Kau3w8av+yoYiYUjz3yxii90DHmwuPGAJIZZLJeTbB0Ufx8AHmKBbKL6oMg9bVVOV6cyDOv/wnwr3YinjwI/ff0HZYhsMX5fM50CV4q9u0PwHpoCuIa1Sbre61/gJyZ/E47Ttlv57tlfxY8ZxHHA7NVfyWie1F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=fwA9+DGq; arc=none smtp.client-ip=185.125.188.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="fwA9+DGq"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id B1E9C3F46F
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 01:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1792200494;
	bh=0mjkyYEUngwHjfAHjSum0/O69y/J1Lrer/CIfPsTUJo=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=fwA9+DGqCGAAFswhVrWY3bVUvT61bVSOXic6O60bwD2e9a4RQTHb+OTkc0IScJLxi
	 9Qdp9fWLmUiI1B8WtNnj+IJKKJkv/vYqnK1pZjTDRyowikR/GkKNAKkH0/YnOazkoP
	 iyoQvF8BrZdcHjO6bV8iUb137FHjYwwP5zNsAEGIG7k7VwOZRL512eva4YlEblGQ8i
	 z9zuuVCdV0UYpTTElsAAbNXToOBao+oVZjr32YdMdeq4EjZ3Uzvq2abHO79l2fDlbi
	 AB0NtfKqnIPWz7NzTRqPnhitgKQtNnEMSNL+68kdzZkEZANHi8OZF8qoCv3kwKdee1
	 lXxD+XWaqHYcA==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 92CA0BDA4D
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 01:28:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
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
Subject: [Build #33851039] armhf build of rdma-core 66.0~202610162254+gitb63b7bfe5~ubuntu18.04.1 in ubuntu bionic RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179220049454.2506948.9877095033694280307.launchpad@juju-98d295-prod-launchpad-51>
Date: Sat, 17 Oct 2026 01:28:14 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="f26fb3ece56641d26593dddafecfb57e59f1d938"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: aa68712d71e089e4ca59ef3c59fdada172cca9f8


 * Source Package: rdma-core
 * Version: 66.0~202610162254+gitb63b7bfe5~ubuntu18.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 7 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33851039/+files/buildlog_ubuntu-bionic-armhf.rdma-core_66.0~202=
610162254+gitb63b7bfe5~ubuntu18.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-020
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 66.0~202610162254+gitb63b7bfe5~ubuntu18.04.1 in ub=
untu bionic RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
851039

You are receiving this email because you created this version of this
package.

