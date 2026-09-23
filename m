Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7D746D547
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 08:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153670; cv=none; b=DX8+bEpnH7GHdVreR5UD2B1Yn1vc4MOicF4muaWjj/Q/E+OExhLNKH7pJIeMPeRBIuZvF1KlpbUxYWYgC7LJ5UcS+qHxyU3Osv7IFnVzVxL8B4YVXA0DcrBYOyFRxsF1PXhdhAYh+Pt6eH5t9XkJPy+TbM79Ge3M1R1B6axgfVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153670; c=relaxed/simple;
	bh=764x9wqEt2l2MCXHVe7GNHBLk/YoCUZTpX8vpd4eVD4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=d+m3SFFuSritZDz/vKu4DGhcwIZRC5MdDHLX/OzvH8OE6aPaYo/Ty+HZWMhMRK7GsWH+Fr3LpRQsBMchlwMkBqYVRDcjNcHJxPW+Hd8xuhzYNc9kjROMmzkv/PMFuFxRqD1Gx3hT8ckJAZu1kLX19jXWwUPNXgQAzmNdmm1+uJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C8sa0YdA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C8sa0YdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D781F00893;
	Wed, 23 Sep 2026 08:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790153662;
	bh=UW37Y8iCyhlGvDtJ9+M516jItLmABo8RJKJhdJroEk0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C8sa0YdARmLgsuMoSoMSAVtFdN3YCmTmavZxzFRSNBnEWl6fRyWcJHju4qUnwhfRL
	 MayZL5HzT+VKN7D4pytCfVHGWmy9NkDTPutHEHHxdEeTmhevUaWq4shDJFyKEV9CgU
	 3BT5MHNKaG9GutYBKQl+dZnQexiwx3VpARhdCsDd0iTPb8DPTIGM5Z1LSVjEZF5sbH
	 U0ohfGl8+pqmJkm30lakNiYGOWSVCq4yr+JDQlXZ8iKWTb+L1Y1XX+v9H5mQTQ+00+
	 hN1Xf9ATI3xK+87biBYoHCvselxLCG4bvkWh1favR+lkwXcyHeyIi9pA5h3KjbMOKN
	 FvXCi6HnSbbVw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v6 04/12] net/rds: make rds_destroy_pending()
 report a connection's own destroy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922085410.391323-5-achender@kernel.org>
References: <20260922085410.391323-1-achender@kernel.org>
 <20260922085410.391323-5-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 08:54:22 +0000
Message-Id: <20260923085422.77D781F00893@smtp.kernel.org>
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
> cancel in the destroy path already rejects - guard the queueing with
> rds_destroy_pending() under rcu_read_lock() (the last stragglers were
> converted by the previous patch), and rds_conn_destroy() already issues a
> synchronize_rcu() after unhashing the connection.  But the predicate
> only tests for the two global teardown cases (netns destruction via
> check_net(), module unload via ->t_unloading).  Because the conn
> itself lacks any indication that a destroy is in progress, the
> predicate does not cover the destruction of a single connection
> outside these two cases.
> [ ... ]
> missing pieces of the requeue guard, which stand on their own.
>=20
> Suggested-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922085410.3913=
23-1-achender@kernel.org?part=3D4

