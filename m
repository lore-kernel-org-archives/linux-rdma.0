Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792700264;
	b=eNAFDp93uRFfnuFDG8ySL1GkEzq0bhTtQaQMeL+gVHVKLKQOXMuXVYzqLZ6mudTxRH3g
	 XctH/UqA0iYl79pJrEqEzmtmgGBOVfccuIsWLuVpQQCXDUokP3px2GKPdkk971elRxMTz
	 P6NHVu2fxLh1jpIYD6N2EGWQuewV0djuS1vpXMiqsvaDLn+mSJDMsXsS7MLZiWtQy74ur
	 yuW5rOtLzDQWAH7bDBUFcLzaJ1uDSMGnA4kyK/eEq4k+PifSA9Usq6DruOoqMkhUuyFpz
	 FCT1atuWgYm3pFN6FznqMbqT2IH2cN+DCoZV0wSBFuohuumNwNDAbO2cPBWSZU3yV7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792700264;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:To:From:Subject:
	 Message-Id:Date:Reply-To:Sender:Errors-To:Precedence:X-Generated-By:
	 X-Launchpad-Hash;
	bh=q7ufRpA4FdBRBbdgS7u6syOoqmaPHg/7S7lgFqGYCA4=;
	b=uf7oWfu9Yq0uNTRALMHRcwPPVwEeyztMoeRLrEUX6LXc6pbrdgAs+NPD1JXjQA+pu805
	 dgnhYqMA2LiSDb5qwkTjXNjEvM8TyupFDraidRQoOuQDeGs8qQAGBCbQlI0nz6Ieti+6K
	 lMLZeBQE/WXbx+nryYqDqwx+Pxn9cww6Nqf2YgHQce6LPs6ODi251foa1/Wm4LepHimUq
	 zq1IjWrNiBC95sInAd6OljPjUNDWAMWhppfmEweG+ePU+4G2a0CqxkJSQ+cxyTU4/fFvV
	 5G+WF1InfQuAgWUQ9ny/5f9mx68+bQXYWS+qnavg8rTi7XMmsqV0RQTZ9+49m9ZzOkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=d18ATTUa;
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F50606A324
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 20:17:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7F50606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=d18ATTUa
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id A48253F4C1
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 20:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1792700255;
	bh=q7ufRpA4FdBRBbdgS7u6syOoqmaPHg/7S7lgFqGYCA4=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=d18ATTUa8FPe3lghni8OM1wUCOvsRzNLUY0XCef/3Yp8xAXfgBmh1Btbn9Jz7pZin
	 liBvj2+IefWdCSF29JV9rPbg73QySqsiDeNz8IRQCN4sj6hq7AxpdpPGkuKDxs8e1H
	 mZ+1fbb3mW02QAp31qPX36SZu0m5gP/Y0LxJqHsfv1pI0dZ+5biCu+8HUQwMRZy0Ca
	 V45BodHJCMWJuRIN5ixxlmsvb7Ju9ycxDLThtfYJDdj3wfCKf1vsNlk3E0W+2lNFXy
	 YxqAa8w/204+Mm7JPpJgV+fqBaL/Km3h2B+gnVDzAPsHpciigoIKYIFfFz74W3PJW8
	 KP7humOiHcy+w==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id 72210BDA1D
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 20:17:35 +0000 (UTC)
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
Subject: [recipe build #4104932] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <179270025536.558687.1756802318514257808.launchpad@juju-98d295-prod-launchpad-51>
Date: Thu, 22 Oct 2026 20:17:35 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="56f1eb70c27d2139772ead22665134d9e7db3f2e"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: cdda1df5f33853b5a3baca797538de71dc181c94

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 8 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4104932/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-083

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4104932
Your team Linux RDMA is the requester of the build.

