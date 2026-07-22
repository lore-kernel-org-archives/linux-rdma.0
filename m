Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF61481FDF
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 08:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784709836; cv=none; b=XjX1B/wPoGFRnnnLIKfX60vY9dbZr1rC9gkwld6wrbz0MPABWulB63kGErppKSeucy1xEyC3LwRUFh6gYdSki1u9AbkGuI2miobHkCq0bAaSa72OoKPKBLxjbZoGQu90QDPC4K4DPa5oIo6pup3wmVhkMc9cHeDqsmcug+zmD08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784709836; c=relaxed/simple;
	bh=/nDKgvLloGgD2s8Geqk11Y19e7PGJwBo7wJ3IdVTOO0=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=P5hRpgYaEeI9uDWMhZAZN8WDcbpvhGf1MxQqw44fcO0HfPUsP0T+GthBiIy5uBWbjS1B43Pk7hnrfQC7trRPsyzY+mKu1feyNKsFsWw0o7SqfvQ3Rv/jm70fU4PFlchu/V8+NEdo55WFHplDFFKV0JDfWWSpsIPRM6zCpjAfLnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=Ub7fXkPw; arc=none smtp.client-ip=185.125.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="Ub7fXkPw"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id C773A3FDBE
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 08:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1784709819;
	bh=/nDKgvLloGgD2s8Geqk11Y19e7PGJwBo7wJ3IdVTOO0=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=Ub7fXkPwud/kNCJw1jxYtF1ILhaEnRoAUTGXCnnwMGs5qPrAHYpuTqmhxgc7NQdmQ
	 vLbvlQ7ez8wFNgoyEaC6pe+L31dtTPevt+0R6Ygi6CAtSkHjELpEXkTmuIoKPtrm39
	 jw3uhMbCYIvPut6mCjqBmGVNKjdiE0ugf1eyljOkK8jBvm+lLyZP6nkDM+1JGEGhpO
	 pXcBEjXLFFxDlWjFm8n8q3WH6kjqg0sCd2wbFCWGPQg1t+PC6jGaAG3u1QG2CV98jn
	 zCCkDbLTqfgX1wyqwb8bda+vJYb5uwOWiLYEUX6/yy2pZGfyLzGKdGMUQMSex2MB4k
	 KAKmeb0zFtYQQ==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id B08A6C1180
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 08:43:39 +0000 (UTC)
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
X-Launchpad-Build-State: FAILEDTOBUILD
To: Linux RDMA <linux-rdma@vger.kernel.org>
From: noreply@launchpad.net
Subject: [recipe build #4068555] of ~linux-rdma rdma-core-daily in focal: Failed to build
Message-Id: <178470981948.180546.12790334136911684190.launchpad@juju-98d295-prod-launchpad-51>
Date: Wed, 22 Jul 2026 08:43:39 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="774348fdb24c5c7c9b709dde2a8f044a871f127b"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 9fa007cbc328411cf00d9514ee25e6a439116a49

 * State: Failed to build
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: focal
 * Duration: 13 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4068555/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-078

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4068555
Your team Linux RDMA is the requester of the build.

