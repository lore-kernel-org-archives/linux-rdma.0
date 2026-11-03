Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793698090;
	b=ENhJJ2nvi9i1gHO2B8OCl/EyLzXdBl9+9kGgZgIBYKN4DABvU+akee6O6Um6h2yJAMm6
	 HuSnrbFDwY8TgBwJ2PFQmnBqgcrv32uCBulzxGY0ZLBw60DPI692FulYAQDb2OP1sCjTt
	 3Cahku/7Cw6ZG7IXypbSEV4p1DxPPAsmZW8gSpEkqqyM3ztnwjF8tADMZD5xXoUV0VC5X
	 Zfc7rHOjCAJIuI2e3jslGjhGQYgiP1dj7a4QxUhnSh/alc7UT67M0bgNat3ggadBDlQNC
	 PzBNzUquyczPFVQ9GYtp8lzllgqJGw3E3jCoH5WK4GRgPwceFUy9z5YhgmWBf77QAIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793698090;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=tkRdaw9CKQa+QeUibzAbt0S2MJfnrjPZ7a/LQzcZE6w=;
	b=Nwp0WGTaV8lBARLxuJ6fgEke6RAePwZYORpDi8PP3uXmKzgvUA8AJmD6CZemZNTHkUEN
	 dJl92t/dj5WlorxTLR18suUprMUYEsPemq38mnrH8/6NKgvFs1MgNJRY2dWtiTCb2jsW1
	 8DOoWDpCbNcni1kitZH7EckQ82XsrYKXIf4/HjiijDEVxFuUs75s0j2O37k0tRg/dKdIc
	 BBqeQ75Fh7hOBf/dlHUvaeh090R04fCShXnLHRFevfs2TJxt2r3OCoy3lHMKRrLxAm6SY
	 eQXh3kvtT6lAGi7GVus98y+gFBhVUXVrRWhV0Muq8hHyoeNOuuVM8oI/2fYZ8xZ3HIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WKGs0U2u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F2B606A324;
	Tue,  3 Nov 2026 09:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WKGs0U2u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3315C1F000C1;
	Tue,  3 Nov 2026 09:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793698089;
	bh=tkRdaw9CKQa+QeUibzAbt0S2MJfnrjPZ7a/LQzcZE6w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WKGs0U2uGQwcpplaJ/N1mP5f/Zq71mKyFkNT6Cd+4p2XF62MvsD6kbR/8csoPZ+OY
	 8vxQTP5JsMws6nsboiweSh2A8lanneCplfYuVjB/RIM2FX/dMq+dDg/72lEn4wto97
	 cagT0i+5SGx7eYF4e3WAyuu1Wl+yjtcjwtyhcRx1ZImvcRoJr1/y1uzfya/+3esNHK
	 YDg2pRMvd2HO/AZYNwNErJ9/sGzYlXGQmY8UnHFFIxyTdk/szXCb/dUf12O3DK3b0V
	 M9yIS2JjjXL5VzAt0TkOYMtu7LRzToF7zmWagY43wK0DJqXZ3I0yDclkRnCyN1Sitm
	 Bd1sbEJY5C1Fg==
Date: Tue, 3 Nov 2026 10:28:05 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: leon@kernel.org, linux-kernel@vger.kernel.org, jgg@ziepe.ca, 
	linux-rdma@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] RDMA/cm: Release the GID attribute even if its port has
 no CM support
Message-ID: <20261103-exotic-savvy-spider-5fb44f@quoll>
References: <20261103081103.1134475-1-vulab@iscas.ac.cn>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261103081103.1134475-1-vulab@iscas.ac.cn>


On Tue, 03 Nov 2026 08:11:03 +0000, Wentao Liang wrote:
> When no source GID attribute is supplied, get_cm_port_from_path() looks
> one up with rdma_find_gid(). A successful lookup takes a reference even
> if the matching port has no CM port object. cm_add_one() skips ports
> without IB CM support, so cm_dev->port[] can contain NULL entries.
> 
> The current cleanup tests port instead of the lookup result, leaking the
> GID attribute reference when a matching non-CM port is found. Test whether
> the attribute is valid before releasing it. Keep the put outside the
> CM device lock and skip it for a failed lookup or an empty device list.
> 
> Fixes: 398391071f25 ("IB/cm: Replace members of sa_path_rec with 'struct sgid_attr *'")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/infiniband/core/cm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 



Multiple things here:
1. Your team ignored completely previous feedback. Multiple times.

2. You use multiple identities with this email address, thus I doubt that we
   speak with an actual person.

3. Your bot does not even bother running checkpatch, right?

4. Nothing of this was reproduced nor tested.

5. Finally, the same feedback:
You sent multiple independent patches, to multiple independent
subsystems. The amount of these patches clearly suggest this was
AI generated and most likely not tested.

More importantly, you sent all this work without properly organizing
relevant patches into patchsets. This makes reviewing difficult
and might cause multiple reviewers to address the same issue.
Replying to the entire set is impossible and requires handling each
patch independently, instead of applying or discarding the set.
Maintainers also won't see the bigger picture of your work. Quite
worrying.

This is on the verge of hostile patch: bomb us with so many
contributions, we won't be able to handle them in efficient manner,
like responding ONCE to ask you to slow down.  Considering all this
is untested and LLM generated, I have even more doubts whether this
should be considered for review.

Please read kernel documentation BEFORE posting more work. It will
explain you how to identify subsystems, how to organize your work per
subsystem (so a patchset grouping multiple patches with a short cover
letter), how to document the issue discovery method and what was
or was not tested.

Best regards,
Krzysztof




