Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B82364950
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 03:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791430339; cv=none; b=AIi0yszVtrkhFBDYtsPsE2K7q3aFhZC6ARtnROT3iFIchni/cSuD4QO+YWnGaWH1gwIM0mNLQx+GJ3W2GPbhOcHJiFyImkrKrTTKajadFm8xWiHL/mD8kkNeMCJx1q/BV8Dr5qSYNgqI6ksuqRufyqvgwzonF70Ft7WJX3mbIoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791430339; c=relaxed/simple;
	bh=eTeVTzyv+UnD1BoXwr9zQlWnrJ6v+PUX3qJ8lrYKXpc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=j+Dh7JVMMrkSO+JSbJ2QO/xBhDmtUhHlm8FHB67gyI9MDdZDDEEDoT+pHFp7OGqioTyzcCw1JzTTIyMq5Z4MAkdfTuOyPOZ8Cs2VZjz7vYsaxCynhDcDLOZAphhgLBk9bhQJQvVbXI4Bu1bZy85BSAYO6xvq4aQH45rTTP1R8NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJz7R1Rs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJz7R1Rs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C51D1F00898;
	Thu,  8 Oct 2026 03:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791430337;
	bh=6aJe4R21U8mh6UJX+Oj0+6rQODsCqDVtqjy9qLiJaI0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iJz7R1RsoIa6j2JWt1lokKe6ligzSnqvDU9Kz/r8e0cz61+mBKcUCyLRzvowwi+Ak
	 vFLXLAEUQsqhCRbj3LvpSHYmEudT4o1B9OCEt86zpjCV9luTA6+a2jF0pBzw1mwo7U
	 bp7Ce/2lnnSJdKiUuwukbq/fUj1IWAdJa3ilMlARnCec3EWgIxC3Mh4NA3mqyxTW1x
	 FRHybDR+JT2VdbhiW956jIzIBxOhcIa7xHj0c7EMQs4Gl/YTgktMDyub3v1E1M44L6
	 zqunu048KgVKOFoNbubH40ybjj4sjPaxpNHZiOpgfKFf4H5SXDrO/HePlOysWWP1Jn
	 w4wo76jYJ02JQ==
Message-ID: <sashiko-outbox-163547@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v9 10/13] net/rds: take cp_lock to purge
 cp_send_queue in the quiesce
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008031333.1142174-11-achender@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
 <20261008031333.1142174-11-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 03:32:17 +0000
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
> not one worth a panic, since the socket side keeps its own reference
> and retires the message on close.
>=20
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008031333.1142=
174-1-achender@kernel.org?part=3D10

