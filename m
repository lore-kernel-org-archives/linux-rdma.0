Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F83F374E42
	for <linux-rdma@vger.kernel.org>; Sun, 20 Sep 2026 06:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789884726; cv=none; b=MTHcSEInYb9Z1HV6ZnUCSvuMtsc4zuYtmwVm5GKPZRiyd/2je2X/PAoxUO+CrUkyNLqNHnk0k0wwSNELmfjgPAjJSmw9pZG81BO2Dd06pyq8DnkP14+gA26EAbesYCNgtEZtC2etakqPWmWMImcUfhDmYvSYCaNgds5uvTePf58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789884726; c=relaxed/simple;
	bh=pywVlpYbaY6kstskcA+FmZ1QOemFC9RBXn8wR+bwe3k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ORObSXuu9tDPTYC8VcjeVRUGm0Uh8GNqzm8kP2km3KrJoQ8EKV/7Rj2B3g9CsnQdpwSefwCRyKg98J0lIdArAXg2CnqmZxZ+xKRwZn7eHwwtqxhhO02jI7H6WeKlY1WKt1LSJkzMMNGUsCMJ4kAIAtackE60LR6woLvlum+/064=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYTWEeQy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYTWEeQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3071F00898;
	Sun, 20 Sep 2026 06:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789884725;
	bh=VoN/Juw2R8mBBNfeKPBq4UR3jRN76h8JrouziDSNgIc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RYTWEeQyn1Xko+iv+9iqNSMzAVQuh9ROtZeGoh4574iazKNGI16NYGyZneoemBGsr
	 1Gmv0K7RO1RVNeyupvFGqiywbFj6CrLokNePYw2ciLAFYZGtOQtJPMinSGfXQgVee3
	 GUlp0NFRMb91WsjW7DYNtImmPeaex84RCkg2Sp4eIbC5OhahZUriS0WadNpx/+nGcV
	 0OucIq0JjltF1Aa3kU5h3zH8z/Ba4MbSfaogJCM4jbw8jEIU1OFSf3vI6PzYoeqEm4
	 opFhMOeplNxlv9PjGEV+iGRLACjqau0nH1tR1igMftlskKZnlfmaWdlXIoPoBlkahe
	 WsDDAsV5kpdqA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v5 07/12] net/rds: unlink transport nodes
 before a possibly deferred connection free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260919061149.250658-8-achender@kernel.org>
References: <20260919061149.250658-1-achender@kernel.org>
 <20260919061149.250658-8-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 06:12:04 +0000
Message-Id: <20260920061205.3C3071F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> The transport teardown helpers - rds_tcp_destroy_conns(),
> rds_tcp_kill_sock(), rds_ib_destroy_nodev_conns(), rds_loop_exit() and
> rds_loop_kill_conns() - gather the per-connection transport nodes onto
> a list head on their own stack and call rds_conn_destroy() for each.
> The node is unlinked much later, by the transport's conn_free():
> rds_tcp_conn_free() and rds_loop_conn_free() list_del() it, and
> rds_ib_conn_free() does so unconditionally.
>=20
> That is fine for as long as rds_conn_destroy() frees the connection
> before it returns, which is still the case at this point in the
> series: the initial reference is the only one.  The following patches
> hand out references that outlive the teardown loop - a socket's
> cached rs_conn, an inc parked on a receive queue - and with those, a
> conn_free() deferred until after the helper has returned would
> list_del() the node from a stack frame that no longer exists.  Make
> [ ... ]
> what keeps rds_conn_destroy() from being called with the transport
> lock held.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260919061149.2506=
58-1-achender@kernel.org?part=3D7

