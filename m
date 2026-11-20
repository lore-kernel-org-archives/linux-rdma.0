Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173441;
	b=2yCjFz6sTubuOESaj3FvXIIittO4kZA6yfXFtGBKmjhMnrqpKSvQyHVGXFK4KnZkPecy
	 CMToUVbUeG97mOZdWpGFaRxQz0e3tJozAZxJjWRIVSxcdhYP6R/+wQAFYqXjXcN22MgvN
	 UOVpOyW5qNbQiWYfck+Q+apJAl753EwAIRy03os12UTxoRwaJwlZYe5JhC3UHjb250Uv6
	 v/U4Wm5Fb1PGt2DfTEoTTL3VyMruc+z0sp6xKRN4Ih+Soc9hwdUTM7sa4iFiijM+MZ2Co
	 cTScuMbvHxJWI2LzNm7KlGrn8lUlnRy8IUD4t0FL+G2VPiHfUyuFTp5lX/SZkPi48fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173441;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=A1lcgVzzp+pytrpt9Jk76UcIqoQWHaex/t1ymOrPbeo=;
	b=ZPe15MtWbUsQcJfYMv03CA1EeOehphvE9KZLqJO2ebgfrL+D2GHfvmtupgA5qUcTGre3
	 7v22KDkUoAgmj2zcPq3Drr8FdkMpcCo0UmpXFNclfGMqlEm6yhJB4Q1wDBJlSKbaVjoxm
	 DBWM3LugRdlyQbK2wszRo2IZtYEcKahlApbAMJbLHiy9IZzC1Dyhz5tamfZ3KVEH3gH2F
	 3PSkL8LjWdfs27AlnyU1wT4EwghNuH0YLS+tWxWMdarysZpcnHqvMeh7XI68Oo1mc6b5u
	 WUexZaCIm6hw4Lxm3wB+oxoD7Kg4HY3DOup5HQQ7anopjcm7AwPEddeeEcwIqa2EEwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=awlTvYNz;
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A8B606A326
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 11:17:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34A8B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=awlTvYNz
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 7CF0B3F1B1
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 11:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1795173439;
	bh=A1lcgVzzp+pytrpt9Jk76UcIqoQWHaex/t1ymOrPbeo=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=awlTvYNzZvCtP9tbt949+dTUBO4Yw8s3hm2acrFoA6oWRk9zgBGqpQHsef1adH24R
	 X8Su7ND3wcbnWxsUElRJ2X7+6AB3S6bJ8i0j+z0M9MMIHz9IXl4mivO024/kZZ9Art
	 3pE+ssDWetDcXTLBtBg3jVhSdixeVRghqBWC5k55ZJFWqlr6CjItF4jzPJ8jpTgcW4
	 rn7oddU/nWF530+qhdiSMDeK29SydbIBQPbV4/44TLW1IY1CN5dd+OcQu6N2Bc6GeO
	 NxugCUuENI1WOvX+uiKeC02c2sXMwS4aL0EWGaemae6T7skrGj7deHdhHJLVVb0vWO
	 KW+QWfUPIVgEQ==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 20FCFBDA54
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 11:17:19 +0000 (UTC)
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
Subject: [Build #33995959] armhf build of rdma-core 67.0~202611192021+gitf3081095a~ubuntu18.04.1 in ubuntu bionic RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179517343907.3108509.8535229015611819554.launchpad@juju-98d295-prod-launchpad-51>
Date: Fri, 20 Nov 2026 11:17:19 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="5893e20085ddb97aea2534e1b2a802438957dea5"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: f5390bde4c126c9bf926a9221ee3ecfba6d8d7e6


 * Source Package: rdma-core
 * Version: 67.0~202611192021+gitf3081095a~ubuntu18.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 9 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33995959/+files/buildlog_ubuntu-bionic-armhf.rdma-core_67.0~202=
611192021+gitf3081095a~ubuntu18.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-117
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 67.0~202611192021+gitf3081095a~ubuntu18.04.1 in ub=
untu bionic RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
995959

You are receiving this email because you created this version of this
package.

