Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2DD3FFAAA
	for <linux-rdma@vger.kernel.org>; Tue,  9 Jun 2026 12:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781006658; cv=none; b=MH2fKC2dsXC9U9HeRQJ+75yncnsCNnXHIj41eTNscQt+CgUuMkhQTthCehsbDF9NhdjVl2+QXxoXSeWPj5PzNeJdUA8GNqxAJMg4hvnqlSopYckDZQYH7uRyFl1AxYxJ30ZQ/0ZynhEA7ZzPe8rL+MwZEeeQaJzbnOkNmPWc3oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781006658; c=relaxed/simple;
	bh=m+fwNac0d3eghZ2l9RLWeUSq9OY2Icj+ac7oXmrrZHU=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=b9zSujEkqha1rr9MQaH4hkuBG6hyBdLO/3OakA9YDviIJvcw2XvrsWtK0b13/M2y4txUlYAOHq+968e+O2bvWE/XawAIUF8k2IRyFH7AK1fi+9fghI20kHPwTXkLbUUgxFK40BIyMctl+6vkE354mFo38cHI624XAkSXg7aRbEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=GUa/YDz1; arc=none smtp.client-ip=185.125.188.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="GUa/YDz1"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id CE7564031F
	for <linux-rdma@vger.kernel.org>; Tue,  9 Jun 2026 12:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1781006647;
	bh=m+fwNac0d3eghZ2l9RLWeUSq9OY2Icj+ac7oXmrrZHU=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=GUa/YDz1Um4ZeFK8BrkVYNDjQQfT3CsYah+kAoggkT9FVh9nJykfHhEDkxSFmrsEI
	 ZNKORdrOuf2zyGf55XU+EcaF/WpF8s9+63s7kKs6hC9ESJrcqae+G1zjjR7w4K7Ni6
	 SzJWYxgN8tVOOd67xOWNquyeAUz48lmyDacDrahCvyIlHmlatQsV6qMGiWwKmt5Y8f
	 KuQHgbSsxOaKe1F70UUTQCmT81fch2jeOc+Gdon5tcNXJHfbP/iYe6M6o5QSvtBqE+
	 45Vwqnjvber8VZXNl08xxdKFlAleg2qrAth3IjUxWnjvT3G5nQoJL87Gf0fS7mUltI
	 5lKqnNyuqSUwQ==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 913B3C5073
	for <linux-rdma@vger.kernel.org>; Tue,  9 Jun 2026 12:04:07 +0000 (UTC)
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
Subject: [recipe build #4049948] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178100664754.3806946.881234282292865707.launchpad@juju-98d295-prod-launchpad-51>
Date: Tue, 09 Jun 2026 12:04:07 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="f85a4e13f5f1af0eb2d5aadecdf089bdd7783432"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: ad0bdcae2c888f595cc18159c215a922842b5e66

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 4 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4049948/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-054

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4049948
Your team Linux RDMA is the requester of the build.

