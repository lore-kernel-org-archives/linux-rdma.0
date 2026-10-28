Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168409;
	b=b6gCe2g0dU8ULmQ1eCyPtyef99XNu2SAH2UaKGfc/ZsofBb8wDm934Mrh0WGvqhstWAF
	 TPhVTgjWaEEwsPWVctkAxmFibOEfjPxXX4jqTE3dwK9+OSr3iRYT3XGNpfgeoTPGEtyhZ
	 oUL9w0qYEe7y3mBh116763oJxnmb2CzY+TF2rsmhqgbSSxKeaVdIh8FBjcM+2AkxIaFNA
	 3FzOyW241R8kGLaqQMoH4R7Io7Ob5xW6BFgzCO5UNxx+wBqopo6WSBNH1pC5TCNA8QMBB
	 5GzGdZlEvgjV8og256GR1zcCIBTfQfRXbMhwMkjF2+/5xf8ObKDk90GyfnJMjI/qohw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168409;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0esoPIblQoTRbdJcrE99anu53OCObqLVyla9H29+3Jg=;
	b=wtk1FD0bNzCDhg1BBwdTxmYB9gpynSjaRgrIsgGfVDCZ4S2v0MAKhrpuk+GuT88dS3tf
	 r1FkDh+UNJDsajxU51RsmBB6kqJ125qEe/50aAGjJ+Fy10nxRLP2gzaBnqxH+l2QGiFI3
	 fnbM9GKPfsuxUT0TczhJ/IbT7mYYrb+ZAFt0jbnJ2HKQc4A4qUqZnX/io6BHKuJmujVOC
	 MjYOp2ljcEQmAuDB11ItXlJl0y9I+I6fekly2dL41ooqCOuJ4OccsYP4VRKjV8j6oWPxe
	 PoLYVm3K+X6Cx1Q40AQjF4wSEjsRLdE/sELAwdTYjqazLEyFGfQE2jqNQqJms4JMPBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C+bGqTdS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBC8606A329
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 06:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C+bGqTdS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DCC1F031E4;
	Wed, 28 Oct 2026 06:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793168409;
	bh=0esoPIblQoTRbdJcrE99anu53OCObqLVyla9H29+3Jg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=C+bGqTdSWQ3H+OxBAogAH5xPgy3EPef27QfzLWssqWWgg+J2j6EGNTv/NPg0JRVsp
	 tdHe1sTgeOlBBo97/cJoSHbZSlTdXIDR/EK9ow3orO8IhCGwC+i93FIm92Rvr1bHGZ
	 tY6KjFTE45u5x5+0krUBZ6V+jAcmJ8eBIPP46ug+oqMyFCc+VA0kUr1EVbKQo+i6xf
	 QTBH3LGuR30ks3O6p21Rkniq5ZrNl+r48Ot2Fcw1F9lBWSbif1PGEllrN31TvD2LjZ
	 unBPdPtct/th6OoBURaGpNzXGkZUH7vCX0rMlzT+D4+76NAgUEITr73shVW2IV/KOX
	 t+3FizKfeJnOQ==
Message-ID: <sashiko-outbox-187556@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc 2/7] RDMA/bnxt_re: Honor a completion that races
 with a wait timeout
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261028113404.33289-3-selvin.xavier@broadcom.com>
References: <20261028113404.33289-1-selvin.xavier@broadcom.com>
 <20261028113404.33289-3-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 06:20:08 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> If the wait helper gives up (timeout or firmware stall) and the CREQ
> tasklet processes the command before the waiter takes hwq->lock, the
> response is already copied into the caller's buffer and is_in_used is
> clear. The waiter still returns -ETIMEDOUT and may set
> FIRMWARE_STALL_DETECTED, and for CREATE_AH the handler skips
> destroy_timedout_ah() because the waiter was alive, so the AH leaks in
> firmware.
>=20
> Under the lock, if the slot no longer holds this command's response
> buffer, a completion was delivered. Use its status instead of failing.
>=20
> To keep that check valid, never reuse a cookie slot that is still in
> use: __send_message() returns -EAGAIN and __send_message_no_waiter()
> drops the internal command.
>=20
> A slot stays in use only while its completion is outstanding. If that
> completion never arrives, the cause is a PCI error or firmware still
> processing the command, so there is no point in posting more commands.
> Continuing to return -EAGAIN until firmware completes the command in
> order is intended; otherwise recovery is initiated.
>=20
> An internal destroy_ah dropped for the same reason leaks the AH in
> firmware; this is accepted and the comment in
> bnxt_qplib_service_creq() is updated to say so.
>=20
> Fixes: 691eb7c6110f ("RDMA/bnxt_re: handle command completions after driv=
er detect a timedout")
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028113404.3328=
9-1-selvin.xavier@broadcom.com?part=3D2

