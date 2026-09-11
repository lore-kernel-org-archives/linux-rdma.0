Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811313F99F4
	for <linux-rdma@vger.kernel.org>; Fri, 11 Sep 2026 07:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789112476; cv=none; b=KxpyhZ/SZBtSeFH+1OY201RzkqHoaTRdzo6LoyIpCrcfS5J5pWD2mzwUA0gOEn8qsU6PWCF/G63SxNOc8iiV7FXdqOO2l3m/skV1hJ2+U7xTdLo5KyZLq25aPsw77YkbWNo9Vn/yX31buPAwNhL5zqKDcgiBzVT5/fndPW8uImc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789112476; c=relaxed/simple;
	bh=NTTSjBpcB4cDpoQI6orOP/2ng9wceSBZa9xJwFoj0B8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aDYEDhFLdTZX7YHewSSy7VEYaN+b0BZ00+fVZSJgeA6kVXHwonxX4kvhwOoMDHMWL3V2UGLcONzmdOzlmyQM1LadeKAH2QebX9JyQAzTBvHsJ8lG+/HWQqvCUN4+rm3GXwJ2AvOgnXbppZReZ1e+Hbs3zPFgsr7SRxw+sOVKYsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ENZ+tqgR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ENZ+tqgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4459C1F000FF;
	Fri, 11 Sep 2026 07:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789112475;
	bh=LrW7XxQ6d/89QZw7LoVMOEgumHOTvM6/9y/Udsgsen8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ENZ+tqgR5yLQ2ZQHquSFHV9HuyqZ/QPfgUOnz2EF7S3YOtr2nQ1nVu5P2LoQIPhlL
	 pIhZ6MvSLfaGbol7brwkANazMdxKjhVKB6ZMHk2nd8JxcJhj/bwue4rZmBjO/iiL3m
	 8MsOYYsqnYbRBfOQ2enpBlNrVPlJhTwZSoEoO/VBN8jVR7iXxt2iip9zmKD4lXx597
	 04ewhtLuH4Ywn+XCbLfMTGWD4JlMWLU3sfjg5o4J5AtXFtpKnfjjEfs3mkKiV0nqna
	 XDB3dwthpBJxM2F6fWus9aLafj1C7KYtDjF6rhI4UvqygsszupLQlwLG/RWl7iIRJB
	 QARWk7/XXeUJA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2] rds: ib: use rds_conn_drop() on protocol version
 mismatch
Reply-To: sashiko-reviews@lists.linux.dev
To: "Aohan Mei" <ljp1205831794@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260911073436.3542080-1-ljp1205831794@gmail.com>
References: <20260911073436.3542080-1-ljp1205831794@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 07:41:14 +0000
Message-Id: <20260911074115.4459C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Aohan Mei <henrymei@tencent.com>
>=20
> rds_ib_cm_connect_complete() runs from the RDMA-CM event handler with
> conn->c_cm_lock held.  When the peer negotiates a protocol version
> older than RDS_PROTOCOL_COMPAT_VERSION, the handler calls
> rds_conn_destroy(), which is only safe in the rmmod path: it
> synchronously tears the connection down and flush_work()es the
> shutdown work cp_down_w.
>=20
> That shutdown work (rds_conn_shutdown()) needs cp_cm_lock, which is
> the very lock the event handler still holds, so the flush never
> completes: the two workers wait on each other and the RDS connection
> workqueues stall for good.
>=20
> All other RDMA-CM failure paths (REJECTED, CONNECT_ERROR,
> DISCONNECTED) use rds_conn_drop(), which marks the connection
> RDS_CONN_ERROR and schedules the shutdown work asynchronously.  Use
> it here as well.
>=20
> Fixes: f147dd9ecabf ("RDS/IB: Disallow connections less than RDS 3.1")
> Reported-by: TencentOS Corvus AI <corvus@tencent.com>
> Cc: stable@vger.kernel.org
> Assisted-by: CodeBuddy:Kimi-K3
> Reviewed-by: Allison Henderson <achender@kernel.org>
> Signed-off-by: Aohan Mei <henrymei@tencent.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260911073436.3542=
080-1-ljp1205831794@gmail.com?part=3D1

