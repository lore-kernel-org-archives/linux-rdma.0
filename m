Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=134.2.5.213
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794215692;
	b=Pyab8/vooHSOhQrv01NQKviUnaxQAWykO8mJ0oK3guSSrdFj74+k9vL7BYqSeRUcJ85x
	 UvALYNtDrIgaslV7jfdOdnRsFBQDZCn4lMcr0JPIQChCbJWUriHNLIL+yfAsHN357K1ck
	 4yxL2WyzOKGxU8KzN4pCUtlbVjhage7eKydvUICFkGHd/XMEkggC2TNoOnutPnL/Igv/T
	 AnVjX1oLjwfbtlrFQzHNqbK5XRg1TRpN8l0+IPM4WYGn2okikIRoOQuqGT9lKLhqdr82g
	 O3mkhzn5fbZjbCrE8jj6s5M4iV9GavGd6A/bDQjjWniDtMxPrHY2HaYRg355lu3HJjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794215692;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Received:Received:
	 Date:Message-ID:From:To:Cc:Subject:References:In-Reply-To:User-Agent:
	 Content-Type:MIME-Version:Content-Disposition;
	bh=FPeu9j17PDk2SiXEbdCHQguIQJ//xBSzqu+0z+fbgyU=;
	b=NnLtZ/6ehicTwtakEkth0QcTZtcxjpWZRW8bl0N78EwoM6e3JjI7uY+Su/ry+FTv3yTi
	 +mE5IAy1VOjtHGhbdtBeEHeewwJ0Gr9PRq663cjrgmEcPUpncTWVA5mL2ZSlcuIBcHEHl
	 AjNsjfAfiBPtjRHAoBQq8yRqr7KxM5s09RotcnteMk6q7SgFErX9u0T95rEI5GEOVu5s2
	 j6FB9v8ulJ2oz4pml7VMGvz/ivpbF9dtj4HONcspp13BkKyPkbK8emwMslgpTprR4BxDb
	 Gqg1sJ5ZYmxC1AHGAR0znwSsAZLoaB3Ti4uTtyhbywg3uSsk5/Ics1S7Fg2V2M9vePQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=student.uni-tuebingen.de;
	spf=pass smtp.mailfrom=student.uni-tuebingen.de;
	dkim=pass header.d=uni-tuebingen.de header.i=@uni-tuebingen.de header.a=rsa-sha256 header.s=20211202prod header.b=uWcX6NFx;
	arc=none smtp.remote-ip=134.2.5.213
Received: from mx03.uni-tuebingen.de (mx03.uni-tuebingen.de [134.2.5.213])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E196606A323
	for <linux-rdma@vger.kernel.org>; Mon,  9 Nov 2026 09:14:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9E196606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=student.uni-tuebingen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=student.uni-tuebingen.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=uni-tuebingen.de header.i=@uni-tuebingen.de header.a=rsa-sha256 header.s=20211202prod header.b=uWcX6NFx
Received: from webmail2.uni-tuebingen.de (webmail2.uni-tuebingen.de [IPv6:2001:7c0:300c:3105::8602:5c3])
	by mx03.uni-tuebingen.de (Postfix) with ESMTPS id E481A20C6E65;
	Mon,  9 Nov 2026 10:14:41 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx03.uni-tuebingen.de E481A20C6E65
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uni-tuebingen.de;
	s=20211202prod; t=1794215681;
	bh=FPeu9j17PDk2SiXEbdCHQguIQJ//xBSzqu+0z+fbgyU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uWcX6NFxoHZAJldhC7jrqNiFRCYSc984lxPgvq+AKhdjZrQ/AoHLIOMfFK3lampVj
	 6QC6DYrDEwjFLLKmr4FP4SlVTmI3r2vbouHhoh19YyHS0mkifNXm/Hu3hY+ChViYOf
	 35Sn3SRdeHzW5ewSfGrGwn3u5EEPutMSQA2rG4eVcsVqnYqYFz9EPG6AIAU6j+Ui3Z
	 t4AfMjSnZS6Y7dLaBn8hgoRm+EsXroBSJW+eGjXpYk2Ff2NcOqXW/x+aKAyHUei4tA
	 lTCErRwcDWX1+NUvPGjiqEO9IFYGHf9o+I+3q0eEywx7TvjOhbBaqHWl04njDnfrUm
	 j+xz0SjS4KfdQ==
Received: from webmail2.uni-tuebingen.de (localhost [127.0.0.1])
	by webmail2.uni-tuebingen.de (Postfix) with ESMTPSA id D674B60ABD8C;
	Mon,  9 Nov 2026 10:14:41 +0100 (CET)
Received: from ipservice-092-209-235-033.092.209.pools.vodafone-ip.de
 (ipservice-092-209-235-033.092.209.pools.vodafone-ip.de [92.209.235.33]) by
 webmail.uni-tuebingen.de (Horde Framework) with HTTPS; Mon, 09 Nov 2026
 10:14:41 +0100
Date: Mon, 09 Nov 2026 10:14:41 +0100
Message-ID: <20261109101441.Horde.kdJueQYqP_FYnw4Oz49l4pn@webmail.uni-tuebingen.de>
From: Dezhen Lu <dezhen.lu@student.uni-tuebingen.de>
To: Junxian Huang <huangjunxian6@hisilicon.com>
Cc: linux-rdma@vger.kernel.org, tangchengchang@huawei.com
Subject: Re: rdma-core: aarch64 mmio_memcpy_x64() ignores constant lengths,
 and libhns relies on it
References: <20261107231102.Horde.VTLAyGut_WGch71PWzwoxG_@webmail.uni-tuebingen.de>
 <7e10ea80-0dc0-68c5-2d16-7ff816c5735d@hisilicon.com>
In-Reply-To: <7e10ea80-0dc0-68c5-2d16-7ff816c5735d@hisilicon.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Disposition: inline

Junxian Huang wrote:
> Thanks for the report! The proposed fix LGTM. Once you submit the PR,
> we'll do the test on real hns hardware asap.

Thanks. The PR is up:
https://github.com/linux-rdma/rdma-core/pull/1851

It has the two commits as described: libhns passes 64 first, then the
macro checks __builtin_constant_p(bytecount) && (bytecount) == 64.

Dezhen


