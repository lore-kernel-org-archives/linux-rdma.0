Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9A33F54C6;
	Fri, 21 Aug 2026 05:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787288849; cv=none; b=og/RnQ6k8nfFiPSwh2Vut82ttS2lqasAVxTAUTOypDyuu9KzkYMorSVWYBbmIgMZ6LFz3TAxxtxJJa9qumsVP3d5B952FDo7GmvMNmdN+pR0F2JicH/V89KEcPkKlXXPg57Vb1t7Hi62Nwx9x73YIKQAK5Tftc0jpQ5rqcOyFuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787288849; c=relaxed/simple;
	bh=yro9R2fesggXT/5F+cz6y2n34EAQ5yrwBaQi6FHzUfw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Z0Sddr22mmwGnpVryd2eV/vx35rjdht7nQo/fQz+eWXHXzjTvfCS/4OwOGAUHAfyNp+h77B4MxbPov7Z61AtHQRAD34KfBq664CK2c0a3bfRVNLb0nhBtUcuh/K4Gtk+aoE8CubdGcDdyTeY3lnz3rG2qrvyactAa1NNWUb4Cho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CaHdQrP8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CaHdQrP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865B41F000E9;
	Fri, 21 Aug 2026 05:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787288848;
	bh=Ml4SGLLYZO9tAklishfHK9SoubleA44hWORl2MU9U7Y=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=CaHdQrP8XsJAVi9s86w9XruqC8CcdKvEwDPJZBsYPnlYvjOcUfudk08p59SlnTCbF
	 ATogEy0tiM5ZV93E8F1nrIKPfCUAA3oX987OFkT/vICbuPZQl+M9qSyIwVzfqBXEcZ
	 nMXi5JyAGjm6yUWfVbXRi7sEf/fQKBPrVzjlboWQKgOVdUgDAm+CGmlQ7qtcaIpR30
	 EkrFZPn11xOW38oz9cDnfc+FE/z/gPUcOlDuS5e6jdvN1LBVk9VTY2wmuQB3lST79q
	 vmHme+rMspG8+B9j2oDFvSAAOpGni1Rb4OipIQBGuVN4ACDWgIT4Lx8nCIEv5k4gk3
	 1ol1BM4pXfXSA==
Message-ID: <c3c9a3f2683a37474256b9f879f9ee896d62704c.camel@kernel.org>
Subject: Re: [PATCH net-next v2 0/5] net/rds: own the fastpath locks across
 connection teardown
From: Allison Henderson <achender@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com, 
 edumazet@google.com, horms@kernel.org, jhubbard@nvidia.com,
 woni9911@gmail.com,  michal.kubiak@intel.com, leon@kernel.org
Date: Thu, 20 Aug 2026 22:07:26 -0700
In-Reply-To: <20260820133832.5384be37@kernel.org>
References: <20260816001510.73645-1-achender@kernel.org>
	 <20260820133832.5384be37@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-08-20 at 13:38 -0700, Jakub Kicinski wrote:
> On Sat, 15 Aug 2026 17:15:05 -0700 Allison Henderson wrote:
> > This is v2 of the follow-up set to "net/rds: Bug fix ports, part 2"
> > [1] (v1 of this set is at [2]).  During review of part 2, the later
> > half of that series needed more work than a respin, so it was split
> > off into this set together with the companion fixes identified along
> > the way.
>=20
> Any thoughts on the AI review?
> https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260816001510.73645-=
3-achender@kernel.org
> IDK enough about RDS to judge the severity of the last one.
>=20
> BTW we will take these via net now that the 7.2 final was tagged.
> Don't worry about net-next being closed.

Hi Jakub,

I think the last review in patch 5 isnt as severe as the review makes it
sound. The shutdown worker can hold RDS_IN_XMIT for the duration of the
TCP drain, which in the worst case can be up to 5 sec across 50 retries. =
=20

If a duelling SYN shows up in that time, the accept worker on the global
krdsd queue sleeps waiting for the bit.  That does mean that things in
the same queue have to wait behind it since it's single threaded. It can't
deadlock though since the accept worker runs on a different queue than the
shutdown worker. Shutdowns are on the individual connection path queues.
So the accept workers wait for the shutdown workers, but nothing on the
conn path queues wait for anything on the global queue, so eventually the
drain always finishes and releases the bit.

There is a low-memory fallback where conn paths share the global queue
instead of allocating their own.   That's what they used to do before
commit 4716af3897 gave them their own queue.  But that just means
all the work items are serialized, so they can't race over the bit.

The waiting algorithm itself actually isn't new. The accept path has
waited on this bit from the krdsd work item since 335b48d980f6 back in
2016. This series stretches the worst case from "a sender finishes its
batch" to "the teardown finishes its drain".  Ideally the best fix would
be asynchronous teardown, and there is another Oracle-tree change that
coordinates that.  It's another porting effort on my todo list, but
I try to contain changes in small subsets to keep the reviews manageable
since a lot of rds patch tend to snowball.=20

The other commentary nits from the review do have merit though. If you
like, I can send a v3 with those corrected, but I think the code itself
is ok. The patch 1 comment about cong.c is a pre-existing issue similar
to the lost-wakeup issue that patch 1 fixes. So I can send a follow-up
converting those waitqueue_active() calls to wq_has_sleeper().

I hope that helps? Thank you for being accommodating with the branch
targeting.

Allison

