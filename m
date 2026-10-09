Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6794E56CC
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 16:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791564064; cv=none; b=J7hr7aXjsxxVKeZi0EDHG6WoNjlWaXPzPHJ1MmkaJ4uJDupIyvxGIdc/3fl2r96RNr4ekhliVDa3ICMPphX4aeyswchi8yPIRrEsI4YX2S2j/k+fXhPOddktHx0vvP5UFnTAVtJ/4lOZ7sBhVffKg1AChewA9LSWlUOgyO89DVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791564064; c=relaxed/simple;
	bh=/d6R3Ud6Mak4l3ErzKkTGhxSpTvn0DUfeSqA9TAQH/k=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=BITnlhHTU5m3Y0XXcgiTu5GJOqDahqOd8VuJ7ZH83PlmEQTB3tbP7VIDynQTV7oXrnJpIO/aeF71gflf3f46PEHmOQ4n6KEbz9PnvrX4J1/Pu/QE60Zj7D9gdUoNu2FJgdfT/YEmzM0Roof9mUeBYPTGZ4t0zagOrnamKACNWx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HtTbmTYp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HtTbmTYp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 770161F000FF;
	Fri,  9 Oct 2026 16:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791564062;
	bh=TQCp5ACZ6JgJOy4P7XXhavN4ZRK7qx9hJwK+JutxyT0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HtTbmTYpHhqB0YF3j2ndKObVN/CZ09a54DwkxqbAER7bBvqZymuQ8NtQVXNYCdRBV
	 bkG0na5eb59mva2OCP0yJIyaSl5l42QpPKWayBspMxor5oWevQbpxsj7p1SrK1WOTc
	 RNHfDGXiieZZ0wkjf2u2lqQlZc2RIeUAMjV61gSdz65CbPJNTi0GjeLDl/pqXWtZmE
	 pImKmamXE7eVdjKyx+4/L0aOndTlNGh02f/Bn5T2P+UDcyQluKyRUKYRnAtsTLADOx
	 mtE84XVlNJmBhiT25AKjjZTk4jR8Nzun2q/EyQe33iLPDWrYTrOvabAUE1VR6GJxzK
	 J3vuU/F1iqyPQ==
Message-ID: <sashiko-outbox-165841@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] rds: fix out-of-bounds conn_path walk in peer gen
 update
Reply-To: sashiko-reviews@lists.linux.dev
To: "Henry Martin" <bsdhenrymartin@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008164041.961961-1-bsdhenrymartin@gmail.com>
References: <20261008164041.961961-1-bsdhenrymartin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 16:41:02 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net/rds: race condition in rds_conn_peer_gen_update causes sequenc=
e number reset
--

commit 717052475aa8589026dc0030beaf8862f5697d69
Author: Henry Martin <bsdhenrymartin@gmail.com>

rds: fix out-of-bounds conn_path walk in peer gen update

This commit modifies rds_conn_peer_gen_update() to bound the loop over
c_path entries. It checks whether the transport is multipath capable and
walks either RDS_MPATH_WORKERS entries or just 1, preventing out-of-bounds
memory accesses on IB transports.

> diff --git a/net/rds/recv.c b/net/rds/recv.c
> index 6204e577a90ae..afc810a2e3cf9 100644
> --- a/net/rds/recv.c
> +++ b/net/rds/recv.c
> @@ -144,7 +144,8 @@ static void rds_conn_peer_gen_update(struct rds_conne=
ction *conn,
>  	if (peer_gen_num !=3D 0) {
>  		if (conn->c_peer_gen_num !=3D 0 &&
>  		    peer_gen_num !=3D conn->c_peer_gen_num) {
> -			for (i =3D 0; i < RDS_MPATH_WORKERS; i++) {
> +			for (i =3D 0; i < (conn->c_trans->t_mp_capable ?
> +			     RDS_MPATH_WORKERS : 1); i++) {
>  				struct rds_conn_path *cp;
> =20
>  				cp =3D &conn->c_path[i];

[Severity: High]
Does this code have a race condition that could cause sequence numbers to be
reset during active transmission?

When a peer reboots and establishes multiple multipath TCP connections
concurrently, handshake pings arrive on these paths simultaneously.

Because rds_conn_peer_gen_update() lacks connection-level serialization
across paths, multiple threads can evaluate the generation number
simultaneously:

	if (conn->c_peer_gen_num !=3D 0 &&
	    peer_gen_num !=3D conn->c_peer_gen_num) {

If Thread A and Thread B both evaluate this condition as true and enter the
block, Thread A might complete the reset loop and the path could resume
active transmission.

If Thread B is delayed or preempted, could it then execute the loop and
reset cp_next_tx_seq and cp_next_rx_seq after Thread A has finished?

This would break sequence monotonicity and fragment reassembly, leading
to packet drops and connection stalling.

Furthermore, is the update to the connection state protected against
this race?

net/rds/recv.c:rds_conn_peer_gen_update() {
    ...
		}
		conn->c_peer_gen_num =3D peer_gen_num;
	}
}

This unprotected write to the shared connection state doesn't seem to
prevent concurrent threads from observing the old value and incorrectly
assuming they must execute the reset block.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008164041.9619=
61-1-bsdhenrymartin@gmail.com?part=3D1
