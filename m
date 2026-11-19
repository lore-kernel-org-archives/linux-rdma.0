Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795085505;
	b=iZZ7L6lljCpKdDKH3UyWgmdBUm+ds7zr8BrIf6Xatx/rd4dEkIhiv+KGtKN27h8R6De0
	 oSCNHOl0gt1L+V1MzVwqXraXpYs4KmbwjH2PpZ77DMA1m9/FQRM5cv2foE0bUTMjVEy0N
	 tSRQJkys+Yx3u8+uj1Oo7K1CgU3CINat8s0N/IUO5xVou/DttRs0e+U4PXYx+RGww7puE
	 StSwawNo02xk57wB+kb7PFiDrnVXOT2/Slnar99LIGSCapTP+L22b5MivHPiW2h6Nvlxu
	 Ke65fi9Yb5pdk/cvYMX4EmGql/2kPkt4zexOMqmahCy3Is5ISlNQ16TKSJ7PGXcJyPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795085505;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:To:From:Subject:
	 Message-Id:Date:Reply-To:Sender:Errors-To:Precedence:X-Generated-By:
	 X-Launchpad-Hash;
	bh=un8/K13+GctFCiTWONN7dT7uORbgJ/f8h0iD8pBoGyw=;
	b=xeT8ajxy9LvB5INj7iwFnUjhQiFV30oLyGuxOxkVkJPnpYKmwidUcoGU/7oAyrIJCMwg
	 faWYewLV9IU8V1WI5Bq58W/jDPBhxOQbj0HPlacSsFRZKtPxUIR+YwMBTWMrPciMgKjJR
	 LyPiBcn6lHGJcWruuF9TxyEmPG/Q3Vc7V9FsKt4QTK+VMlzKFTDlC1wqyW4JFSecG7qdm
	 MPoZuxkh8cWbNke7d8VZu2xEZ9/ci4c3nGocsOcbd/wfdLY7r8n58/I5Zqmd3R1wkSXvO
	 mk04lG4CuvphiSHrkIHp6WKgQ5TXgTZLDzbS8zsZ4i2RtpLTyo8+hOZJWXxA7HV9s8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b="R/mbxPap";
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EA1606A320
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 10:51:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6EA1606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=R/mbxPap
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id CA0DF3FE4F
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 10:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1795085502;
	bh=un8/K13+GctFCiTWONN7dT7uORbgJ/f8h0iD8pBoGyw=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=R/mbxPapJuLob2FheEWRdQ9EXQNmfObfbyUqsvr5MJf1vK1NaELg8HTKLNdpsw6Z4
	 /lqo49eMsAHILuJDuxTdmaS3nQpSsxKB8ETGhHSXDrf6FolKPXi/eLfj4bREdO33D3
	 FtRc3IKZZQESuwqkRKO733CFXpd3s5MhqQqV5NpZBgGQNFt6hf5PLJ3z1KVXhU4rfx
	 ZENcmJ1VD7br06m6cYt2A4FkVebax2i+/uQ0KdSts+8zUNspFGF7GPss5egysfiqh+
	 Lz1b3v8IWkBLYSivogEODaMhdXiJ1mlcQdLyZFtPkj/H2aBcuGM0OzEg7VajylEADc
	 GHhIDKZIHbn6w==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id A0F43BDA54
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 10:51:42 +0000 (UTC)
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
Subject: [recipe build #4116995] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <179508550261.2685656.10725239995126981442.launchpad@juju-98d295-prod-launchpad-51>
Date: Thu, 19 Nov 2026 10:51:42 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="5893e20085ddb97aea2534e1b2a802438957dea5"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: a8c87011a958fbe7d8b7005d1c50ba8481a18482

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 6 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4116995/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-002

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4116995
Your team Linux RDMA is the requester of the build.

