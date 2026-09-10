Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486E046D56B
	for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 11:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789041328; cv=none; b=lKLFzbJvF6THcaaN3b2XCX9VYa9zriBCQNkj6wxwexH9bnqTUWZebazZEi4l5e0h0k146zUtzP8O6MgjUPtzo1bcqHO1lVZ5W2xUKQUpQr2pAlXFUVFDx2RGbUSgHpjQRMSWP45YKiqb3Mr20AYFqmE10xBrvDIH1Y6KvXiloeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789041328; c=relaxed/simple;
	bh=fh9VPLencj71ugMUwDoCUs7bZM5UNDFqFkWdFNqYU+s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=FSbPoSP88lCwY8knjxcSwJCucjgCM/I2+vxuP216k0HK+P7zhiPyLER+1mnMSh8enWH49s0kVy7Ku4chAX8miwNM/rtKJ/f7twy/dH8dU6oPKtf1vfm9hB5w7v5PXxNudxoOPZx8hITeRrq8/TrHw1kiQuRdBkJbZD4wKhmRxlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KDK/UJLN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KDK/UJLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C5C1F000FF;
	Thu, 10 Sep 2026 11:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789041326;
	bh=lJaIer7jxIhxp0dcTtt+nk27dvRpxaiDkKtcP4/65sc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=KDK/UJLNFFnKXaljacyqVW9lEA4JYWZkhLBe6fA622awJZvFcVKAymASp4UVGFbAP
	 XbTUjbc+pvM+JdepZNTRn1R4di8El2Iuz/mYs8uJrhBxxv5skg/rY06DMkMJGv+zIO
	 VHahAOR/BhsLhp8PP9nIkV7Fj0XeRerFZGDfalCUlsAqGCT63Mg9X0wLiyHHbW42hO
	 E8xA7m+J3yGaYbYtXwnzvZEj9XUdKoZMsbe9BB/VJICq7+QL4fBn0BkCkYE/FkWQN6
	 iSB7v9GNOyBBB19mnueQ19jvfRfcIwFxHWZDBDQ22fNGQxd04/MbeSUrWtEwcGUfRL
	 A45pLMCdUhtaQ==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, linux-rdma@vger.kernel.org, 
 Junxian Huang <huangjunxian6@hisilicon.com>
Cc: tangchengchang@huawei.com, linuxarm@huawei.com
In-Reply-To: <20260907084901.2420703-1-huangjunxian6@hisilicon.com>
References: <20260907084901.2420703-1-huangjunxian6@hisilicon.com>
Subject: Re: [PATCH v2 for-next 0/3] RDMA/hns: Fix GMV entry management
Message-Id: <178904132380.247727.5430046966536289125.b4-ty@kernel.org>
Date: Thu, 10 Sep 2026 07:55:23 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 07 Sep 2026 16:48:58 +0800, Junxian Huang wrote:
> This patchset fixes two issues in the GMV entry management. It starts
> with a preparation patch that changes the type of gid_table_len to u32.
> 
> v2:
> * Change gid_table_len type from int to u32 in a separate patch, as suggested by Leon
> * Drop the redundant (u32) cast on gid_table_len[0] since the type is now u32
> v1: https://lore.kernel.org/linux-rdma/20260904093837.1633748-1-huangjunxian6@hisilicon.com/
> 
> [...]

Applied, thanks!

[1/3] RDMA/hns: Use u32 for gid_table_len
      https://git.kernel.org/rdma/rdma/c/593fd6c4886136
[2/3] RDMA/hns: Limit gmv_entry_num to avoid memory waste
      https://git.kernel.org/rdma/rdma/c/bb464eeadd301c
[3/3] RDMA/hns: Fix GID capacity loss in 64K system
      https://git.kernel.org/rdma/rdma/c/95761b8736c938

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

