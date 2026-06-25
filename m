Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7560305691
	for <linux-rdma@vger.kernel.org>; Thu, 25 Jun 2026 19:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782416214; cv=none; b=OPra8EFFuq+VtbjlfQJfb9tnVFKPdoazsHghKaCc2WAmrHLrmz7yULQpCDsqg+byarzH7G0R76oRNDlSwuHqrdPqOtmDhp4ym5p77Bc32N+mgBIxi0bf6NPxQwsvj1mPpwVnvclLgqxRqqn8xvCip3siL6u5wRFQS6LtS971mdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782416214; c=relaxed/simple;
	bh=lrrF6+9X2t7/IcDpSRadFcUMuZfktZkllMwV5jd/DWg=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=S4ukECEbhLzKftWSHtdT6q4RXUxVqE15ek0e34zx0UGXgSkH8N0Q6AqLDl+8Idyv1O88+1FNVxO4gy6Ugaiy5T0zqEHmJquGkFWuMzFowUBJn6I04TtGHHUxmn5K4rE5qWuUPF8J7/OLjtOUkkkvmRCKBEQFptBF7U6T9wC/tHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=ANX/tkSU; arc=none smtp.client-ip=185.125.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="ANX/tkSU"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 878343F353
	for <linux-rdma@vger.kernel.org>; Thu, 25 Jun 2026 19:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1782415797;
	bh=lrrF6+9X2t7/IcDpSRadFcUMuZfktZkllMwV5jd/DWg=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=ANX/tkSUSoFPUKhV6d8dsn93Wqm/Q+CpCD+q+V2FU4ovZcAGtcbBEIrsUQzES/8s5
	 oMRNVPYUhtLgdFOocKp3x2wPDwf8mLsR8oheJuUa/ZbBhYNtZTk08MKuU1uFTKGOui
	 gsAdAaX7lsnjctrU13Y2Y+aTqyikTSiwuW9yEIPD/OkR7wZNs2UNb2KzZ9tIKovxWg
	 vlCA+ahA3x1yOgYPrdDz7RgKYqSIkxhQVsDI0d8pz6NZkBQTINVCDdky0ymRbasL2p
	 m3gjXl3U/hPPyUf+MUVcOJvpgxclocgubz9n7fT4FaMZgWh1LYGfZzVNv3NvnCwc+t
	 FTeX8Lm0a0A8w==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 48B2EBD3E2
	for <linux-rdma@vger.kernel.org>; Thu, 25 Jun 2026 19:29:57 +0000 (UTC)
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
Subject: [recipe build #4057524] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178241579682.3391778.5711490982567689134.launchpad@juju-98d295-prod-launchpad-51>
Date: Thu, 25 Jun 2026 19:29:57 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="c38ea58da9d7185c4996adfc854ab433551cdcdd"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 1f65c4f4f701e1d572568ba225cd3389d100431b

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 12 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4057524/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-011

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4057524
Your team Linux RDMA is the requester of the build.

