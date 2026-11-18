Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795002381;
	b=GNxkR8ZZy5lfuycpgBu/HXcmclbx5/3ePddlNckm7mzTo+l0ZlGdiF3ERM+KHberS4pn
	 8xfdHvuZ1MWW2+g9pmzKwM3ikv1RkqtLorjpnicaLA/ViHEojFAvA4yjnFRUWoLb0u0w7
	 DxMZgRbOkBYGCVl3HQJxpogMPz909cHaQTp6yyBxLcpIy+QxvCt0Kaa0HHPEw6U1K575r
	 9G/KbMjbbPXH/m0hWJYZbyxZCvdm1Uo1N7gagXEY6eXy3Cy4TkpQxL8ulV0pFDtmxeYeN
	 hVi3WFNLurfjeJrBcY6a+9GlBr747cwCpK130tRZ0J5qDhSEw//h/jnDOyb4Y60+coA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795002381;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=pWsm3GTHcr/XwqwluGzdmrDJ3daTddn4L08H4MHQhfg=;
	b=hBzCyw0Flr1n1yXjnWSiBXxl7+CjzlLXHdFxxwFqX4KypIMpHxGwdyaHm72cchRfZomX
	 8eGlvjTOUtXReXdKn4MwWUmMYi8JdHXeSyqbIAJ2wUebeab/gTTcf4adoeoJ4U0uPaUQf
	 8tIKBVLY/lAwYXKxtLY4d2eVqlfqwvzcCVznLyfPamzX6IugdcE+lDqH53lNnBB/5Uku0
	 V/PC+9i3FLUJd3D2WQ7SVqYb+IdexT5r5lzFBtm0Jc/9VHn1PjfljwWOZYlCXTdmFTRW5
	 8mXiP1imvu1Y/ak0yquGIwoD3aAFTLIyvrQmUKNP9YXykm1P/9440grwDPLprLw2Fuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jkP5pxyN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5463606A31C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 11:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jkP5pxyN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451991F000C4;
	Wed, 18 Nov 2026 11:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795002381;
	bh=pWsm3GTHcr/XwqwluGzdmrDJ3daTddn4L08H4MHQhfg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jkP5pxyNRFYyNRsgOZ+hS+04+IwTPjS+z+SnQOVKMwlheudv02SIGzVe9/1ZZcgls
	 5k/VVLHh8RLTct+JQbWdKi8bO+TU2kcnw+RzwR8S/44oQRHl/CUB1HOfB2xxVqqCXu
	 j03hFSik85gTuP1U7fFOusMphSMU6Z56WCoooOScQnctska5v4J0VhyPhezCm8SFOr
	 IpcPYuPYRFrcXVD/VDMfvU430O8Mc8i603YDbjCKVrh1Vbr1j55zWm3bdKB12o2Iz+
	 lSpcOENyPXf19eGsC/DAYt1G8wrKMQv78FfptGrNTsBtYFJaVe/bDU/070f5bF3tXs
	 KwO27hiqYLAig==
Message-ID: <sashiko-outbox-220837@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/4] IB/isert: do not leak the receive descriptor of
 a dropped Data-Out
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261118113905.2361969-5-yhlee@isslab.korea.ac.kr>
References: <20261118113905.2361969-1-yhlee@isslab.korea.ac.kr>
 <20261118113905.2361969-5-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 11:46:20 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> isert_handle_iscsi_dataout() works on the command it finds by ITT, which
> holds the descriptor of the SCSI Command PDU and not of this Data-Out,
> which is why the function posts its own descriptor explicitly when it
> succeeds.  None of its other returns do, and isert_recv_done() ignores
> what the handler returned, so each such Data-Out costs one of the
> ISERT_QP_MAX_RECV_DTOS buffers.  That includes the returns where
> iscsit_check_dataout_hdr() answers 0 without a command at all: 200
> Data-Outs carrying an ITT that matches no command stop the connection
> after exactly 128 of them, with no response to a NOP-Out sent afterwards
> and nothing logged beyond the per-PDU "Unable to locate ITT" message;
> with this patch all 200 are taken and the NOP-Out is answered, in 5 boots
> out of 5.
>=20
> So give isert_handle_iscsi_dataout()'s other returns the same post its
> success path already does.
>=20
> That one function only.  Everywhere else a handler returns non-zero, the
> command isert allocated still holds that descriptor and the response
> posts it from isert_post_response(), so re-posting from
> isert_recv_done() would post the same descriptor twice; the second post
> is skipped only while the descriptor has not been refilled, which is not
> something the receive path can promise.  iscsit_handle_logout_cmd() even
> returns 1 for an ordinary logout.
>=20
> Fixes: 4366b19ca5eb ("iser-target: Change the recv buffers posting logic")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118113905.2361=
969-1-yhlee@isslab.korea.ac.kr?part=3D4

