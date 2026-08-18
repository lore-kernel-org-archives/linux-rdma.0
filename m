Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B87F3115AE;
	Tue, 18 Aug 2026 18:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787077184; cv=none; b=GUBNRxWVTy30DKnVH6sDJy0L3p53HRWqPG+pVaydr1xsetRiIrYSYmjqnyMxrBmM8DiEvJAVZeadoYIN6hk3ZlUtKAYo/5WXE8nW27o92h9GaVG0O5xCt41ZHfmp/B1beY1CKrzmUgbcXzIYsVW2F+vfq+9gdMo3Tjubh2ywAkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787077184; c=relaxed/simple;
	bh=H0FY0cE0l+W0tLgiLuBaClWT3UzfpZjlhDPgczX2sh8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=COhkakDtObkkkSfPqEzWl7FxZwRYBoKvxONaq68ysmFXXjOY/MX/bAE0jpCGD3UdC53wIeWQaBtUFbtfDR4kfwP4dkIoNOYLtoTepZ/dYn4F8Q1vRcvn3eV6q0p2nUOQ4XoZAtiWhOD4qX1QDsUSuSiPYtWx7BATYW3YlVu89Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sux8edeC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sux8edeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5101F000E9;
	Tue, 18 Aug 2026 18:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787077183;
	bh=ETkdxpF0tWteog/KgiT1FsO7wpghpPcJQS69iR4Nkr4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Sux8edeCFCaJcTjEbYr3gqRoxfK1jSE1/+SPmVdBg0gfzcEYZv7X8zVv+9UEiGGpT
	 3vhTFsYy4zlxy9/PdHazRIEdqv0cERm2YiN0kz1mjdr8k/Yy9CMgSQVGe2vZ99nmqE
	 cIZpn4lk0O66W3g/6exvx/aQOCx+UUTj4sw9uGR7bIiONOE2c1c98oNfrmtU0Y/Yi+
	 mcynAMzj1tH97qegngbomLgMtsNYL26DoBRuluoSfdf8x5GHodQUeZu7fI6YR958Uc
	 WkHBjqnw5A88hJF+4GOHo7AcoXBZS8mdA39P7lYnSn/qKNQq4n0n/WXIikyAqZ3f3p
	 h5ey7nS4LrDqA==
Date: Tue, 18 Aug 2026 11:19:40 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Stanislav Fomichev <sdf.kernel@gmail.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, anthony.l.nguyen@intel.com,
 przemyslaw.kitszel@intel.com, andrew+netdev@lunn.ch, saeedm@nvidia.com,
 tariqt@nvidia.com, mbloch@nvidia.com, maxime.chevallier@bootlin.com,
 mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
 aleksander.lobakin@intel.com, horms@kernel.org, magnus.karlsson@intel.com,
 maciej.fijalkowski@intel.com, sdf@fomichev.me, ast@kernel.org,
 daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
 witu@nvidia.com, martin.lau@kernel.org, yoong.siang.song@intel.com,
 rohan.g.thomas@intel.com, intel-wired-lan@lists.osuosl.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org, leon@kernel.org
Subject: Re: [Intel-wired-lan] [PATCH net v2 3/3] net: stmmac: skip
 queueMaxSDU check for AF_XDP
Message-ID: <20260818111940.2e280a6b@kernel.org>
In-Reply-To: <aoSOau3NuHTLLxnL@devvm7509.cco0.facebook.com>
References: <20260813190800.222527-4-sdf@fomichev.me>
	<20260818162442.3980697-1-kuba@kernel.org>
	<aoSOau3NuHTLLxnL@devvm7509.cco0.facebook.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 18 Aug 2026 10:03:16 -0700 Stanislav Fomichev wrote:
> > Was completing the reserved descriptor considered instead of removing the
> > check, i.e. keeping the length test and doing:
> > 
> > 	if (priv->est && priv->est->enable &&
> > 	    priv->est->max_sdu[queue] &&
> > 	    xdp_desc.len > priv->est->max_sdu[queue]) {
> > 		priv->xstats.max_sdu_txq_drop[queue]++;
> > 		xsk_tx_completed(pool, 1);
> > 		continue;
> > 	}
> > 
> > That would fix the ring accounting without dropping the enforcement.  
> 
> Don't think this suggestion would work. xsk_tx_completed(1) will complete
> the first queued entry, no the current rejected one (completions are in order).
> 
> If it's not convincing, I can repost only patches 1 and 2. Or if it sounds
> reasonable, can try to explain that part in the description.

Hm, I see. No strong preference but I'd probably just add a comment
above the checks saying that we are leaking there semi-intentionally
because it's an application error to send packets HW/schedule can't
handle. We expect user to fix their app. IOW if we can't handle this
well I think it's better to wedge the SW and bump the drop counter
for visibility, than risk HW silently misbehaving.
