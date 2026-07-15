Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B8247886D;
	Wed, 15 Jul 2026 15:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784128297; cv=none; b=LnNpdnSgvT8AeRlI7wBXJhzgtdK8FE7CKK3TpaZDoEKcZSxfCuWJ9S1QB4/pWQHcqjtaLxMDvtX6dtnaxoWqHoA3YNUsHt/+ZkGIbSWHZ+Ypq/7uVZ0jP59rW3ZBzkB5ocKLI9BOyVFGQ7Z4weyyhXKnhkV30MqJ2qOxuQe1OMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784128297; c=relaxed/simple;
	bh=RRi54PZurEa3e/dktflSktOSoT1OTTtAUfLIja2rEUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c6gTRzwBVBQ7yoNO0HHDr8mESdcKeFxEUHqgvAeu5MsZjkGADYX3jik0c89i/s+gs1raYtRT7l5nhup7s7BYyW72wN9ZPAUVWtREipGAzheRk02bVgaKjt+p2mm3HSWz3GIAZOgdWhPHUFcChrn/B44wu0QrlsBXN/cboiQT4+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cwT1U6nW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cwT1U6nW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34E11F000E9;
	Wed, 15 Jul 2026 15:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784128296;
	bh=ePzEmtk8x02P1WznyGCn4yajEKC+1evCizrCaaVYdeM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cwT1U6nWDEVhvA7ZfpHauTWDUmCQNlzoa2UkvOcFFtP4vTsQrqr1jMI9Oe6mVXbX7
	 Hq7NYxDy6Ab5pG9Gis3OnR1X0xWF++EkwpRB4RVNIHw/5sKsA7h0H/F3ycK+A60dEo
	 AyBGArjV2fjahq8DXY3ZAdKKlyHjocKC4lOt9r8FLgYRM1E8TcQG60dVoBJwRCe0pU
	 dq1CrY1j598oXx4J6CBW5uyVtR7wQXo4RF9B2jf7XOQnT2/UZteHsiLdRmZIjZXzMF
	 FWLcqUFCWs9H2xp9ydqPuYK5KFP7PlYjdIJAjRVO6TKtxRWekBDqKiPJQRrRjvj9U8
	 mQm2OryRGG1eA==
Message-ID: <2d83ccf4-952c-466e-a79a-ee93bf072380@kernel.org>
Date: Wed, 15 Jul 2026 09:11:35 -0600
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH iproute2-next v6 2/2] rdma: display resource limits in
 curr/max format
Content-Language: en-US
To: Tao Cui <cui.tao@linux.dev>, leonro@nvidia.com
Cc: linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>
References: <20260713131238.955962-1-cui.tao@linux.dev>
 <20260713131238.955962-3-cui.tao@linux.dev>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20260713131238.955962-3-cui.tao@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/13/26 7:12 AM, Tao Cui wrote:
> @@ -55,7 +55,26 @@ static int res_print_summary(struct nlattr **tb)
>  
>  		name = mnl_attr_get_str(nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_NAME]);
>  		curr = mnl_attr_get_u64(nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR]);
> -		res_print_u64(name, curr, nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_CURR]);
> +		if (nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX]) {
> +			uint64_t max;
> +			char max_name[64];
> +
> +			max = mnl_attr_get_u64(
> +				nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX]);
> +			snprintf(max_name, sizeof(max_name), "%s-max", name);
> +			print_u64(PRINT_JSON, name, NULL, curr);
> +			print_u64(PRINT_JSON, max_name, NULL, max);
> +			if (!is_json_context()) {
> +				char buf[64];
> +
> +				snprintf(buf, sizeof(buf), "%s %" PRIu64 "/%" PRIu64 " ",
> +					 name, curr, max);
> +				pr_out("%s", buf);

claude review:

The feature and backward-compat approach look correct.  A couple of
nits below.

> +             if (nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX]) {
> +                     uint64_t max;
> +                     char max_name[64];
> +
> +                     max = mnl_attr_get_u64(
> +
nla_line[RDMA_NLDEV_ATTR_RES_SUMMARY_ENTRY_MAX]);
> +                     snprintf(max_name, sizeof(max_name), "%s-max",
name);
> +                     print_u64(PRINT_JSON, name, NULL, curr);
> +                     print_u64(PRINT_JSON, max_name, NULL, max);
> +                     if (!is_json_context()) {
> +                             char buf[64];
> +
> +                             snprintf(buf, sizeof(buf), "%s %" PRIu64
"/%" PRIu64 " ",
> +                                      name, curr, max);
> +                             pr_out("%s", buf);
> +                     }

The intermediate buf[] is unnecessary; pr_out() accepts a format string
directly.  The snprintf -> pr_out("%s") dance also silently truncates if
`name` is unusually long, since two u64 values and a slash can consume
up to 42 bytes, leaving only 22 bytes in a 64-byte buffer for the name.
While current RDMA resource names are short, the kernel is the source of
`name`, so it is better not to rely on that.

  if (!is_json_context())
      pr_out("%s %" PRIu64 "/%" PRIu64 " ", name, curr, max);

Similarly, the max_name[] buffer for the JSON key has the same size
concern; a 64-byte buffer with snprintf("%s-max", name) silently
truncates for any name longer than 59 characters.  Again unlikely in
practice, but worth noting if this pattern is copied elsewhere.

No functional issue with the netlink policy addition in utils.c or the
backward-compatible fallback to res_print_u64().

###

in addition, please provide json output in the commit message.
