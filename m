Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5419147125A;
	Tue,  1 Sep 2026 13:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788269290; cv=none; b=pTNLIkEZxFMX24fCXtiM3W+DdkzdUbOCHuvQMHW55x0wZ9FJWewKnrUT5d/eezGkqjyHC3DwJvL9/tweRiQYuNHRWU0eB5zkRXf6A6CN3kzwePCHY1RC0jnhadhhIuGdUi0mWCaqD7nQv81tyaoTXokCilGccUEjEmhfpLQUCdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788269290; c=relaxed/simple;
	bh=MB8P2VX7udw+EtrPCUEPYNQBMlMKKQkaA3IHG2g/HQ4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XqloiBE/37bQXuRhnilPRp4klQRAHVhFTkorfeR14CbOQYgYbuzaYzUloBskj7xwYIJnBuBUPy4Gi1/y2jbCqVPQcoscilyiSwO4DFhaaYw2PSm8WjHKbRCK9UYkB0AO6fxcBQyllRi0/WpbaDM3LUxs+oRwoTJYCdNJJ2kWfXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nrDo6Aa7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nrDo6Aa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F341F000E9;
	Tue,  1 Sep 2026 13:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269289;
	bh=mMnzvvdtndSSKqirORQDCTo1blgvZzMzFL8EX7KvH9M=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=nrDo6Aa7USP3IrzorX1EDaUdeKRmsnUJPIdtdnW3oLlNV2O9slD9nAYEoVoQTt/2n
	 Uz+f0fsRd5LpFaglug0T179E59L2+0QI8TgI7QAuLfFZoP2m/pKEF47E2yH55Hb+zI
	 dWWeHt7z8QkVOyAkH9B4CQzfIEEGWG6Y0AhQJmcuQH5i77efb8CWTIneJ/uiDI4NYm
	 G3p3rkZHHupKLmd/SaQ6b3mmRFiVarrzfUxLA0hTqJfu0wCveibqlpVdtmeV5imxxA
	 SmUXSi8ukyDPI0CFn645nu/FRijzoMXTxIKSbhwIdNPiRW6S5Mbie+90opq/pXFP8T
	 mHRA3D4CPqRfg==
From: Leon Romanovsky <leon@kernel.org>
To: dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca, 
 Shuhei Takeshita <jyohuku.alterego@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dean.luick@cornelisnetworks.com
In-Reply-To: <20260809032743.2671579-1-jyohuku.alterego@gmail.com>
References: <20260809032743.2671579-1-jyohuku.alterego@gmail.com>
Subject: Re: [PATCH 0/2] IB/hfi1: fix the PIO_CRED credit-return mmap
Message-Id: <178826928647.1339788.4877014218833537243.b4-ty@kernel.org>
Date: Tue, 01 Sep 2026 09:28:06 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 09 Aug 2026 12:27:41 +0900, Shuhei Takeshita wrote:
> The PIO_CRED case of hfi1_file_mmap() hands user space the credit-return
> page for its send context.  On a two-socket host with a translating IOMMU
> it instead returns a page mapped from a frame above MAXPHYADDR, and the
> first user read takes "Corrupted page table" / "Oops: Bad pagetable".
> Correcting only the offset arithmetic replaces the Oops with a silent
> wrong-page mapping, so every transfer that uses send PIO hangs instead.
> 
> [...]

Applied, thanks!

[1/2] IB/hfi1: Resolve the credit-return buffer through the send context's node
      https://git.kernel.org/rdma/rdma/c/975396b9e5a402
[2/2] IB/hfi1: Fix the PIO_CRED credit-return mmap
      https://git.kernel.org/rdma/rdma/c/62f0f34fbd2b2d

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

