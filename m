Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B55442FD3;
	Mon, 10 Aug 2026 19:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786390861; cv=none; b=oTx8WUwtGRnNSQo+f7dcXdEG43tr8+iMvcnoum4nrS/HrQAvuf0nE63cAp7Opk9iDr2DgkOKsEOM9HtRwQHhGPQGSvOakkwhwaSQfdg8QjSjOG2SFMZBShcZ9fdGEX6n5cuGbj5YeljcW3nUK+eeCLFlOTgA+2hbjh0ESQ3/vgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786390861; c=relaxed/simple;
	bh=QfT241+xV9dXIELDl32SsiKe2QwmWPyUddangv7rsXo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gkmt2U2Q7Cp9e3I9ih7RGuCnO8IdDldVtQWsgNjur/AHjubWcYcbGB2rqtugtoCkUI1xq6nVVg4OooZ2GV0Ye0v2RiY9Jvl22rgcp4q4t2U2zqcfZBovWNeeAmkJtZugLS+aXYMPhrL5umRT7wlpi44xtMdr5JTuVzQxvvj8qMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LOoKrRiY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LOoKrRiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF201F000E9;
	Mon, 10 Aug 2026 19:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786390858;
	bh=aQkbAL8gDFRxpXIIle+bm2wnXM0lq6rIv0I7IeHxRts=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LOoKrRiYuDgUfvBRlZ4LwZbOfjNQeTCquT58/+SCiWtzUlO7Pm0sAMjtC0i4Chvey
	 rDhUlVnfXNhfG3oJaRFwr7DOiXl0bJlyyzVAasYb2FdUuRTSLii0fH3dTI8TOF3t0Q
	 9XqNyxp2KIbMwjtCZ4s9+hvDj0bVXGV5qQ+Hpy/NbPPcW7tZvOGnitOs+YNQ8s95QF
	 d0nMri9FbdSbVw6Ggqc5RbQ6qKIDDtLJTRFk/BxYqgjhHnniaBNvruhP9SDD2h4USF
	 8F2RiDbWegBBBDZoS6TPkmVDavKW9k8CZhHRrqXL4Ei2Xi1vUeyPAd9Y++rIcFA0kL
	 cUqINYnzLeVqw==
Date: Mon, 10 Aug 2026 12:40:56 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Stanislav Fomichev <sdf.kernel@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, anthony.l.nguyen@intel.com,
 przemyslaw.kitszel@intel.com, andrew+netdev@lunn.ch, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, maxime.chevallier@bootlin.com,
 mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
 aleksander.lobakin@intel.com, horms@kernel.org, magnus.karlsson@intel.com,
 maciej.fijalkowski@intel.com, sdf@fomichev.me, ast@kernel.org,
 daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
 alice.kernel@fastmail.im, dtatulea@nvidia.com, witu@nvidia.com,
 martin.lau@kernel.org, yoong.siang.song@intel.com,
 rohan.g.thomas@intel.com, intel-wired-lan@lists.osuosl.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org, leon@kernel.org
Subject: Re: [PATCH net-next 0/3] xsk: pre-existing AF_XDP TX metadata fixes
 from Sashiko
Message-ID: <20260810124056.469fc9a4@kernel.org>
In-Reply-To: <anodof8GsDZHZb-S@devvm7509.cco0.facebook.com>
References: <20260810184753.135756-1-sdf@fomichev.me>
	<anodof8GsDZHZb-S@devvm7509.cco0.facebook.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 10 Aug 2026 11:52:01 -0700 Stanislav Fomichev wrote:
> On 08/10, Stanislav Fomichev wrote:
> > A few fixes to address pre-existing issues from Sashiko review.
> > 
> Ooops, this should've been targeted to net tree. Will resend in a few
> days in case there is any review feedback.

Please make sure you look at the Clashiko review before you repost.
Looks like it got kicked off already so let's not waste it.
