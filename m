Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575494;
	b=oQskA97u2FT26Md8OmhuO93TEv+OoSmzjghiqFwBdxREy6hEWDZTMqOxYzA9qlL+xhAy
	 RNkZxiFfAJhKLzAppx5QC0B3qWVKE28hGFaNru7K8uSzvP6j7OMBkX6DG0rQ3yNsy1nS0
	 xAsQs3cJhncg1Lxe05lr8SOA9CZcq9GphMEqnjF0CXe92JVP/pCZmymFT+GwSXicth+Ef
	 HPAJ+SuOT8T3eAHD4CMmSvaM0SmQYqkFG1d/Gmf2zWf7qSlT2H1/pWmlxY7RzICyflobj
	 TQhctvzETIt7wE7GpBpAVS/MSySb1u3gEHwk0MpDXIelx3rnqmfGBwU0LTjs3NSTtKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575494;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=rb3BQUuG9UAzR7SuXkySVikCPBWFpbaeK5eaVbvBaKA=;
	b=xY04Hq8Z/cGtz/MQGSdZtHAcr41xnp7rnZqX29jsWqL5kkWlA2v22TrmImrygLWPmGqc
	 G1rliDDSKalVeO/mO+V5hRDxO0sk1D7KuVUcPKcUY+fuiDtg23Gk6/qYyS2xtIWOz4cSa
	 La2RORJrassEHsWN/y6kOSXOGVrnHFtlpdlDIgrhoQO9diY23GROC2gu+kbuLiVdwIgAI
	 6Uib7eKgZBG0SnjL/tdq6LWa0t0Sz//wxvDcvEGYbJl32NqiiCOpX1h0zRIZVK/Tu87Xq
	 NkHUN2Vvp5sYSCeiSl5YdFKUIaGhJESjCBiRxFs4PqEAjtoFSb8twx7Q8pYwJIU8tCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b="cX2/2QWS";
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AC0606A8A0
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 13:11:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54AC0606A8A0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=cX2/2QWS
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id B43DE3F151
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 13:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1794575492;
	bh=rb3BQUuG9UAzR7SuXkySVikCPBWFpbaeK5eaVbvBaKA=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=cX2/2QWSiDfBLrPv2ufWm8bEHg1KBwmYMyQcrjpSWmXOjfNWxxJlLMiRlr0D4N9ho
	 aVvl/O9cZUFdhY4pWJhTBzFP3jPFDl2IFG99f3lt4m9p5gbMNbG5VLdbc1IcKTS0fJ
	 5eCXIAKqseGt0cNtS9cpfMLGONzfD5wSEFwS2CpeTXMWlN3hIwic97VTw9R8jKwBNQ
	 GPrUN70X8hUqqpRb9eTn0CX6BqoezIhMJiORihK0gh2Zji5lE7xFFqOdzXZRurEiOA
	 +qnX9DJOZhuXBJ19cLJDYj9QYBGzLfZZXERkbHdXICj8bcf6LKgJwASbctofnMfTIc
	 zzpLBbcOCLiNA==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 91423BDA64
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 13:11:32 +0000 (UTC)
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
Subject: [Build #33966250] armhf build of rdma-core 67.0~202611121121+git997f2a6f1~ubuntu20.04.1 in ubuntu focal RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179457549246.2919559.3142602792264127661.launchpad@juju-98d295-prod-launchpad-51>
Date: Fri, 13 Nov 2026 13:11:32 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="72ba15af7e009b17d4aa1467977127ac8392a4de"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: e578397b4b4429e367eb853d1f10d6e81710bfb5


 * Source Package: rdma-core
 * Version: 67.0~202611121121+git997f2a6f1~ubuntu20.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 11 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33966250/+files/buildlog_ubuntu-focal-armhf.rdma-core_67.0~2026=
11121121+git997f2a6f1~ubuntu20.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-085
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 67.0~202611121121+git997f2a6f1~ubuntu20.04.1 in ub=
untu focal RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
966250

You are receiving this email because you created this version of this
package.

