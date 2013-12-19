From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv4 for-3.13 00/10] create_flow/destroy_flow fixes for
 v3.13
Date: Thu, 19 Dec 2013 19:29:37 +0100
Message-ID: <1387477777.11925.85.camel@localhost.localdomain>
References: <cover.1387273677.git.ydroneaud@opteya.com>
	 <CAJZOPZKKg73s6Y+=KD6c8vdDXG0CmkL_gErv=KE-U0jPTSWEjg@mail.gmail.com>
	 <1387459287.11925.52.camel@localhost.localdomain>
	 <CAL1RGDUfC38aKqDv7rOnbi3m7PMPC8ze+1kymgrWwNvYHU7e2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUfC38aKqDv7rOnbi3m7PMPC8ze+1kymgrWwNvYHU7e2Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Le jeudi 19 d=C3=A9cembre 2013 =C3=A0 09:08 -0800, Roland Dreier a =C3=A9=
crit :
> > Unfortunately, some patches in V4 were replacement for patches in V=
3.
> > In this particular case, I've rework the commit messages in V4, so =
these
> > changes might be lost.
>=20
> > And I'm a bit disappointed about this particular patch applied with=
 a
> > conflict fix:
> >
> > https://git.kernel.org/cgit/linux/kernel/git/roland/infiniband.git/=
commit/?h=3Dfor-next&id=3D2f92baf8313756fd32da4d2a24abc67c8f4f7026
> >
> >         if (!access_ok(VERIFY_WRITE,
> >                        (const void __user *) (unsigned long) ex_hdr=
=2Eresponse,
> >                        (hdr.out_words + ex_hdr.provider_out_words) =
* 8))
> >                 return -EFAULT;
> >
> > https://git.kernel.org/cgit/linux/kernel/git/roland/infiniband.git/=
tree/drivers/infiniband/core/uverbs_main.c?h=3Dfor-next&id=3D2f92baf831=
3756fd32da4d2a24abc67c8f4f7026#n679
> >
> > Checking for write access on a pointer to const doesn't sound right=
=2E
> > It's harmless, and, if sparse/coccinelle doesn't have a check for s=
uch,
> > it should be added to report a warning.
>=20
> Sorry for that mistake.  I've fixed that conflict fix to get rid of
> the const.  I've also pulled in the changelog updates.
>=20
> However, I still prefer not moving all the casts out into every place
> where we use INIT_UDATA(), so I'd prefer something like the patch
> below.  I integrated that into the series and pushed out the result
> (since everyone seems OK with rebasing for-next).
>=20
> Please let me know what you think.
>=20

I'm a bit puzzled :) Sure it address the warning problem from sparse an=
d
gcc. It's even handling setting NULL for response if out_words is 0,
which was part of another patch[1] in the patchset. So I would say OK.

But I'm concerned about this global change of behavior of INIT_UDATA().

I felt it was OK to handle the case of out_words equal to 0 in the new
uverbs, since there's no current user of this, there's nothing to broke=
=2E
It was a limited, locally change.

But when changing globally the behavor of INIT_UDATA(), what about
existing program which pass a non-NULL address for the response and set
out_words to 0 in a command.

libibverbs doesn't seems to do this, but who knows how one might try to
access to uverbs ?

Since currently ib_copy_to_udata() doesn't check struct ib_udata outlen
(I have patch for that[2]), some provider (hw/) might be using
ib_copy_to_udata() without paying attention to outlen.

If outbuf is set to NULL when outlen is 0, then it might broke, and thi=
s
could be called a regression.

I haven't double check each and every user of ib_copy_to_udata(), even
if I've found some ugly hack regarding udata, I'm looking at you
ipath[3] and qib[4], I haven't payed yet attention to user of
ib_copy_to_udata() without check for outlen first.

In this other hand, with my patch[2] from the patchset[5], I've done
some tests, and haven't found any regression, but my testbed was very
limited.

So I think we must double check here before applying a global change to
INIT_UDATA() and/or be ready to pay the price of regression in some
vendor software (I'm not aware of) ...

[1] [PATCHv4 for-3.13 04/10] IB/uverbs: set outbuf to NULL when no core
response space is provided
http://marc.info/?i=3D330b13a0884b6cc03e287a32f8f49c1aac6bdbed.13872736=
77.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

[2] [PATCH 04/22] infiniband: ib_copy_to_udata(): check output length
http://marc.info/?i=3Dd27716a3a1c180f832d153a7402f65ea8a75b734.13768474=
03.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

[3] ipath_srq.c:254 ipath_modify_srq()
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/infiniband/hw/ipath/ipath_srq.c?id=3Dv3.13-rc4#n254

[4] qib_srq.c:250 qib_modify_srq()
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/infiniband/hw/qib/qib_srq.c?id=3Dv3.13-rc4#n250

[5] [PATCH 00/22] infiniband: improve userspace input check
http://marc.info/?i=3Dcover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
