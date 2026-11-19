Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795094902;
	b=4mcjacOkuvqyDpRM/pP1p+fOkXNrxyTR+I3qwhbyXYWY0Mrk++4+gPt6MZ/Vru4qBP13
	 0HWyXpOW5d0m0xk2PKaNAPtipL7TJHAcVS7Zdz7Ei7yqc+hPbqK+Nxk5A2io8wrEm23hk
	 FtxXQufDs7qvpFI5d6/eFU8k4EZznoVOQ2/YWY1yw9pbhRIL5LdHgKHLMhlzZlM09OTIk
	 4lKMvpjb2KiEsjRGm+LjjB5ZdC7XqJoUrS97hOMAdB/5L30w8bLp/bQpxw0CvcCtxPMI4
	 i8yGXKsVnd7Lt+wTMHZBahMN/tzmsAXMtV5F7Z3B2tEbM6nH6kxTE46kQ0djb0VqN7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795094902;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=YJevmme3dudbAh/94dsVoODljHBQcfzmwY1A5DzWbZg=;
	b=nxusYzl1EGDJB2eecK1bGBHtN6GuWyaW5FhwmgaO0gZA/px883C2JnBIOUQBb1igvzDI
	 HT7AHB4QM1oGluMv3kV8/w1kEZ6yQHfJkzPdCHUbhqWjs8WGyDWBqWBvBU9vLbUmAAdtU
	 /IvhnyCvfO/F8bPEl8WuOJS9rPhdqlMCcAW7UT1VDJLdmaw2w6SzomnO5ssFiva2BmIE1
	 Jzb6W7Epzrz3JERvoANchP8GzaPhKNvXMsS1e7+5LGBK4ebi77LdQ/pNng1tg9xE/YW8O
	 r3uHr5IjT18hJ33X5TfDTfXi9ieWeDUl0ucAwGEz56M0sMlO2g7NG810ejCamlWpqTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XHbQ0tfY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4F560A6F6D
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 13:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XHbQ0tfY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771CC1F000C6;
	Thu, 19 Nov 2026 13:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795094902;
	bh=YJevmme3dudbAh/94dsVoODljHBQcfzmwY1A5DzWbZg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XHbQ0tfYqNpLTd1aj8ATVuWKB10H7xB5y3LQx5gqLkkTgjaOX8kJANu5mnFPqqqJn
	 spfL/nUn98RIIyM+Q1KMOgdeJCTd+9jcRuqpVvLQ1BZNKKnsdEMrLftZWl/Ib5RabY
	 9tPGJu5Oa1GkzhRCbJScGqLOuXic6uSEEEQVQca+KCevX0SO4IlJa3Efh2Qbzh5Mim
	 NUj2iq1+2kt/iRIaIYKHapvuIJiXYBR8SmJ07EPZZh7EPTZhr1nb+TUlmv+7bX2YSW
	 4o+a1pzi+DXYVZ/aOY6oDgZCW7kGJb40ujWPWs35/azIe80WX4sOqjcMD2i1bcFzfx
	 MSDnio5K6pkvg==
Message-ID: <sashiko-outbox-223176@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/4] scsi: target: iscsi: retire an unsolicited
 NOP-In only once
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261119131700.2722108-2-yhlee@isslab.korea.ac.kr>
References: <20261119131700.2722108-1-yhlee@isslab.korea.ac.kr>
 <20261119131700.2722108-2-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 13:28:22 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> iscsit_process_nop_out() answers a NOP-Out carrying a TTT by looking the
> command up with iscsit_find_cmd_from_ttt(), which compares the tag and
> nothing else and leaves the command on conn_cmd_list, while
> iscsit_add_cmd_to_immediate_queue() allocates a fresh queue entry each
> time.  Two NOP-Outs with the same TTT queue the same command twice, and
> the tx thread's ISTATE_REMOVE handling releases it twice.  For the NOP-In
> itself that release is quiet - it is a slice of the session's tag pool,
> not a slab object - but it can land on whichever command has taken that
> tag in the meantime.
>=20
> The same lookup also hands out a Reject, which the core allocates with
> targ_xfer_tag 0 and leaves on conn_cmd_list until it is sent, so a NOP-Out
> with a reserved ITT and TTT 0 is given the Reject instead of a NOP-In.
> That one does reach the slab, through the header the Reject kept in
> cmd->buf_ptr, and an initiator gets there one PDU after login on plain
> [ ... ]
>=20
> Link: https://lore.kernel.org/all/1437516477-30554-4-git-send-email-sbaug=
h@catern.com/
> Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v=
4.1")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261119131700.2722=
108-1-yhlee@isslab.korea.ac.kr?part=3D1

