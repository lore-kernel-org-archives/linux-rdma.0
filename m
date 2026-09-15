Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8281A426431
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 03:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789443462; cv=none; b=vFnJwfxISJ0njBZ5ePvIf3GzXS0xKSWtctj6aRoU0ZgL0AUgzHLes/fTP2RF/K6bdOZmaa+UqMlVkZOYSwYwcjRq7Pfw/eIWx2Ntvzvtu1eAlWQI2dv82DvpSl/H/knjDGcimxWN3SM4AX9wfKCa/vMdOmxz3pwWNJMLLZJGh9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789443462; c=relaxed/simple;
	bh=/X+tV6wlZOaC+6yMSY8wJNzlkdgZqk8GBGTUH4R6I/s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KpKc8CX0LmWPWEozqFVWbCWU174jAvqFx6tV2uMg5094tJSIbxa0rxezAJrPGKqYUttCHWO9gkxog+0kbwLxYRPawC5urLlyRejafNJ6RaklFMEwPEdCUc0yUAOeANm7RTlqlHSNn6rd+I3rVp4olzrOBSrVzGFC4DNN0p6lp0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sr8v5QkT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sr8v5QkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E571F000FF;
	Tue, 15 Sep 2026 03:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789443460;
	bh=jEPq2MFJezGWrkQ+CBQKI5BQRFL4yxTl9tLX8dhbANE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Sr8v5QkTK3rqfzfIre4oU3PWWHSXOG5DlE16fd9n8GPeA/rD+lvWR17Q/kISM1ZID
	 4YCzIoNKM5vO3tt0jTeK7Ux0349Xy4w28Q3rfEZR6xMZH3pLBBVSM6Gfr+CVEG/Dnv
	 sdcKoUePTZWCuti4DUVRzDvGu9IGz4l5jy3e2ExyLCDSEjdFQvh3pCw88vF+P57+pg
	 UP/7i5kHWPNr+R4DOx9iqdrK+/usu6Q2OqB0x7zQTMS8LMS8noxPgCXSBBRSp+cQCh
	 VbfveYmUXTpG4lZjNHpxocRihf0r1LbQoDqom+LXgOpwRz/wmXkT3y/3ZWxfD4P+Ot
	 930JJJzwAEnpg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 11/13] net/rds: pin the connection across
 RDMA-CM event handling
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260914033719.138057-12-achender@kernel.org>
References: <20260914033719.138057-1-achender@kernel.org>
 <20260914033719.138057-12-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 03:37:40 +0000
Message-Id: <20260915033740.54E571F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_rdma_cm_event_handler_cmn() picks the connection up from
> cm_id->context, which carries no reference, and holds c_cm_lock - a
> mutex that lives in the connection's path array - across the
> transport callbacks.  Now that a connection is freed by its last
> reference rather than by rds_conn_destroy() itself, a callback that
> drops the last reference other than the handler's implicit one leaves
> the final mutex_unlock() running on freed memory.
>=20
> Take a reference for the duration of the handler, and ignore the event
> if the connection is already being freed: its cm_id teardown is what
> stops event delivery, so an event that still arrives belongs to a
> connection whose shutdown has run and whose memory is on its way out.
>=20
> rds_ib_cm_handle_connect() has the mirror-image hole: a connection
> whose destroy has already quiesced it sits in RDS_CONN_DOWN with no
> cm_id, which is exactly the state the DOWN -> CONNECTING transition
> claims.  A connect request arriving then would install a new cm_id
> and QP on a connection that is only waiting for its last reference to
> go away, and nothing would tear them down again.  Re-check
> rds_destroy_pending() under c_cm_lock and reject the request instead.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914033719.1380=
57-1-achender@kernel.org?part=3D11

