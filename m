Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245CA3546CD
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 06:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576114; cv=none; b=OE2wTbziPFxFrzbLzU8f5CXSYWxxGGHAphr+OPhdl/TioXiKTYF+TbW0oHhQZxYDgOakN237+8hXV9mVr6NLu0fzPrzQ0kuOfEP7YXSChFPmRWbRdWSE5Ze47MB/yuJJQWo4eqn1IzJslb8dnswqmF3uyZMWN4uktc+E6YK1xRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576114; c=relaxed/simple;
	bh=FptdsE3YlZhawrllmxB2fWkGTk0G5MF3IAmsOupOib0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ptF7J/Hxo9zNnTYqznZXSNguFjnSL+9RMAlg7bm7y3APmZAz1z0P2SQDCQs00lzaETZU96tAZ+KK2orouVl7scg7Zdl2OGvwzQUC5PvBdDqicm3UJCs+zw2GYhSrs+yNOBgrd14CE2P3Uo/jZSBYyn82SwtDPVq+2lxJb4aQvOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nb2htbDn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nb2htbDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F6C41F00893;
	Mon, 28 Sep 2026 06:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576100;
	bh=HfIzizAYAvfJbnN+WqyJpksGI5QjXmOC3YRxrqxxdgQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nb2htbDnktLxTg1/ZdnysjihBNIfvqcDVtOAcLmziU6yNoAWTJJsohOKJ8pYC9N41
	 MN2kTopgD5yp+78DgXa8acPSwc/Hs0LFRVxIZ6FIvpq8clUgiADlVkF+N2k3QnNG1q
	 ZdePEilcKtzVlKJXB8q9nmgm0cS2BT8BRqhudhmU5xbdY0g3CkRonn1Owuqpo2yccz
	 HcclSBpnBxrjXWjlc87xJT/9wYQVlcpL7Jf0Ym40P59tu38lk9YYWfFHVxmtITgB7V
	 vPOPeYAeLVNYeJsFAsYHzcl+fRfyyDabfaZoA8d5eguHNa+mTQ9Bf8n10oKi9o1D70
	 fX3ilHcxES+1w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 04/12] net/rds: make rds_destroy_pending()
 report a connection's own destroy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260927061448.167862-5-achender@kernel.org>
References: <20260927061448.167862-1-achender@kernel.org>
 <20260927061448.167862-5-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 06:15:00 +0000
Message-Id: <20260928061500.7F6C41F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_conn_destroy() cancels the path works and then destroys the
> per-path workqueue.  However, nothing currently stops the
> work-requeueing sites from queueing new work on the connection while
> that happens.  The existing code would suggest that this protection
> is supposed to come from rds_destroy_pending(), since all of those
> sites - apart from the workers' own self-requeues, which the sync
> cancel in the destroy path already rejects, and the destroy =3D=3D true
> rds_conn_path_drop() that the destroy itself, and IB device removal,
> issue and then flush - guard the queueing with
> rds_destroy_pending() under rcu_read_lock() (the last stragglers were
> converted by the previous patch), and rds_conn_destroy() already issues a
> synchronize_rcu() after unhashing the connection.  But the predicate
> only tests for the two global teardown cases (netns destruction via
> check_net(), module unload via ->t_unloading).  Because the conn
> itself lacks any indication that a destroy is in progress, the
> [ ... ]
>=20
> Fixes: c809195f5523 ("rds: clean up loopback rds_connections on netns del=
etion")
> Suggested-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927061448.1678=
62-1-achender@kernel.org?part=3D4

