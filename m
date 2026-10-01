Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D5F52F29E
	for <linux-rdma@vger.kernel.org>; Thu,  1 Oct 2026 15:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790868995; cv=none; b=A7eAwc+3uMZFe6YacnktWRTQfHxKFX4MDAqDvJY074+ebXUohtLUp8ZJsJZ7jJqN7w6vF1PBYIeTOaVErwhfRSEPcsRQ5xUUTx6X+d2A9NEd8HnlPcOuDTDZJ4POatU/hEmOlgLrbH7zPESbEvYG6ul4LByYPvdUzKpg1QqlA4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790868995; c=relaxed/simple;
	bh=JdSOtQ23NoMqo+tTG5zgwQu1Sv4HbzUOclTk3seSRl8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sZFVrdu8zKNG8T/nqvtfmGmOvqQ6fRv23nBsBsQFWM35qDsJD+YfYy4HJzkgJEFp8vVr0cn7ehuzxluL46IVPh9GFLftNG45vv0YGFM8qILGref/YmwJI5eB/33ijuWa/SfTaxqGjdCaIdNNH18UttNHtRCwfAvTuA7ae1fJroE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EQz8AU7W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EQz8AU7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CF81F000FF;
	Thu,  1 Oct 2026 15:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790868994;
	bh=JdSOtQ23NoMqo+tTG5zgwQu1Sv4HbzUOclTk3seSRl8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EQz8AU7WfiHa6l4eb73a8oF9PjIyD/K02bfomOEtk3oL9l3qqYNtd/uM2Qf9wNeIo
	 rAoxZjEGcc3Mn9sJOUA6h9yIOKmBRih1qcceHBrenhoewOi+lPVV83YHd9OBpdIJUY
	 cmw5KtG8f6GWEfYW8+73us/mgAu00hbCHJGch0mliYwuykeCgD+0y5wSfURmiAaxtW
	 9EkMZs/rbcOlAC2S2Q6TOQCu6YrL772MnU+5axRvwYolBnwTshDxXLPkCcxBTpCh3q
	 b3PE9ZHa3cRRVKxzFZGjgQYuuSgbLnYz7xEB3J/H80+6yYYWLxOl4jePeYBGYJCXNg
	 QRWIyuh7yJoPg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/rxe: bound the WQE opcode before indexing
 rxe_wr_opcode_info[]
Reply-To: sashiko-reviews@lists.linux.dev
To: "Youngsung Ahn" <ays511.kr@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261001152407.3259261-1-ays511.kr@gmail.com>
References: <20260930180221.2497908-1-ays511.kr@gmail.com>
 <20261001152407.3259261-1-ays511.kr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 15:36:33 +0000
Message-Id: <20261001153633.E0CF81F000FF@smtp.kernel.org>
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
> Cc: stable@vger.kernel.org
> Signed-off-by: Youngsung Ahn <ays511.kr@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001152407.3259=
261-1-ays511.kr@gmail.com?part=3D1

