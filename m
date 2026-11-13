Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794546312;
	b=Mk087KOJDfsqvnBuqaSQ7Ajyg/USZlUMKg3cvkK6MMmN8ETvdx3AzKTpYedHFT+sTsjn
	 kdMzr7LmS3cxubOw68y0HdW+OeCSV9FM9rUQGXTLD/VndZgXI1DTr0rf6kxHD3rYXeDvP
	 lBliImTwP1UnIwe7KGpK8yP4BMZyJJNOT+ohLxs8W8L3S3imrcO1Tx7T7lLlAryY8v7/a
	 p3MRP9vf5jjCeTofdEagyNkG9xx0HcipIpMslT8PlwA77NU3HkVyvSyAuAh6gyby4YflN
	 X9+axolih7rfbvesC+sK9BNPUIH290yIRP14C7r800SBDBpTJn1+3hLHP8/xeSgGobw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794546312;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Edag5sPpTqbn+hCE/jogNpDfEZUXi3jkUNZRnVgH3xM=;
	b=EfTbeXlK+cXKm1m6l19p7HaWhQchAaDO0cHSPrvLQ8o88rNhe3psjy4tzLeqznOId1Kl
	 Cz6kg9ju3QOO32/tuaj+Ico4XykClk47/T6Dhj2xmPf9q4iwAEx4rHcqt9pOcQgD58sAa
	 oHxxKEMgqqUGjYUM7Ky3BXqFiKABUOAYUfxcF4MgNIISDjj0v2RMFJNEDKaLXT+GcK/Pd
	 SIjp9SzdYgcG8P1jZrqfmvyOb+4SNMoCpqyv1x7fOBXPLi9xQfXJA/h8Iuvk/Nd+Xnlov
	 kOQXwEs7Y8voC+osy3kISB7GtFQ85dz8XLLf6n4f64z/MNedr456lX4WZqnXkhZw+Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vey9gaKE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FB9606A323
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 05:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vey9gaKE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FD71F000C5;
	Fri, 13 Nov 2026 05:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794546312;
	bh=Edag5sPpTqbn+hCE/jogNpDfEZUXi3jkUNZRnVgH3xM=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=Vey9gaKEd7xhtefSrY5PkhmeoQcRks/Om9ybEHbWWGJph0a8iPqiFwT6JpnbCNCTN
	 CvYxoEGJJpERx6/BFB2XhY6GNFfiVVqRUquU3iRyb4DXPkmsMpgcbA6u+22Y9eTr3w
	 ABc5I6wfqa0/jTzuv4KwSlsSZoz9HWq3oPfEiUr2vNrcu5kBnXC3BI5HtdbYUIiXhT
	 56tuwxm48mlvghVRx7btxyEETsb5IZhqcO2vUHQjyuLmQDFbD4dwlWWhcF3piQNCWP
	 wJpODe2LbakW+5kjq2LAu8ggA5hKymQ2OVp8P8BAc1rgEvi0xXo8qaLG+IvHCFskEo
	 QQ2A17wKK0c5A==
Message-ID: <sashiko-outbox-212191@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v12 02/12] net/rds: ib: refuse to attach a
 connection to a device being removed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261113044355.2932029-3-achender@kernel.org>
References: <20261113044355.2932029-1-achender@kernel.org>
 <20261113044355.2932029-3-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 05:05:11 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> rds_ib_remove_one() drops every connection on the device's conn_list
> in rds_ib_dev_shutdown(), then clears the client data so that no new
> connect can find the device.  A connect that is already past
> rds_ib_get_client_data() when the walk runs is not covered by either:
> rds_ib_setup_qp() goes on to rds_ib_add_conn(), which moves the
> connection onto the conn_list the walk has just finished with, and
> builds a QP on a device that is on its way out.
>=20
> On a hot removal the rdma_cm still catches that: its own client
> removal runs after RDS's and delivers RDMA_CM_EVENT_DEVICE_REMOVAL to
> the connection's id, whose drop shuts the connection down and returns
> it to ib_nodev_conns.  On module unload there is no such event - the
> device stays registered - and rds_destroy_pending() is already true,
> so every drop short of a destroy returns early.  Nothing drops that
> connection then: the device's shutdown walk is over, and the
> [ ... ]
> rds_ib_add_conn().
>=20
> Fixes: fc19de38be92 ("RDS/IB: disconnect when IB devices are removed")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113044355.2932=
029-1-achender@kernel.org?part=3D2

