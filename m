Received: from mail-43100.protonmail.ch (mail-43100.protonmail.ch [185.70.43.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167984854FE
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 09:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791453052; cv=none; b=sYvfzLkfvTqFsWyAxE5ifudkygeWarbf0J34Dklxgu75VoUw/EXPJk9jNBEPBnY6J9ozEabDvmRznUB7fMFqpG1QcTvgGGL6ixx4TvS5AunKuC9dv7uCa71wFIwMXME56GXLDqH7SFSkevKSSv0h4nJJ28GDKr3c/pexjzjjXIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791453052; c=relaxed/simple;
	bh=dF6sKLY+Do9pHHWvxRoqnDDI4GgDYEde6ShyMUMvE5g=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fAgBCl+YtpuFrlbC9aocIE82MfpVZyc5lDfWkewKb2JfC7UImB0E1GrYyP8prl3sgt50Pp+oARBHwOPK4o+/v/hFlBjShbE7nSLtDZu83ULe+axvdZZKS16nAGoo7Xsy6/2gktWFju08k7o9mbxKo8WBrjt7xIFLeuZsjtI6t6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=gpDXlilU; arc=none smtp.client-ip=185.70.43.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="gpDXlilU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1791453039; x=1791712239;
	bh=dF6sKLY+Do9pHHWvxRoqnDDI4GgDYEde6ShyMUMvE5g=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=gpDXlilU6/2oALFV9Gv7sRNQklD21rVBN2GMffuWfxOnfwSWoY8sqVvkNMb9AC9cL
	 0v45Bpr5RtZSfKV8y0R3jRd+AUZL2roC11nrpB+8IxdsTJr4fcfzY0nJ+WZGWdgNot
	 uag4QlMk74v+fS6tebcJh5+Rh7i9YEuQDJFRPKvxrzHdcsWs1wAimZu62XEbrKv77m
	 LNMPEbFq+aBxGBQWUhT1F2C5GA563FMSitXw26dlgiVQ8pmHmKtM4EQdUGrsp2o/OA
	 1sYutSM2Q7+vvAM2BoV40U9TzCul+gFms4a6bvby7q+XXAvJ2OtWdIPaPXNxos5C7X
	 3A6zKFj5H4e5A==
Date: Thu, 08 Oct 2026 09:50:34 +0000
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Jakub Kicinski <kuba@kernel.org>, Sidraya Jayagond <sidraya@linux.ibm.com>, "D . Wythe" <alibuda@linux.alibaba.com>, "David S . Miller" <davem@davemloft.net>, Wen Gu <guwen@linux.alibaba.com>, Wenjia Zhang <wenjia@linux.ibm.com>, Eric Dumazet <edumazet@kernel.org>, Tony Lu <tonylu@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, Paolo Abeni <pabeni@redhat.com>, Ursula Braun <ubraun@linux.ibm.com>, Stefan Raspl <raspl@linux.ibm.com>, Simon Horman <horms@kernel.org>, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v5 0/3] net/smc: bound wire-controlled CDC cursors against the local buffers
Message-ID: <20261008095028.269577-1-hexlabsecurity@proton.me>
In-Reply-To: <fc1eb33d-f9da-427c-9e0c-c2ff79d2a1fe@linux.ibm.com>
References: <20260723-b4-disp-0d07164f-v5-0-6a9e235dbc4e@proton.me> <db896915-5858-4fc3-a56c-77b626980284@linux.ibm.com> <20260901162012.602cc62e@kernel.org> <fc1eb33d-f9da-427c-9e0c-c2ff79d2a1fe@linux.ibm.com>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 1a24bcbe52fbbdc86ba114ce928bf68a18f010da
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Mahanta,

You asked twice and got no answer, sorry. I was away: there was a
major earthquake here, and I was also finishing a postgrad program.
The program's done and I'm back.

It only needed the repost Jakub asked for. v6 is rebased on net, no
functional change, and picks up Sidraya's R-b on all three patches.
The one wording fix is in the 2/3 commit message: the OOB read goes to
the receiving process, not to the peer.

v6: https://lore.kernel.org/all/20261008-b4-disp-f7cd3d96-v6-0-fba616c0920c=
@proton.me/

Thanks,
Bryam

