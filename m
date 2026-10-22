Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792702098;
	b=LhbF2M1HJi9tVSu71BzDEgSt4CvtQzQGYGCxoPa0f9WTX2zsB75oe6i11rYPLRVzVlTi
	 yF0RM9MU3q/7Nr/3w8+JgC7ZiALtryQXrdIyuOwXA/EyhNfJCkLJBRECZMST+dJ61jgKv
	 MyzfOomlgkS0/cVBwogDMGwTfCifjdi/VhB3pkZ7bfHaXwICREGQpscnIjjo33TljkV7m
	 Uyh2kTzZ9fqZgwguVGHd/A2Q1YqUEhV+5WkUY5YU8vQ3qTEr7Sw2SDIwHuSbw8Uaf4A8T
	 zs8Y5+Pj/G/5dnlYdDYDXA5Z84C7F/1j70A1Bl7wI+zXEpCrrVMfaruEEtPIqCui0RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792702098;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=uOtEyq63UmwuJy1XHctskTSIPOVw/pQMceTCvQUbu+w=;
	b=YHgYrKyBlAgcFvtfUzbHe1cI4MFeOKreO2+brT2ZjDH+qsCC9SdzsJyWSeMhC/v6B2Q9
	 /l3KeAlrSbwjMGmiQAb7GdNOOUwZz19kZ6jlAZTYEMk08V2aXY+IWrwtAG1DKRE4PyOts
	 98gbYxbayC5n/QX4NjomEjudf2wLMACEMauC/9IvKR133Ft2p6gk8uPutVwyFI4mKvVbc
	 N+jSMRFD4q8uOoylPy2j0eFOyecNBOmA08H+V6yMQ2DVwuKduszyMnglBJasjjpaHtPfd
	 jPoZGhj+TF0KVAxGbpig/ChgfHLBqQqvRxVd21bboQuyUhBA6dxfSG6XgrlkSxCp2ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=SIVc3Ayq;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7481E606A31E
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 20:48:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7481E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=SIVc3Ayq
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 198D33F142
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 20:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1792702090;
	bh=uOtEyq63UmwuJy1XHctskTSIPOVw/pQMceTCvQUbu+w=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=SIVc3AyqL0bKD31WY/gzJDxh4YtBh18tfM7r0OocETAxVcjZSnmGBoEdeD3iPRJWG
	 nZIpixGFXIydNkK/xA5qm6x7nVMAwteHtBQFbzOI/lJMKreTNB2gOoODazuNbiZXQC
	 PNs2T8daxZFTnCp9qRY5MIDws6beudFEILLgTy9S0fkFsjZXOZZDhdxHtmWhPP5Ro8
	 44zDF5s63A/GOchnDth9+DPjh/wTvmXsYO9GyEGTExbdznD0UbtUy9CoOsX2PNG7+4
	 Y+Amxct0Psl6NzrHlojn36n/TrrSfSzcwsXx7rxfDRe3oUJrYA8AbPswkzLrx3hNhO
	 O8ZBh5jzSWSAw==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id BF3FCBDA1D
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 20:48:09 +0000 (UTC)
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
Subject: [Build #33865391] armhf build of rdma-core 66.0~202610221835+git144dc70bd~ubuntu18.04.1 in ubuntu bionic RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179270208956.558687.18395845626259209433.launchpad@juju-98d295-prod-launchpad-51>
Date: Thu, 22 Oct 2026 20:48:09 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="56f1eb70c27d2139772ead22665134d9e7db3f2e"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: bde77c7f0985670e6e3c7a426558b9db2ead20f8


 * Source Package: rdma-core
 * Version: 66.0~202610221835+git144dc70bd~ubuntu18.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 8 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33865391/+files/buildlog_ubuntu-bionic-armhf.rdma-core_66.0~202=
610221835+git144dc70bd~ubuntu18.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-034
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 66.0~202610221835+git144dc70bd~ubuntu18.04.1 in ub=
untu bionic RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
865391

You are receiving this email because you created this version of this
package.

