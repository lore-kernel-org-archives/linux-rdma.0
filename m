Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55F836C0AB
	for <linux-rdma@vger.kernel.org>; Tue,  4 Aug 2026 09:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785836647; cv=none; b=Lr4t56ZBnpW5iikoMxswpZtXCjf358cP1i/ELC9CI1CDEa1ggBUQAA86Ne+JuDyowNXc1bPDAZnK6RPrtOzVmFvfFg0S7V3/IAxW5ruwjgzHsue1I37b9rnwPRR/QRmaD9Vih3LIKNw+NspIleKlerO961GGmY23Mlr0W57eSsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785836647; c=relaxed/simple;
	bh=1TohxuSFstBLPQPHJ0UT8NuluWLQXWDyzYfC8dnf83A=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=gkShEM77XsHn41YZgQcfaF66cOZ6Ejht3mu6rEmQvjDK40NxLzdq/xuyG0cKc8WyInsrY8YnXfp2vn1Lcrp8/ioQiZPO9dIKmQEr3kFgRjtHTyzEXcaPiq+MwPDinpulDwXkdxX7+NEMUjc4HX1kc2eBjR6cyIZLEOdrt0n5xKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=k/6jVyhW; arc=none smtp.client-ip=185.125.188.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="k/6jVyhW"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 5A78F3F186
	for <linux-rdma@vger.kernel.org>; Tue,  4 Aug 2026 09:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1785836276;
	bh=1TohxuSFstBLPQPHJ0UT8NuluWLQXWDyzYfC8dnf83A=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=k/6jVyhWa/7uZV1wwVk60oP1FHZ1jTFhvzhheQaPeNXJNVnUGU4szCwLm1zRHyLBl
	 d7940+WQUqvJf36mHbCA4IB2s/QJX4+MLOQoz8o9QX/PP4TwBqYELn41SjvdsIDd4r
	 nfshHk4pC1eyw85DfF4JsxcqStLUtA8mt4s61+CztMRA192FV/C4AkWJUs7cH9Xwzg
	 bK0apGGfE14xqJEx0A7bDYZ3YlqD3XvmAltwaXTWSND9uCoaw7OhuFxwgD2Qrtpdvs
	 Y/TFXGJhM8nPaJ/lUnTiVPNWfOL0TQW4GGEe02q6kxxDW57wFsRybK2oGttn+tKvh+
	 5vsWueDUDgXsw==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 43493BD3E0
	for <linux-rdma@vger.kernel.org>; Tue,  4 Aug 2026 09:37:56 +0000 (UTC)
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
Subject: [recipe build #4073409] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178583627625.1455614.9859013875452734222.launchpad@juju-98d295-prod-launchpad-51>
Date: Tue, 04 Aug 2026 09:37:56 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="b042f2deb3ecfaa583e2ab7763b0e6f8b706ff27"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 1e84697f8b65ad1d2876fb9a087f4f630e1bff55

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 7 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4073409/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-072

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4073409
Your team Linux RDMA is the requester of the build.

