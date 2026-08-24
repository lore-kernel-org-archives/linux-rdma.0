Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51013839B9
	for <linux-rdma@vger.kernel.org>; Mon, 24 Aug 2026 18:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787596169; cv=none; b=t3ZcvcS/nu+DeRNXlenxXBgVC9RjghTRGFkVqyiXeABY1/ZTMYcubB0vaBMQ/DnhXni3TWzGRbG51Ar7/gq4le5CYWAfDMpdnUJ5IYjnQ3VNWcwEmUtNsBLLt0U3/jPgYbkBLVlZlkY5/24/a0Fjx++2frAtKzOOCd+NTFAxJjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787596169; c=relaxed/simple;
	bh=vneEVqbupcQabJxu8kWTwHb6ra6+uyN8D1N8WTAPuQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fmVJNHSqDibmLqo7CkfikmM/YAB/BrF/bKxWHQH4b+2h1KH/lC+4dYXr/J/XX6+RxpYSra8EmvfT4kSQQucniUj9ShEw47QFJw895EUT59Cc+m75xR8zG9OGJZl05FMlrIHQHXy3OuzSmiS732YiCPba6Zd/+DpuSzyMUPc4VMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TmS/iezu; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TmS/iezu"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c20e70a0962so581579166b.2
        for <linux-rdma@vger.kernel.org>; Mon, 24 Aug 2026 11:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787596166; x=1788200966; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vneEVqbupcQabJxu8kWTwHb6ra6+uyN8D1N8WTAPuQc=;
        b=TmS/iezuqyGJ/j874tAS+6xx3BTol9hlHLHxcO6OCLVGYlB5ScEFz8Q0wns6zojcZY
         YHm4LSa2N+jG14Ie1ZEIiUFvQDyqCAauxnVVhEZyUl7TvkgoxedL0Mr6cXWy39PaCLC2
         NI+LA5G+NyGJz0Ka47WmxX5JaL3cHF7TdTw0frDl60EbALTxC9pdJd6o0Fct5teoTQ8G
         arn8uZmu/2EJyGDDTEyoS6m5+WeGcbhhFZ0MAY7kDnr6Oa7qFCg8Tj8XhZ69pq0PwKyF
         Jci/imSEaRmRrQNzS8SCpXR92YNO5tyIAboLNlrSZ77wBSGcXzk6W1Oqgd4GJ237+wZK
         M27w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787596166; x=1788200966;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vneEVqbupcQabJxu8kWTwHb6ra6+uyN8D1N8WTAPuQc=;
        b=Fc/P+Mb/hNwMFmkkhNgLI65ehtOjA2U8ztMXNtX5PkwNx1Nl/p8ZBTwBpV3V4mc7PA
         4WRzyOfkQtT5cIn/ICLa57nkx49vaiLz7kujFSB7dHvVKo09xKjc7vn8nql4HVENMQUg
         rYkrCbkqit1S8dnfQLM+JCwQ8JBuGWGqQP+RFQXX9ix1ZZK0vJ/rY+Bd0c822dJdGpcv
         rIdMvjsiKPQ3n7omJAZ08okmgzkBa0Sj2Ng8qzYyrwXB9Q+CEC8hnYWgz3BJ/nknAMSo
         JDxo+wjOjgSMcStdq0PSA+BLOeV7mJq0ej/qPS/kQIIRPpqHu7xrRL7N1sb65nyOA7Lh
         uNnw==
X-Gm-Message-State: AFuF++kGhZNK7CyeMZTCR1T354BylRm3tw8LpHQNwoUgMIpEEU0OqMcH
	ToRW2SM8DhBHdPuM20YntNFQTMOWYUm9Vp4ie8ZU99kHIMjrPQ+NADoHs+Hif4oB5bk=
