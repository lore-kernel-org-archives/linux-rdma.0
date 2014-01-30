From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx5: Fix binary compatibility with libmlx5
Date: Thu, 30 Jan 2014 10:27:28 +0100
Message-ID: <1391074048.5835.14.camel@localhost.localdomain>
References: <1391005649-17932-1-git-send-email-eli@mellanox.com>
	 <1391028523.23180.63.camel@localhost.localdomain>
	 <20140129233335.GA20224@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140129233335.GA20224@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le jeudi 30 janvier 2014 =C3=A0 01:33 +0200, Eli Cohen a =C3=A9crit :
> On Wed, Jan 29, 2014 at 09:48:43PM +0100, Yann Droneaud wrote:
> Yann,
> thanks for reviewing, your comments are helpful :-)
>=20
> >=20
> > 12 digits identifier are the norm for kernel. Please update your gi=
t
> > configuration:
> >=20
> >  git config --global core.abbrev 12
> >=20
> > See http://lwn.net/Articles/571980/
> >     http://blog.cuviper.com/2013/11/10/how-short-can-git-abbreviate=
/
> >=20
> > > libmlx5 and mlx5_ib since it defines a different value to the num=
ber of micro
> > > UARs per page, leading to wrong calculation in libmlx5. This patc=
h defines
> > > struct mlx5_ib_alloc_ucontext_req_v2 as an extension to struct
> > > mlx5_ib_alloc_ucontext_req.  The extended size is determined in
> > > mlx5_ib_alloc_ucontext() and in case of old library we use uuarn =
0 which works
> > > fine. For new libraries we use the more sophisticated allocation =
algorithm.
> > >=20
> > > Fixes: c1be523 ('Fix micro UAR allocator')
> >         ^^^^^^^
> > Likewise
>=20
> Will fix.
> >=20
> > I'm not sure how this could work without subtracting sizeof(struct
> > ib_uverbs_cmd_hdr).
>=20
> struct ib_uverbs_get_context happens to have the same size as struct
> ib_uverbs_cmd_hdr so it passed all my sanity tests. Correct, will fix
> that too.
> >=20
> > As I explained in "Re: [PATCHv4 for-3.13 00/10] create_flow/destroy=
_flow
> > fixes for v3.13" [1] ib_uverbs_write() does not decrement input len=
gth:
> > it gives hdr.in_words * 4 to the uverbs function, here=20
> > ib_uverbs_get_context(). Then, the function built struct ib_udata=20
> > without taking care of the extra bytes count in in_len:
> >=20
> >     struct ib_uverbs_get_context cmd;
> >     ...
> >     INIT_UDATA(&udata, buf + sizeof cmd,
> >                (unsigned long) cmd.response + sizeof resp,
> >                in_len - sizeof cmd, out_len - sizeof resp);
>=20
> So this just seems broken and the fix is to do the subtraction here s=
o
> the hardware driver gets the correct size without needing to subtract
> the extra bytes, like this:

>         INIT_UDATA(&udata, buf + sizeof cmd,
>                    (unsigned long) cmd.response + sizeof resp,
>                    in_len - sizeof cmd - sizeof (struct ib_uverbs_cmd=
_hdr),
>                    out_len - sizeof resp);
>=20

> And the hardware driver gets the correct size for its struct.
>=20

It's not the place to address the issue: the proper fix is to subtract
it in ib_uverbs_write().
I have a patch for this but I'm not going to submit it for 3.14: it's
part of a patchset that need testing and polishing. I will submit this
large patchset for 3.15 (after v3.14-rc1).

So you have to subtract the header size in your driver, just like mthca
does. And don't worry I will take care of removing it in my patch that
remove the header size from input length.

