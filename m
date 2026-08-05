Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8EA30C156;
	Wed,  5 Aug 2026 04:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785904251; cv=none; b=qAywC3JvzsZ615ZqqpJHRABj3F/LeArNOIJ5rCYIRv5HvaWrafplHssyrR4cFBfjeeBaZ+xvOA0y5aWEhNy9ja7vRECEkvXXY41rMSaZtuHSmTemu7DL49bOMm61sjr5lLCS4L1OCvyPRJMD+EewY9bvnGmeVhYaztBkt/5AeYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785904251; c=relaxed/simple;
	bh=ac4tmf6Yjp5eIYyjOzrrMl+/e7nD04dyyn2QkguLwj4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GJ1a24ouGtu/t/FnaOGApu607sCensqDESqWH05RjPXnH4jZkux/vDWKBIFU5Vl5Rf/H2avLgk33+mK23cDv/i32ZYBie9subs4necqMVFfLB5MV68gYy1zR3/Z+zgEjN0JUvSnUY/8YPrrIhppGtYf/wW+49zba4xmlogLN5iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZeOQFxC2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZeOQFxC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1E61F000E9;
	Wed,  5 Aug 2026 04:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785904250;
	bh=/av1BTC5dZe5RiLzur7payE7KJhD0Si3Jmj+7BIZXhM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ZeOQFxC2oExBDo6dlGTCy/idhtlGDVdl45++EEIEU+Id9u97OHj+27MnyHdMav8nh
	 i8CeO3ggbudr3q+wGeEMAUrYMRtl0s+weQEz0vSTn2KsOQwTKEqij7dE0nreduQbeU
	 z0itgQfZMfxn4cgsyjIQphAFyo4tyldsJkqTUiJnQNsDH7Ka+que+X6L/jyJwz8CSz
	 +A2z/Nt7I3fah3SXDmD5/k1cQKLZB1EAUW9/StS3ykfIG9evFpfcmK2KoVTfLSf5r5
	 Ci30IThCeZvy6BRaVRQwn9JmGy2Y4pbNBHKOkCa4xAzSfo8fmImJWk3Q+XhjTtKeZm
	 kbfJDODys+Wog==
Message-ID: <91d50a922e04c108506ab7e958d62df300ffe5a1.camel@kernel.org>
Subject: Re: [PATCH net v4 0/4] net/rds: Bug fix ports
From: Allison Henderson <achender@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com, 
	edumazet@google.com, horms@kernel.org, jhubbard@nvidia.com, leon@kernel.org
Date: Tue, 04 Aug 2026 21:30:48 -0700
In-Reply-To: <20260804180203.3413c381@kernel.org>
References: <20260730041629.3512480-1-achender@kernel.org>
	 <20260804180203.3413c381@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-08-04 at 18:02 -0700, Jakub Kicinski wrote:
> On Wed, 29 Jul 2026 21:16:25 -0700 Allison Henderson wrote:
> > This is a small set of net/rds bug fixes and ports from uek to upstream
> > rds.  I've been working on extending the rds selftest case, but need to
> > stabilize a few more bugs and the first few fall into net with Fixes
> > tags. I decided to leverage fable for this set and I thought the ports =
we
> > clean and well explained.
> >=20
> > This series fixes a sleeping-in-softirq bug in the RDS message free
> > path, a use-after-free of the RDS socket through long-lived MR
> > references, a message leak in the rds_send_xmit() drop path, and - new
> > in v4 - a pinned-page leak in the IB transport's MR teardown.
> >=20
> > The first three patches are ports of fixes carried in the Oracle UEK
> > kernel, reworked where the UEK approach no longer applies upstream.
>=20
> I don't have much confidence in my ability to review this,
> so let's queue this for -next. Hope that's okay with you.

Sure, that's fine. I just sent them to net because of the Fixes tags, but t=
here's
no rush.  They're not simple bugs, I usually end up spending quite a bit of=
 time
reviewing them too, but they're also really old bugs. I have quite a few I'=
d like
to get through, so I'll target them to net-next going forward.

Thank you!
Allison


