Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793155802;
	b=XBF8UrgVR794h9XPstswS7nAJg7u1mrFHr0+qeC2aNJcS50ec9W+0dBPLF2zxukwmN/c
	 MWnL+9VeWHKfsEfAl5Zotfgy/o6cmtqfCO9jak/e1E9g0AWMSYszQ2KyrR+YEaa/ktQOD
	 Y252euXTtGs1dste1PCBsCwaXyaDzuxXdQ6Xg/3Ye/o07rcoy0p9G93YisFnRD052jvDk
	 ONfqkb0PC8NKZESlnH7Gv8FHgLJMm6xSVDLHnryphxXlNZucZybtkU5FIrjKQYegvuctb
	 w80TWTSt226O5zGS7S+9trPs007gTWSuntslY9zR1zM0QsyzKhVkIiSskSEnhsy7ajg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793155802;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=srhan35HzVs5ZqVFLS6k25kjy1tE373JubHrLUzJj6A=;
	b=ifuPEMwZ8C3dkK4kFaYneuNoRkZsb+Uu5bECUesESNU47gApKhkGG9YxWd4pHHZopDm0
	 5hcqnGtW77jBcbdC8Pul2ly6A8WH8szV8TL8r+7HQvqPk0qZ/buAyjugDHVebKeWHyyh2
	 S39A8X6hBTEyz0ir4PQe+ATlCc0tJxJ27fBIlQ7IVT3HrOyAlflOH5pftkiDg5wzA8Eiv
	 O3fbtN3pFVRUip8YOJx/r6rIbK/SSje+wNzVPmr5TOXw2J39mrZu0IARNGZlR0ac7ON7i
	 lxv/ChdWxzl7BVqNy44GMcSAVaoDYeqG+M8PCG2yZPws1cnVjkGWlPGsmwY/yUeF6jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b="ia/yAmZk";
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B69606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 02:50:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02B69606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=ia/yAmZk
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 08ECD3F071
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 02:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1793155800;
	bh=srhan35HzVs5ZqVFLS6k25kjy1tE373JubHrLUzJj6A=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=ia/yAmZknMZLoZ4IfTwKMKl5WnxclnPc6/fa7tRfD2XDmLq4x7vpWwwoRyAIe0cBr
	 zT+DWtNCjneGqk2nrw6kBvI/WwmkbpRJwa6HlVqgqYVNQwuZJf4ilL/uXGRp8hV48k
	 UvdxvR+uGz/iFHAVPMvMd1R8Cni73dGnU7pWsjrZyAysUIm7rZqOeVvJOMaMW/jtiE
	 q12hBT+MwGw9xTlZVjWaz0hKPob4jCPTiRPPPdSZ2/j7K6I/Lm+pZd8VHeaUYRQFwG
	 jfAEruJVxvROv9G7Y6uIDlaqXOrdHzQ2nwaCoHadyjem9DhmFr4W2tGlO4lKJGR3nB
	 6ebeExgPZ+JMQ==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id D99D5BD8BB
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 02:49:59 +0000 (UTC)
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
Subject: [Build #33879542] armhf build of rdma-core 66.0~202610271821+gitc56edf7ca~ubuntu18.04.1 in ubuntu bionic RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179315579987.3317829.11146385660137488253.launchpad@juju-98d295-prod-launchpad-51>
Date: Wed, 28 Oct 2026 02:49:59 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="8aad169d2e22e99bfd86998a2cf0f0a07502f5e7"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: feabca989d41361b5a23ae8592b407221238d125


 * Source Package: rdma-core
 * Version: 66.0~202610271821+gitc56edf7ca~ubuntu18.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 5 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33879542/+files/buildlog_ubuntu-bionic-armhf.rdma-core_66.0~202=
610271821+gitc56edf7ca~ubuntu18.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-047
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 66.0~202610271821+gitc56edf7ca~ubuntu18.04.1 in ub=
untu bionic RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
879542

You are receiving this email because you created this version of this
package.

