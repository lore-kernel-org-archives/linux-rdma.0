Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792495727;
	b=QiaeyY6W8qMU2brAgB0DgCo+sbyqMajNVxhRAXvjqmBGTt4DTWp+e8ZN72kSVF/wCGgx
	 Z0rmRudEH0ax680ioJRqTZr9H4Jg9zVNTyac31O3w1df2HKoMF0aPSPdwXWyOqXGoul0I
	 JyBO9lEcdRCGXjWqKPeC/cqStxppj0FGwOoA+U62q0ZV5EAkhT5vGPSfJoMQUwA75JOj3
	 n6BsnuaNlNKQpQPy2RAZx1E5LulHPHrWXDaf3XjCgxR8YnrJ0ktWdaoPwiJHaXov9NkBY
	 fzjlCfhXrGYprckNApxNUydfvUOEkR8t1jhEZlTp4hvD10Y5LQLkGSXRtcEOKx7SMxA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792495727;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=PZiLc2FJzquG5xUHmScRfMBdmwa5Roffly8SX1z9Pgs=;
	b=tvwTA03+457kYIjyZ3/DkNyBAcOPKIlvH1LUWd0LdvzPMHjpVU+rYzX1oNQY6gXStgSE
	 B+jw5DsEnC0/XxHzLVgtNLv24PzJJ4BZfgM49Np0vGrgn5LiAYTd1p8yZSGbyNGaxNJKA
	 ouoY8/3VcPSYRVJNc0oPErR92Z56V0nml6K7DozioGkJ9SbeuqX9+fpzjYu1e+o9Y+RPf
	 mSk3duYk13r8BT9+DeX9oSfURJDO2i8H8rdfI46GOx2h5VyuLVv8jlHfW3PAXuVNUuGvq
	 3zJu7yA6X1ALxumAOPyNbDdoA1fu4Od1dD2/9qmt6t4krtzVUTF37wzB5ZRA4AZRmjg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=P2zBV+vR;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.52
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B38606A31D
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 11:28:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B5B38606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=P2zBV+vR
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-677d35fd1d2so3066545d50.1
        for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 04:28:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792495726; cv=none;
        d=google.com; s=arc-20260327;
        b=hmW5OZiRgapA4P41wIzyUVD+Tqm/ZCywrSSu020JjUbFm7mkVh+G6OpKdrfx4z4EE1
         q+DJ18TvNR0HSTJxRhxsL3H0vFl4ftEdz0K5oAs9x0HleRxbbWDnrUPGTcNuOObIU2fv
         rzox5wkpTU4pZWM9WmkoR3OSIYR5/Lx2+Lv9rgZL/Xc088tqGjREeggPzqWjCD4jfJC5
         lI1I7xlHXqjnh9NH9APUaip32Y7M8k69W+SYlnJMJuK0uEIEixosiOWROqxqRtruGMOh
         WibPbJYz1rLcuyaJaozlCLpNR9TZKmi2EiFg3M7QCPq5kS09i/yWxcufjrUTUnHqQ+KC
         zfJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PZiLc2FJzquG5xUHmScRfMBdmwa5Roffly8SX1z9Pgs=;
        fh=l/McMZaOnYdNv/8TpPFhrygKg8LOb4Qv7PFbZ2aT464=;
        b=FjbKUN/mq6x0BBnYRQ7Bnm4IkqoxL61LD2dyUvDNZDyz0QdIMgg+XtG3m2y0VEvjG2
         oK1J1xarlhjYF9ah5i6oFJu0j8c6EtUZYa2JkXiTo60a0Q4IWhpBHfp50yCuCe2HfhUY
         y4u6PvP6dc724uu9IHbbXJahSx6RD3oxcROXiHpq8zKALFQRYEAYr+t64+Bdk0MKQcAb
         HCJ+men9PfpSalP6XCsWy3O7Run/7W7psE0AwWtd9dPeY00DXECNEwlia7W8wRWjoyAf
         /oWngpHK6nHw18jGYFHhDjJZk//O2TBp93lxd2NY46Kynqkf440nj4e9J8kwP74UtuPy
         4vsA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792495726; x=1793100526; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PZiLc2FJzquG5xUHmScRfMBdmwa5Roffly8SX1z9Pgs=;
        b=P2zBV+vRpL7UXpo9kRn0S/qjdwNQ38BibI9CiFXlpxu2uX9sFfuD/pqJeeiFZUDbgb
         aDfQhQBQ7gNQ28P6uvHm/apUrgkFkEnDEi43NIOQNjCIyJ1rljlXGi141sqBFBxLJ/Lf
         tFfIJZU9nI/et1StK2L48asHSBDXN/b9zXxxQRTO1gDOQdNW363J2qj5qgKmUSiGbZTO
         aG8cnwMhPlDTW6RNa2L9qsa7ZNJ0GjDXvrc7Y2SbbuAnKfxRCeZMvcgid2foI/UaIQ70
         BnnkaRNaU039kMxKZTY1v8ApNPXWT4zVNTzOxcOHsILG4Dfynk4FGSZ1yqsPTW+NS7mj
         4lUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792495726; x=1793100526;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PZiLc2FJzquG5xUHmScRfMBdmwa5Roffly8SX1z9Pgs=;
        b=QSWJTmfMTATTkHh5tMGzL+zcQ5SzKn6dzkZFg9XckLl+m9VBK3Awxz9vwT4kS9Jl5R
         mOIF+KZd1io2j6vkrJ+DdHKcP8WbYv9hfMxJ+T2vPDBsVhKPuS+gVqiWnZxut5R04Nmp
         Wvh0QS732Xo7mz/aRL3Njd03mgZ1W6Lt0ktpa/d2bRZhdKmQGkYbON2Q5RRIUJKyS1Hs
         u0IBQWFDzjQ9XWZHlYl4RPU5ib8+ENa1s1ARfpkcJ+UCtjbKsfcC14wxOSx+CBkXTVob
         OqL7wRYT10OuGcemNPn1m8lIBvM4YYjqGAHZpnqGx1CHpUZgH1FEZzXBi1BEyboTjg+g
         ImOg==
