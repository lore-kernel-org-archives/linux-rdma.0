Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3108C219A7A
	for <linux-rdma@vger.kernel.org>; Mon, 16 Mar 2026 11:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773658890; cv=none; b=RedN0MkEnEKWkdRDEC9b45rKiYtxftRmgH5j8NL2ibh8dNAURCnEY5OEG1VUx/B7j2Vr+OmTrmiZSxd/+/ue6NxPg1hc8r8Y3NDiRlwraAR6oNvac4ba/zcE6h5yyG3PyiCpkXrYEov91pqBmB5MPoByO1cl9m0wvz8tQbpddtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773658890; c=relaxed/simple;
	bh=9HH04+NHszq9rohaqdRlPtYP76kqZzqYtUvHXbtgkn4=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=S9Ffkwwgq3qKFR8FjMcHM7gZiM3UFl7ewhwEny/xozcOmTUl8xW1EGkpapTxWA4ZvXxAmGfN1p+fNvau1pbEaw+RpIhz60OZFCHBPH68mE3Pg3d5a+mTnQZHyaDZCrPXoQtXEvdm6X8NrFN/0omLMxgkRyDy2kgyaPOobqJIzhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=M7sgGq9s; arc=none smtp.client-ip=185.125.188.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="M7sgGq9s"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 5A88C40536
	for <linux-rdma@vger.kernel.org>; Mon, 16 Mar 2026 10:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1773658550;
	bh=9HH04+NHszq9rohaqdRlPtYP76kqZzqYtUvHXbtgkn4=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=M7sgGq9s76kAr6GPYronpW43P8PTC7DHkd3/CzTEYGmmb1LXVlMQx9ilyqf8zm/rP
	 JkQ5lB2+CzgyP0aOgLmqYOmP9MA+1chrQmXvFG78jbHafUWT5AlDmmv1cA22H3J7DV
	 jh4V/NGvOP/E+Ocys9VO5Sa/RniytQVwfTqMEj4gvabBuSWFn4IDZZ3NOB/V8fK/hd
	 TrWWZNiCefdP2UXFl2CSxYf0yADHQJRtFh8JXeHZQItkIDg52LLHHzbTZIUTAy4rRg
	 NIBjAlgpnKS/7yM7GYgtzOMfzYF14b5pSm1NmamSXlabgR0f7B+/cdMuPvSHSuv1vr
	 Y9A3wbJqze7CA==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 2B314BD9D0
	for <linux-rdma@vger.kernel.org>; Mon, 16 Mar 2026 10:55:50 +0000 (UTC)
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
Subject: [recipe build #4019105] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <177365855005.31593.17576423688897577339.launchpad@juju-98d295-prod-launchpad-51>
Date: Mon, 16 Mar 2026 10:55:50 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="30ebb7e51b1d452d1afd137b32cca7f23d23d307"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: c87984ac99dfcd82b788f48b32bc8b0865dfc539

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 8 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4019105/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-006

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4019105
Your team Linux RDMA is the requester of the build.

