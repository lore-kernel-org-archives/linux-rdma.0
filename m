Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD66155C97
	for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 00:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787012941; cv=none; b=eLhKHEBky47T7FD9x8Lji5qf1JsuOFNl7E7JiYqgoBluY9gYKBKvPlJDk9/OLvBDxOqQf4HU8upglhLdlCXnGVKirZGaRmEXTJZlJRM591DGxx3Kqmwm/zxVpvsoknwy407ogR81UQMfTTj18S4TpQSM/inaMzijuUyo7Z4buFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787012941; c=relaxed/simple;
	bh=mDHVjnAqV5eIPTdkjjmXh/O+sXnPmMTMWPGMnet6sHk=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=A/X00AIJaXp5WJ9hZ2pegM85Gz5ZdC2rft8I1FtnAg5TqSgAXDi94rSYkxgzmKQpHcSgwNZnQOSi6DrIfGLcADNJlOgu8WEXxgxav67QENkvBln7p/196v+S9oXBOaPncJJ07Jb7gJ/QQ6nPpsHgf1dfOu8BYl6MByyr/L9wIHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=v66EJlAr; arc=none smtp.client-ip=185.125.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="v66EJlAr"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 95C993F065
	for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 00:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1787012932;
	bh=mDHVjnAqV5eIPTdkjjmXh/O+sXnPmMTMWPGMnet6sHk=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=v66EJlAr7+kox/V7t0wyrEA12ASwIjjB68liJmsalLcRVHT6wpDG7zifVprsCskLZ
	 DzbFFF78nCjCbrvSUwpC0jgGRIQeV2cH0Z38nqp599Mu6cLKKq/IStEqO5/Sz3nriJ
	 H83p9Cnil+0ZPOnj6xNA6FPsewua3rCruO7kmDJnRl1bvoqEppbgddpP8Dsg9jeDcD
	 rYv1REljzWJJrdLCFz/+tmWkMO/hQOfLX8xeiUR0GyISkWh5FCJzjEYeXEr3dvNkT+
	 jaftDGltZFdaUlpMSvNtnYAa1dxNCs4NQ2aLwTaGgPIiw1DonWYt3ZPtH5QM7bkLN+
	 iF2BC9Vlo6tow==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 54B9BBD894
	for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 00:28:52 +0000 (UTC)
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
Subject: [recipe build #4078587] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178701293232.1060360.12478429734703523748.launchpad@juju-98d295-prod-launchpad-51>
Date: Tue, 18 Aug 2026 00:28:52 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="1f3f5e18eeb078b421219d9c98ba0dd1171ead1a"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: a8f5e40b2c8685390430dd35c9fab6a3e8152e5f

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 14 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4078587/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-031

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4078587
Your team Linux RDMA is the requester of the build.

