Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9CB2D1F7B
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 01:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792200787; cv=none; b=OD+5UNGT6cW3PrQ7XR4HvzRqdtqac2669d9SykT5jk/gldBICOHU7BA6i2ReahxXneiTfAWmv2ja3bRb30pF99gkNwz68JeNOH0nrfhw+G8uIkLdTB9+JfLwI06TtbWKCiVK0G1zC6/V1eEIN5WopmpRSyd4CJAAgzpKxBav/HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792200787; c=relaxed/simple;
	bh=4akw34soB2rSCwXuAc9JVXsbaMiqZMPcCtzSvYcpzyI=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=jzkk25Hnarm3Kvf1RNeCTPnaWEDTJxrhgksyLIAZNuZdaAPCPMARNxPbQSauR6kgnNcwT0GzAq43AW00YCtJ8ifmeR/LLw/ingtDpgGaQs7gdseVIss5ddE2Egnc81WBKLyBo6UZnJwZYibWqiNC2oiEHYa/poCEumTjqgM+xDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=Ys82OoDx; arc=none smtp.client-ip=185.125.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="Ys82OoDx"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 936CB3F6D6
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 01:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1792200449;
	bh=4akw34soB2rSCwXuAc9JVXsbaMiqZMPcCtzSvYcpzyI=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=Ys82OoDxXCc99uO3MMygxGqDhlICN/eiF+dnQgM5N16tD5C8BlKqNOg1RRTquYbKV
	 UvEgdXeYtS/wBkDYCxVuo+pKeoN3LceU+kMHU3KUAI8LF+jZrVhGagQXa4OTAo0LzO
	 pWumIzBIOfDEPLbWTXTXhnOuwvS4e4imBb7rlOv3CcnZ3uWEpJcyzUL37YCVacbGfh
	 dWj+f0KY2zcy9KRASmk7dzjIBC2O6vPefLgZWKa9gSyBKf5/Kv1VPxIDjOCWHYuHOY
	 V7aMTRy0kPICeaFh/yOTbvktV1w6utfsCe3P8Zu5zisr9U+Qd4Zjed3DblKAOKjiTz
	 mEgsj7hyHsjXA==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 73CCEBDA4D
	for <linux-rdma@vger.kernel.org>; Sat, 17 Oct 2026 01:27:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Launchpad-Message-Rationale: Creator @linux-rdma
X-Launchpad-Message-For: linux-rdma
X-Launchpad-Notification-Type: package-build-status
X-Launchpad-Archive: ~linux-rdma/ubuntu/rdma-core-daily
X-Launchpad-Build-State: FAILEDTOBUILD
X-Launchpad-Build-Component: main
X-Launchpad-Build-Arch: armhf
X-Creator-Recipient: linux-rdma@vger.kernel.org
X-Launchpad-PPA: linux-rdma-rdma-core-daily
To: Linux RDMA <linux-rdma@vger.kernel.org>
From: Launchpad Buildd System <noreply@launchpad.net>
Subject: [Build #33851046] armhf build of rdma-core 66.0~202610162254+gitb63b7bfe5~ubuntu20.04.1 in ubuntu focal RELEASE [~linux-rdma/ubuntu/rdma-core-daily]
Message-Id: <179220044933.2506948.8823514025996080701.launchpad@juju-98d295-prod-launchpad-51>
Date: Sat, 17 Oct 2026 01:27:29 -0000
Reply-To: Launchpad Buildd System <noreply@launchpad.net>
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="f26fb3ece56641d26593dddafecfb57e59f1d938"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 6b94c01e900ad34342e98c5dee29df28fd773cd1


 * Source Package: rdma-core
 * Version: 66.0~202610162254+gitb63b7bfe5~ubuntu20.04.1
 * Architecture: armhf
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Component: main
 * State: Failed to build
 * Duration: 6 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+build/33851046/+files/buildlog_ubuntu-focal-armhf.rdma-core_66.0~2026=
10162254+gitb63b7bfe5~ubuntu20.04.1_BUILDING.txt.gz
 * Builder: https://launchpad.net/builders/bos03-arm64-096
 * Source: not available



If you want further information about this situation, feel free to
contact us by asking a question on Launchpad
(https://answers.launchpad.net/launchpad/+addquestion).

--=20
armhf build of rdma-core 66.0~202610162254+gitb63b7bfe5~ubuntu20.04.1 in ub=
untu focal RELEASE
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+build/33=
851046

You are receiving this email because you created this version of this
package.

