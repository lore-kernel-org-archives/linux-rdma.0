Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E043937BE9E
	for <linux-rdma@vger.kernel.org>; Fri, 16 Oct 2026 08:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792140895; cv=none; b=V04sU0AIq+rijlSj5mJdhbBR28zpJXhOj1hgaPGpEPXhkt0n8VrCNiePzLsZQaGt/8wDb5CHZS/v+q5YxMC5OW/hPclEtQvJKxdAlkMaP2GmS92BoQTerdQJc7WE+g+JwtyHCVOx3TTN83lwvZSOMMPdv1lAxBYRFAZTB7GXMv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792140895; c=relaxed/simple;
	bh=SetulTecVqHPKtZMgtmlckaTsO8vcfc0YZt8suuDKqM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q090ZIrDWbICsVU5yuDwf73Zha398ARWg6iwUprVnwBw+QP1WACGkur09aMXbaTnwd/JtkIn5Wr/WSI9MJbbomuUdUp4Rrhta0367P/S24XOMBPDQb7UuNdlwvslplYKPLD8t8oIU0+eJ966s5Wu6gQbqwAK9kdAjrE8TXgGUz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=LAjMEUU/; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="LAjMEUU/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=ZaXYSs48hiDBET+dgSJgc18EP66GHmIw1k3iPy7rik0=; b=LAjMEUU/30aGGwAunyMTWikiiT
	jaH0mjBw7+nHBMt+1tO3gU6gQYtBGYReIpme9EcNaUqD3YoLbKk2e2uKiRhDaKzVgVPvdGb5B8g0U
	H108LeDllu+j9mz2nLG+BsoseNpsLWPOM4yl3jJZW8/R4H5B6EZqRSJCSHxgXF54oyNhV1zipZ3E5
	/cIKBJuWQvXWcZ/AacwsEafF5VywX152rSDkyMD2izupdhd6h6m0KgKVOXnI+YyFTgyjMW7U/bXvX
	DHC883mBIK0lOiI5kVgRT9ErNI/WgoAGxGqhj5OkQkeXj4KR3vTNSmEXqDfyD08ZxtSIomGcY/Mdj
	7qWzZaIfahAwbYWFLVE4GunkewpJuzH5kpxflHJ9JXQ1K0Qs2LgkgyL9VHYJYEbyjFO59/HCFkJJr
	dPEBbShhVw4TKFWIFysBWT5xYCNhJ9U9he0x35obz97PqXhrs/zgi+7UvJ+PjtPMjCpf1zhvib+Ca
	T34VCADJ+2zaeIr5zA5DIHDx;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xHdi7-00000002YI8-3DEm;
	Fri, 16 Oct 2026 08:54:44 +0000
Message-ID: <5904f535-c9d2-4326-b149-91b72938173d@samba.org>
Date: Fri, 16 Oct 2026 10:54:43 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/irdma: Fix FRWR IRDMAQPSQ_PBLADDR field population
To: Leon Romanovsky <leon@kernel.org>, tatyana.e.nikolova@intel.com,
 jgg@ziepe.ca, Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
References: <20261015161756.3078300-1-jmoroni@google.com>
 <179208986858.417468.8994738327508258200.b4-ty@kernel.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <179208986858.417468.8994738327508258200.b4-ty@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 15.10.26 um 20:44 schrieb Leon Romanovsky:
> 
> On Thu, 15 Oct 2026 16:17:55 +0000, Jacob Moroni wrote:
>> Previously, the IRDMAQPSQ_PBLADDR FRWR WQE field was being populated
>> using a mask that was right-shifted, whereas it should have been the
>> address being right-shifted.
>>
>> This ended up working fine in many cases because the lowermost 12 bits
>> are always zero (the addresses are page aligned) and the uppermost 12
>> bits are usually zero too, but it could break for DMA addresses that
>> are wider than 52 bits.
>>
>> [...]
> 
> Applied, thanks!
> 
> [1/1] RDMA/irdma: Fix FRWR IRDMAQPSQ_PBLADDR field population
>        https://git.kernel.org/rdma/rdma/c/59df57262e6fa9

My initial tests with this resolved the smbdirect related
data corruption.

So it replaces this with success:
https://lore.kernel.org/linux-rdma/20261012161135.494544-1-metze@samba.org/

Thanks!
metze
