Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792591384;
	b=a3E8q6n+C6IN4FE4mlPbWZ8oURX7ftJN6jyh4BNyraWIBbtG6nQcd8uczIdMJplAdjFX
	 +l/XO1Myr+Uy1xzjBN6i+uTJNGP67XrSgoXBWnDsvp3th4edYIoA2Z7ya4W+CYUE/to1F
	 SFU65ISG+49knzOhY4ddYCfMAgT1rNFMFotczrad4P6UcnYH3VQxZkMZFy+RJf/wCS9ux
	 BeJ/mmrH3E6K4cLPn5OhIuuoNUbAD2egwexMdODfCzZRL25WY3SJv54iXiCQqH7KdrZkq
	 zneZQ2jef/7jJNRfUmUrpvkuzGC+Q0FRz3YAbvxp+wb0Ja3VY1UdsF87XdvnXDa/2Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792591384;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:To:From:Subject:
	 Message-Id:Date:Reply-To:Sender:Errors-To:Precedence:X-Generated-By:
	 X-Launchpad-Hash;
	bh=o9OEW75pzQcxAaB8JKey/fELQ4dCoxaftZl/aLELm6g=;
	b=DbGELZ8eQDxcz1A6HN+Fa62M+4B2QkYBjrXhEF41SLuTMVcfddSzoAal85UGN7CO3AP4
	 CqzIeZTVl4whMwtJoxf5Q1wH5aKnhaW0i07VfqMW+6I0oskFTTryuaYBh8ovBS90g6CS9
	 MEzOuSTnc+kpot3O9m4r+0y9/9hghc/ziXoX5HfjJHY7qhBi+Mszi1iENwg6RS+sw5ZI3
	 JIjU9qAFmq4swmlBRTAeDNAL6uIjvSQ8kRKaBf/Ea2josms+DVsYu0vbaSyKQGzk1iq+M
	 rv7PXJ0i1iZec29Db+hes77ztrFbToU0jizOk+0d1VbiOPwSGLOLqJCM9bNyLDtPJ2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=roMXuqb4;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA14C606A319
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 14:03:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AA14C606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=roMXuqb4
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 8636F3F0AA
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 14:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1792591375;
	bh=o9OEW75pzQcxAaB8JKey/fELQ4dCoxaftZl/aLELm6g=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=roMXuqb4GVpInDOopP8VVKvfpXcKf2UkxQXxuj4Koe8bcObHh4tesiTx1wTLJ9LaB
	 bADJy1S32gwN73doz/pOBD5T+6VSBl1ZJOvRFtni1fpkLvbGoHOw5rvsoxF5mTqGU7
	 6B03yir3wnOh4S1Kt9FJbwfCNBSYR+ANxtUXDbofMFW+aYzRa5oTvhEpI8VgOEXFjd
	 DESIhU9ykLNuGQ6/32C79fQWAmkX0wXc/3GxNgyS69szjzzTNwKca8r19REffD/jWj
	 aVSi7jiP7lThqmLgcQvRaY9OiGAPjRuxTdzQoXYq0uY2oPo/TOi/2/GMrfP64ZsH07
	 8xHM7DiYk/4EQ==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id D17D2BDA1E
	for <linux-rdma@vger.kernel.org>; Wed, 21 Oct 2026 14:02:54 +0000 (UTC)
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
Subject: [recipe build #4104217] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <179259137468.558687.8223144138537938346.launchpad@juju-98d295-prod-launchpad-51>
Date: Wed, 21 Oct 2026 14:02:54 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="56f1eb70c27d2139772ead22665134d9e7db3f2e"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 75405ded46a66846f7077eec846f06ccf2125221

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 3 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4104217/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-119

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4104217
Your team Linux RDMA is the requester of the build.

