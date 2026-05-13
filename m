Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9031DF261;
	Wed, 13 May 2026 01:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778637262; cv=none; b=NuFzq223R+uVqV7vBizVAKzaDBdzpYx7YJalkHo24HcYwUlEJE+J8gAMOaL2xGqI5bAoUWkVuStbC3IWI3hfwCVFD4EcLmU95T6/GYVXzG5OREarqEIRa4Gtxr/kgv1lLYRZ9qpg70SDJCS7WUSfyfPJUIsQEsZIURgqBIhKDiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778637262; c=relaxed/simple;
	bh=nvkKlP+muh+e39AxYKH9NZ8enYjEU29a+h+cLGdElwQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SyjikUpwzEqvtx+m4idQm3UGHCHRwqm4MYEGKrkXSl1DJqFi1X3d65Kw22wTQe+mKRVreWA7Jht8/paxZ5u0W07OEpY8OAHfZ2RszHAI89nMD+NWbR3++pkmuPXpcABfxgQIN841JTAUlXWawg05DxPnPO5BiX5EKBE46BX6+zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fi0ObpWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fi0ObpWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703B1C2BCB0;
	Wed, 13 May 2026 01:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778637261;
	bh=nvkKlP+muh+e39AxYKH9NZ8enYjEU29a+h+cLGdElwQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=Fi0ObpWePc/vTI/DoHV7qqDJ3dCfZwYGjWe/iamzdU+zmyLtetiCWsUVzVXe2Z0pE
	 m8CIa4H/RuDFRVm011MWTTTuo+ua+nztjD9Juj6myZYMdtfOU7rSClP2rC6fL1/dKQ
	 TSojoNBv/JZ+grbAD4ygFVkbNfURvO54DXSpSdwHH0GfaScpOi81/LZ+fEhAIGkjKH
	 Hp9pxjtaLKi65clFZUa7eqizxf3CHfl1maiugSEdgX/FATVDhV2L8fHBScXWYpmO8f
	 8sJKbExoArbHjI0VZh0H1wRi2zcCoExRS03gK2oU3D2oP/pCVpp9jXkKvWZ7/y8EDT
	 cVUFHA6NbCwkA==
Message-ID: <38c21a1067fbdf2f2780b6dfd06d839001943d59.camel@kernel.org>
Subject: Re: [PATCH net-next v1 0/9] selftests: rds: Add ROCE support to rds
 selftests
From: Allison Henderson <achender@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com, 
 horms@kernel.org, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org,  shuah@kernel.org
Date: Tue, 12 May 2026 18:54:20 -0700
In-Reply-To: <20260512184209.0956bcf1@kernel.org>
References: <20260511072316.1174045-1-achender@kernel.org>
	 <20260512184209.0956bcf1@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-05-12 at 18:42 -0700, Jakub Kicinski wrote:
> On Mon, 11 May 2026 00:23:07 -0700 Allison Henderson wrote:
> > Currently the rds selftests only tests the tcp transport.  This means
> > most of rds_rdma.ko has no testing coverage.  This series refactors the
> > rds self tests to add an rdma option when running tests.  When used,
> > the test creates a pair of ROCE interfaces to run the payloads through.
> >=20
> > Most of this set is refactoring the existing test.py module.  Since mos=
t
> > of this code is one long procedure, it is difficult to modularize it
> > without creating a lot of pylint complaints about lengthy functions
> > with too many variables or branches.  The first seven patches address
> > this by breaking down test.py into helper functions.  After we have
> > modularized the send/recv packet logic, we introduce the new ROCE
> > equivalent network configurations, add the new command line flags to
> > build and run the test with rdma support. =20
>=20
> Looks like there's a handful of ruff and pylint warnings flagged here.

Yes, I noticed those. I will send a v2 with some more pylint/ruff cleanups,=
 and anything else that comes up in the
sashiko reports.


Thanks!
Allison

