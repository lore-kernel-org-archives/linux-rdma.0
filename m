Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792787157;
	b=XJFHqSmGTFRmG33A7H3/ZQHuhwgAKUlsrKbaDrQA2W+VMB6VbD7sAhO0roELfHcNQmYR
	 SpXRX6ZIxTBIkvTtw8P02pDyN0fsZ265HIwiyMWTcT35XeYGaUyPvI0eQ08Ulp7Q3MKZx
	 6mXNB2p/AMnTaqBpW9ZE+2AjPPXdG6HGusJN8pr9ha8u/zIheyxH8IAZI74VKuzT/npPo
	 YwnPmjIkFAKYUzdapu6SMg3jL1I6W3Kv00AJ2pNXtOMRszRYQ45xKZgpzgQ+C93nP+2u8
	 fsbmWjBtLKJnQI7lKFUPRA+Xh75jiMQbd//+UIWZcNLT5Jn8rdDe4MsZT5Rq1W4yrOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792787157;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=GzISC/85s3B2fOOSh1kPe9JamkYWw0WpHwXulm+Lcyg=;
	b=nPX1t+Ct6GEH78CYZhaKmUJC+WAe0X6NqayGQ7Wtw48noKIhHg+81mIYllW+2mNhhjtq
	 IU17EUNv66a48ZsiYnlinyh34s2p9qtCletzEQLlJSzjaV7adrXnVM7SUerZmX6pifJfU
	 6Y3dRNW7eFOT/q1fAz/RE6OAxqdo3UrcP/H06hSiYQwp0VAPq9XJrW9h8FtmWxJqlbVjE
	 MzStbTtKwfHkLZVKyA5VULEETr7VJ5Tg9GGRqVY30TSHBqw0299Xaq+9VAg4LAtbfmlTn
	 xFzznrnUg0bmGC+qZTqflz+X8ANIhZXQyfXZLHbDl9Kj5CssuKZa3F+WINWrBQo6y+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=A1roqKe5;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2D4606A31B
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 20:25:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A2D4606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=A1roqKe5
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 770C53F48A
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 20:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1792787154;
	bh=GzISC/85s3B2fOOSh1kPe9JamkYWw0WpHwXulm+Lcyg=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=A1roqKe5UnKdp8BWeoBK3ywCdtTJdHjNL8HlRP5EmDkgbVdwScfwA7/SvHWgYwdxw
	 CLABa1v9BOtE+E1DM9gPOOV1D5v8NNB1AsOUy9c85NhPG2+2InpLBCs5Cguj2Vl+Ds
	 97ApScWW07hTKwXPE54PnmboohCNvF8oWOBAWI2vJZkUHCPM5qCA1kbpy1NyUC+B+N
	 B9jAPEXrhv0AL1EESHRkVno7BizOYwPh+0F3LmNarQVVmn1Cyx2okWJYAIB3ckh4zq
	 fKSZyBnuswQ9IWuRPYm0gyPswyHjwu/XbhBfFZXCuuJe2ChXOoS6aVcvdppSMqV5+2
	 OtdPWf66tHsPQ==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 432CDBD8BB
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 20:25:54 +0000 (UTC)
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
Subject: [Build #33867986] armhf build of rdma-core 66.0~202610231640+git8009440e9~ubuntu18.04.1 in ubuntu bionic RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179278715409.1684904.1383919666626839754.launchpad@juju-98d295-prod-launchpad-51>
Date: Fri, 23 Oct 2026 20:25:54 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="8aad169d2e22e99bfd86998a2cf0f0a07502f5e7"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: f15a87703b03caa1f007a2a0c32342ced4e1d85d


 * Source Package: rdma-core
 * Version: 66.0~202610231640+git8009440e9~ubuntu18.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 18 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33867986/+files/buildlog_ubuntu-bionic-armhf.rdma-core_66.0~202=
610231640+git8009440e9~ubuntu18.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-034
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 66.0~202610231640+git8009440e9~ubuntu18.04.1 in ub=
untu bionic RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
867986

You are receiving this email because you created this version of this
package.