X-Forwarded-Encrypted: i=1; AKwUvBzO4Tlgjuz9Dm8zvihtA47zbVgoZXipOovBn9WozsvOpXILIQTM7MjW1PwKqXzC4zxNdlp/HqDlbVJa@vger.kernel.org
X-Gm-Message-State: AFq9FYIEPRUY1YFw/+Me8VEKqyZcNrAlVqnq9ldaSqFjz9mSUQetV5zO
	X+EQOLH37xOD0tGCV7me0o+X1WASbJDK/J9ITFgft5YAsYXHmaOPgjjbvjL3J9fgnEnlvFXxFzs
	5RsSuBU5eyHmDIOYU/1ddM8KkCEhkZ4Y=
X-Gm-Gg: AYBFou0b63Tap7flUaUDWj6uPmUjTS+ts6Z8D1JdZMzcR7RDoXQDwJQdgksiTjLwF0q
	Du6jSFr2NRCwJG6gSWJ0r3B4QR/Q5arLf1jxE+If8idgCLdUGI1b29oqqR9roElFlgZGlH9OAl2
	mCvjbdRGJVa+nubHqry2ahot8vpdqd6eyP6yujbWabK61rTKScxpswWhkCr2tChr3Td1Z5If+aC
	BPL7guEbZYHYr7EeWU0dq4qGpiiQ4do5ZmWyHdLY+QWREol/bnxFODHFkozLlJHbg7pHXPHJsmD
	8X74fjkycqQnQM6fNZAAyeYcCcdAkrM+1jgRq7aF/oX+U9doGORVvzDEE57cdGx7Xgfe/Qsw0TK
	Sbd1jEiGA
X-Received: by 2002:a05:690c:6604:b0:8b0:dd32:d6ca with SMTP id
 00721157ae682-8b0f21b39ccmr35306147b3.59.1792495725784; Tue, 20 Oct 2026
 04:28:45 -0700 (PDT)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261012150311.555104-1-ekffu200098@gmail.com>
 <20261018151325.GP503057@horms.kernel.org> <327efca9-7df1-437f-8040-a244111d719e@nvidia.com>
In-Reply-To: <327efca9-7df1-437f-8040-a244111d719e@nvidia.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Tue, 20 Oct 2026 20:28:35 +0900
X-Gm-Features: AclHuK_T3LY9btY6nnZpWl7lP_oogPcSS-OenmwKtFiMhqPXy3keZX8vw6zZN-o
Message-ID: <CABFDxMEYVzfeVCy-BohLTTSrcuji43o0zd-nr7Nr8zqWcq7BiQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net/mlx5: Remove redundant memset after kvzalloc
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Simon Horman <horms@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>, 
	Paolo Abeni <pabeni@redhat.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Simon and Tariq

2026=EB=85=84 10=EC=9B=94 20=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 3:44, =
Tariq Toukan <tariqt@nvidia.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
>
>
> On 18/10/2026 18:13, Simon Horman wrote:
> > On Tue, Oct 13, 2026 at 12:03:10AM +0900, Sang-Heon Jeon wrote:
> >> kvzalloc() returns zeroed memory, so the memset after the allocation i=
n
> >> mlx5e_post_meter_create_mtu_table() and macsec_fs_tx_create() is
> >> redundant.
> >>
> >> So remove the memset.
> >>
> >> No functional change.
> >>
> >> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> >
> > Hi Sang-Heon,
> >
> > I'm not sure if the value this cleanup brings is worth the churn.
>
> Exactly!

Fair enough. I do believe this patch can be helpful to future readers.
But I fully respect the community and other people's resources. So
just let me know if you don't want to see this kind of patch later.
I'll keep that in my mind.

> > But I do believe it is correct.
> >
> > Reviewed-by: Simon Horman <horms@kernel.org>
>
> Anyway,
>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks for the review :)

Best regards
Sang-Heon Jeon
