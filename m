Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173435;
	b=iRE4xyXMOp4DKBs2yYFX/LzI1ilRUCB/w6jJB0Fq2dAzyVrjB9pjXgkYkaSaW5XOuQl8
	 VsHdI+58eDLJ5ZI7UH6caIdImLxlpQ7Er2tv3sKMsplgDBWgkS3LWPYQvKPyIYWFgR8F6
	 +vLRibVpdZ8RspUQCh9O6ss8OXYoKyCrZjH49Gd8cZUDj66z2FMK031yxY5ZriRK4hxrh
	 p43BJ8wfQDZP9quM2PH+NMh+RGQlyK6r+cBA+OSwr1A9/flvneiWL5Kq/BxQyGlzz4HAP
	 KyfxRyQvv+k3Wt/mMcD2i/ObP8tw86MRow9VvKbBlioy2YmVKBdwMjok9WLA9iLAwEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173435;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=f10ltoBYERcmKBX3FpQMdrFhzDdwKSbklj5cmsK+raE=;
	b=YYcBZJXy+nYZYe5HUaZlLrwSYKF9W7c6ZaQ6ar6G1i5FaFJL1o7FKXeQUoMJE3htl3+x
	 chb+8oWuR8lZu/lE73HwMfdPoFwZOqCSyBEG/ujnjznuuiVCPC7zLCxVwy12Tb/7fKnXO
	 taSL457X6MX2u6A/BEvH9/MXi+xkB65cpb2Jq9yHRPIeSBdqzSCkQLhzbtrijm7EZbjdn
	 p35mJxM9mJbStSGClhGxjyNo7an/XtUmznvdMjKM6cmMecl03k2qpJmFwXZgxJ2JkMsVT
	 V1KeVyFfHJ66LU6fW5ewll85rvk0tykRSkd9X8D0UOhBPJ1vJ7TWEt2lO6BN4LawSiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=wfpD0WYn;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4C1606A325
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 11:17:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F4C1606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=wfpD0WYn
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id BC47742AEF
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 11:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1795173426;
	bh=f10ltoBYERcmKBX3FpQMdrFhzDdwKSbklj5cmsK+raE=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=wfpD0WYnY/Fb5obPGjAQg/3kUt6Z0dla8N4mbVa91AR5r4PODReqVPgmS1uALeC1a
	 SBlJmj3SWcemJ5sobWZh/2Nt6DJuXQJUryPlEofUgAqbiiloQj83clAVSx8hCU0ks9
	 rRv4aP+GgDJ+kKhiDQ38CYrQGvMywILsbVtdH9iS3wGooiln81AW29Jvt+WhUeATia
	 SAM/JHRUh8GLjKsFwy+VvQ9xONj37GO454o08BX7QfZV2V+4U0c+jRmBUYLmobWuU5
	 V1WZ4h7BmP8dWPJ++u5mJQVWb52owDhBo8ZRYgWS/6gNMt6E72WRzxWU/2bJyuREaR
	 ZO+lDWe82xz5w==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id ABD98BDA54
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 11:17:06 +0000 (UTC)
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
Subject: [Build #33995965] armhf build of rdma-core 67.0~202611192021+gitf3081095a~ubuntu20.04.1 in ubuntu focal RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179517342666.3108509.9720120016624631676.launchpad@juju-98d295-prod-launchpad-51>
Date: Fri, 20 Nov 2026 11:17:06 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="5893e20085ddb97aea2534e1b2a802438957dea5"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: a67703bc89c9009a1f9f4909d546a82098a3d3b3


 * Source Package: rdma-core
 * Version: 67.0~202611192021+gitf3081095a~ubuntu20.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 8 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33995965/+files/buildlog_ubuntu-focal-armhf.rdma-core_67.0~2026=
11192021+gitf3081095a~ubuntu20.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-018
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 67.0~202611192021+gitf3081095a~ubuntu20.04.1 in ub=
untu focal RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
995965

You are receiving this email because you created this version of this
package.

