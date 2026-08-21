Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4DE396B76
	for <linux-rdma@vger.kernel.org>; Fri, 21 Aug 2026 07:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787297066; cv=none; b=pA3Gm8OPNHd7wWP37TWVNGw4OHl+4Hl9/OPcb13a//aZITxX60qmlQ1S75nGFhcLEQbq+kohDPZn9WFRO8BrQES/r0w+EklvipQ7BvJHxUEbHxvDs6eazxIwuP2TjuBNmhJY6PFT7fiGJXWyY+ulKDQ4Z9H2UQ9cByqNGoGI54U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787297066; c=relaxed/simple;
	bh=PgOtu4zlkumYABAgej0G94tJhnRkZ3GRbGGz+Dz/Xyk=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=huXfKb7WFmt9WVOeTq2VF4VRj93OKP3F87iUFlN6lNBVr9enBQrSNHT9hvmnkZDOOSQvRwHIeC768z6qzNNx4hVttoppJHbRO7Tf606MAIuaVaACnDjIQVcuELEgJ0kstwOFbdjgWQcOM9nXePpMyHetSpWDf0i7W00jBVPO8lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=D2G1SldT; arc=none smtp.client-ip=185.125.188.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="D2G1SldT"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id E154C3F28A
	for <linux-rdma@vger.kernel.org>; Fri, 21 Aug 2026 07:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1787296738;
	bh=PgOtu4zlkumYABAgej0G94tJhnRkZ3GRbGGz+Dz/Xyk=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=D2G1SldTlw2TEzqt1F8YcigxoLU8nRxp9m+TdF1uUES3vYPpWvg5hrkTVuorcIPoB
	 RwGKt8nqkT6XAXnkAwjeDUADo4wd21mPvZuXVEBfzpNKQa6fRvGe5JZoY3ZbzB2BO9
	 QsW/BxSKA0RwNXp7fokAC3c76pcmqht4NSyA2wWBCFp88Az2VaNvNC7BvyGOLDYxEf
	 pk2oIvmfJDpSLyYNV8iNJ2mszFgSe4o176d6mAkVFqXSkQo1UmDwbIFLnhrx6flEdi
	 ZXdTc/5YAOPmZn6pGKXhyI+h11sEhpOpd9tpFDWrWQSy5Ht1NBtLksR8tZD4Ve7QhZ
	 MbGrYToVYnSsA==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id B9EFFBD894
	for <linux-rdma@vger.kernel.org>; Fri, 21 Aug 2026 07:18:58 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Launchpad-Message-Rationale: Requester @linux-rdma
X-Launchpad-Message-For: linux-rdma
X-Launchpad-Notification-Type: recipe-build-status
X-Launchpad-Archive: ~linux-rdma/ubuntu/rdma-core-daily
X-Launchpad-Build-State: MANUALDEPWAIT
To: Linux RDMA <linux-rdma@vger.kernel.org>
From: noreply@launchpad.net
Subject: [recipe build #4079504] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178729673868.3849686.7302530361652977623.launchpad@juju-98d295-prod-launchpad-51>
Date: Fri, 21 Aug 2026 07:18:58 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="31c197e5e79ab0f4ab5cdf39f7fb1bdd55aff62f"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: bb4545bf7fed483929a283788e26f580f902633d

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 12 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4079504/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-015

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4079504
Your team Linux RDMA is the requester of the build.

