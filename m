Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794262088;
	b=X7j7YcDY8ZJWLwpktcF5SF8lkAJQyqrISpuNGQXiEghNnd5YfJzB2cysTTNBTHkmnCEr
	 8/yIyFZYB7Nn8qU8Ow/ub2bRRUu6x0uwkHK655UXTWSQ0qoVxxGIIr32WWFkJpX4B6hoa
	 ueDahU0IRGN7XwyOxtM7w0S0c8OgIm7k268LSnpRk0divRdeWIOhlYNY6gfVxhW/VuJ8S
	 GMgTfDiGY695cBWe/pAMAQOpUt+pIy/PGIz2cl7AyczbRwO+J4blnGYKHTbp8Lu+ykt+e
	 /0+noFsK+X4Vso4ROriSFVAxOIQI2W7dZwcFKUiKxkay9W51DzEYNHs6xBD6IewAC8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794262088;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=z0MQw8N0a3IaPjL1jNBaKBgkbxpU9q6XKT5ogJolUFg=;
	b=p2Og2elzTpsmpVUUX0uyR1X6St4b951VbCCWkaCGjD18/3v6NBY6W5MtYCRzO+YxcXr1
	 4jYm6tQQmun56xPE6niJmgnWO+ughmfVBobKyFycPPQEepDQp99pZhauD5mum7DHBdBRr
	 G2cOPiY0uFJaD4nKkNZmnQKePcxyg8xdih6l3qVhmv7uJgt3upp7aeRVLCkihXc01ieNV
	 Q8z197NHWce0ZJQjfq0oL7I6+ClbbXo6fjGo11CSpYO7YNkFA6Hcrl7EIohvXeM7JNpgG
	 dB6BlIRs29Gxf1JYJ8yp2EQEBEjaYxJqcUygArUg07wTWkp8KWAgiIdmAY3vRzjRFAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=YFn62orQ;
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8041606A31C
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 22:08:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8041606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=YFn62orQ
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 0191E4253A
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 22:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1794262086;
	bh=z0MQw8N0a3IaPjL1jNBaKBgkbxpU9q6XKT5ogJolUFg=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=YFn62orQMsMShAPpP5KxxLAbNpM3N4wUx260GVQPxEloUdCDjw48ID/wLW7DqV71w
	 AwX8tOEB3VilHygnMwOx8rcn60Hf5/CXdon33UD4AodiiqciInR5gOfFpiOIWkBxXL
	 j9c7AY8XU/ebX2w/8igDp7vPwxPUzKcNimVhFanqJpU0FCkQQ2w0VXWwQB8r5Ya8Oj
	 p6VjqCT/LtBXrlHrieN1usVIPlYPk20hFahQN9EJcKU8mWXghSNLn8odmrpXKQc5CP
	 Ay6SySk4XbZI8owFJ+b+ivqizwAhu2bnEZnHRaMjWya/S5WhroPeQCF/dNSHLDRsZk
	 S/taWPAmpGeFA==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 92078C2B6F
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 22:08:05 +0000 (UTC)
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
Subject: [Build #33952670] armhf build of rdma-core 67.0~202611091236+git67aa0a10d~ubuntu18.04.1 in ubuntu bionic RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179426208528.3544717.6059309399959116611.launchpad@juju-98d295-prod-launchpad-51>
Date: Mon, 09 Nov 2026 22:08:05 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="c0a367959c9c9b09a1b30cc94b3d52c142eaa123"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 6b62e36390bcc9e23447c6b42fd4ed4256e49258


 * Source Package: rdma-core
 * Version: 67.0~202611091236+git67aa0a10d~ubuntu18.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 16 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33952670/+files/buildlog_ubuntu-bionic-armhf.rdma-core_67.0~202=
611091236+git67aa0a10d~ubuntu18.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-104
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 67.0~202611091236+git67aa0a10d~ubuntu18.04.1 in ub=
untu bionic RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
952670

You are receiving this email because you created this version of this
package.

