Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15833F54C8;
	Mon, 20 Jul 2026 11:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784547479; cv=none; b=QVBMDwkXOn4tDnIPp4UBgUuuw1r1czOGKWFwU+PAXDp0pmCVIgTOeWC3DsWxHREwl0Lu4R/Jtq6WWIbBGH88kRNkyowNE2SnNjlAlb6ge1RK7csEaCojmNscJwPY6N7I2kyCq9b8zSm5gZq3oYHSUXK6VhmwD0jX5CsZgKdNYTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784547479; c=relaxed/simple;
	bh=PyTbGQ9LC8AaQgvaxgXZIRoOgxzjqJbW+ZTYg4fBQ20=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=IvNolwaddo5Wn1jOaM3CwQEPWjgu4CrJp0+9HsV71Zv5Aawl6sVE8PAGveh+L5heSUfJCb5mG7yGft/SYy47M3bODbd4ZQoErpyZletj1kMv19eMYnUG4zGfl14xF4BgaAdLmABK9zFSroN/j0LTSnhcczz+imBkVu5ArXr4HHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dqs/mBQD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dqs/mBQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440A81F00A3A;
	Mon, 20 Jul 2026 11:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784547478;
	bh=S2mOcR7AFK4bq+JGtNxMGMGMX+v/LNIMm21BqbV+Ui0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Dqs/mBQDxW/sgpeXk0jxANQs2oy8vcfPcAePNcg1pT6PXNdeQrDIqw6JSBt4PGJ99
	 40O9Zo6+aeb/w9Ndy7xsYWeUKGrP1SuYj0gXlgrD/t4g5677ROy6HzkB7RdvlDg4Qj
	 rlcFgh5wwKTcjdSMYnzTHlzMClw5EUdgCXicuK0ObqwAe48U7MQbxqyblGaFxuh+Iy
	 GSWCgPNDsnDIBnJBaRvpbTY88jgGkuyOpdhBzkga76ATypRNWSaVqxEkIGAbNDoBON
	 /PqJLzBo48dIwrwf2+Vtih63QFrZYvPC2wcoawXY+VIOM3UK9wQXNt48dlPoeMpzkF
	 AfW9PH1G9shLQ==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: allen.hubbe@amd.com, nikhil.agarwal@amd.com, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260717092345.2533564-1-abhijit.gangurde@amd.com>
References: <20260717092345.2533564-1-abhijit.gangurde@amd.com>
Subject: Re: [for-next 1/1] RDMA/ionic: Add robust udata compatibility
 checks to all uapi verbs
Message-Id: <178454747587.884493.1878746644126089900.b4-ty@kernel.org>
Date: Mon, 20 Jul 2026 07:37:55 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 17 Jul 2026 14:53:45 +0530, Abhijit Gangurde wrote:
> Enable the robust udata contract by setting uverbs_robust_udata and
> adding proper input validation and output handling to all verbs that
> accept struct ib_udata.
> 
> For verbs with no driver request or response struct, add
> ib_no_udata_io(). For create_ah, which already responds with
> ionic_ah_resp, add the missing input validation via
> ib_is_udata_in_empty().
> 
> [...]

Applied, thanks!

[1/1] RDMA/ionic: Add robust udata compatibility checks to all uapi verbs
      https://git.kernel.org/rdma/rdma/c/f8320432ea2369

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