X-Gm-Gg: AR+sD12WdTISIjm4Nn+xLvr1HcmBvRqVZdJkAxKSU+AdRuR4S2aFF9tZq1+BFcLIvMm
	pMVGRH30t9qqQgzX55FyMymDgGqA0qFRqCSfPZPbwy9xQ3pqfe1iVnUg2JtLWbT9cSxE5CuoHYc
	rMPZ+E19+0VGeLQ0NldKC9U+IadI49LQDmJHznjCvdMKF/3M5eNHPpyqZJkbpYoB1ogmVKVtJqM
	VDm78Lk0ujnuo9Bv59sMIcryheW33mOUNIvzxcu2egZRxk6DNFBPrNoj8HD7CdY//GZ/De+U1x3
	AE++dPaSgX0HtfQpt6oas18vgL5gB0D56HbDWW5Ys4gW/I6CxqJYfeJLsGiMviUo75IBqc2ICnA
	qXh2J+PsA9nsuYYY7XRZkO9vk/ew0XksQmD/r6WtWPu4Ww2fDF/SjAGO28Lk+UukrUcJlhXl+xv
	lmey4qqXigJPNt8YPCN33iNpV1k7in/T2gikxcV0B4Cj4OD30BObLWIOphuYgie94=
X-Received: by 2002:a17:906:fe48:b0:c15:fc59:cdf3 with SMTP id a640c23a62f3a-c24b3ebee48mr1527958466b.12.1787596166247;
        Mon, 24 Aug 2026 11:29:26 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24d8375776sm315993966b.31.2026.08.24.11.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 11:29:25 -0700 (PDT)
Date: Mon, 24 Aug 2026 20:29:23 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: linux-rdma@vger.kernel.org, cgroups@vger.kernel.org, 
	netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	jgg@ziepe.ca, leon@kernel.org, parav@nvidia.com, mbloch@nvidia.com, 
	cmeiohas@nvidia.com, roman.gushchin@linux.dev, bvanassche@acm.org, 
	zyjzyj2000@gmail.com, shuah@kernel.org, tj@kernel.org, hannes@cmpxchg.org, 
	alibuda@linux.alibaba.com, dust.li@linux.alibaba.com, sidraya@linux.ibm.com, 
	wenjia@linux.ibm.com, yanjun.zhu@linux.dev, cui.tao@linux.dev
Subject: Re: [PATCH rdma-next v3 08/14] RDMA/cgroup: Disambiguate devices
 across net namespaces
Message-ID: <aoyNXoZ4K2i_TNi-@localhost.localdomain>
References: <20260716132316.1495242-1-jiri@resnulli.us>
 <20260716132316.1495242-9-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cxu7rzeeuvesxlev"
Content-Disposition: inline
In-Reply-To: <20260716132316.1495242-9-jiri@resnulli.us>


--cxu7rzeeuvesxlev
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH rdma-next v3 08/14] RDMA/cgroup: Disambiguate devices
 across net namespaces
MIME-Version: 1.0

Hello Jiri.

On Thu, Jul 16, 2026 at 03:23:09PM +0200, Jiri Pirko <jiri@resnulli.us> wro=
te:
> From: Jiri Pirko <jiri@nvidia.com>
>=20
> RDMA device names are unique only within a network namespace, but an
> RDMA cgroup can account resources for devices from multiple namespaces.
> Duplicate names therefore make cgroup output ambiguous and can cause
> limit writes to select the wrong device.

=46rom the cover letter:
| A device in one network namespace therefore cannot use a name already
| taken in another, even in exclusive netns mode (netns_mode=3D0) where
| the two are otherwise isolated. Net devices have no such restriction -
| their names only need to be unique within a network namespace.

If this is modelled after net devices, why not make the visibility netns
based?
I.e. only list (write to) devices of the caller's netns.

>=20
> Use the system-wide RDMA device index to distinguish duplicate names
> while preserving the existing UAPI for unique names. Reject ambiguous
> name-only writes with -ENOTUNIQ and expose a complete device view to
> administrators.

I admit, the administrators won't get the full view but that's no
different from the netns devices situation.

Regards,
Michal

--cxu7rzeeuvesxlev
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaoyNfxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ag9cgEAmqyg7SX/4xxY6jGBQ6Ho
ldb//2ddSquKpPFaT3oiD/8BAOPzNVL2AFncp/3gajGpePR8JfvA8gWP67r2kNjr
koMD
=6AcV
-----END PGP SIGNATURE-----

--cxu7rzeeuvesxlev--
