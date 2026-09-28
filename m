Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773E741A50A
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 06:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790576123; cv=none; b=nXK6tZagX7v5WBKR3MyMcYAO8JwJUfTK9GRvDq0hvj4rSwaaMJnqub9Mae/5sZIH0NLz9Gn2jXBAo0WnrN1VzU8lUqdYkCR9B/qPlWn7PacOtU9POFyLFDrDS5z8S0JkzyqwRFsQtO0ILLi0fYMlOTsbx4BWlQyq6Ta2ElUhxLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790576123; c=relaxed/simple;
	bh=gpsvZD833DFuHW8uWO/dzHFiz4+MCeAY9WWCHMi9y3Q=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PjxDFEsBXBaJMmpvhYImff7dMvpM6upuKULqyZLF4eUxEQs6GYcrV/4MDE4tnNPQkOh35qbEDYDcpZwxPJIsm+7vC5BzdPX2WEUHydR5tc2jPl9lNwOIpk42dHoFL+SArpWgzIdy/bLikNdVDmcl7jSYUkHpS1AL0Q721qFs5lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FDCeOAmp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FDCeOAmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223CD1F0089C;
	Mon, 28 Sep 2026 06:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790576104;
	bh=aENPo5VsRJzr+JUxDIfmgHw89Vu60HhUdRjpC6uFVL0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FDCeOAmpQrf1Cb7gkVjDaB8sAUanngUFbxQREHN/HmFeWBR/5hCNBo1n9i/Klxd5k
	 BriS/u/BaidCG3sJK3xukFIL0ASMBrCtc3yK34ABEJYVOwlutliFA16rpysFsN9zH3
	 /QdG05Jzd6RwcUbHzJ4cbzX3BnA+EoW7DwPbg5bNPH43Ps+SkZfjHczmGCMQXKJsXt
	 W9mbtUyLYaPtszc2aWgJMx1Gzv0F5HD3o8w85CVFSbjfq8H+NpmgTNlQ4KdzEyMVuQ
	 r9okYoDOe+Fu78eow//0EfPA3GhTjquqTRnbjMXcWlcxzwLlGsfDdXeH6U9azl0bP4
	 IV57ATWowZQyA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v7 09/12] net/rds: take cp_lock to purge
 cp_send_queue in the quiesce
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260927061448.167862-10-achender@kernel.org>
References: <20260927061448.167862-1-achender@kernel.org>
 <20260927061448.167862-10-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 06:15:03 +0000
Message-Id: <20260928061504.223CD1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_conn_path_quiesce() empties cp_send_queue by walking it with no
> lock held, while every path that adds to that queue -
> rds_send_queue_rm(), rds_send_probe(), the retransmit requeue in
> rds_send_path_reset() - does so under cp_lock.  The unlocked walk was
> justified by the destroy running with nothing else alive: at every
> destroy trigger there is - netns teardown and module unload - no
> socket can still be sending on the connection, since a bound socket
> pins its transport module and a namespace closes its sockets before
> its RDS connections are torn down.
>=20
> That argument still holds, but it is an argument about the callers,
> not a property of the code.  Splice the queue away under cp_lock and
> drop the message references outside it, so that the one walker of the
> list follows the same lock discipline as its adders.  This does not
> by itself make a sender that is still running safe - nothing here
> [ ... ]
> keeps its own reference and retires it on close - so the
> BUG_ON(!list_empty(&rm->m_sock_item)) goes as well.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260927061448.1678=
62-1-achender@kernel.org?part=3D9

