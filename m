Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794559143;
	b=D7Rnpze8jIEbrakBzOWJnIaLgsSV1MHdGtfHhZnmEkIO0zw12myGC49+2x+6ghtvkfp/
	 c01cx167OoksBfBgBztooGFzDjSXyimquTh7ttX1DjmjkpS95JrK5dZJnZymF/jWg9JgF
	 9Q5Q0gmuvF/OAoLoAk/6xrfwUtImZpwLLqzk69kfY4DYb5R0ucJPIMwaJQcMdVzUpKY5U
	 Q8cksR7Z7D70u7ChQq2D0VvBspykZ2EVzBygq72+2Dzizy6wp3dbNGwkG8c0pWS4j8Dqh
	 o4NLtcx7InpoB3NkkJg7V+CMUleqDQzyh+tVD0wl5YEprkr2jiUoPZl4Z3ekiZQAgiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559143;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:To:From:Subject:
	 Message-Id:Date:Reply-To:Sender:Errors-To:Precedence:X-Generated-By:
	 X-Launchpad-Hash;
	bh=505drjZXSJUyVHbKhDqpZ/vCyknEG6J7VkI+PakhhRg=;
	b=Cojmp05VHBUGUHhBp4x09wJV8oYMQVIpDHQP17b54ig8DQPMaVfnqRGJVjyPQc0AixQp
	 0vM+nwSUy33Vx+obtFJCzXxG/t2oAXiKMK8b0dU/bAmkN/xEgGYt7J6sn9KTXsjiTGmmY
	 pvJlU3ISXjN9hgF0UXt4wZn7UrK5IUPF2y3J5se8ZDp+0lv2t+YwMYPEATS8Wu4v3Xy6W
	 lm4ZZ2rKNT9czeWZqejHqqP/kFxvd8rwwbF+vyJ1atweT9cSq3cWy5kEY1x0R6mEWug8Q
	 Hq59xCB9bTkp3ehq3grWcU38kmWDH7WvQ4TEjqWtVjs0tnnxOT1crTZI01aL99Fkpmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=Y9NPm46C;
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D293E606A321
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 08:39:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D293E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=Y9NPm46C
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id CE6093F355
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 08:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1794559134;
	bh=505drjZXSJUyVHbKhDqpZ/vCyknEG6J7VkI+PakhhRg=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=Y9NPm46C6ho2vGPbB2vSDCSYpYF04QuXNlDcOLQmQoJN9qtoSWyUWwQSf74+9Sijp
	 /ulfqxv/iOEoeS1MLtv74nNTYcyLk1JclAzPwrQPeeDCuFEOUPty79SkPJra3Gzzo4
	 C1WlUCFnjjz85KKrd9LJny/OlcEmJOstgk0SRXurFqoKwtPw5kCkhMt0NWIrtnyxwv
	 8pJ7/bcO6e5eUGDdmrTmMaGddiIfUvYLv7PmwtISSTS/sdlBG3O0QhzNIjh5VamjGg
	 7x1kUAUdWmAOR1z+y6x8TARKXE26ar+IESpXGkwHeXguMx8uxyC3pqqrOgFpt2P+a5
	 KPe8V2HexF2YQ==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id A0A65BDA64
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 08:38:54 +0000 (UTC)
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
Subject: [recipe build #4113848] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <179455913458.2919559.10884155601113422661.launchpad@juju-98d295-prod-launchpad-51>
Date: Fri, 13 Nov 2026 08:38:54 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="72ba15af7e009b17d4aa1467977127ac8392a4de"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: c6f2bf729fc5e01c46df7d79b813ab16bae22cba

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 8 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4113848/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-079

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4113848
Your team Linux RDMA is the requester of the build.

