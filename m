Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E73533556D
	for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 17:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786470622; cv=none; b=qrN10FMLY9VKMbymRUpA94IWaglbHpnj89eTDq+whObUcMwD2QMUJP2sovRAyg19qSoXXKBF/SntOAOaREFkAABRE0O6piEiaGnHVd/hhPnKvrszsNoi6+OO2uBveQehbDnIjKEwFRhPeRJtp9c2PbjmEDPLbwXU8J5y2KH/Hc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786470622; c=relaxed/simple;
	bh=MpY5s4b7RVbHkQ5qxsfwZ+34F9CVxZyy8SGWliRgZxI=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=VUMNwNc4MFNEsN8hWDWA0A8WaBS2aBbngr8dSCAnR13Et+REobpPsWhgMMmTkXEN0/qfZBW6pcY63yzqRGKM1Nolam8bZxLjbK1F/rAuc5m8hFdvlDjKQBWb45MQa7juyCRyT0R+LhTeZH01HoLKjq3+Mt4fyrZ9CANCRrNkG64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=OM8geRiZ; arc=none smtp.client-ip=185.125.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="OM8geRiZ"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id C741B3F25A
	for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 17:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1786470611;
	bh=MpY5s4b7RVbHkQ5qxsfwZ+34F9CVxZyy8SGWliRgZxI=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=OM8geRiZp65VUB7OScMt6QuqmZ2L0N+vof830SK2Q7/4jx5prHNx4n//6iuQEvG7y
	 YPEpCCCgElmGYdlUPtZLv51TxFcfW9BEfW+1H+FLEk6SvFPQr8B2WlurTDdcCpLTii
	 3phASrxibRktXnDWkeiLqgbtBBgtrqtp3ew3ZMtq/Az3zYUzN0fxxL+EG+xayfOimc
	 PGge6kKe/z2sF6DO8+mw2kVZouhbeUPanl/RGucLN5dbexNDbdx1/67zqAUunrX0mO
	 L9oTFZ8zLCekQ94lQDBDok6hh3ufQkr18QQoW4G/ShtZ15pFjFWgQKtQ6cVFWZ5eYW
	 XuTrHa4UKL60Q==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 97EA3BD3E0
	for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 17:50:11 +0000 (UTC)
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
Subject: [recipe build #4076053] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178647061144.1942752.16035174947844689862.launchpad@juju-98d295-prod-launchpad-51>
Date: Tue, 11 Aug 2026 17:50:11 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="399dda0239c9ba55952183493d3bba88a48490de"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: a34c6b5bcd6fa21be33703f81017b0715c19752b

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 5 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4076053/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-014

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4076053
Your team Linux RDMA is the requester of the build.

