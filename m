Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792590162;
	b=IPT6y4PwcYLlcIFwxteHjn80rYdvPcbZ8OYzU+rJQ7Edum7fHegwxVWrwt7fyOI7ryJT
	 +mZryso2Z1Cdmxxo9dVFvmM7T1PpVFtA0XvnfSgDbNDehZvgYc3HtFyGyH6WcZCIe9kqm
	 jyhJI3WXuMjsYPhEOkITCUuCJ7d/mCZPwpUcmy1a7J1p10zy1i6Cl9nZv5KXaPu3gpZ6J
	 k5bxikTIAt6gHbiate1+hpinonjgk/big67Z/opgncYT91h5Hb+I/d5wwLuRmAlw/6e7G
	 XJ0x3/do17Xwem5p3j3LvlgJodC5oLJHihDPQcTl6wlLU2KezMuwUvrvGaymXA40XbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792590162;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-Rspamd-Queue-Id:X-Spam-Level:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:
	 X-Spam-Score;
	bh=qEgSvgGQIN5UC/cEOcl8Ma5axvPfziiFmfY6ClYNUSA=;
	b=q+RWLpG7h+litiA66pYL2O+ILs5MEIvBlyMa6g1yURoFRyKxpHtatYL96yOIKivF+K1P
	 isHozTcPvoSuWSN6kLS4k0ZhxYTWUKmS4NqwGeVJX8AchAJkwkD5ZRIX5Hbya9CM3Edh/
	 erI+46vuvtql8bqIY8IK4RpcU09Cj6k6Aj0YieApB90gj6r4aw9NatV/EAPA5l6qXYIHE
	 qkv38pVa5ym5MoYZjZ0S48RGBmHCFf7Fm+6SYIQW5nbU1lITCeGYrWkmUQ7+RMV2v8dfG
	 EJ6eT/sNNfSsm9yZWdA/Kj1r4Ib8Ro5IM3qudN+NiZs41nA6fYxf3sGez+1yLlA09Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="d/pAMTTH";
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=MMMznhCx;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b="d/pAMTTH";
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=MMMznhCx;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDBD606A321;
	Wed, 21 Oct 2026 13:42:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2EDBD606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=d/pAMTTH;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=MMMznhCx;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=d/pAMTTH;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=MMMznhCx
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 27F3C1F842;
	Wed, 21 Oct 2026 13:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792590160; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qEgSvgGQIN5UC/cEOcl8Ma5axvPfziiFmfY6ClYNUSA=;
	b=d/pAMTTH0m1EW5ad38O0p6SlVC6D6HLuXYFQPH2xGDkitB9kxKiv1LMbV811cF7DH7nJLW
	FYHXiFQ0+30+v1Vre6jhc3gV/o+5Giyd5SREjq9xuunH7TCKDx7YS2KAOF3arzYrf23+MT
	b4Xkn3YKzTdzPI+VJMSP7GTZulAJT1c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792590160;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qEgSvgGQIN5UC/cEOcl8Ma5axvPfziiFmfY6ClYNUSA=;
	b=MMMznhCxbwXJZ6RliIBvdkTuWPGQgRwNsHoPu5AtyGKjyXyQ4lvUCmwAv/yoRNMmxUd1vr
	uMxORaNGhT5WPNAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="d/pAMTTH";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MMMznhCx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1792590160; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qEgSvgGQIN5UC/cEOcl8Ma5axvPfziiFmfY6ClYNUSA=;
	b=d/pAMTTH0m1EW5ad38O0p6SlVC6D6HLuXYFQPH2xGDkitB9kxKiv1LMbV811cF7DH7nJLW
	FYHXiFQ0+30+v1Vre6jhc3gV/o+5Giyd5SREjq9xuunH7TCKDx7YS2KAOF3arzYrf23+MT
	b4Xkn3YKzTdzPI+VJMSP7GTZulAJT1c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1792590160;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qEgSvgGQIN5UC/cEOcl8Ma5axvPfziiFmfY6ClYNUSA=;
	b=MMMznhCxbwXJZ6RliIBvdkTuWPGQgRwNsHoPu5AtyGKjyXyQ4lvUCmwAv/yoRNMmxUd1vr
	uMxORaNGhT5WPNAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EE783134A5;
	Wed, 21 Oct 2026 13:42:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id boB8L07B2GpcIgAAD6G6ig
	(envelope-from <fmancera@suse.de>); Wed, 21 Oct 2026 13:42:38 +0000
