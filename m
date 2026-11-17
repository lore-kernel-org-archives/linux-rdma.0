Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794914473;
	b=DrjcMn79sUKZAa24IRmOcEJfMZwU2E2aO5aJVAUmwwM9Vs8ZeFb8dmzkWzXqs1+gU5QA
	 jmCBENhdqO7KM8AemQ9oLajaBOdVYSJAtEaPDuRUW5T9kpCOw7CUhGx5VtGywzFVeoPaW
	 hFpXS2lBVnCvL5OyAk0WZIcDE9Sm1vPZBcsUvtWI8d5k71UEwMY7XCGiVtdOLpLDZhnMa
	 euhy8s64SoNGdeqatw4FvV//OB2DLuLOIvsM+bqmO4dfEOqLjDTJrW/I+xaUO5MZQGZjO
	 PKqL7hNwdnsHWv3CuBHJNAR8Uk26fK8dQjyZR4dCMP2pm6UpeodNnbrdODtrQlMuRcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794914473;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=hGmQwb2eMLzpOW5q//rs3cXt1NhRCWlPUDigwg478f8=;
	b=Hs/NGMJUIMkL0kNc2OxJcm4W6bhpvRdfethgmOoT9ldgkOu5VVdsddLLv9yX2MbezgB0
	 oS9bQzrzjq1rRnZ3w7RwMxD3RtvqjfhCC/Hw0aih9Qi46u8Ds21SFBLn8MepNiXeqF/0C
	 /NOQCVCzNAFp6mCBpW0yOp/mUUZ7WrFtblw7fIiutOF1s7fGRMZOgU9KzTJoA6estk4O9
	 6LVcto6lsgyy7nSCWE4tpiBFt8ipH7+JyJCIh8Mn5PfASSyw7jZ58DGTcVLyjFKp/fhf4
	 Kd8HmXTLzUyZN8hsOUGlgN5vt3aIwE3gvB0NJJ2CBRxaTTTLCG74fOGR6sTxpCiEaBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=RZvIxLoE;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEEC606A335
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 11:21:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6FEEC606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=RZvIxLoE
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 114AF4079A
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 11:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1794914472;
	bh=hGmQwb2eMLzpOW5q//rs3cXt1NhRCWlPUDigwg478f8=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=RZvIxLoEBc2RjXTHAvTup23u4bAUbIgKsjqxHhkJlzdtmciXuRcJl/NuCYDmb+sk2
	 x7pAMGITmrNWRiN75bFaE8AUh8nYUwejevF0ajicYbSIGALQeWHLHEDyMH0wrgtTOQ
	 lWFUnBgYuJUTQXtKA1drJQtcgIR6ko+xyaT4giRdbZuyLw6h7EWuJq7YgtFOqpocjv
	 fsN0x0elthuh3h2vGxq/2WmJ69HLgvQZqwITh4MhfKGwTGXbXh5vvmQQKw/HG9ipbP
	 +z8xGoQResoy549paqWZpw06HItAMzmVHLuyIgVeTUxZft0X83IXaqY5oAzjr6zWKC
	 x5XOkJFww8CBw==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id D3318BDD85
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 11:21:11 +0000 (UTC)
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
Subject: [Build #33979604] armhf build of rdma-core 67.0~202611170757+git313215c80~ubuntu20.04.1 in ubuntu focal RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179491447183.3474504.16590210939744409162.launchpad@juju-98d295-prod-launchpad-51>
Date: Tue, 17 Nov 2026 11:21:11 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="72ba15af7e009b17d4aa1467977127ac8392a4de"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: d224b8e0b9469b45c5145923c1464a1425c71191


 * Source Package: rdma-core
 * Version: 67.0~202611170757+git313215c80~ubuntu20.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 7 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33979604/+files/buildlog_ubuntu-focal-armhf.rdma-core_67.0~2026=
11170757+git313215c80~ubuntu20.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-041
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 67.0~202611170757+git313215c80~ubuntu20.04.1 in ub=
untu focal RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
979604

You are receiving this email because you created this version of this
package.

