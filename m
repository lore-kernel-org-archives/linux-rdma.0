Received: from smtp-relay-services-0.canonical.com (smtp-relay-services-0.canonical.com [185.125.188.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160082BE057
	for <linux-rdma@vger.kernel.org>; Sun,  7 Jun 2026 18:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780855939; cv=none; b=jSw5EHBfXyT5qgGz0jHFarn3JubZu0rYxY7eIHyph6hDn5a53VbkkYeXj6t5VsQdtKjwtkDeAOwPz2Sl6solef8585eiJ85VTafYIyLdpn7aBXl9iNT/PoRRJFL23mOYFeFrDJBD4BS07USA5CaC0rsCRyRdKfV/X9iQF3Qg4yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780855939; c=relaxed/simple;
	bh=/LZe8Bi29kUkz7VQN3MW2ZKvLXmC0ZkMpAoOmKU8NH0=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date; b=bPacL4KmYSCALthJbgQSrOLWq591FtG0bnUocxWSGq2Lyp1hpQhvlWiiYii1pC+LnRUCHKYW+IALP9t1EBFwSH7Jrw9hjVVhmtQRWKR+dUMdYTGoR0c+q888uN2PgfBJR90bHKcbHZUENg26Qw/QzdTMBwItl2UEjKkh+hTIc9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net; spf=pass smtp.mailfrom=launchpad.net; dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b=DFPuzFrE; arc=none smtp.client-ip=185.125.188.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=launchpad.net header.i=@launchpad.net header.b="DFPuzFrE"
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-0.canonical.com (Postfix) with ESMTPSA id 6FDD33F142
	for <linux-rdma@vger.kernel.org>; Sun,  7 Jun 2026 18:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1780855390;
	bh=/LZe8Bi29kUkz7VQN3MW2ZKvLXmC0ZkMpAoOmKU8NH0=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=DFPuzFrEmZ0PbliDxH03j3ygPVT4jcx/TEpLQlb0HJAkMo+HYggVAWOOP4msXt1Wc
	 wenWCv+Z24+11WGlgWRuYLqN/SkMxfSPdTTr3T2hrTZ9oc8f6WPi9OXTfvbGMVXNyd
	 YPWOpzjJzOrD/9efNZrcqPxt8TBOr9rldBjo/XxOYc1+RDoSMrtdcj2JvS+kY8Lx6a
	 f5j00boTZdu+6gwaSGjBeolVRs8zRL+A5IwdaIVIocD8wQ5pG/ILwCKrhj3zy/iHYt
	 WEMySw2Sa4NLLAxEnjwm9DyckO9corjL09/5P0DDu35F8u3onkAqaPD/Fbj5/lG+92
	 PwzIlKL0ZN30g==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 50EF3C2614
	for <linux-rdma@vger.kernel.org>; Sun,  7 Jun 2026 18:03:10 +0000 (UTC)
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
Subject: [recipe build #4049277] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <178085539028.3806946.1044377097226568756.launchpad@juju-98d295-prod-launchpad-51>
Date: Sun, 07 Jun 2026 18:03:10 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="f85a4e13f5f1af0eb2d5aadecdf089bdd7783432"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: a6dd06a8ab0333d220e57311d1dd6ef9d981af32

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 2 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4049277/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-008

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4049277
Your team Linux RDMA is the requester of the build.

