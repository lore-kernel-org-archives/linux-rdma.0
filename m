Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792980888;
	b=LDHKFbZMTvwZk3q/uip8RniDmb8FauHuZOvjtW80ZUpeDZU0igAQWdCE4ddTTjH8fbX7
	 RJG2L/P0tKL+BNwl9ufyI8G/aI/O8txm4e9tkDhiH3bGvooBXpt4uO9KIJ28IjPHAu3ri
	 zWhc4gMAWkEEfj5lG1yPZ03TnreBtfXxGsVFBfiV1soB21GByIb8IqQDRPBIl2hf0LSpr
	 THdlms/BHMrwkfnqbr6el/I2QiRF/R7LuBcgYk51V9Uh0pUEsEhAFJOg1cHNTuCU1VGGK
	 AEYtPt8I0U81vpdTWjTTjn50tDl2esalXujyTlvJAMq1aTVKUzYhwDgmyaVKWN8e9Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792980888;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=gRp5hhkNKr+wiFYoRu6SpQ4vc8idmESAma+Cr5UxLAc=;
	b=oMViw8uUQBTkam6TIARufrOyCzJ0PMaaHtdzQFH+1031s3DOvMVT7jc3N9JYeqNdT35r
	 FlfxGyE09m/PbG/TG8om7XyrrVDqHS/jia+idd9c1yhu9zdkwnMkHxqHO56sd3WIYaszf
	 XAulTafrHLHorBMEVC/TCnha6D61ja0ZA3mMMfQzjbldxp1gvlOx8s0Js58bOT9I2rM97
	 0WLUmN6lqPmRuwOpcorptB5bVU1V51d22vYcyKabTvakGx5cb/PD3kpWPZW+r6X5Rrvb8
	 FmkgWLdgtwwl3Aef4aUCwpB8C0gJIsJJowhCyXx6pwDAJuRlpCHV6QXJoCl7UFsXGBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b="eUwLk33/";
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE66606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 02:14:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDE66606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=eUwLk33/
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 298733F42A
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 02:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1792980880;
	bh=gRp5hhkNKr+wiFYoRu6SpQ4vc8idmESAma+Cr5UxLAc=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=eUwLk33/ddKvZeUBSc43Z7gHyI57IhlOoVCJ8hzESJMR0w6hsdfKGIdhswJxRPv1t
	 3VDkae7AuCHnizCu+UYAK5sA/MS3tSW+lQ8EGvXW8woNO7LuQg170HPXjCAGBuilES
	 zOxc2/n0abn4/ECJUtU91HswbCBqvCz3B6AGYdiHJT6tjtesOh5yK8m/g026ggx5G5
	 9OwjudO95qZnh4Mwd+VRxY7QmrJE0dt4Kuy/crcbhFdaPLWgT9mnavmDozldrdRgrO
	 h2GSnDRABHZFbknlLKIu5BJmzjNKeuryDvPKq4PpOpQ+MKq4y88TKK6Uh4iHdHBWo0
	 LG+I6VJSl3hwA==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 0E942BD8BB
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 02:14:40 +0000 (UTC)
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
Subject: [Build #33873173] armhf build of rdma-core 66.0~202610252240+git07ce3f50f~ubuntu20.04.1 in ubuntu focal RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179298087995.1684904.17150429734433150605.launchpad@juju-98d295-prod-launchpad-51>
Date: Mon, 26 Oct 2026 02:14:39 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="8aad169d2e22e99bfd86998a2cf0f0a07502f5e7"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 68f2675b0c23d9cf2c871162f9cb5e354c0f3499


 * Source Package: rdma-core
 * Version: 66.0~202610252240+git07ce3f50f~ubuntu20.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 6 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33873173/+files/buildlog_ubuntu-focal-armhf.rdma-core_66.0~2026=
10252240+git07ce3f50f~ubuntu20.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-004
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 66.0~202610252240+git07ce3f50f~ubuntu20.04.1 in ub=
untu focal RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
873173

You are receiving this email because you created this version of this
package.

