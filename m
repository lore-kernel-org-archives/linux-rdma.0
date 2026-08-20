Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA67C3C1984;
	Thu, 20 Aug 2026 20:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787256500; cv=none; b=ZkIFlT2iar3phaiQN6cpAvHiy+aCbc9dAkFe7OVjj7qRP0C0DzhcJz04nWIRUX4EAT/5Vrb+NzDE4X45CINInw7isVqCJqW0c4tgJwx877EZzGFwl04W9bySA4fY1al3vsZi54jFHVw28eFc89JTWRLsY56mo/WBJDcyHF0eCXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787256500; c=relaxed/simple;
	bh=LASZoqjW3hFIgVCWSDQhrrobFOL516RWzCqLt9qLnfA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kqaRNGE6PwTdbrQ1/d9fANpyEurCVPbu32WHHdLWTi/uwGezjfvRZFUf8dmUa8UbCgdhQVIbrH56KkKqwuMU7QXkWiGvFGDsx3zTaj1jtN5KOvkS8J+hGk4Bnei9YbV8rOkkEn7TUR2nIcWsMkkZgbnh3lXSQAwqiLGtMlGyOxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KCCQlewA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KCCQlewA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602041F000E9;
	Thu, 20 Aug 2026 20:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787256498;
	bh=qYu84t3fABADnPYtP9MVaPEECHRcbhACsJ87Z91nlZo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KCCQlewAVugu6i/lYy11Xbf976TbBsNlbivTrwKFo8uiw8MARS9p4gYdU9rEc4XLO
	 AACqMCb6CtSpRcnBoBtS1f15ACokNtOVGPQoXQwXsomHJsBcOGSQwl2BuppNbSaP9v
	 0FVFC+89xsfzQjekcBi5FJBoUEa4+v+Ur1DcdI/QdLFtfmJmRoAx+i19XJYzVhIdjB
	 etZMhO8SllYkcwJVX7ynoJQbZbVoT/2GG9OmiI2Jfk4zDdS0bqQh+YtpEyHQT8zOV9
	 OEsxJLbJT1JFHQXMuI7HlbH9sjCHOubHFH1Ltk7zi6UNDnuXDixqDgV28PkX1cuWIK
	 4isK79PdAPEOA==
Date: Thu, 20 Aug 2026 13:08:17 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: jgg@ziepe.ca, leon@kernel.org, brett.creeley@amd.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, allen.hubbe@amd.com, nikhil.agarwal@amd.com,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [for-next v6 0/2] Add Reorder Completion Queue (RCQ) support
Message-ID: <20260820130817.43317368@kernel.org>
In-Reply-To: <c565fa0c-08e7-60b9-90e9-07daa4777a48@amd.com>
References: <20260813104954.319065-1-abhijit.gangurde@amd.com>
	<20260814102413.5a26bf8b@kernel.org>
	<c565fa0c-08e7-60b9-90e9-07daa4777a48@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Aug 2026 12:35:52 +0530 Abhijit Gangurde wrote:
> On 8/14/26 22:54, Jakub Kicinski wrote:
> > On Thu, 13 Aug 2026 16:19:52 +0530 Abhijit Gangurde wrote: =20
> >> Patch 1 extends the net/ionic firmware identity structure to expose the
> >> rcq_sign_bit field from the RDMA LIF identity. =20
> > I asked for a PR, based on a tag from Linus's tree with that patch.
> > Did you send that?
> >
> > I only see a PR for rdma-core here =20
>=20
> Hi Jakub,
>=20
> I have the PR ready on Linus's v7.2 tag.
>=20
> The following changes since commit 8d3ae59288f1e7d58d76558a6ee96d533bc501=
9f:
>=20
>  =C2=A0 Linux 7.2 (2026-08-16 14:32:26 -0700)
>=20
> are available in the Git repository at:
>=20
>  =C2=A0 https://github.com/abhijitG-xlnx/linux.git ionic_rcq_shared
>=20
> for you to fetch changes up to bb23acfd05f0399f33dae000df2ef4a88787b7d0:
>=20
>  =C2=A0 net: ionic: Fetch RCQ sign bit from firmware (2026-08-17 10:58:31=
 +0530)

Thanks! Pulled


