Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2B239E6FF
	for <linux-rdma@vger.kernel.org>; Thu, 15 Jan 2026 14:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768485959; cv=none; b=jT5k2FQCXZLCvfVmzlhIzyWG0BFJVTHLWOat8gjDDHtyQQtaQgLRYoDmtyO9o9aN28t9/4F/+iObPqd26IfLg0tVWFg0vTYFT1Dl5b4bnh4I2L8e2NThTr/Wv96+3sGhOmeLJ4HI7f2LAS1rNi4d59ocLt2W/sGCGn6tNWfbEIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768485959; c=relaxed/simple;
	bh=LQHTzElf+XPRhD5xkMo2Znps3/HT1S8nLjOJQxPt4Xc=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=PdD2zWuYloglyh3U7JqQnSh//k+as5szDu1HhCnWZHZ1RWR/LD3YiiYvosHbBpiSnqKRiBW86hXUFMpzngp5oo/zujpjgbmeT/ISz13gqfzo1x/V5dv9rtg02eYhdcfS2VPkOq9XmcoTxu5hs9t9R5hWpT7h+R1n9cmOcsIgb6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=p9ySkJ7b; arc=none smtp.client-ip=185.125.188.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="p9ySkJ7b"
Received: from buildd-manager.lp.internal (buildd-manager.lp.internal [10.131.215.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 116D741269
	for <linux-rdma@vger.kernel.org>; Thu, 15 Jan 2026 14:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1768485955;
	bh=LQHTzElf+XPRhD5xkMo2Znps3/HT1S8nLjOJQxPt4Xc=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=p9ySkJ7b1L+nWg+OcSRJnP3CSt+WWGxcQAwN2Cd7nQoi4vxD4Kip1447eqZz1Wh6C
	 gItjfnupZAduqozCUriiR2SxoddnrT9D3Mk8XKVqK/Xxb3U86QzWM8eAnXIZRUhaNF
	 /6xq3TMI9m5hqakMS0mC1elJ1GjKUo7wJqsX70m8a7zp1Bt2EKuP48ufseHmtkYWRZ
	 m13wPzz/ifqz4JA8lL/+h7xT6Y8kMSwLojRM6VAOZxxE9EXR2ujDaQYeuWt4naU4n0
	 fOELc5Sr151CHuZb94Z3unZ7IR4VvXaQdNuShUq8eLDqM++vWnC9tvgtkurdiKduCP
	 PyAVGhFZEuMDA==
Received: from buildd-manager.lp.internal (localhost [127.0.0.1])
	by buildd-manager.lp.internal (Postfix) with ESMTP id 01EDE7E851
	for <linux-rdma@vger.kernel.org>; Thu, 15 Jan 2026 14:05:55 +0000 (UTC)
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
Subject: [recipe build #3998501] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <176848595499.3160048.12227321041187536843.launchpad@buildd-manager.lp.internal>
Date: Thu, 15 Jan 2026 14:05:55 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="9fcfff1971229ac997140f06b41a902ac8ec69f4"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 5c470b028571d09bbd2853cb3166ac5bce88f28d

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 5 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/3998501/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-039

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/3998501
Your team Linux RDMA is the requester of the build.

