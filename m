Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8CE3D6CD9
	for <linux-rdma@vger.kernel.org>; Sun, 20 Sep 2026 06:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789884729; cv=none; b=XGogjt6kegcvI0Al+jmYKi9kAVbuozXK7HjTxXbprgnCzF7G7GtASXVCn4BEPGgTnhe3CrGBoxUpPlQT5lhZxJH5akUSm5w9uJ9AB27A/V2kD4S+X2lUCERv21Kz0EzqYiCizieAMSNXQv8nJbRwqHPym9Ln5Ua7yfARhwgEbrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789884729; c=relaxed/simple;
	bh=ptrUQn8sDHTppdNOsbF1xJwZe8wsOlm0BCzfUIx49ts=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MevPRd7SbXDTGPt2vBw058hpT371FgEuHWqsUofPysdQrjeNuBYk9H1bcB93bRk5RSXmU7PPzR28gv2z1mC6yElM3yAkp/YPufgFwJRzAb7HF3vPJVr35J0p1pI5BFUWTZqI0svGUYBokEUHLAqo+xPF0wRuLMwpKP2m08Yq93w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RsjpC1AI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RsjpC1AI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38A81F00893;
	Sun, 20 Sep 2026 06:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789884727;
	bh=HCS7xO6jNtuQvy/Jh1Q8yfqkkrsCMrLwED3cVocecAI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RsjpC1AIRdjiMw2OW1Ebk3pm7NnOHMe0QyLV1NC3FSvTATDSWXCk/V8U3ZAleAPSa
	 aIWL2+um5GgLC1yYtlqmcj9rVlGReoR7pScO8JrDkWOEGqV+sRA5uLYlKRnZB0f56W
	 qjY6BtersSnI8MYn3E6sbLmMnCI2B6r5f6bDm7yGpuu6NW92N1CPrxW8Knb0C4PFG0
	 nzTQNN3tHkwojZGkRs+zuG17ks6UZbzacZr+tUf3kmFLXtCc0fwBpH4YGgkEk2SHyh
	 anOsn0y72KUnKGcw7IJ9ZuFfLYnI+vWz1JoJJxPs+9YGNlFh1naDxLV3GqfbdsOE+1
	 nHXPyGvwy7uSw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 04/12] net/rds: make rds_destroy_pending()
 cover single-connection destroy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260919061149.250658-5-achender@kernel.org>
References: <20260919061149.250658-1-achender@kernel.org>
 <20260919061149.250658-5-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 06:12:07 +0000
Message-Id: <20260920061207.A38A81F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] rds: unnecessary synchronization logic based on false premise
--

commit 55cca7f8de5c5dd35f087d9e3e677bccea8d4c72
Author: Allison Henderson <achender@kernel.org>

    net/rds: make rds_destroy_pending() cover single-connection destroy
   =20
    The patch introduces a c_destroy_in_prog flag to synchronize connection
    teardown. It assumes rds_ib_cm_connect_complete() destroys single conne=
ctions
    and aims to prevent requeueing work on a connection actively being dest=
royed
    outside of global teardown events.

> rds_conn_destroy() is not limited to the global paths:
> rds_ib_cm_connect_complete() destroys a single connection whose peer
> negotiated an unsupported protocol version.

[Severity: Medium]
Does rds_ib_cm_connect_complete() actually destroy the connection?

Code review shows rds_ib_cm_connect_complete() upstream calls rds_conn_drop=
(),
which merely transitions the connection state and schedules a reconnect, bu=
t does
not destroy the connection object:

net/rds/ib_cm.c:rds_ib_cm_connect_complete() {
    ...
	if (conn->c_version < RDS_PROTOCOL_VERSION) {
		if (conn->c_version !=3D RDS_PROTOCOL_COMPAT_VERSION) {
			pr_notice("RDS/IB: Connection <%pI6c,%pI6c> version %u.%u no longer supp=
orted\n",
				  &conn->c_laddr, &conn->c_faddr,
				  RDS_PROTOCOL_MAJOR(conn->c_version),
				  RDS_PROTOCOL_MINOR(conn->c_version));
			rds_conn_drop(conn);
			return;
		}
	}
    ...
}

rds_conn_destroy() is exclusively called during global teardown
(module unload or netns destruction).

During global teardown, rds_destroy_pending() already evaluates to true
via !check_net() or t_unloading().

Is the stated premise invalid because the bug it fixes only existed in the =
Oracle
UEK tree (where single-connection destruction was present), making the port=
ed
flag redundant for its stated purpose?

> diff --git a/net/rds/connection.c b/net/rds/connection.c
> index a96569a3ee9ad..242ca0570a47e 100644
> --- a/net/rds/connection.c
> +++ b/net/rds/connection.c

[ ... ]

> @@ -579,6 +579,14 @@ void rds_conn_destroy(struct rds_connection *conn)
>  		 "%pI4\n", conn, &conn->c_laddr,
>  		 &conn->c_faddr);
> =20
> +	/* Make rds_destroy_pending() true for this conn.  Together with
> +	 * the synchronize_rcu() below this stops the work-requeueing
> +	 * sites (which all test rds_destroy_pending() under
> +	 * rcu_read_lock()) from queueing new work on the path
> +	 * workqueues once we start cancelling and destroying them.
> +	 */
> +	WRITE_ONCE(conn->c_destroy_in_prog, true);
> +

[Severity: Medium]
Is this synchronization flag actually necessary here?

Since rds_conn_destroy() is only called during module or netns teardown,
it appears rds_destroy_pending() already provides full coverage via
!check_net() and t_unloading() without needing this new c_destroy_in_prog f=
lag.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919061149.2506=
58-1-achender@kernel.org?part=3D4
