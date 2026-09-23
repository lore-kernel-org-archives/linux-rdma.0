Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617B149BD77
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 11:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790161606; cv=none; b=F5C4kcfKiTZgj08j2Cds2S60ZqzMh1FB4C6+Bl1trFGQh88auENiU8RmqWD4JTnZpfU0h43EbRl7mbz6S/1NWanSaDDoEphrj3fWoWGKxRge0Kw8qYVHOuqoZ49XSp0ZLPToG6UP626gfFGHyd6qViq+Au0hxow2NBc7tq6oHNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790161606; c=relaxed/simple;
	bh=+nlGtCCTPNNuCme4kqQUIJrDh1bzVOA0ae9x6AMBya8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PfgX7BtNXJDHxd7EAXAHXu+A97lJNonbntIPKM5Z/+1ly91IoTS/kt58R9ZiRvmhZi2XH3OiJX04dtK7cbiff8nR7gk1+umR5YHkT/aDLU8Q+8xBUa/ZoiTziovmCcpzOOltk5B+czOSbRVMhwJ64RC8MxVaOiHAB++6xU0iO58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aoTr4R2F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aoTr4R2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB4B1F00893;
	Wed, 23 Sep 2026 11:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790161605;
	bh=+nlGtCCTPNNuCme4kqQUIJrDh1bzVOA0ae9x6AMBya8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aoTr4R2FXBFHD+urKCqtMxVaIyrBm+5t7bpBQI3arwPhkZFtOFQLGZ0eoh1s9D7aT
	 Z5pKTNa+MiLID8xCjbvKm6wNW3fYt6Ca6jvjk4kBEW/C+IPL5E2WSFx7HsysAeJOgd
	 +UlQNXFd2AKPmEgJQIS+Oden4il39/qlzB6ltLGg6cFaSYIucGAcF19+Sdv919rfrH
	 a3J+NsaLBFMA8s6XGUogogJkc4kQVnOrqo+ArT+eu+szHi44MZOD6KvmYLV1pT8KnJ
	 luYUeOWFmMV+LVbBcgxUDK63gdzD49q475TQtIsHv9QWO6MjrybRy9bGjIbc4JR+Im
	 Tv2g/T7qwTAeg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/rtrs-clt: Validate peer-supplied IO completion
 msg_id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Quanye Yang" <quanyeyang@proton.me>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923-rtrs-warning-inrtrs-clt-rdma-done-v1-1-0827a9a77c0b@proton.me>
References: <20260923-rtrs-warning-inrtrs-clt-rdma-done-v1-1-0827a9a77c0b@proton.me>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 11:06:44 +0000
Message-Id: <20260923110644.EAB4B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Quanye Yang <quanyeyang@proton.me>
>=20
> process_io_rsp() indexes clt_path->reqs[] with the 19-bit msg_id
> taken from a WRITE_WITH_IMM immediate. That value is chosen by the
> peer. The only check was WARN_ON(msg_id >=3D queue_depth), which still
> lets a completion run after free_path_reqs() has set reqs to NULL,
> or against a slot whose FRWR is already gone. Either path
> dereferences req->mr and can GPF; KASAN reports a null-ptr-deref at
> offsetof(struct rtrs_clt_io_req, mr).
>=20
> Treat a missing reqs array, an out-of-range msg_id, or a req
> without an MR as a protocol error and recover the connection.
>=20
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Link: https://lore.kernel.org/r/CA+0ovCiJZz6O8LzsS9Dq1-JE1OE1L_OTA6Mr-Wra=
tpUE6jczHw@mail.gmail.com
> Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
> Signed-off-by: Quanye Yang <quanyeyang@proton.me>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923-rtrs-warni=
ng-inrtrs-clt-rdma-done-v1-1-0827a9a77c0b@proton.me?part=3D1

