Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0614A99AA
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792072798; cv=none; b=r0fO2tB5jXxh5Xkq07y7H8vNLFTzMDB9gY0mQ5FFHEdF+QwDM7J8fGgf4A4a48J0DpgfG2yXsoGWAPLbNqgZ0aujEf/znCWj4TakM4LXca5mKm9Fd92f4TToskgraab18WYBKEJBV4o6SEycHVUuiIWgAFrhzIObl0xlkK04F04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792072798; c=relaxed/simple;
	bh=G5SWYxrBRYk33igXoAJNQbdWhrH0w72m62R8ODkZTk8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=HOmpTZfnJb2WPpCWjVL7ZROGH6lBBIkpYw0zt+xq69gR6ptfLfHK05KDB4hUHeRIeg1wbX3X+pu0CfWyiTBYgg8AjgMkI79p6LvuwWsgoQMMG4fRez/n70oMiygPp6LoxS+QrTGwL3I2l1bmdGdseBmBCtuXo60scMkluj13KSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=makdYi8T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="makdYi8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBA11F000C4;
	Thu, 15 Oct 2026 13:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792072797;
	bh=aHgS1cdPusfrvE+zsSllPSC9hWGrCYFCEessr2OpHWc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=makdYi8T7hSYuexNMhidVUdzjHHQ7+B/WLCnzfMYBBjfi5Rz78Ni2bJpFbN3B4OtY
	 n/A3E09QKxUNlYwUUH70zOxr33AtXzReDxMLMs+9j3yK9DOd9lFy1Qi6/DwUb7TzBG
	 zTKA3AEpYgeyLfiZdI+4/VhRp7gZW+4njCbi9i/ePBgYHO0pON4S3sUz9hfngtEnzD
	 HJvhVnalbOslpmiZWfMd31KwuB5h5GmYirtVLQeuRs2R8Dr80agbhp5h44aEcEAbUe
	 DQF8OFa/ywMyxWQHZvn6vyeYWfhrT9cCVE1WPJuB4IxkvwRkgvhfW/7MHfASCay5x9
	 tBlCpAbgvi2Gg==
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <yanjun.zhu@linux.dev>, Youngsung Ahn <ays511.kr@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261002164552.294749-1-ays511.kr@gmail.com>
References: <20261002164552.294749-1-ays511.kr@gmail.com>
Subject: Re: [PATCH v3] RDMA/rxe: bound the WQE opcode before indexing
 rxe_wr_opcode_info[]
Message-Id: <179207279445.164616.12507740631628356638.b4-ty@kernel.org>
Date: Thu, 15 Oct 2026 09:59:54 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sat, 03 Oct 2026 01:45:52 +0900, Youngsung Ahn wrote:
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
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: bound the WQE opcode before indexing rxe_wr_opcode_info[]
      https://git.kernel.org/rdma/rdma/c/c887e53e1c852b

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

