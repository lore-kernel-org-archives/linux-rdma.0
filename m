Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E73376A05
	for <linux-rdma@vger.kernel.org>; Sat,  3 Oct 2026 01:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991200; cv=none; b=NHa1IKBHYiWGAtYIxDnmfX2mBtukdIZtdUG02cB4OBCxeAgdS3t+yzCaI0BoA59RJeynIHnJpUFvbXCTLbUe9t0JArsijBnaTgKea7wDrkM0xK8VBcczTLFSIMrQZMmED8JoVdULwuWMP+wU7X4rdx8fLLqe4m/VzeAAdeMUvcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991200; c=relaxed/simple;
	bh=0If7S6/ZpdvqdrcA+uzQFIZmoITCEdEK7jSlTE23cbg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=u78bYrAmgDMi8624FyENS7DOEAtHgfSXgtv4IagudN66K8N4Kts3Y2hJxcykev3PxdJY0OYoQnJ/cW4/owSMbKNlw/mGNY9yyb74JuMbZAuiPkglOdMqKBn3aKW7FbiYCIo6j+tcxi/y+F5rSq+OebAdWZ+lFRHZ9fSbZKts0LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fWjBCDKw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fWjBCDKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991321F000FF;
	Sat,  3 Oct 2026 01:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991199;
	bh=0If7S6/ZpdvqdrcA+uzQFIZmoITCEdEK7jSlTE23cbg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fWjBCDKwQlvCWI+9ConXwv7pjwBU2dM1vOWkbNB4uT3reiCAfHWnexAyMceWIWox9
	 /oxiiFRa4RAaiMr6sVizpCsUvpjV/1qY+jnyqZRM3cb9C7Agi51F2fLSIZ8oHKqytA
	 WMPwiZcb0cEUTJykPggy8h2LZYy4BC3UujgOg3YrerkpIEXv8yFr7/ZMtW/ehMLwql
	 r1YqAD6Z7rBRdjLSbq7Uo+mO+xA1+2NhN/GM5rFcnLwDgJ78GbZAzDTB2AedeOkYtD
	 JHgmNbYOFDGUOBVCanxkMIy2zg6EKEzErX2kiJDeILUqDGdM9QjDkCRU6q71vcVEYv
	 Gp8pREUBjlvXQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] RDMA/rxe: bound the WQE opcode before indexing
 rxe_wr_opcode_info[]
Reply-To: sashiko-reviews@lists.linux.dev
To: "Youngsung Ahn" <ays511.kr@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261002164552.294749-1-ays511.kr@gmail.com>
References: <20261002164552.294749-1-ays511.kr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 01:33:19 +0000
Message-Id: <20261003013319.991321F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> wr_opcode_mask() indexes the global rxe_wr_opcode_info[] array with
> a caller-supplied opcode and no bounds check. For a user QP the WQE
> comes from an mmap'd SQ ring, so wqe->wr.opcode is an
> attacker-controlled __u32 read back by the requester
> (req_next_wqe() -> rxe_requester()); rxe_post_send() takes the
> qp->is_user branch and never runs validate_send_wr(), whose only
> opcode check is itself !wr_opcode_mask() (it indexes before it
> checks). rxe_wr_opcode_info[] has entries only up to IB_WR_REG_MR,
> so an out-of-range opcode reads out of bounds and the result is used
> as a mask and dereferenced; observed as a KASAN global-out-of-bounds
> "Read of size 4" and a wild-pointer oops.
>=20
> Return a zero mask for an out-of-range opcode, matching how
> validate_send_wr() already treats a zero mask (an invalid WR), so no
> path indexes the array out of bounds.
>=20
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261002164552.2947=
49-1-ays511.kr@gmail.com?part=3D1

