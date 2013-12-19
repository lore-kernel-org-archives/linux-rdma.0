From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv4 for-3.13 00/10] create_flow/destroy_flow fixes for
 v3.13
Date: Thu, 19 Dec 2013 14:21:27 +0100
Message-ID: <1387459287.11925.52.camel@localhost.localdomain>
References: <cover.1387273677.git.ydroneaud@opteya.com>
	 <CAJZOPZKKg73s6Y+=KD6c8vdDXG0CmkL_gErv=KE-U0jPTSWEjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZKKg73s6Y+=KD6c8vdDXG0CmkL_gErv=KE-U0jPTSWEjg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Or, Roland.

Le mardi 17 d=C3=A9cembre 2013 =C3=A0 12:35 +0200, Or Gerlitz a =C3=A9c=
rit :
> On Tue, Dec 17, 2013 at 11:58 AM, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org=
> wrote:
> >
> > Please find the fourth revision of a patchset against create_flow/d=
estroy_flow
> > and associated extended command scheme.
>=20
> Yann, note that V3 is already applied, so you need to change incremen=
tal changes

Thanks for pointing this, Or.

Unfortunately, some patches in V4 were replacement for patches in V3.
In this particular case, I've rework the commit messages in V4, so thes=
e
changes might be lost.

In this other hand, V3 is not applied asis in for-next branch of
Roland's tree. In fact Roland seems to have dropped this patch:
[PATCHv3 for-3.13 2/9] IB/uverbs: remove implicit cast in INIT_UDATA()
http://marc.info/?i=3Da6da021658e9a1cee5cf9f6db61694711cc2852d.13867982=
54.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

This, then, require a conflict fix when applying next patch:
[PATCHv3 for-3.13 3/9] IB/uverbs: set outbuf to NULL when no core
response space is provided
http://marc.info/?i=3Dd4ae6494fb2dc1f8a81e8d8e90d8084b37d15ba2.13867982=
54.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

And another for this later patch:
[PATCHv3 for-3.13 8/9] IB/uverbs: check access to userspace response
 buffer in extended command
http://marc.info/?i=3D701fc3ee1136bbb4a0fd3d560c3ec1ee3bb3b828.13867982=
54.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

And I'm a bit disappointed about this particular patch applied with a
conflict fix:

https://git.kernel.org/cgit/linux/kernel/git/roland/infiniband.git/comm=
it/?h=3Dfor-next&id=3D2f92baf8313756fd32da4d2a24abc67c8f4f7026

	if (!access_ok(VERIFY_WRITE,
		       (const void __user *) (unsigned long) ex_hdr.response,
		       (hdr.out_words + ex_hdr.provider_out_words) * 8))
		return -EFAULT;

https://git.kernel.org/cgit/linux/kernel/git/roland/infiniband.git/tree=
/drivers/infiniband/core/uverbs_main.c?h=3Dfor-next&id=3D2f92baf8313756=
fd32da4d2a24abc67c8f4f7026#n679

Checking for write access on a pointer to const doesn't sound right.
It's harmless, and, if sparse/coccinelle doesn't have a check for such,
it should be added to report a warning.

BTW, I would prefer being responsible of my own mistakes :)

I try to be helpful and open to fix my patchset so that they are easier
to merge. In this particular case, the fix to my commit was not
'agreed': I haven't the chance to review it before being commited since
it wasn't discussed by mail.

So I hope the infiniband/for-next branch could be rewrote (it's a branc=
h
for linux-next, do people care of it being rebased ?) to include my new
commit messages and discard the not so incorrect fix to access_ok()
call. And perhaps include the patch adding a 'response' pointer as
'common pattern' of uverbs function.

Just tell me what you want me to do to ease the integration of my fixes=
=2E

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
