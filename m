Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794546315;
	b=SZNFTITuvLbGPuP6M+55V0PMfdjpWDouXdB7YHAluIJ0AxT0BPV7floK4vKdpP8RIiWN
	 Xlod9m8jYDUDZGx4h9+NsTTGzTWPUUObwtI3HPL7v0opIL/qNbcZyILajCOG9Ao3wUVey
	 yNgi0Rx8iVlfcsD9r4Iu6O5A5J4HLVB/XYSWZZACqgDXilgBB1WrZlrxc2kZ8hnpV8lFQ
	 v+4tn8rxm5CFZfxrD6HHGU3hbOsiLb48fXz8npOFEvxITjJ/Kael97VfdrtL8WzfUPsjR
	 4DpR3QpUQxM41LmryAVtfmNHvXiWsu8wProyxvGVIJqt10Q6lLWsP7TRtPmzgNcOevw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794546315;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hl4IWQ+0Psh6VKiep5HELh+2VcvqS1vXQ4emgjFDwjE=;
	b=LvbQVkbGw/LtTsk0Rtnqi7k9fGX/6DjXMC3SPF7r3MK4udUgbekHJ6/L8opN167yX7b1
	 nd86R+NB/2MhNWuVcGm9q3pWqAaZmAB4xlYpZUY+e3TreOMThsS/7KuQytbk9iAggHHIH
	 /+ej6E4Ts0GmIcfoWOmkxDq6vN16n538fp0fnBUEnaJz6tb1BqgDHIq9ymCy55TH1Dexc
	 pqc+RTWwCu3PB6848qTMA483//Iz+k4eKZGiNTaYqylD0D0R1+FaTPemp3eeC0FJqgcTY
	 kVjDRMgH7UIKgT1DPcncszfk5MPJpnVi4R+bz+BrT2EpO8N0NUVlu1bvN7kCIfLhEQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EigHMKF2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23805606A327
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 05:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EigHMKF2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E01981F000C5;
	Fri, 13 Nov 2026 05:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794546315;
	bh=hl4IWQ+0Psh6VKiep5HELh+2VcvqS1vXQ4emgjFDwjE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=EigHMKF2xGk5axTjU00PCOgVJLDlR3rdiImpX7qKbUG/Vh5g3fOwhcalh3OvAjWVR
	 Dk97zTmGdZMSjUYnKUE3RXO+stN8MC72fWkvcg3qrD4Z+djQpKtPim7JRL5nDN1D+x
	 Bf43fD8AvXy+HsJ/peAX5FI71mZG5HZIfSrwmlM0FJ2o4O9rbB8LP1Nr8alY+pew5z
	 rCU5Yp1svmu0cnE6fPbBiG+u/6yztoRLmcmr7dbbtoTD6IwMfBuBYqqlJmNOFyHUh7
	 VX8y1QR+vfQBBRZFNwVUbQCYhaezg295Ch0VIhBiJT0hoYlVn6nELLEzMZBv/K6L4I
	 RONmRBppZIAXw==
Message-ID: <sashiko-outbox-212196@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v12 07/12] net/rds: wait for connections to be
 freed on transport unload
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261113044355.2932029-8-achender@kernel.org>
References: <20261113044355.2932029-1-achender@kernel.org>
 <20261113044355.2932029-8-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 05:05:14 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> Since connection free became asynchronous, rds_conn_destroy() only
> quiesces the connection; the actual free - including the transport's
> conn_free, which lives in the transport module - runs when the last
> reference is dropped.  The transports' exit paths destroy all of
> their connections and then proceed to unload, so a free that is still
> pending - once the following patches hand out references to lookups,
> sockets and incs - would execute transport module code after that
> module's text is gone.  At this point in the series the initial
> reference is the only one, so the wait only has work to do for IB,
> where it also catches the late arrivals described below; the
> guarantee becomes load-bearing with those patches.
>=20
> Count each transport's live connections in t_conn_count (incremented
> [ ... ]
>  place of UEK's wait_event_timeout() + WARN_ON(), plus the resweep for
>  IB's asynchronous device detach; also cover rds_loop_exit(); rewrite
>  commit message]
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113044355.2932=
029-1-achender@kernel.org?part=3D7

