Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECCD42BC23
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 22:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792017558; cv=none; b=BoKY0FXd9HKiHy89jLHIxWc38Y6qMEjA03QS6KUU19qbbfxUVYXrCFLwFllfj/rQ9bX3WtF2SSqVeiQLCF0Di+oB73phoyj8mD9qPxbTkfFca96wiNcgFhrJdaUSiEMe48luxpAyLNdavoWjXOHyBgR6/if6W9nnz9ARnQd/kyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792017558; c=relaxed/simple;
	bh=zZGbKc2Xk60aeAH8mGHPn3qhDHn5s270lgRicKRYxxU=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=UROfos0lbCjYEW2YVdUVPeRDcDBvZzjHpf1okGwqNzaeuJPZtlF+UKC7RPuqs/HbHu+jJczmOeQ27LbMWFKpEfftumc8d+zEQi5EIvm4XEcDzA7RkzxSHY/HM2jTf6c78GpBmwDwVzF2tb7S1cJSOE9np5CmRP9p+8Y3TAhQgec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JOX7AUwR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JOX7AUwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505A11F000C4;
	Wed, 14 Oct 2026 22:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792017557;
	bh=zZGbKc2Xk60aeAH8mGHPn3qhDHn5s270lgRicKRYxxU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JOX7AUwR8vFcDmeMrvYKytyHnz+hoPQyzZj616s77taCgGYinIqJPM83PcKRw/Rpr
	 uPd4jj/r7mYkfW6PxgggVXAiAFBLwOg2eD7XQi9OlTpUSZtp5EGXmaq22fdDCasD2E
	 llSg4QsBgzB5mRjT4Ypk6TftuV850FQrz66+HqD3OWDnB2AJmn3lclEK9dbIeksU/c
	 cq+WrHjBrZdANfd8Rao7VPXxVo3iHGvseaAmWH0X5z4MUDI43IHnqoKRryqdhkbXJY
	 JmSQoLfpreU5qwlPHLIb5PLAf92j/DKALZFnVfPjjMbtQIhPgMqHfuQPPrkI1/WB0n
	 mR+5IUm4L+j+w==
Message-ID: <sashiko-outbox-171983@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 09/13] RDMA/core: create a queue pair ready to
 send
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014-uet-ib-core-v1-9-a0e626117113@broadcom.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-9-a0e626117113@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 22:39:16 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> Some transports have nothing to negotiate, so a queue pair can be ready
> to send the moment it exists and the modify sequence carries no useful
> information. Let a reliable unconnected queue pair be created with the
> attributes that sequence would have supplied, in the same form the
> modify command uses, and apply them as that modify to RTS once the
> queue pair exists, so its checks run. A queue pair whose modify fails
> is destroyed.
>=20
> Note that the QP handle field is refused, since the create is what makes
> the handle.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014-uet-ib-cor=
e-v1-0-a0e626117113@broadcom.com?part=3D9

