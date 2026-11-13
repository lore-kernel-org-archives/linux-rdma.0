Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794546312;
	b=OoJmbypMKrC5oxkZ6BWNuDk3DgHreQdR85KycQKhvNDgCzuNQLHDHsYvfoppDR7NhJbF
	 aft4m2ByXL31hODGoixFRxWxRXNfpOkzPUt5DALaqj2+ieUrEzLfQeTpuJRWZL1P4phB7
	 1cYCjhO+np7H838GNuMTAzLwTNMc6MHN+MF1787IaDeYMVorf/uHFCWn17wOZxkz9h71u
	 xn/l5cFQloAyQ+UpjM5m8mOmSR7GSF3TJEWB6kOEIjF+Lk2332bt5oMGiu2JmdgSoYJcr
	 jcdZcP4JEkdJPwqGw5K9MNsJJMWG3dvWA/omJOrBP1JnL+hL6e8rSuDlo6Vu7xyM7bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794546312;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=owI4PW4wAO/U/hNLl1F2hEHZHf+ieFLENIhPaxSPLRI=;
	b=EFP45pkzK0zCnlvlQaWMg9+JdQsn/34kFEuB+/bIzYXdR2QfPRfVQwsSi3SNLcUPxtPg
	 iCBDQe+st8ywWZRwPlpe2q3ZYAmFnvREnHGSGoK7UNx4U75vAouardkDDHV+6JodoDGPW
	 HXIMPsOIt2xO7vDLq/XDGWeC2p83tV0i4A58eXo6UoZIRmqvUMdMFZOABAZEBP4dhE0oW
	 vkmkUopbqtis2rk6WsmeAG9x5papdDmt1XTyRiS120QKa0zQnCUhbul35gbIyMfY5Tc8X
	 yWcoxzZ9dZP4SfXxXXQinNXMK4X8DWF1GRNGczT8u1ixAeMM6ztmmz/tj5d9b+0+G3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="MOPT/ky1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9CA606A31C
	for <linux-rdma@vger.kernel.org>; Fri, 13 Nov 2026 05:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MOPT/ky1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D68C1F000C4;
	Fri, 13 Nov 2026 05:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794546311;
	bh=owI4PW4wAO/U/hNLl1F2hEHZHf+ieFLENIhPaxSPLRI=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=MOPT/ky1ddT5td1m5kgtWbYwTeeqp56CQofurPNbamcElnXOBt4UUO2YnsTcl9M2c
	 GWPEhcIp+VXvWXN5rdJaeRspnxlkJ5uVxEfL5CZp5pk/0TeGCQ4L1WlRQVUpLZPq9n
	 Y54LUPNN8TdfRAf1/V0lxvm/YuwhKEUCGrDfZPk7Ugp2NCXstebu66wgsN7H7Xcwpk
	 C+q+xE+49gs9KbPTGalkhyETMZ80KKn3qK5ac078ZD8PwgSOKZh7RK2Yss0xVsTEtG
	 LPF+zbt+ps8cJM6+ZnXGZ9RZP3Z626NZHDD0OBl7fTKnOdTMjyET3IKe4/y1S3n+Gd
	 3nlLRa/xcanfA==
Message-ID: <sashiko-outbox-212190@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v12 01/12] net/rds: undo conn_alloc() the same
 way on every __rds_conn_create() exit
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>, linux-rdma@vger.kernel.org
In-Reply-To: <20261113044355.2932029-2-achender@kernel.org>
References: <20261113044355.2932029-1-achender@kernel.org>
 <20261113044355.2932029-2-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 05:05:10 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> trans->conn_alloc() may allocate transport data for every path of a
> multipath connection - rds_tcp_conn_alloc() does - which is why the
> lost-creation-race exit of __rds_conn_create() loops over all npaths
> when it frees the connection it just built.  The passive-connection
> exit right above it frees only path 0.
>=20
> That is not a leak today: a passive twin is only created for an IB
> loopback connection (an incoming TCP connect to a local address is
> refused with -EOPNOTSUPP before it gets here), and the IB transport is
> not multipath, so npaths is 1 on that exit.  But the two exits express
> the same "undo conn_alloc()" step in two different ways, and the
> following patches add another exit of the same kind.  Move the loop
> into a helper and use it everywhere, so that the step cannot silently
> diverge if a multipath transport ever grows a passive twin.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113044355.2932=
029-1-achender@kernel.org?part=3D1