> >=20
> > Driver mthca does some handling which look like to what's proposed =
in
> > your patch, but takes care of subtracting the header size from the =
input
> > length, see mthca_reg_user_mr()[2].
> >=20
> > [1]
> > <http://marc.info/?i=3D1387493822.11925.217.camel-bi+AKbBUZKY6gyzm1THtWWGXanvQGlWp@public.gmane.org=
main>
> >=20
> > [2]
> > <http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tre=
e/drivers/infiniband/hw/mthca/mthca_provider.c?id=3D0e47c969c65e2134214=
50c31043353ebe3c67e0c#n988>
> >=20
> > > +	if (reqlen =3D=3D sizeof(struct mlx5_ib_alloc_ucontext_req))
> > > +		ver =3D 0;
> > > +	else if (reqlen =3D=3D sizeof(struct mlx5_ib_alloc_ucontext_req=
_v2))
> > > +		ver =3D 2;
> > > +	else
> > > +		return ERR_PTR(-EINVAL);
> > > +
> >=20
> > Doing so introduce a subtle regression: there was no check on the l=
ength
> > before, so it was legal to pass a input buffer far larger than need=
ed,
> > aka. trailing garbage.=20
> >=20
> > With such new test in place, it's no more allowed, and this is a
> > regression. It's not a big issue, but a little departure from curre=
nt
> > behavor.

> Well it's a regression if there was out there another library for mlx=
5
> out there which misbehaves and there is any as far as I know. So I
> think it's safe to add this strict check.

Yes I think so.

But as I'm used to write it here, there's no clear line drawn: where is
the ABI that we should enforce ? Is it the kernel uverbs data structure
for response and request or libuverbs/lib<hw> ? In the first case, your
change add a regression, in the second case, it's not. It's just a
theoretical question. In practice, as you wrote, we can say there's no
other library that implement the userspace part of mlx5 rdma driver.

> >=20
> > BTW, this is the correct way to handle the request, every other uve=
rbs
> > functions should behave like this, eg. being strict on its accepted
> > input.
> >=20
> > > +	err =3D ib_copy_from_udata(&req, udata, reqlen);
> > >  	if (err)
> > >  		return ERR_PTR(err);
> > > =20
> > > +	if (req.flags || req.reserved)
> > > +		return ERR_PTR(-EINVAL);
> > > +
> >=20
> > Just like this :)
> >=20
> > >  	if (req.total_num_uuars > MLX5_MAX_UUARS)
> > >  		return ERR_PTR(-ENOMEM);
> > > =20
> > > @@ -626,6 +640,7 @@ static struct ib_ucontext *mlx5_ib_alloc_ucon=
text(struct ib_device *ibdev,
> > >  	if (err)
> > >  		goto out_uars;
> > > =20
> > > +	uuari->ver =3D ver;
> > >  	uuari->num_low_latency_uuars =3D req.num_low_latency_uuars;
> > >  	uuari->uars =3D uars;
> > >  	uuari->num_uars =3D num_uars;
> > > diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband=
/hw/mlx5/qp.c
> > > index 492dc33..300475c 100644
> > > --- a/drivers/infiniband/hw/mlx5/qp.c
> > > +++ b/drivers/infiniband/hw/mlx5/qp.c
> > > @@ -430,11 +430,17 @@ static int alloc_uuar(struct mlx5_uuar_info=
 *uuari,
> > >  		break;
> > > =20
> > >  	case MLX5_IB_LATENCY_CLASS_MEDIUM:
> > > -		uuarn =3D alloc_med_class_uuar(uuari);
> > > +		if (uuari->ver < 2)
> > > +			uuarn =3D -ENOMEM;
> >=20
> > In the commit message, you specified that uuarn is set to 0 when v1=
 is
> > used. But here it's set to -ENOMEM.
> >=20
> If you look at qp.c you can see that the code falls back from high to
> medium to low class. Low class always succeeds and gives 0.
>=20

It was not clear from the commit message.

> > > +		else
> > > +			uuarn =3D alloc_med_class_uuar(uuari);
> > >  		break;
> > > =20
> > >  	case MLX5_IB_LATENCY_CLASS_HIGH:
> > > -		uuarn =3D alloc_high_class_uuar(uuari);
> > > +		if (uuari->ver < 2)
> > > +			uuarn =3D -ENOMEM;
> >=20
> > Likewise.
> >=20
> > > +		else
> > > +			uuarn =3D alloc_high_class_uuar(uuari);
> > >  		break;
> > > =20

Regards

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
