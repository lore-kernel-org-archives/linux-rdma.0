Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279688;
	b=hSxiRAzzIGQ9mR991x6G4wPtVeJ/Ee6bUds08/A+cBaaRscQ8DUbWssrAMZsHHTzKtdr
	 RST2rgmu5+VqgiOg5yCtvbD+I2uRjOlHe2Z0nZ9d8qnnOITrFjxepIoRxrdV3MUG8jZcO
	 xjE+iQABSCnlhKHh7mnTPLJrcJIYBn9RHaM1aaa5RpibUIDlGsDoHtQa7eRKKbjxm1Cva
	 vMhMGrQKS0LsAYha6TYZfMJIvYWsGZ250+x307bwuGqRI2xUN4+N6cgsRiW4elI9obXyg
	 l2w2GI0P2GxVe+q+54GxXatu24NZUE9WKIMk9h7mxFuxPJEu8J5sTORZB2l5vLbsYRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279688;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jahtBZOJe+7+2N5SkoAMkPIdliEdUcLfb/yopyYMb4I=;
	b=rCaEGGJuisVvUlWU/GUqJRAzP+Etx1AiPRNrHqujCyAdpQNwznKewifEjzWC2q3EzfZ/
	 YS5+IJ9iKnR2Bd1X3ULnJE+trT28eR06vp6xAhxDqJ4CfG/Ak6c8Zm04xyLQjlml6QHx/
	 xzqFwzy9X/XVdeYD0NL0FxDHHn4O0jlnhyXVrQMoUWUJM68ZmNQC+7fjYeQnGsnHbnvky
	 H30KASU7zo/JFdxXgdL7POvJII2Al5ilCfQGLxZ/u0C4fVdJmBHsPBfM69m8C2nVM15Rv
	 CmN/aPk/uvjTZ9TyRDPD8TPSZ4rYhtWkNTr8hDFL+9rUTYIt9OCGAaV2xJ8Ko4JIJnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OTsgGRRh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265D3606A32A;
	Tue, 10 Nov 2026 03:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OTsgGRRh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6781F008A2;
	Tue, 10 Nov 2026 03:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794279688;
	bh=jahtBZOJe+7+2N5SkoAMkPIdliEdUcLfb/yopyYMb4I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OTsgGRRhBAqNQ45zko+AV/XSMAjZWeBBTjIpcPFQuFZeDwrJtAM9bu6i/eZCCDsHc
	 PXELZMGuAhYoF+sWTXXjmn6iFZmO3PDQqAK4kTSD4hTT817aSA0coprFQfUjHxgKk1
	 gA0M8E0Ud6EkFK9d3DBPzdkfTENUhOKowGrkdLDz7yrrP0Cpp5EHfZZC4vy+TEGvW/
	 HvYr5DBy8QrEsm63Bfe33KfumZcu+ivTuM/+NaaD5wRUnkq1KD93ckyr5pdQeCzjT+
	 00Iy20HXC5d53jbw8jdJWdeozvYABDcr6O4wYeGJOYinLi5P1OUsAj1CLIg8oE4Zwg
	 OAhXihpGMO2gA==
Message-ID: <sashiko-outbox-206079@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 06/14] sctp: annotate data-races around sctp
 sysctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: linux-security-module@vger.kernel.org, mptcp@lists.linux.dev, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261109025425.328445-7-jiayuan.chen@linux.dev>
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
 <20261109025425.328445-7-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 03:01:26 +0000
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
- [Low] sctp: missing READ_ONCE() on cookie_auth_enable in
  proc_sctp_do_hmac_alg()
- [Low] sctp: missing READ_ONCE() in proc_sctp_do_rto_min() and
  proc_sctp_do_rto_max()
--

commit 93a2b54452b64ee91dbf610597cfa8b06cc871d2
Author: Jiayuan Chen <jiayuan.chen@linux.dev>

sctp: annotate data-races around sctp sysctls

This commit adds READ_ONCE() and WRITE_ONCE() annotations to per-netns SCTP
sysctl variables accessed concurrently by readers and sysctl handlers.

> diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
> index 2b94c211427de..8a84ae3272d24 100644
> --- a/net/sctp/sysctl.c
> +++ b/net/sctp/sysctl.c
> @@ -402,11 +402,11 @@ static int proc_sctp_do_hmac_alg(const struct ctl_t=
able *ctl, int write,
>  		if (ret)
>  			return ret;
>  		if (!strcmp(tmp, "sha256")) {
> -			net->sctp.cookie_auth_enable =3D 1;
> +			WRITE_ONCE(net->sctp.cookie_auth_enable, 1);
>  			return 0;
>  		}
>  		if (!strcmp(tmp, "none")) {
> -			net->sctp.cookie_auth_enable =3D 0;
> +			WRITE_ONCE(net->sctp.cookie_auth_enable, 0);
>  			return 0;
>  		}
>  		return -EINVAL;

[Severity: Low]
Should the read path right below in proc_sctp_do_hmac_alg() also use
READ_ONCE(net->sctp.cookie_auth_enable)?

net/sctp/sysctl.c:proc_sctp_do_hmac_alg() {
    ...
	if (net->sctp.cookie_auth_enable)
		tbl.data =3D (char *)"sha256";
    ...
}

Unlike proc_dointvec(), proc_dostring() only sees the selected string
literal, so a concurrent sysctl read and write of cookie_hmac_alg still
race on net->sctp.cookie_auth_enable.

> @@ -441,7 +441,7 @@ static int proc_sctp_do_rto_min(const struct ctl_tabl=
e *ctl, int write,
>  		if (new_value > max || new_value < min)
>  			return -EINVAL;
> =20
> -		net->sctp.rto_min =3D new_value;
> +		WRITE_ONCE(net->sctp.rto_min, new_value);
>  	}
> =20
>  	return ret;
> @@ -469,7 +469,7 @@ static int proc_sctp_do_rto_max(const struct ctl_tabl=
e *ctl, int write,
>  		if (new_value > max || new_value < min)
>  			return -EINVAL;
> =20
> -		net->sctp.rto_max =3D new_value;
> +		WRITE_ONCE(net->sctp.rto_max, new_value);
>  	}
> =20
>  	return ret;

[Severity: Low]
Do proc_sctp_do_rto_min() and proc_sctp_do_rto_max() also need READ_ONCE()
when dereferencing ctl->extra2 and ctl->extra1?

sctp_sysctl_net_register() points rto_min's extra2 at &net->sctp.rto_max
and rto_max's extra1 at &net->sctp.rto_min:

net/sctp/sysctl.c:proc_sctp_do_rto_min() {
	struct net *net =3D container_of(ctl->data, struct net, sctp.rto_min);
	unsigned int min =3D *(unsigned int *) ctl->extra1;
	unsigned int max =3D *(unsigned int *) ctl->extra2;
    ...
}

Reading or writing rto_min while rto_max is being updated (or vice versa)
still performs an unannotated plain read against the peer handler's
WRITE_ONCE().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109025425.3284=
45-1-jiayuan.chen@linux.dev?part=3D6
