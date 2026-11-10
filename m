Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279687;
	b=Byc/0o/bhT08/kkuZYVXH1h3WGqR91OoJFD70PGCZkGVaYnXh/H/O4UUMGszC61Sd0uH
	 3liFg/vvO10HxFVh5ygEd1ct8DIgQ45B7jciiErAUUwEZsDZSzDCm06GxIhJiTDqhAj00
	 AkcDqa+nM8W10AZfeqWztTjEols/xrDrQPBhI3RggyaThcEHhR+/ljFDQeRFLzFq10AqZ
	 BbfgW3k8sX9nx88E34I+4nawdYNLCn8AsauDpk24KzArmpVMGiAX5trtkWKKvtHjnDDuN
	 nbFpGgoT6pzg50s1NFFBWdPIY3kfcTsEujOn78/wrysy13ef0+miYyl1JCxRuXuh/hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279687;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=LwPxb87P/ZMSlxzE35IFxKPrriUKfDnffp+r/ViXC3I=;
	b=OY2yr90byHVziSrD8QIZ7WqiaK35UOL0H4WZBlCQpNB8F8WaRAkANqZ3IGunTb2rWrin
	 /vEzeZOCNEUxkkKQ+XxaVQQz9xgiswoySvZY3ENXaURDwLF5VR1zCqPsKCW7n5VNEBxVY
	 bydw+UYrXQ/IBN0gg7QB5dEJ0zzjFSw+EU/uyYU9TAWv2UH1vowvoJIOxu+hk5xMdoPby
	 neZR4AilmnszmSQ1ofMwu+0fZGWfN0yH12/pD4nzfzFy6buYkLpm9ZakH5dKt0HNL+fkw
	 I8HeABYZ8aeaW1YQuvgsH3enROUuYytF4lh10jVmM2BY0VH0HMZ+oKMUjtfni94t+sA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CupUMgNE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70CF606A321;
	Tue, 10 Nov 2026 03:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CupUMgNE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2911F008A1;
	Tue, 10 Nov 2026 03:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794279686;
	bh=LwPxb87P/ZMSlxzE35IFxKPrriUKfDnffp+r/ViXC3I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CupUMgNE4szJI0b3013+VDsRDXINyPSHRuwidqb5s04joTezM3+dfd3xcAUFuoN2b
	 0xaBzjsvHoCl4MDCgwmWrPwCcy4R/oZeG4Vv+xVPfXlYaahns3rlUHcufF3Ar6iVns
	 pS0c1ArkCAgJEB866bWspTOsHXojaIrAoJOpzdfhw7o9MIMtuacLel91rg7pCaFlQs
	 HXiAmRo9OGQ383BdQrB063LYCuAoRNC2OrHERQzNJf1s6JwsTQHVEK6rV685+tK8Gc
	 oPLgS+65wNv+tPv6ZxoqMIhA0hQ+HkZo+ZjSTZS5N0ymcOXDNy+pvTrKVn6XhvQkyQ
	 x88kqxBGVpNNw==
Message-ID: <sashiko-outbox-206078@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 05/14] calipso: annotate data-races around
 cache sysctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: linux-security-module@vger.kernel.org, mptcp@lists.linux.dev, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261109025425.328445-6-jiayuan.chen@linux.dev>
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
 <20261109025425.328445-6-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 03:01:25 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] calipso: double READ_ONCE() of bucketsize in
  calipso_cache_add() causes TOCTOU
- [Low] calipso: missing Fixes trailer for commit 4fee5242bf41 in commit
  message
--

commit 430c1b1d214e9e8a15979062b88b1428916c12ef
Author: Jiayuan Chen <jiayuan.chen@linux.dev>

> calipso: annotate data-races around cache sysctls
>=20
> calipso_cache_enabled and calipso_cache_bucketsize are read without any
> lock while their sysctl handlers update them with WRITE_ONCE(). Add
> READ_ONCE() to the readers.
>=20
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

[Severity: Low]
Should this include a Fixes tag for the commit that introduced the
unannotated sysctl reads?

  Fixes: 4fee5242bf41 ("calipso: Add a label cache.")

> diff --git a/net/ipv6/calipso.c b/net/ipv6/calipso.c
> index e399a42e30839..5e63212b60163 100644
> --- a/net/ipv6/calipso.c
> +++ b/net/ipv6/calipso.c

[ ... ]

> @@ -269,7 +269,7 @@ static int calipso_cache_add(const unsigned char *cal=
ipso_ptr,
>  	struct calipso_map_cache_entry *old_entry =3D NULL;
>  	u32 calipso_ptr_len;
> =20
> -	if (!calipso_cache_enabled || calipso_cache_bucketsize <=3D 0)
> +	if (!READ_ONCE(calipso_cache_enabled) || READ_ONCE(calipso_cache_bucket=
size) <=3D 0)
>  		return 0;
> =20
>  	calipso_ptr_len =3D calipso_ptr[1];
> @@ -289,7 +289,7 @@ static int calipso_cache_add(const unsigned char *cal=
ipso_ptr,
> =20
>  	bkt =3D entry->hash & (CALIPSO_CACHE_BUCKETS - 1);
>  	spin_lock_bh(&calipso_cache[bkt].lock);
> -	if (calipso_cache[bkt].size < calipso_cache_bucketsize) {
> +	if (calipso_cache[bkt].size < READ_ONCE(calipso_cache_bucketsize)) {
>  		list_add(&entry->list, &calipso_cache[bkt].list);
>  		calipso_cache[bkt].size +=3D 1;
>  	} else {

[Severity: Medium]
Can reloading calipso_cache_bucketsize with a second READ_ONCE() corrupt
calipso_cache[bkt].list when the sysctl changes concurrently?

net/ipv6/calipso.c:calipso_cache_add() {
	...
	} else {
		old_entry =3D list_entry(calipso_cache[bkt].list.prev,
				       struct calipso_map_cache_entry, list);
		list_del(&old_entry->list);
		list_add(&entry->list, &calipso_cache[bkt].list);
		calipso_cache_entry_free(old_entry);
	}
	...
}

The else branch assumes the bucket list is non-empty because
calipso_cache_bucketsize was checked to be positive at function entry.
With two separate READ_ONCE() calls, a concurrent sysctl write can change
calipso_cache_bucketsize between them while calipso_cache[bkt].size is 0:

CPU0                                    CPU1
calipso_cache_add()
  READ_ONCE(calipso_cache_bucketsize)
    -> > 0
                                        proc_dointvec()
                                          WRITE_ONCE(calipso_cache_bucketsi=
ze, 0)
  spin_lock_bh(&calipso_cache[bkt].lock)
  calipso_cache[bkt].size <
    READ_ONCE(calipso_cache_bucketsize)
    -> 0 < 0 (false)
  old_entry =3D list_entry(...)
  list_del(&old_entry->list)
  calipso_cache_entry_free(old_entry)   <-- frees list head as entry

When calipso_cache[bkt].size is 0 and the second READ_ONCE() observes 0,
the else branch unlinks the empty list head and passes an interior pointer
of calipso_cache to calipso_cache_entry_free().  If the second READ_ONCE()
observes a negative value, comparing u32 calipso_cache[bkt].size against a
negative int promotes it to a large unsigned value and bypasses the bucket
size limit.

Snapshotting READ_ONCE(calipso_cache_bucketsize) into a local int variable
once and reusing it in both checks, as cipso_v4_cache_add() does in
dd44f04b9214 ("cipso: Fix data-races around sysctl."), avoids the second
load.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109025425.3284=
45-1-jiayuan.chen@linux.dev?part=3D5
