Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD10247B437;
	Thu, 23 Jul 2026 12:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784809296; cv=none; b=buRF+QofrNYTiXtYDD+7mI5VPy4/WvJVColBNMjG6N5FunGIziJZIMmGQ5UkB6c/Y9FBfpNLWUhN+KFC8VqvW796VM4GOUk6ZBApSde0TwwI0DlS4Y8fvaenYTAJe8ikdmQWLDDU0oDNIWkggzyM3a3rb23gzuuVnYM97UrnB2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784809296; c=relaxed/simple;
	bh=pv5eZuB1thzECvG5SiQ7iPy4DoOUjFQd3dgCB8anxW8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=DTNLbJc2ciLx1xckS8AzgqArBeIWGjVhByMxxOStQWKwjxyqA6sIjPcVtW7qj6DWjexgziKJCSVEkpb1ap0kWnke6hH6EnEj9kUFHAChtG6yVnqdsambq0VCOA1LB5zqr+bg/LFzQZTwfMiU8shBupKmPt0Ze34Yr4yELEIUYg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TOzVaRgo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TOzVaRgo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE361F000E9;
	Thu, 23 Jul 2026 12:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784809295;
	bh=jSrntobQ7gBUvzamFTLDgEJCjs2+xuioarLdGmnqwFc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=TOzVaRgo3ucl2v21hsBtEuF07t5uno7TlDKrhgj+F6SHogWA6CYoPzS/jf5bNnU9X
	 dhXog8w002wuOssmY9vtyrbK8hew4j2m4Sbo0fqlTmMS6XoM3J0B08JzRkANON+nnv
	 tGG3K7lUvs/JiJhyLrYJCmE7UYgUsmQFZ6M2VzSoWuqe04hKT9xELQhibQcUmVL/Mt
	 FUJ+Az85kcJ1ZY6OLHklX12cTgHvQHxljXRETitxLuF1pR89FFsDAauOGkf2yK7Fgx
	 WrHanYhbau0BWUGB9J/EyGXJeyCFyaNFy74lxhcQQsERb2DxrjduQa74j03fdPs6TF
	 5/mQhVcJkbB6w==
From: Leon Romanovsky <leon@kernel.org>
To: kotaranov@microsoft.com, longli@microsoft.com, jgg@ziepe.ca, 
 Konstantin Taranov <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260717200839.495327-1-kotaranov@linux.microsoft.com>
References: <20260717200839.495327-1-kotaranov@linux.microsoft.com>
Subject: Re: [PATCH rdma-next v4 1/1] RDMA/mana_ib: return PD number to the
 user
Message-Id: <178480929243.3474575.8851518196795445414.b4-ty@kernel.org>
Date: Thu, 23 Jul 2026 08:21:32 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 17 Jul 2026 13:08:39 -0700, Konstantin Taranov wrote:
> Implement returning to userspace applications PDNs of created PDs.
> The PDN is used by applications that build work requests outside of the
> rdma-core code base. The PDN is used to build work requests that require
> mentioning the PD. The HW still ensures PD isolation using PDN attached
> to MRs and WRs, therefore the PDN mentioned in the work request must match
> the PDN of the used work queue. The work requests can fit only 16 bit PDNs.
> Allow users to request short PDNs which are 16 bits.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mana_ib: return PD number to the user
      https://git.kernel.org/rdma/rdma/c/1773ca1a8912cc

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

