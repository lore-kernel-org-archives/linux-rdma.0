Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCF0441020;
	Thu, 11 Jun 2026 18:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781202932; cv=none; b=KVGnNBkka9nZwuez7R7Z3QjwfiuwyAniyQfoLaKS2Np8T02dSNOM38p/FSVfvVdqo02JrN9SBPawRTxy8kIqwWIDmHe2NkO3c6NbUMBLB1DRspKgzaol317tV8NHy2eIMcwaADzH8XeFkmexvbmNwgGlzKPvVVP3APHZ+9qTFvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781202932; c=relaxed/simple;
	bh=TdsLNy3J48DIEkZE95wz4+H92kY/6ccYrj2Y27LTQjU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HnVeJEXSOf7o1EXgB3WMFvlWk3IXApR/M+IUTTrF5f+NPDYNYez6ameTShOv0mwvkx88kGzU2exW9HpRyhrltunGZHDiuunuCdWmnRJh0rArJC1tYZ/rIvX+XsoWVJp+2XwmT+wrGJoh1sM7NR3fClgdk88u1qw3L+EXYkDMV14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T3lRWgIY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T3lRWgIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925F41F000E9;
	Thu, 11 Jun 2026 18:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781202930;
	bh=zP78fCboUMqsgOMHEpBSMPeHIld6qJheOyCP6eS27Yg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=T3lRWgIYua101YJvc0nCGWrlU/HoMvh09Q86r4EwDaN5eBBBasfcdprGobppOcOwS
	 /yOYlnTrz/TuBdEVFoKT6no6fKS9iTmwKQaUvGXMjzhU5HELVoweWXN4SG7BPpVMAO
	 9CQKKXtKVTiImltbSqVf0WHs1KNwX9Z90lQkY99K6ccsNAI1n5b+QzQPTrsnWQAgUW
	 GKAqRKvhueEWhDhQzyVcAQ61JoaeczwmqueblKIOCmECY4lN0BHnMC6s2GH6clOkhF
	 0eBnLlAtQaUmLPwAWBdp/DYmmNiwDRcHEpx45NPuB6Hicbh8PRY+foJARHRcdSlQxQ
	 pJcayvBtGMXjg==
Message-ID: <1101d5bd0bb23a07f5184f9f448d71e5649fdf75.camel@kernel.org>
Subject: Re: [PATCH net-next v3 2/2] rds: convert to getsockopt_iter: manual
 merge
From: Allison Henderson <achender@kernel.org>
To: Matthieu Baerts <matttbe@kernel.org>, Breno Leitao <leitao@debian.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com, "David S. Miller"
	 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	 <horms@kernel.org>, Shuah Khan <shuah@kernel.org>, Andy Grover
	 <andy.grover@oracle.com>, Mark Brown <broonie@kernel.org>, Linux Next
 Mailing List <linux-next@vger.kernel.org>
Date: Thu, 11 Jun 2026 11:35:28 -0700
In-Reply-To: <2e1b0534-a1a0-4eb1-a5e2-d42fcf991188@kernel.org>
References: <20260608-getsock_more-v3-0-706ecf2ea332@debian.org>
	 <20260608-getsock_more-v3-2-706ecf2ea332@debian.org>
	 <2e1b0534-a1a0-4eb1-a5e2-d42fcf991188@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-06-11 at 14:52 +0200, Matthieu Baerts wrote:
> Hi Breno, Allison,
>=20
> On 08/06/2026 11:44, Breno Leitao wrote:
> > Convert RDS socket's getsockopt implementation to use the new
> > getsockopt_iter callback with sockopt_t.
> >=20
> > Key changes:
> > - Replace (char __user *optval, int __user *optlen) with sockopt_t *opt
> > - Use opt->optlen for buffer length (input) and returned size (output)
> > - Use copy_to_iter() instead of put_user()/copy_to_user()
> >=20
> > The RDS_INFO_* snapshot path in rds_info_getsockopt() used to pin the
> > userspace buffer with pin_user_pages_fast() on the raw optval address;
> > the info producers then memcpy into those pages under a spinlock via
> > kmap_atomic() and so must not fault. Obtain the same page array and
> > starting offset from opt->iter_out with iov_iter_extract_pages(), which
> > pins for write because iter_out is ITER_DEST.
> >=20
> > The page array is preallocated here (sized with iov_iter_npages()) and
> > passed in, so iov_iter_extract_pages() fills it in place rather than
> > allocating one for us; RDS therefore keeps ownership of the array on
> > every return path and frees it itself. The rds_info_iterator /
> > rds_info_copy machinery and all producer callbacks are unchanged.
> >=20
> > Kernel buffers (ITER_KVEC) are not page-backed in a way the info
> > producers can use, so the RDS_INFO path returns -EOPNOTSUPP for them;
> > this matches the previous behaviour, where a kernel-buffer getsockopt
> > hit the WARN_ONCE() path in do_sock_getsockopt() and returned
> > -EOPNOTSUPP. The simple RDS_RECVERR and SO_RDS_TRANSPORT options keep
> > working for kernel buffers via copy_to_iter().
>=20
> (...)
>=20
> > diff --git a/net/rds/info.c b/net/rds/info.c
> > index f1b29994934a..499b3774860e 100644
> > --- a/net/rds/info.c
> > +++ b/net/rds/info.c
>=20
> (...)
>=20
> > @@ -230,13 +239,16 @@ int rds_info_getsockopt(struct socket *sock, int =
optname, char __user *optval,
> >  		ret =3D lens.each;
> >  	}
> > =20
> > -	if (put_user(len, optlen))
> > -		ret =3D -EFAULT;
> > +	opt->optlen =3D len;
> > =20
> >  out:
> > -	if (pages)
> > +	/*
> > +	 * iov_iter_extract_pages() pins only user-backed (ubuf) iters;
> > +	 * iov_iter_extract_will_pin() reports whether an unpin is owed here.
> > +	 */
> > +	if (pages && iov_iter_extract_will_pin(&opt->iter_out))
> >  		unpin_user_pages(pages, nr_pages);
>=20
> FYI, we got a small conflict when merging 'net' in 'net-next' in the
> MPTCP tree due to this patch applied in 'net':
>=20
>   f512db8267b73 ("rds: mark snapshot pages dirty in rds_info_getsockopt()=
")
>=20
> and this one from 'net-next':
>=20
>   6e94eeb2a2a6 ("rds: convert to getsockopt_iter")
>=20
> ----- Generic Message -----
> The best is to avoid conflicts between 'net' and 'net-next' trees but if
> they cannot be avoided when preparing patches, a note about how to fix
> them is much appreciated.
>=20
> The conflict has been resolved on our side [1] and the resolution we
> suggest is attached to this email. Please report any issues linked to
> this conflict resolution as it might be used by others. If you worked on
> the mentioned patches, don't hesitate to ACK this conflict resolution.
> ---------------------------
>=20
> Regarding this conflict, I took the modification from net-next, but
> using unpin_user_pages_dirty_lock() from net.

Hi Matt,

Yes, the conflict resolution looks correct to me. =C2=A0
Thank you for fixing this.

Allison

>=20
> Rerere cache is available in [2].
>=20
> Cheers,
> Matt
>=20
> 1: https://github.com/multipath-tcp/mptcp_net-next/commit/a8d41e018cc6
> 2: https://github.com/multipath-tcp/mptcp-upstream-rr-cache/commit/88eeb
>=20
> Cheers,
> Matt

