Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFE93B2FC7;
	Wed,  2 Sep 2026 13:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788355540; cv=none; b=M9fb7wZA3OMgaAOA7orfPVEY9l2yKnz6gemfOfewVzDuhSdlSfJpk2pW8rmGekkXNVJvoQxqg3VgTGiGHZaiXiEHLbPsnELvDGXIIDCw/DoSoc4RklBG2Lt+zKETZO4uvsf+rkHrIPG45KzTyo876/FjcGyf6Fl7wMM8D6HIs7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788355540; c=relaxed/simple;
	bh=QeZJgxrAMDCJ6OgVBLmn20qrfNm2J7ODNGMkG7qM5tU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=QyT9ag6QTUctvsVnmrrWCZ157Yig45E1EejzalcaIj8MAZzBb3L0qHwMSaFxenHMKHwjnRN/RM4uOxkGyM+RlKgvIRiqI9v3VoGttn1jf/jnkOOVwspMSC+5AuNnyqyaEk8EU6RIEY2o5EiZ4wStZ24P0jP2+Gppiylw/NrinU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FGCX0OvF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FGCX0OvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D971F000E9;
	Wed,  2 Sep 2026 13:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788355539;
	bh=sglCB8Udlf2cRdlyl5noR83Rv05tX+aW7o7hveIpBTc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=FGCX0OvFP+1cuqoz3bwGXM5A6MRR/IfAna2WmhTp0u3ek3liyZgBsRpXQQP5VF/4j
	 m6WK4rtuilNyXzvFwvF5auiQC+US/kNzoLIgZJ2ED9ODTnlyxDvPS7IhlJ2o2PERl4
	 wbfzSQlNZ5C5iPELfpU5QY+ZKp2PWGc/W8yjzotlh5+Jc/ar5JA058RszpFgBsaNet
	 wx3pguhRJP0oeb+TZo+RWyXWOksYXbXr4syCci2nFloQtjE3MxytnFU7TApDIKkfSC
	 TqvgjRqwNTbW6rVZ/VXY395GPuAefdyJNNPOwyNnACLWnu93bARx11Vjer5MfTKiur
	 5NOeZ2Jh37n3g==
From: Leon Romanovsky <leon@kernel.org>
To: haris.iqbal@ionos.com, jinpu.wang@ionos.com, jgg@ziepe.ca, 
 Ryan Mehri <ryan.mehri1@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 syzbot+1695193198994f4e7fed@syzkaller.appspotmail.com
In-Reply-To: <20260823034303.163403-1-ryan.mehri1@gmail.com>
References: <20260823034303.163403-1-ryan.mehri1@gmail.com>
Subject: Re: [PATCH] RDMA/rtrs: guard against null kobj name
Message-Id: <178835553654.2490215.14620289585126056739.b4-ty@kernel.org>
Date: Wed, 02 Sep 2026 09:25:36 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sat, 22 Aug 2026 23:33:43 -0400, Ryan Mehri wrote:
> In the client, if `init_path()` errors, the callee tries to clean up
> with `rtrs_clt_close_conns()`. However, this can lead to calling the
> event tracing code with `clt_path->kobj->name` being `NULL` and thus
> causing a null pointer dereference when trying to copy from it.
> 
> This just adds a guard to check that the name is not `NULL` before
> copying from it. The server appears to have a similar pattern.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rtrs: guard against null kobj name
      https://git.kernel.org/rdma/rdma/c/99c24a8968ebef

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

