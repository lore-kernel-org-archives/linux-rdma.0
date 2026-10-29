Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793313179;
	b=Qr5v3pZJzpsBtVU5k+g5O6Pnb8yD7fhOJArRBAzLZ9c5ACuHBGjw8OlqjiDDJdFdrt8J
	 YaG1lFPHrGD/kiIdSkFHa0TJk2F6zqDCNR+KpWuE4ywNDrNtJUmlI/h8N4moz2K7JV4J7
	 YWu8rO1xOi4BElBJV3c1xscyTROkm652OqKHnF8Au/zaODEwsEFL9IpvDNDwPrG/CTpkd
	 C2HWLu+CMETef0pgK3cF0F0B/0ONZL6WJ80KndAsZqFTEEQSDRpeZ8CvR8MyaIPW6U7w8
	 H+J6qdj3li+JjqZgw2tusxeWqTbovrrQjQawsDwWv4Nu1ncuQAsD2Ti4YVFm49ijUtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793313179;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Launchpad-Message-Rationale:
	 X-Launchpad-Message-For:X-Launchpad-Notification-Type:
	 X-Launchpad-Archive:X-Launchpad-Build-State:To:From:Subject:
	 Message-Id:Date:Reply-To:Sender:Errors-To:Precedence:X-Generated-By:
	 X-Launchpad-Hash;
	bh=N8CPp+xVBbnz+/GYZ3tkD2H98sComz0z6Fp3SPtX0yY=;
	b=u3lFhNv6aXTCoNi/1KnBlzNyLcW/WJhQRTX/F8kd4+7WykhoFoxCJtZ0yc3j0TMLI7No
	 atjp8fNLN6etObrPwpRYJ8SRr/ogckv5NqC7HSiabuaDKhnEDllgUPtNN3063OWv6tcVj
	 qmbII909CUIjhimC+q5gSVwXeLxlC9VjZk+X13zt2N08jrIIxgSKXGEQb4VRd8uyMvM9x
	 849vIBkAIZc/Q+uQIJ5cIu7wJjyVziDd6YBVjhyIdEZr7zNdetHKexuecocwVgZBgcxo+
	 /5kiFrAmiAu02nM5RZdTbiLi1oFO2vYBp58urnYzkR26aTz2TTJ+bCqOZXYVPzwnTUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=launchpad.net;
	spf=pass smtp.mailfrom=launchpad.net;
	dkim=pass header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b="ellKtay/";
	arc=none smtp.remote-ip=185.125.188.251
Received: from smtp-relay-services-1.canonical.com (smtp-relay-services-1.canonical.com [185.125.188.251])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1CA606A31A
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 22:32:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A1CA606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=launchpad.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=launchpad.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=launchpad.net header.i=@launchpad.net header.a=rsa-sha256 header.s=20210803 header.b=ellKtay/
Received: from juju-98d295-prod-launchpad-51.localdomain (unknown [10.131.215.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-services-1.canonical.com (Postfix) with ESMTPSA id 23B423F0A7
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 22:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=launchpad.net;
	s=20210803; t=1793313171;
	bh=N8CPp+xVBbnz+/GYZ3tkD2H98sComz0z6Fp3SPtX0yY=;
	h=Content-Type:MIME-Version:To:From:Subject:Message-Id:Date:
	 Reply-To;
	b=ellKtay/qOJwlZbcymL3hr/5YVRRPazYS1abNPB++iAfjgZGANjBiJ0+UVVQLMSu7
	 /I/nHNiWji+1KOteXWsnOIE4U0wCu1dZqBTMLH+ON12OwMq3/WdmJx+otJlhuNwgtp
	 XJdl7+PCQdN3e1bIgkPqRGrrmoZk1kZ2micocy1hWHXw5cTulPFmiTKQAC7ZBWtNxW
	 oTP2XSVebCWd/6f7XxEOVp35ljc1TyiN9k1a1reJ3GMtjfHlTFa6CIWkY8dVcMLvig
	 QelE2U/2DXn9pytwc9qloi4vlF8ek/J1GxD4BW4CfWu4Mv14rsAo9Dn6DUyrAbKDkz
	 O2QVvDuVh0WAA==
Received: from [10.131.215.15] (localhost [127.0.0.1])
	by juju-98d295-prod-launchpad-51.localdomain (Postfix) with ESMTP id E9CD7BD8BB
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 22:32:50 +0000 (UTC)
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
Subject: [recipe build #4107487] of ~linux-rdma rdma-core-daily in xenial: Dependency wait
Message-Id: <179331317088.3317829.15164227444194391956.launchpad@juju-98d295-prod-launchpad-51>
Date: Thu, 29 Oct 2026 22:32:50 -0000
Reply-To: noreply@launchpad.net
Sender: noreply@launchpad.net
Errors-To: noreply@launchpad.net
Precedence: bulk
X-Generated-By: Launchpad (canonical.com); Revision="8aad169d2e22e99bfd86998a2cf0f0a07502f5e7"; Instance="launchpad-buildd-manager"
X-Launchpad-Hash: 098d6d86c2eff25c1eb57c4c8ffca62ee1809bf6

 * State: Dependency wait
 * Recipe: linux-rdma/rdma-core-daily
 * Archive: ~linux-rdma/ubuntu/rdma-core-daily
 * Distroseries: xenial
 * Duration: 11 minutes
 * Build Log: https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-d=
aily/+recipebuild/4107487/+files/buildlog.txt.gz
 * Upload Log:=20
 * Builder: https://launchpad.net/builders/lcy02-amd64-049

--=20
https://launchpad.net/~linux-rdma/+archive/ubuntu/rdma-core-daily/+recipebu=
ild/4107487
Your team Linux RDMA is the requester of the build.

