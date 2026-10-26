Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.250
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792980235;
	b=3jG8Rq8EaDoIjqtLP8aeys+2GKS8+jjvnvQoQAVAJuqciB9EbOqPX5q11yapzOkPGudS
	 hteCOjpNdS53vxkZmLveo04iKEvWtW8jvDXXCphkawWlAsRPwkmBTUF74Ar7ObEnwHJxl
	 AS03MbMQO/6LKGiebRbRpyZ7ca68xLaAfHPCmarRqcxsAvtnCr73sZ07XOJYR7WMj+c5+
	 9BMtizj90i2Z2q8dSKEoe466ydhHXg6uXLhcAGU+QkzSYCuiKNAA87T6HH+uLAbKqoBZx
	 V/reAGkxuPCJrxD9NMdWvGbBmFrdEt6g1IT50sCfcJWaTs3vSGLwoxhKelJSjOHIX3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792980235;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:To:From:Subject:
	 Message-Id:Date:Reply-To:Sender:Errors-To:Precedence:X-Generated-By:
	 X-Launchpad-Hash;
	bh=AcRDoRpbrJCcWq4+jmDlWzSbY86Xxnh9WWmwveaU8gI=;
	b=w1HcL7StjDScuddHBkRcP2Z/PMwbRLWnEigG/3GVW4SnZnaibyiuKlDHnGauikuF0TK4
	 kgnFmHjDgwMbMw/gZWYGtP1gNigJvYxX3Fm95x7PIBAulSsQdNdqM9CGiU7MV2mQBiMkG
	 gKGi23Fug8Q8k5jxkejnX+5+QcjLVQIgUo4iL4uKYnUoXbW/M0BJx1zTHa8P8/A4gpdNO
	 NePIMgcR5VZq8aKvhhhdVr0EYLxxHrw78BHlSqX1qgQRReOD9V5Kdi9o3TaRMwOdRWs0f
	 D7jycmmzci/3aLcIMluhTpV5Tvkclb3P9mZaUtjCwWuiNo82aWBHZHOahwFjccaeQyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=E+KRvtP+;
	arc=none smtp.remote-ip=185.125.188.250
Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69013606A31E
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 02:03:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69013606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=E+KRvtP+
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 0EA813F54C
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 02:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1792980227;
	bh=AcRDoRpbrJCcWq4+jmDlWzSbY86Xxnh9WWmwveaU8gI=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=E+KRvtP+neSbus+KbdDcT9H8owYpgcQEmPAMqZNQHPu4f3rrJ19bfFOP08mNIFa1R
	 hx28/25rZlJYoQ9n3jU07Sg/DC7oTZ9ZePNq1vNsxpZQ31ObINVyaufZa+FUhG6m70
	 O6Wb/J+AP6tbiJmDo9ZW9E8P5O+v3E1uiLwTpxs3urhePrRTAg0dHc+RqnyqsQ1l8d
	 8hzoadJzwwtv+0jL+btt+kIpM9Ftjf13QL8vyDo5WAYXOwF2eDZlsNjt2dmS5Z9z4d
	 iWLyHwvnqVPXfibaGczwN13Lbtqj04yTbR4D1HKobolIz4Hss1tpadfhguFXCRIKMy
	 88fx3wsSYxRow==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id DFDFFBD8BB
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 02:03:46 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Launchpad-Message-Rationale: Requester @linux-rdma
X-Launchpad-Message-For: linux-rdma
X-Launchpad-Notification-Type: recipe-build-status
X-Launchpad-Archive: ~linux-rdma/ubuntu/rdma-core-daily
X-Launchpad-Build-State: MANUALDEPWAIT
To: Linux RDMA <linux-rdma@vger.kernel.org>
From: noreply@launchpad.net
Subject: [recipe build #4106119] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <179298022682.1684904.9325837571684902995.launchpad@juju-98d295-prod-launchpad-51>
Date: Mon, 26 Oct 2026 02:03:46 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="8aad169d2e22e99bfd86998a2cf0f0a07502f5e7"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 8bec28d8578c3b66979a197c7e0c5a5648db67fa

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 3 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4106119/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-030

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4106119
Your team Linux RDMA is the requester of the build.

