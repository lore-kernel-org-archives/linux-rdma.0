Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702A62CCB9;
	Sun, 19 Jul 2026 20:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784491756; cv=none; b=T08y+w0wLMEp0qsvFmf1WjaJjNfL8nzqjciLtpnt43XN/eVTsBxYqSUz0B0wunNyDqyPkgrmtZyVdCsFD44OSp41ForVlkCRn4z06otzM7CoLGWuduHet0ZgHZwEe2G41qWhtZlZfVSIhC5U0jOTBalM47PhkP9OZQ+j2U3VUl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784491756; c=relaxed/simple;
	bh=LlbAlMe15CZyovXFFzlMM+97NL5mtScD3ZgDp+JMLNU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=e4XoQsV4C/ctdjQ/AIsnHpIg0bzdf3glbNPQedaSBh9AFM2IBNJz86JzZxdUvSRgIr+a1JG7wxPB4jn0QNw44LvNNJftniIZbPDVje1QchUG2xpOhbVP3qAjtzubK+KLGEqJh0yYpZib4z19WrwQ7hWzWQuo9f7Ke4sEAEuv6IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nMXSWyYv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nMXSWyYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709601F000E9;
	Sun, 19 Jul 2026 20:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784491755;
	bh=az4+zldcCl05+uDheaSeLXZwKmLPAF88rLZ1abAD3Pk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=nMXSWyYvuEHlosMZCI6RXTEZp+Y88Xkow67uxUtFY7Suw3O35iaWWB8XMSygrd+t3
	 RC9MV8wr+ZTNFbm/ZHkEwZqEEUA3jp5TUo+6eoruPgUXY/PGnbM32zEdLofkC2ImhC
	 uLzLU+n1jp4rDjFPbl8lFpxYAoGSlpeLFnDHqACf+oMxfrlWs8mowgrhQquIwaXC31
	 zZRkX1rC882X+fXtf4y+UiJ2MuOGMCexl9bHXu+qsCM2RJDtVkJW8eP6Tb2gXn7Fds
	 2JHbK8PvV5C2AAEvcTn4pXozLRrA0RgsLynzx5k/9v8/yiSkfHINxN53g4V1lafzic
	 SECALPXPTcHaA==
Message-ID: <ae36eabfd58a08a340be7a988af6edaba9dd683a.camel@kernel.org>
Subject: Re: [PATCH net] rds: tcp: unregister sysctl before tearing down
 listen socket
From: Allison Henderson <achender@kernel.org>
To: "Cen Zhang (Microsoft)" <blbllhy@gmail.com>
Cc: AutonomousCodeSecurity@microsoft.com, davem@davemloft.net, 
 edumazet@google.com, horms@kernel.org, kuba@kernel.org, kys@microsoft.com, 
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org,  pabeni@redhat.com, rds-devel@oss.oracle.com,
 tgopinath@linux.microsoft.com
Date: Sun, 19 Jul 2026 13:09:13 -0700
In-Reply-To: <20260719154840.6830-1-blbllhy@gmail.com>
References: <259284aa1280d387c413cc34fa5e4b11ad28379d.camel@kernel.org>
	 <20260719154840.6830-1-blbllhy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sun, 2026-07-19 at 11:48 -0400, Cen Zhang (Microsoft) wrote:
> Thanks. The KASAN stack was observed on x86_64 QEMU/KASAN.
>=20
> The full KASAN report and C reproducer are a few hundred lines. Would you
> prefer that I include them after the --- line in v2, or reply to this
> thread with them separately and keep v2 concise?
>=20
> I'll prepare v2 after confirming the preferred format.

For the report and reproducer, just include them in a reply to this thread.
Then you can use the lore link for the Link: tag, if you don't already have
report a point the link at.  Also, you should note in the commit message th=
at
the fix was tested against the reproducer.  I think that should be enough f=
or
anyone landing on the commit to follow the link to the complete report if t=
hey
need to.=20

Thank you!
Allison