Message-ID: <5eb0f607-5cc0-46aa-a51d-9cdacea3fe3d@suse.de>
Date: Wed, 21 Oct 2026 15:41:22 +0200
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5e: IPsec, Fix out-of-bounds comparison of
 neighbour keys
To: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>
Cc: Boris Pismenny <borisp@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Jianbo Liu <jianbol@nvidia.com>, Kees Cook <kees@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
 open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
 Mark Bloch <mbloch@nvidia.com>,
 Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Simon Horman <horms@kernel.org>,
 Sridhar Samudrala <sridhar.samudrala@intel.com>,
 Yael Chemla <ychemla@nvidia.com>
References: <20261021064231.3466989-1-tariqt@nvidia.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <20261021064231.3466989-1-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 27F3C1F842
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-12.00 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	XM_UA_NO_VERSION(0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	ARC_NA(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[nvidia.com,kernel.org,vger.kernel.org,gmail.com,intel.com];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[netdev];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,nvidia.com:email]
X-Spam-Score: -12.00

On 10/21/26 8:42 AM, Tariq Toukan wrote:
> From: Gal Pressman <gal@nvidia.com>
> 
> mlx5e_ipsec_netevent_event() keeps the L2 headers of offloaded tunnel
> mode SAs up to date: on every neighbour change it looks for SAs whose
> endpoint matches the neighbour's address. The compare width, 4 bytes for
> IPv4 or 16 for IPv6, is chosen from the SA's address family, with no
> check that the neighbour is of the same family.
> 
> An ARP entry only stores a 4-byte key, so with an IPv6 tunnel mode SA
> offloaded, any IPv4 neighbour update in the system is compared as if it
> were a 16-byte IPv6 address, reading past the end of the object:
> 
>    BUG: KASAN: slab-out-of-bounds in mlx5e_ipsec_netevent_event+0x736/0x8d0 [mlx5_core]
>    Read of size 4 at addr ff110001260a4ad8 by task swapper/8/0
>    Call Trace:
>     <IRQ>
>     mlx5e_ipsec_netevent_event+0x736/0x8d0 [mlx5_core]
>     notifier_call_chain+0x97/0x2b0
>     atomic_notifier_call_chain+0x5d/0x130
>     neigh_timer_handler+0x35c/0x1140
>     call_timer_fn+0x164/0x490
>     __run_timers+0x5b9/0x960
>     run_timer_softirq+0xf0/0x1d0
>     handle_softirqs+0x189/0x8a0
>     __irq_exit_rcu+0x10d/0x250
>     ...
> 
>    Allocated by task 1015:
>     __kmalloc_noprof+0x2e6/0x8b0
>     ___neigh_create+0xcc9/0x24c0
>     ip_finish_output2+0xfc7/0x1e80
>     ip_output+0x172/0x3b0
>     ip_send_skb+0xa5/0x1b0
>     udp_send_skb+0x852/0x10f0
>     udp_sendmsg+0x1333/0x2150
>     ...
> 
> The opposite mix (IPv4 SA with IPv6 neighbour) stays in bounds, but only
> the first 32 bits of the IPv6 address are compared, so an unrelated
> neighbour can match.
> 
> Skip neighbours whose address family doesn't match the SA.
> 
> Fixes: 4c24272b4e2b ("net/mlx5e: Listen to ARP events to update IPsec L2 headers in tunnel mode")
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Reviewed-by: Yael Chemla <ychemla@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
