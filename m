Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794912595;
	b=v4e0gIrKNbcxbWgKKUqi7voosrq85WwhsvftR8ducvZudKWPxNry+R71L72nvoQojWfL
	 HM3VE91Tu9mjKq1zV+f88izSNv5ATnn/PmvkZ3wOeIbgiuJM0JiBrdMpa81gyVc5kzBR8
	 TF82MJQ6mYFUJ4KvAeMFid+vhPNAU758aHulUfJ1K+BJtBW9eBZgq3gIfwwpCUi8ZA17n
	 vs/9BCur0d45lwSGn9CMVRSMNDqifvFDrn3bnr4MISGQjnuJ23CnyndaEc4sNlrZTlW6H
	 2RR9w5m5d9l22L0L15dNYyYSWslhzb3KWArybM1cGUPLlRUpmhe/C544AYrRZSiJdCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794912595;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:To:From:Subject:
	 Message-Id:Date:Reply-To:Sender:Errors-To:Precedence:X-Generated-By:
	 X-Launchpad-Hash;
	bh=yE4MzUcR159ThKpV2UDmKAavn1bJVfJHCfxY8YPgGiA=;
	b=b00H3u72UCrIi+gN39qEYKyMHjUEbvWicsC8YfE04XGy+p7oU+hHi+xxInr0wGZ48mXP
	 Hte8wlFKTk0LFQszFRBogpmGXRsTu7CNohvbw3+Z5gJ09J9prCE1ktg1NPQoW4T8DPnKo
	 5eElBzvkO9QRgtDOmatD/BMpbtOFINx7jPFARkOEk7Hh4p3oTbZqi+pnYAQIF6aS6ErDi
	 BZ+4d6+nC8ytUEEAbTwtuiua5hXVTJpXye8ifcC9r9qVsSD6u77/DRYNAbT3JW2e+TQXV
	 GnRYwL2A1pgIpOo30lXWsmYiEZsWlBl4IlrhcPxU+Drwj12DCYQGN8eO7zIJ9Vv4M1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b="X+jTRTU/";
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812E0606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 10:49:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 812E0606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=X+jTRTU/
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id D6DA83F9D1
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 10:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1794912586;
	bh=yE4MzUcR159ThKpV2UDmKAavn1bJVfJHCfxY8YPgGiA=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=X+jTRTU/nlfmrsvKilIWVAFUBmrC4a21n9GCA41FL5LtGZaakPdmZFaqUUUwVYVmo
	 Yy9sTxfHRDQeBUS8eCaX8cnlpxChRwZBNaaJQKeg+vLR4deoxBEIk5JNBQWVfHMLn+
	 XK5tpaqQM0xLh2c0dYz78v1gLclTY0NtWcv3ee5hOtr/5qKu6OmSdM+gcv9PLmWmB5
	 ZdRqhISHUFzjFDZs84zT6hUL/59iCOoJy5l8zAZ/GLMO3PupLD60wh3o9SkMFoIehF
	 fr5GwRD5NR+pomP4KsERG+3hHP4aXwWSch9GBaxvB4VOM7abW/DHR/+aCd++yf8Si6
	 SB4KL7/Wi2ZqA==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id EDF79BDD85
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 10:49:45 +0000 (UTC)
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
X-Launchpad-Message-Rationale: Requester @linux-rdma
X-Launchpad-Message-For: linux-rdma
X-Launchpad-Notification-Type: recipe-build-status
X-Launchpad-Archive: ~linux-rdma/ubuntu/rdma-core-daily
X-Launchpad-Build-State: MANUALDEPWAIT
To: Linux RDMA <linux-rdma@vger.kernel.org>
From: noreply@launchpad.net
Subject: [recipe build #4115895] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <179491258544.3474504.18350364157868120290.launchpad@juju-98d295-prod-launchpad-51>
Date: Tue, 17 Nov 2026 10:49:45 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="72ba15af7e009b17d4aa1467977127ac8392a4de"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 053bb0c8a3d1fed0fd8de02d2e4bc7fa097c433d

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 4 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4115895/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-011

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4115895
Your team Linux RDMA is the requester of the build.

