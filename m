Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795089180;
	b=pu2mKJUP8NPeToWxNZKQJkPzQ5CFZVX6zv47rSbh7cAZ2x47WyAaqyh5MIyl5U+EHi87
	 KBnZ7C3GUvgik5Pb9xDZWG4IiXHMuBMEpK47iG2/yF2fcA3CG0Zwbjvw7RMNLd/GZ5W5I
	 oMHZuPiqrnWNTuzn73bDUK6pc1I6GRK5mt4GJkvatohHUZwMyC0pJYxjAoopRg69CfOFD
	 dztPHA/lTezYy696dRbSQjST75pNwUg7lmiiqZ0GyXk87D1R8O8Qut1d4V7SJwAppMDOx
	 ct3T80yDyhiO8qAEJmNhCqXz3B+89k7p+N/oJkcEHtsNhZxS4XvUit6K++7OX/x42vA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795089180;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:
	 X-Launchpad-Build-Component:X-Launchpad-Build-Arch:
	 X-Creator-Recipient:X-Launchpad-PPA:To:From:Subject:Message-Id:Date:
	 Reply-To:Sender:Errors-To:Precedence:X-Generated-By:X-Launchpad-Hash;
	bh=N8vX1GFqVkKNPsA7th7XWzCkgO/VhIRmC/jwj53rpyU=;
	b=bq7Sv8j15G0vKC9LbmoStBeUrZwnULZ+AKmdiu+lG/ntKEki6lkdh2JRhWf9+HKwlEwd
	 sAkVrIX1fK724xKdsZj9KXaVN8t5y7038VWIzMYPec2XkTrBlj+Y4dyRM7qt5veg0lrER
	 KwNpsXy12OnhU3veH6LdwKbRuraBp+zm5cOGBYT9be2/vKrXqGbtfm0/bcjSh5DKMIvmn
	 O5eYLlOIbdl3snCNTyiG4+1J6pLDhMnzWLyQCug0KBB40lQOTnm7XPTwwd/PtGDdsNxtk
	 IV8YIP6rXSamBQGGkiQ3sNSekjWpEanbLqKN4B/eIvmq421vbwxjk9kG/Ysv4g1hDRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=L8g8qEZy;
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BA7606A320
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 11:52:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68BA7606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=L8g8qEZy
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 8E8BA3FEA7
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 11:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1795089172;
	bh=N8vX1GFqVkKNPsA7th7XWzCkgO/VhIRmC/jwj53rpyU=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=L8g8qEZyA/bj5rNxSyf+7p+XrFP1X07f8PCbQ/48L3ODW5/NT0qPsn1BmFbWIotM2
	 ZPTmkFViGYGB4TL2P/CeLZZm798NuzpgEpdjoAI55JRR6hxzsc/CZWf4MZaXD7A6Tl
	 YkI6NRKUjN8pvF3kP3fxhlaHMFGR+rK5c8GisJP2TivCx0yROgOHv4BKoAYiUdIc1b
	 m8saarooSsaJ/q7q5lIpZYbLIg18fhVSjBKiQZYwGCWHoBXONKW5uNu3+jaRIqXorL
	 3lkHVG7YwAZYkUOXbASJSanq/mFEmiyM5jTXMkgk+juqog6c5cBSKoHsjRXYfcvCZm
	 Vd5GfSeCOCd4A==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 76712BDA54
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 11:52:52 +0000 (UTC)
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
Subject: [Build #33988602] armhf build of rdma-core 67.0~202611190905+git601e47cf0~ubuntu18.04.1 in ubuntu bionic RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179508917244.2685656.18258235957999064153.launchpad@juju-98d295-prod-launchpad-51>
Date: Thu, 19 Nov 2026 11:52:52 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="5893e20085ddb97aea2534e1b2a802438957dea5"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 141a5d64f97231fd755fe17e277c3518468850b0


 * Source Package: rdma-core
 * Version: 67.0~202611190905+git601e47cf0~ubuntu18.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 7 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33988602/+files/buildlog_ubuntu-bionic-armhf.rdma-core_67.0~202=
611190905+git601e47cf0~ubuntu18.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-074
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 67.0~202611190905+git601e47cf0~ubuntu18.04.1 in ub=
untu bionic RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
988602

You are receiving this email because you created this version of this
package.

