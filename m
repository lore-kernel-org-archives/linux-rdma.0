Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B414D2ED9
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 13:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790603575; cv=none; b=ayYriBEcWLs6mmiWXXs+FPQ7R+o1ibo7L0mqC/fjHImKBo/SzKLJkfqoLXG16io8bBlSrvhSh3oqA8WE4Thp+se5unlbEiOODYJ7fKDE61f4h/OllOoRu1cWo/vA2qzYMDm/BI1njDslLIReOuGhAWmNSuT8hqH4/mEt2HlfP+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790603575; c=relaxed/simple;
	bh=nE9TlXk76aAt4VEBZBTj1Eu2BkPjwfrB6AwHrFh5tbU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bh1bNXncYPOQN7ZiQTFcO8it8JzN5Kt75stAKqKHXhz+kdEm2SPT7YFHSlM053vjYuc8NMC9w/tm3HuWI7flfe7e/U1+t1bGgYPzX6YizwInMbam7b56GO6in5hahdV4ozBjokfTI8ahPEH14gP9DCtLaSQm1qoknOdG/pyNj5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jyf4iOOJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jyf4iOOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1264F1F000FF;
	Mon, 28 Sep 2026 13:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790603574;
	bh=nE9TlXk76aAt4VEBZBTj1Eu2BkPjwfrB6AwHrFh5tbU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Jyf4iOOJE1tWz7dSUDPEwMYEs1x4cht6MFNHdzwB0tTuQRygQsF2ekJ+7CzYPowqD
	 cLaiz9rWtfeitbOzlXPuy1HBMlB21MN+VGMe1Bojwd8gjZ8BCZM9wKKabUsRhE3ZJJ
	 aduN9wNYjO1AIzYcDFyMpPnDzBK+lL+W9dYryj3CcraRWxy2Uw2pOOOYQv6ORMI7IZ
	 rBwHwhfxWySwV8xvELN4r2VKxL8UbUJLRjdtRid5xd3kPZdTrwmUASRKDpaDlglQ6U
	 RqvIsB9rY714XbTqsbq2D8yUCcPnTm7FmLJAdCAU0bz2xGaiaMYyuaTXOAAG+Lv09n
	 vkGZi6YmIY0KA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/hfi1: shut down the trap timer before
 unregistering
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hongyan Xu" <getshell@seu.edu.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260928134151.1213-1-getshell@seu.edu.cn>
References: <20260928134151.1213-1-getshell@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 13:52:53 +0000
Message-Id: <20260928135254.1264F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> MAD processing arms a trap timer embedded in each hfi1_ibport. Device
> unregistration does not stop the timer, so its callback can run after
> the port and its containing hfi1_devdata have been released.
>=20
> Shut down every port timer before unregistering the IB device. The
> shutdown form also prevents a concurrent path from rearming the timer.
>=20
> Fixes: bf90aadd630c ("IB/hfi1: Send MAD traps until repressed")
> Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928134151.1213=
-1-getshell@seu.edu.cn?part=3D1

