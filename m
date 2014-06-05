From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv1 4/4] RDMA/cxgb4: add missing padding at end of struct
 c4iw_alloc_ucontext_resp
Date: Thu, 05 Jun 2014 09:28:53 +0200
Message-ID: <1401953333.20659.6.camel@localhost.localdomain>
References: <cover.1399309513.git.ydroneaud@opteya.com>
	 <b08b42d735d0a9d573ed09f9a30338686a802da0.1399309513.git.ydroneaud@opteya.com>
	 <1400739665.21049.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400739665.21049.5.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Le jeudi 22 mai 2014 =C3=A0 08:21 +0200, Yann Droneaud a =C3=A9crit :
> Le lundi 05 mai 2014 =C3=A0 19:35 +0200, Yann Droneaud a =C3=A9crit :
> > i386 ABI disagree with most other ABIs regarding alignment
> > of data type larger than 4 bytes: on most ABIs a padding must
> > be added at end of the structures, while it is not required on
> > i386.
> >=20
> > So for most ABI struct c4iw_alloc_ucontext_resp get implicitly padd=
ed
> > to be aligned on a 8 bytes multiple, while for i386, such padding
> > is not added.
> >=20
> > Tool pahole could be used to find such implicit padding:
> >=20
> >   $ pahole --anon_include \
> >            --nested_anon_include \
> >            --recursive \
> >            --class_name c4iw_alloc_ucontext_resp \
> >            drivers/infiniband/hw/cxgb4/iw_cxgb4.o
> >=20
> > Then, structure layout can be compared between i386 and x86_64:
> >=20
> >   +++ obj-i386/drivers/infiniband/hw/cxgb4/iw_cxgb4.o.pahole.txt   =
2014-03-28 11:43:05.547432195 +0100
> >   --- obj-x86_64/drivers/infiniband/hw/cxgb4/iw_cxgb4.o.pahole.txt =
2014-03-28 10:55:10.990133017 +0100
> >   @@ -2,9 +2,8 @@ struct c4iw_alloc_ucontext_resp {
> >           __u64                      status_page_key;      /*     0=
     8 */
> >           __u32                      status_page_size;     /*     8=
     4 */
> >=20
> >   -       /* size: 12, cachelines: 1, members: 2 */
> >   -       /* last cacheline: 12 bytes */
> >   +       /* size: 16, cachelines: 1, members: 2 */
> >   +       /* padding: 4 */
> >   +       /* last cacheline: 16 bytes */
> >    };
> >=20
> > This ABI disagreement will make an x86_64 kernel try to write
> > past the buffer provided by an i386 binary.
> >=20
> > When boundary check will be implemented, the x86_64 kernel will
> > refuse to write past the i386 userspace provided buffer
> > and the uverbs will fail.
> >=20
> > If the structure lay in memory on a page boundary and next page
> > is not mapped, ib_copy_to_udata() will fail and the uverb
> > will fail.
> >=20
> > Additionally, as reported by Dan Carpenter, without the implicit
> > padding being properly cleared, an information leak would take
> > place in most architectures.
> >=20
> > This patch adds an explicit padding to struct c4iw_alloc_ucontext_r=
esp,
> > and, like 92b0ca7cb149 ('IB/mlx5: Fix stack info leak in
> > mlx5_ib_alloc_ucontext()'), makes function c4iw_alloc_ucontext()
> > not writting this padding field to userspace. This way, x86_64 kern=
el
> > will be able to write struct c4iw_alloc_ucontext_resp as expected b=
y
> > unpatched and patched i386 libcxgb4.
> >=20
> > Link: http://marc.info/?i=3Dcover.1399309513.git.ydroneaud@opteya.c=
om
> > Link: http://marc.info/?i=3D1395848977.3297.15.camel-bi+AKbBUZKaGOdeMZTrFbA@public.gmane.org=
ldomain
> > Link: http://marc.info/?i=3D20140328082428.GH25192@mwanda
> > Fixes: 05eb23893c2c ('cxgb4/iw_cxgb4: Doorbell Drop Avoidance Bug F=
ixes')
> > Reported-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> > Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
>=20
> I believe this one should go in v3.15-rc7 as it fixes an issue
> introduced in v3.15-rc1. See=20
> http://marc.info/?i=3D20140328082428.GH25192@mwanda
> http://marc.info/?i=3D20140502235616.GJ4963@mwanda
>=20
> The other patchs could probably wait for v3.16-rc1 for integration in
> linux-stable.
>=20

I think this patch is likely not going to v3.15, so in order to have it=
=20
integrated in v3.15.x with the others, could you add Cc:=20
<stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> to  this patch the next time you rebuild
your 'for-next' branch ?

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Thanks a lot.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
