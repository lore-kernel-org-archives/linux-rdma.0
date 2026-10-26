Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792980931;
	b=Xqlepl3yTZzvI7kwD7EODKdDZX6F3SmzZsVyY6CDfOPJgM+OnWFd1ut8xqbmPw2vWv5H
	 hddw8tNiZl23wYdC4Y0UQISrcUoPBygHSAQfVyklRdvsT58VXrBqzn0k0RlYFvMQPJC/W
	 6cI6SJGhD6lXgzI/cwSgkK8hXpdk8uhbGpyzS73Dg+7iSj75DZShpoRHuZSxTNmBGKSmw
	 A2ssLwqS237ZcPyl/H7TTPmGD0jHcOMLJftF42WLOO50w3gLnbirQk7XRKWpgvpbtgihy
	 MdN57hwXri80U4+jsiN+43kGLkZttlX0EaNTlXo9wlkPBykum51Sz5mucwrkrkKlA7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792980931;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=lnJRPDtvPi3uJeEIKmJ35hDJ2n1RlteMThLokNzJezU=;
	b=1+qlWUghm6er/Vntpl+gXMnaig7eDjUw2HUfa/B0f3roXmtWCum2Ye/eIligFCw2JVd/
	 maDzBSy3lGa7yo30WXz0nDJLfxI06S3BHndYSfjAZe/UeXDItJxlFETYbmGWIYwW5kedu
	 xzyBtWmRPaaKDXlc1uHhJSFv2FDap5hNy/kPlbR05LNcYHjZotljzYoMs5Xc0DO6teLd8
	 vEex4xl3qwNRyyw3w5nHRCryQGlnIt9OkfN4C5voLWpSNj0KPLBXQiq8qN14xgYNbB5IU
	 koEVMCSW9x7JBwqTQff6dxwp5a/xE04K+93q2NVUCC5K4BMS8VEvfkZlb8ZVA7XPlwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=WzytnxI7;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAF3606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 02:15:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0CAF3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=WzytnxI7
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 3C2893F0E1
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 02:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1792980929;
	bh=lnJRPDtvPi3uJeEIKmJ35hDJ2n1RlteMThLokNzJezU=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=WzytnxI7PHVKvYxz6bl/DtxdYCiVIxrz8fF7P1v3bOKsJnE9sKzm5UpnoFjtypeua
	 5uXnELdoOK8dEH3836txv/c5vovTxVvjV2XKj6fHJy89ks3PK+O0nvFEOWfmk7syKo
	 Xkt66xmKmNSmwpJH/YyaHljWPgjex5MfX6jo8XaicR2AYLff5h+aOBhvEIo5xh8JLZ
	 gd4q6EQ4x6xISqyQRHodJbqrBCoAU+LfnBvRRGJKQh77jxmrm+NCVT2csp0IOo9PmX
	 cbGKmAWS1exgQiBJsAryoGh5PFefzzBqoENGQh4F15Fj6R8NK4ZdJcIQXV9ThELZUn
	 3Ji3p8IlYRIng==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 22CACBD8BB
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 02:15:29 +0000 (UTC)
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
Subject: [Build #33873167] armhf build of rdma-core 66.0~202610252240+git07ce3f50f~ubuntu18.04.1 in ubuntu bionic RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179298092906.1684904.3582445678006507083.launchpad@juju-98d295-prod-launchpad-51>
Date: Mon, 26 Oct 2026 02:15:29 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="8aad169d2e22e99bfd86998a2cf0f0a07502f5e7"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: c2529fb5e623e029bf13d65657c3618211213865


 * Source Package: rdma-core
 * Version: 66.0~202610252240+git07ce3f50f~ubuntu18.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 7 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33873167/+files/buildlog_ubuntu-bionic-armhf.rdma-core_66.0~202=
610252240+git07ce3f50f~ubuntu18.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-117
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 66.0~202610252240+git07ce3f50f~ubuntu18.04.1 in ub=
untu bionic RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
873167

You are receiving this email because you created this version of this
package.

