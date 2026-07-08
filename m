Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA603F12C8
	for <linux-rdma@vger.kernel.org>; Wed,  8 Jul 2026 16:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783529848; cv=none; b=dEaEIm5HHSM9H0UKzKPIbnrTWlUNgo1IrBkEhN6KIyKmhFPvs0tnpHYHPv9NXx2SWDkYU+uV9+cpyotGw4M/ijZTbq+qGZ1H4LNiMrGrRSKQfhsaC5FmycSKMTMXgYCWLLx0UCjVEIE9l00UPPROecys1c4Q17jDqDtSrJhi2iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783529848; c=relaxed/simple;
	bh=fj8IsF7PLRatz28YWpAheFXHbHJNlGmH+/wjJoQ/p50=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=Cv1bDZhXwNUFIQ97KT72lKECAw7F1pcVuivY1lG0wwNzfRmSchDqR6sNCpx6v8YCMqPuI0Qo1vhvlm7jfKd/TgHkjMn9m3I+ydHTr2/LzXQZCzihKggvzThYdys46NpyirDDxKVPPrG0zcbioWHIC6SJKb8dKXS2A1JDCFQ9IXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=uukyuVQ0; arc=none smtp.client-ip=185.125.188.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="uukyuVQ0"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 874BA3F494
	for <linux-rdma@vger.kernel.org>; Wed,  8 Jul 2026 16:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1783529432;
	bh=fj8IsF7PLRatz28YWpAheFXHbHJNlGmH+/wjJoQ/p50=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=uukyuVQ0Tcr8gxCGutww6kQO+gaKaRYil6MK0cBiK0844Iml8nuhuzY/8G95n0VNn
	 vC0mi9IgOvVMGYlNOWWJ7JeFSzPXFI/qprFcHgybRpS+gNHTfdHGGACTcnsmRM1eQs
	 gdrl29mATQSozdcRtd1qM3mHHmDyCXSHAbqaZObDCZDaOxfNrB2u4YQCM6j5jknBJH
	 bdk0zCmMk0UIeDihIanJC3q265LNAjKHxl5rrwD2FZoy/da3NYX3HhzzJPmBZzOKV2
	 Q2X8gEOVIIsU8TklUxG18EKXuCJ9uV4fMhkEfosg76/rXd8DcVMzirh8ZvT/7WHoRd
	 C78M2/TyB1aHw==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 6D78EBD3E3
	for <linux-rdma@vger.kernel.org>; Wed,  8 Jul 2026 16:50:32 +0000 (UTC)
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
Subject: [recipe build #4063090] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178352943228.182775.5107128854058158194.launchpad@juju-98d295-prod-launchpad-51>
Date: Wed, 08 Jul 2026 16:50:32 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="4cb86061fad3822d81e8d53a5db6f9011a76c47d"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: ce52327c5be853ecf07df03de2d252740aef296e

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 13 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4063090/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-048

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4063090
Your team Linux RDMA is the requester of the build.

