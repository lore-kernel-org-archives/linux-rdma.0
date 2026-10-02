Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D883CEB8A;
	Fri,  2 Oct 2026 21:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790976372; cv=none; b=LvuI1hFu8Rq9wD2quCfwOO4+far0/YyTbsDVS1KLrmJP7HYiPtxlyZnjPIvZl5OdmdfIf3fCw0lZRYy349/GOg+K5U1aVD5BtwiC3o7q+Z4xelwZpJZIwzVn7QWJt5wKrQ/8pR65lEx0dSAoxftR19FPqO76dVY36wI4biplWXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790976372; c=relaxed/simple;
	bh=pyHpraHWilTeDvUj8qS7k321StcntiuhpbLLRW1YN9Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YiskOXBZFR8MTFcigFlqeK4aFQEvjoPjfrbv5BVwEGAHQ4rw4DiVAsZHwHiCGdmgdc2mIt/Rhu566u4ebxkoJhYqd+0IGYpquioml/kKgUBkcO1sOn7RJqdX0cSwoVu00ljxJGPI2Bdj7pRRx5YRhRlQzhPoKr1MKCdSn+7O3yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gKABbKZg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gKABbKZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043BA1F000FF;
	Fri,  2 Oct 2026 21:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790976371;
	bh=aSKbPdjM64u70nK3WMIOZcgPuH7/WnN9NA+UV8a7m7Y=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=gKABbKZgkFUVSGL4C3JpHvWP65aozSlc8EvOzq5W7DHNnqynirNWLTg5ZXki0z//k
	 CbYjf8/+dkrmNEuY0P+yucFEv1Di+ASLNJ+EPH+uRCijojV4TASXe1xfe+9zWI2ecX
	 3TyjvyI7CyEQy7miOfo2aaQsKJTPStD0+6obtjcDkdMlQk5SL+op4/mLkVyPj5Hmpq
	 O/IB8n0Ic3sqv1yV6u/pSlvg5vM5qXMUwJuaLnrw0G2XXC9e8vHnOHmTfpGou5E0uR
	 LIewnpkzDonTRTlgh+5ktuv6fyEgKOzQNbd5i2bL1mF3aA6V7+lxPbiDruZVISAM3H
	 dFa5o8DQO8GBQ==
Message-ID: <3c3dd818b2b720c5d2c91450b87c9833ed6b3597.camel@kernel.org>
Subject: Re: [PATCH net-next v7 00/12] net/rds: make connection lifetime
 reference-counted
From: Allison Henderson <achender@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com, 
	edumazet@google.com, horms@kernel.org
Date: Fri, 02 Oct 2026 14:26:10 -0700
In-Reply-To: <20261002123700.48b9540a@kernel.org>
References: <20260927061448.167862-1-achender@kernel.org>
	 <20261002123700.48b9540a@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-10-02 at 12:37 -0700, Jakub Kicinski wrote:
> On Sat, 26 Sep 2026 23:14:36 -0700 Allison Henderson wrote:
> > This is v7 of the connection-lifetime set (v1 at [1], v2 at [2],
> > v3 at [3], v4 at [6], v5 at [7], v6 at [8]), following
> > "net/rds: own the fastpath locks across connection teardown", which is
> > in net-next.  It is targeted at net-next: although the series fixes
> > real use-after-frees (one syzbot report and one report from Chengfeng
> > Ye below), it does so by reworking connection lifetime rather than
> > patching the individual crash sites, and that rework is too invasive
> > for net.
>=20
> More changes coming / planned or is this good enough?

I'll send another v8 that addresses the review complaints. I've just notice=
d that the sashiko reviews come in two sweeps
now, so I wanted to catch both before spinning another version.

Thanks!
Allison

