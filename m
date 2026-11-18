Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795000738;
	b=1JDHHtBBvsykV3ITgrMvOWwnHxkzMrk8XT8MiQB1B6e44wVNyko6FGHU4ePXST+B3UoG
	 9NQjNDMgZ5gAHpoQc4Jg3329T455VtqNcU2IuH6rjXDTwvX1s6LC0yxNZcUcn6hUjP1Uz
	 2s9khh0gxmFz4vTdF338uza3mDeZld2z31V3KHZwhmmgLsZfGWWKwVKz61+mBapdGjq4k
	 XGDOof2Ndnbj6WwG1RHIZKNAYkY/MIQ1ckETThFeN+kOTjE7Ago+dWXUmfeW2Pj845npQ
	 2FPHPOk3VkIuqWxAK1Kc1r6l3Wwnp/y/6dK2X6qsD4p8jRWB8PqLdcFuzA++YJ2dwTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795000738;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=A5osaARUOYOnV/5I4M5eHMXUxbmA32kR65Bdpxi+p6U=;
	b=oVTXf0ViVIJvIsomcruvpV6BoILYwzdAoniOg19xe93fOwvRoLkOuTXhLtMO0Tmj5Sg+
	 b6IU7SdnAqb2gG8Zm3uoyCTsJOFTp5b0911n5Yal4DtCJuvxu3jehRvvunMM3ONlFR9HP
	 qe6e9GxojM2iJB+TfgZYkzHdL9cIDi14mOtgB0Qov6ewnhVtbPvHtExcvseXUiWrNKubq
	 fit+2HxiUd5oMGNeedstuQ1ya0nqmQqCiiRQfxQUs9lEkKyfOYsApZJiy8bCFeqGi6Y71
	 WxiOg07EKVQm0qV8Cqi8abNCJxMaM/u8r/hIVcOcG2MGoXI2HpOyn3LYB6aviF6UqyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=HnrggPQk;
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F441606A320
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:18:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F441606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=HnrggPQk
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id A44E43F071
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1795000736;
	bh=A5osaARUOYOnV/5I4M5eHMXUxbmA32kR65Bdpxi+p6U=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=HnrggPQktc0BtmI2/rgsRCYwOjAhfcbMgU9Ft0dMXV3uMT76h8nSRbQcFGNnjwzGU
	 4GD9Dm2+ynzay3i5HczsQ2GREsmx079MB7JvCFDqX9oHiAuMXvpxYPSi8w7ujnxU+r
	 AfjLUsv/rv7PGQN8Ob4KKTXFJ82QY9re8tDRImvK89kD00+nbItgo32OujkR0B31aJ
	 80wWjHXJlCgtT2z+N/mWBFAfAdRHRop2ZnLipBCnBa2G7/gdYN0BcWlLAo/31A1tFt
	 /pP/HEab28au8hq6dgbrmDn2uzJ+/2kg/YS3fFqtweVXWPoS94UCHtwdZwpbemwK3W
	 gOeMo2JGANopQ==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 94497BD8A4
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:18:56 +0000 (UTC)
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
Subject: [Build #33984612] armhf build of rdma-core 67.0~202611171129+git0fa993138~ubuntu18.04.1 in ubuntu bionic RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179500073657.1826918.15130556157323074733.launchpad@juju-98d295-prod-launchpad-51>
Date: Wed, 18 Nov 2026 11:18:56 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="b97fa980824250ed53259e6e5dc13c2c57b8d4ec"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 46d4170f65875b9befa2251bdda796202e2ef4ad


 * Source Package: rdma-core
 * Version: 67.0~202611171129+git0fa993138~ubuntu18.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 7 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33984612/+files/buildlog_ubuntu-bionic-armhf.rdma-core_67.0~202=
611171129+git0fa993138~ubuntu18.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-022
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 67.0~202611171129+git0fa993138~ubuntu18.04.1 in ub=
untu bionic RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
984612

You are receiving this email because you created this version of this
package.

