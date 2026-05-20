Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC133E95B8
	for <linux-rdma@vger.kernel.org>; Wed, 20 May 2026 14:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779288248; cv=none; b=D69UUTj97AQzLKdRzeFyj/er6aLrVGOKGrFu/yCbGVcvFfXcC2Xh/nX0TpNtjp6hFONDcoYfaWA9Z/kWQ/5pL8k6EpcANQYSZ4y8dAi3PdNU5IY+v06XlkIGitJQD0zLwRukvOY/GH/Mp44iZjLoM89tcI+hjsKNf84wy/girmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779288248; c=relaxed/simple;
	bh=v6qO+/QmMbx1tbbx79QNFjYGKR+VWKoTL2Y6MbXXoPY=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=bjxiYW8tCyXk0VFY9Pe0nSX6a0d+OjbYLeQTdgQMO9ZBhgCveclH7Js0jqOBKIrfqiFEYS341j1pC4lEueO8JaWXDof7KydjzoYlHYk/l/T3VJur08Fk1LyqeFq6U0ZrimHMrMAlc2/A57O35R4gclEobSV0uAsJf8nkPHapalw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=ZhnXBvuU; arc=none smtp.client-ip=185.125.188.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="ZhnXBvuU"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 7C7ED3F343
	for <linux-rdma@vger.kernel.org>; Wed, 20 May 2026 14:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1779287752;
	bh=v6qO+/QmMbx1tbbx79QNFjYGKR+VWKoTL2Y6MbXXoPY=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=ZhnXBvuUuVnbQTqEgh2daNxkw48FqQSW9V8eyRrmhhYa2xx9SU9cQc4Yj4cGdwIyp
	 5QAPd5mVAbprZx6WOUJGNh0v32xo4yVre3qLNh7TwFTcaMBPY//tHvafweZaz4P2Pd
	 Ohsa7oXHWcy/QHzyf1U4P9arqSHwPQQVkORkh1jKGgiqANo+0xbfBLSCo2YaFU2u7P
	 ukghgxecyc35BRPYjww078AfcNL3h2mmH5TzVFnqh72DESegFbq0ZichYV5CVObWYl
	 Tv0xbqJg5l0riWmwmk2UBut5kg3kQcUYVtORLuPOqW9MaKT0fKAwztBKQ99x42fjdn
	 UIDOEgGFc7U6g==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 69294BD3E2
	for <linux-rdma@vger.kernel.org>; Wed, 20 May 2026 14:35:52 +0000 (UTC)
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
Subject: [recipe build #4042136] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <177928775236.3147202.16009539780741115791.launchpad@juju-98d295-prod-launchpad-51>
Date: Wed, 20 May 2026 14:35:52 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="21e17fefcf122f18da93c143f29f40ba940e464c"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 2f67f76d38388eaec355bc87179e06bad2aa4142

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 5 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4042136/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-029

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4042136
Your team Linux RDMA is the requester of the build.

