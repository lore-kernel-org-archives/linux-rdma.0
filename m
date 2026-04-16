Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0B03002B3;
	Thu, 16 Apr 2026 22:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776377887; cv=none; b=sNO4FZOTsbPW5Jo+yLn4vqfLDfTSOGrloqaC30tDwzFbLZ5Qt6Vx97MM/73mHpjIe/5w6l+TZMuv18Aur/V/pstbVCD6S4s3dIV8bkAcIryRichUU+dAFQd6dux/2pGFwfFTnIT2cdcEQVHiNbO+PgBCVRQF3HM382S5K0fxKLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776377887; c=relaxed/simple;
	bh=rdbqAcea2bPOghKecjij3X2YtJQEorGpdyp2Altmn+Q=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jcNdixp/1qXm8o5/crYORchQ6jawYRgA9R0RkdLJJoYM0zWsb8ClKSquzoJRg+zmTN1VVhU+qCSHo4Pus/D2R16rAQTGc/Nf82PZENqKA7kri/ncf9jKoV6x9LvDwtyfQOA1Wi3I0MYX1hOSEWHi+BXophF+LjyxjZRGOZMXUl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hbZ6xJQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hbZ6xJQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BF5C2BCAF;
	Thu, 16 Apr 2026 22:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776377887;
	bh=rdbqAcea2bPOghKecjij3X2YtJQEorGpdyp2Altmn+Q=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=hbZ6xJQx2qwzmR4PWUUytEZ0fc+38tvleLjQ3tIO7XEPwbJDKPPQmr5XacYnAqCkW
	 ZdncbCBpB8kGmRIW3sw1bUOBQnF2qL+EzrPPE0r8E6jtdMAlwdr6xW6Ru+CH6QqleL
	 hEkXeFs9D+L3Cw2HWbMa/3C4mHixZZPwe7tOzk4JCcckfJ3K7zcz1kdFdHJYgGZ7fL
	 PwY5sHwWVB4G/FtQ20encCFM0TtFQFZDwkgsPZMZMe1biSuN9Z3gLZLW6Wr5HamCgr
	 iICBZhQub9rSSSNH28BiajymXVHydnfKfDW5GtrlGbXDh0bKoixku2ZRgccIlNFkAT
	 3dzrz0I9rA7hQ==
Message-ID: <8d25047d6fe36dda1a872ea710c5ce69adcfe2b9.camel@kernel.org>
Subject: Re: [PATCH net v2] RDS: Fix memory leak in rds_rdma_extra_size()
From: Allison Henderson <achender@kernel.org>
To: Xiaobo Liu <cppcoffee@gmail.com>, Paolo Abeni <pabeni@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>, Simon Horman
 <horms@kernel.org>, netdev@vger.kernel.org,  linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com,  linux-kernel@vger.kernel.org
Date: Thu, 16 Apr 2026 15:18:05 -0700
In-Reply-To: <CAJeqHv+kCScdMLYgOPG0TaRwTH5-Vo-=HEPs+oX24OprbmtbwA@mail.gmail.com>
References: <20260413070005.15272-1-cppcoffee@gmail.com>
	 <d0e820ce-2a79-4443-ade5-a03d16f712bb@redhat.com>
	 <CAJeqHv+kCScdMLYgOPG0TaRwTH5-Vo-=HEPs+oX24OprbmtbwA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-04-16 at 18:00 +0800, Xiaobo Liu wrote:
> The internal addition of kfree and setting the pointer to NULL in
> rds_rdma_extra_size makes the function more self=E2=80=91consistent and s=
ecure.
> After applying this patch, kfree(NULL) in rds_sendmsg is also safe and wi=
ll
> not cause a double=E2=80=91free.

Hi Xiaobo,                                                                 =
             =20
                 =20
Paolo makes a good point that I had missed in that rds_sendmsg owns the
cleanup. So even though iov->iov isn't freed here, it isn't leaked
either. Self-consistency is fair as a style point, but it's not
strong enough to justify the change on its own since it isn't a bug
fix. That said, thank you for taking the time to look at this area;
we appreciate the effort to help track down and fix bugs.

Thanks,        =20
Allison

>=20
> On 4/16/2616:20 Paolo Abeni <pabeni@redhat.com> wrote:
> >=20
> > On 4/13/26 9:00 AM, Xiaobo Liu wrote:
> > > @@ -595,11 +600,20 @@ int rds_rdma_extra_size(struct rds_rdma_args
> *args,
> > >                * nr_pages for one entry is limited to
> (UINT_MAX>>PAGE_SHIFT)+1,
> > >                * so tot_pages cannot overflow without first going
> negative.
> > >                */
> > > -             if (tot_pages < 0)
> > > -                     return -EINVAL;
> > > +             if (tot_pages < 0) {
> > > +                     ret =3D -EINVAL;
> > > +                     goto out;
> > > +             }
> > >       }
> > >=20
> > > -     return tot_pages * sizeof(struct scatterlist);
> > > +     ret =3D tot_pages * sizeof(struct scatterlist);
> > > +
> > > +out:
> > > +     if (ret < 0) {
> > > +             kfree(iov->iov);
> > > +             iov->iov =3D NULL;
> >=20
> > Is this really needed?!? AFAICS rds_rdma_extra_size() is invoked only
> > via: rds_sendmsg() -> rds_rm_size() -> rds_rdma_extra_size(), and the
> > rds_sendmsg() error path already frees any non NULL iov.
> >=20
> > /P

