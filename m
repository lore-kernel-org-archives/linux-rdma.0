From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv4 for-3.13 00/10] create_flow/destroy_flow fixes for
 v3.13
Date: Thu, 19 Dec 2013 23:57:02 +0100
Message-ID: <1387493822.11925.217.camel@localhost.localdomain>
References: <cover.1387273677.git.ydroneaud@opteya.com>
	 <CAJZOPZKKg73s6Y+=KD6c8vdDXG0CmkL_gErv=KE-U0jPTSWEjg@mail.gmail.com>
	 <1387459287.11925.52.camel@localhost.localdomain>
	 <CAL1RGDUfC38aKqDv7rOnbi3m7PMPC8ze+1kymgrWwNvYHU7e2Q@mail.gmail.com>
	 <1387477777.11925.85.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387477777.11925.85.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le jeudi 19 d=C3=A9cembre 2013 =C3=A0 19:29 +0100, Yann Droneaud a =C3=A9=
crit :
> Le jeudi 19 d=C3=A9cembre 2013 =C3=A0 09:08 -0800, Roland Dreier a =C3=
=A9crit :
> >=20
> > However, I still prefer not moving all the casts out into every pla=
ce
> > where we use INIT_UDATA(), so I'd prefer something like the patch
> > below.  I integrated that into the series and pushed out the result
> > (since everyone seems OK with rebasing for-next).
> >=20
> > Please let me know what you think.
> >=20
>=20
> I'm a bit puzzled :) Sure it address the warning problem from sparse =
and
> gcc. It's even handling setting NULL for response if out_words is 0,
> which was part of another patch[1] in the patchset. So I would say OK=
=2E
>=20
> But I'm concerned about this global change of behavior of INIT_UDATA(=
).
>=20
> I felt it was OK to handle the case of out_words equal to 0 in the ne=
w
> uverbs, since there's no current user of this, there's nothing to bro=
ke.
> It was a limited, locally change.
>=20
> But when changing globally the behavor of INIT_UDATA(), what about
> existing program which pass a non-NULL address for the response and s=
et
> out_words to 0 in a command.
>=20
> libibverbs doesn't seems to do this, but who knows how one might try =
to
> access to uverbs ?
>=20
> Since currently ib_copy_to_udata() doesn't check struct ib_udata outl=
en
> (I have patch for that[2]), some provider (hw/) might be using
> ib_copy_to_udata() without paying attention to outlen.
>=20
> If outbuf is set to NULL when outlen is 0, then it might broke, and t=
his
> could be called a regression.
>=20
> I haven't double check each and every user of ib_copy_to_udata(), eve=
n
> if I've found some ugly hack regarding udata, I'm looking at you
> ipath[3] and qib[4], I haven't payed yet attention to user of
> ib_copy_to_udata() without check for outlen first.
>=20

I took some time to read again the source code.

I've asked about the consequences for users of ib_copy_to_udata(), but
ib_copy_from_udata() is also concerned by this issue, but very unlikely=
=2E

To demonstrate how it is possible to have valid (!) uverbs calls
building a struct ib_udata with either outlen set 0 or inlen set 0,
let's define some 'vendor' command and response structure in userspace:

    #include <infiniband/kern-abi.h>

    struct ibv_cmd_hdr {
        __u32 command;
        __u16 in_words;
        __u16 out_words;
    };

    struct vendor_create_cq {
        struct ibv_create_cq ibv_cmd;
        /* vendor defined fields */=09
    };
=20
    struct vendor_create_cq_resp resp {
        struct ibv_create_cq_resp ibv_resp;
        /* vendor defined fields */=09
    };

Now, let's build a request through a custom 'libibverbs/libvendor-rdma'
which might be valid under current kernel, but will set outlen to 0
while response/outbuf would be !=3D NULL:

    struct ibv_cq *vendor_create_cq_broken_outlen(...)
    {
        struct vendor_create_cq      cmd;
        struct vendor_create_cq_resp resp;
        ...
        IBV_INIT_CMD_RESP(&cmd,
                          sizeof(cmd),
                          CREATE_CQ,
                          &resp,
                          sizeof(struct ibv_create_cq_resp)); /* <-- */
        ...
        write(context->cmd_fd,
              &cmd,
              sizeof(cmd));
        ...
    }

Now let's build a request which might be valid with current kernel
but will set inlen to 0 while it will be possible for vendor
driver (provider, under hw/) to read vendor fields:

    struct ibv_cq *vendor_create_cq_broken_inlen(...)
    {
        struct vendor_create_cq      cmd;
        struct vendor_create_cq_resp resp;
        size_t cmd_size =3D sizeof(struct ibv_create_cq) -=20
                          sizeof(struct ibv_cmd_hdr); /* <-- */
        ...
        assert(cmd_size >=3D sizeof(struct ibv_cmd_hdr));
        ...
        IBV_INIT_CMD_RESP(&cmd,
                          cmd_size,
                          CREATE_CQ,
                          &resp,
                          sizeof(resp));
        ...
        write(context->cmd_fd,
              &cmd,
              cmd_size);
        ...
    }

It's harder to get it wrong here, because struct ib_udata inlen, for
current uverbs (eg. not the extended one, currently only flow steering
related), have not subtracted the command header length, while the inbu=
f
pointer is added the command header length. This is a bit schizophrenic=
=2E
It's making bound checking a little bit harder, see for example
mthca_reg_user_mr(), which is the only function doing it right.
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/dri=
vers/infiniband/hw/mthca/mthca_provider.c?id=3Dv3.13-rc4#n988

(I also have a patch to subtract the size of header from input length,
 so that my patches[1] to add proper bound checking become effective at
 checking the bounds).

So in order to trigger INIT_UDATA() to set inbuf to NULL, the total siz=
e
of the command must be equal to the size of command, leaving apart the
size of the header, while still required to be greater than the header
to be accepted by ib_uverbs_write().

We can safely state that it is very unlikely that any unknown userspace
program is doing this. But keep it mind it's possible.

So if INIT_UDATA() is changed to set inbuf to NULL if inlen is equal
to 0, and to set outbuf to NULL if outlen is equal to 0, then, code
using, respectively, ib_copy_from_udata() and ib_copy_to_udata()=20
without checking the size will break for the previous code snippet.

I believe these are corner cases, and, in french, I would say it's "tir=
=C3=A9
par les cheveux" [2], but when looking at infiniband/hw/, we can see
several (hint, *a lot of*) places where bound checking is not done.

(That's why I've suggested adding checks in ib_copy_{from,to}_udata(),
 in my patchset[1][3][4], but it require subtracting the header length,=
=20
 fix mthca to not do it, fix ipath and qib to not swap the pointer=20
 behind the scene, and a lot of testing/reviewing to catch possible=20
 regression, but sometime these a desirable, but I digress).

Here's a list of calls to ib_copy_{from,to}_data() for which there's no
or incorrect checking of {input,output} length:

- drivers/infiniband/hw/cxgb3/iwch_provider.c:162, iwch_create_cq()

ib_copy_from_udata() with no check on input length.

- drivers/infiniband/hw/cxgb3/iwch_provider.c:232, iwch_create_cq()

ib_copy_to_udata(), with a check on output length,
                    but will copy even if output length is 0.

- drivers/infiniband/hw/cxgb3/iwch_provider.c:436, iwch_allocate_pd()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/cxgb3/iwch_provider.c:706, iwch_reg_user_mr()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/cxgb3/iwch_provider.c:1026, iwch_create_qp()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/amso1100/c2_provider.c:171, c2_alloc_pd()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/mlx4/cq.c:195, mlx4_ib_create_cq()

ib_copy_from_udata() with no check on input length.

- drivers/infiniband/hw/mlx4/cq.c:240, mlx4_ib_create_cq()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/mlx4/cq.c:302, mlx4_alloc_resize_umem()
  (called through mlx4_ib_resize_cq())

ib_copy_from_udata() with no check on input length.

- drivers/infiniband/hw/mlx4/srq.c:111, mlx4_ib_create_srq()

ib_copy_from_udata(), with no check on input length.

- drivers/infiniband/hw/mlx4/srq.c:193, mlx4_ib_create_srq()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/mlx4/main.c:627, mlx4_ib_alloc_ucontext()
  drivers/infiniband/hw/mlx4/main.c:629, mlx4_ib_alloc_ucontext()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/mlx4/main.c:696, mlx4_ib_alloc_pd()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/mlx4/qp.c:677, create_qp_common()
  (called through mlx4_ib_create_qp())

ib_copy_from_udata(), with no check on input length.

- drivers/infiniband/hw/ehca/ehca_qp.c:906, internal_create_qp()
  (called through ehca_create_qp())

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/ehca/ehca_cq.c:284, ehca_create_cq()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/nes/nes_verbs.c:651, nes_alloc_ucontext()

ib_copy_from_udata(), with no check on input length.

- drivers/infiniband/hw/nes/nes_verbs.c:682, nes_alloc_ucontext()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/nes/nes_verbs.c:817, nes_alloc_pd()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/nes/nes_verbs.c:1185, nes_create_qp()

ib_copy_from_udata(), with no check on input length.

- drivers/infiniband/hw/nes/nes_verbs.c:1392, nes_create_qp()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/nes/nes_verbs.c:1574, nes_create_cq()

ib_copy_from_udata(), with no check on input length.

- drivers/infiniband/hw/nes/nes_verbs.c:1771, nes_create_cq()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/nes/nes_verbs.c:2346, nes_reg_user_mr()

ib_copy_from_udata(), with no check on input length.

- drivers/infiniband/hw/usnic/usnic_ib_verbs.c:114,
usnic_ib_fill_create_qp_resp() (called through usnic_ib_create_qp())

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/cxgb4/cq.c:943 c4iw_create_cq()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/cxgb4/provider.c:226, c4iw_allocate_pd()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/cxgb4/qp.c:1683, c4iw_create_qp()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/mthca/mthca_provider.c:333,
mthca_alloc_ucontext()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/mthca/mthca_provider.c:389, mthca_alloc_pd()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/mthca/mthca_provider.c:453, mthca_create_srq()

ib_copy_from_udata(), with no check on input length.

- drivers/infiniband/hw/mthca/mthca_provider.c:479, mthca_create_srq()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/mthca/mthca_provider.c:535, mthca_create_qp()

ib_copy_from_udata(), with no check on input length.

- drivers/infiniband/hw/mthca/mthca_provider.c:658, mthca_create_cq()

ib_copy_from_udata(), with no check on input length.

- drivers/infiniband/hw/mthca/mthca_provider.c:696, mthca_create_cq()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/mthca/mthca_provider.c:791, mthca_resize_cq()

ib_copy_from_udata(), with no check on input length.

- drivers/infiniband/hw/mlx5/cq.c:526, create_cq_user()
  (called through mlx5_ib_create_cq())

ib_copy_from_udata(), with no check on input length.

- drivers/infiniband/hw/mlx5/cq.c:707, mlx5_ib_create_cq()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/mlx5/srq.c:87, create_srq_user()
  (called through mlx5_ib_create_srq())

ib_copy_from_udata(), with no check on input length.

- drivers/infiniband/hw/mlx5/cq.c:307, mlx5_ib_create_srq()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/mlx5/main.c:552, mlx5_ib_alloc_ucontext()

ib_copy_from_udata(), with no check on input length.

- drivers/infiniband/hw/mlx5/main.c:621, mlx5_ib_alloc_ucontext()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/mlx5/main.c:798, mlx5_ib_alloc_pd()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/mlx5/qp.c:500, create_qp_user()
  (called through create_qp_common())

ib_copy_from_udata(), with no check on input length.

- drivers/infiniband/hw/mlx5/qp.c:567, create_qp_user()
  (called through create_qp_common())

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/mlx5/qp.c:752, create_qp_common()
  (called through mlx5_ib_create_qp())

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:405,
ocrdma_alloc_ucontext()

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:517,
ocrdma_copy_pd_uresp()
  (called through ocrdma_alloc_pd())

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:870,
ocrdma_copy_cq_uresp()
  (called through ocrdma_create_cq())

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:901, ocrdma_create_cq()

ib_copy_from_udata(), with no check on input length.

- drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:1109,
ocrdma_copy_qp_uresp()
  (called through ocrdma_create_qp())

ib_copy_to_udata(), with no check on output length.

- drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:1213, ocrdma_create_qp()

ib_copy_from_udata(), with no check on input length.

- drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:1669,
ocrdma_copy_srq_uresp()
  (called through ocrdma_create_srq())

ib_copy_to_udata(), with no check on output length.


> So I think we must double check here before applying a global change=20
> to INIT_UDATA() and/or be ready to pay the price of regression in som=
e
> vendor software (I'm not aware of) ...

As you can see, they're plenty of location where having the size equal
to 0 but pointer !=3D NULL might be legal and could be used.

So in the end, we must determinate where is the kernel ABI: is write(2)
syscall or libibverbs ?

In the first case, allowing INIT_UDATA() to set the pointer to NULL if
size is 0 will break the API/ABI as it could break existing (buggy)
programs (but we don't know if such exist).
In the second case, it won't break anything, since libibverbs could be
assumed to do the right thing (but I haven't checked it a lot).

Regards.

[1] [PATCH 00/22] infiniband: improve userspace input check
    http://marc.info/?i=3Dcover.1376847403.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

[2] http://en.wiktionary.org/wiki/tir%C3%A9_par_les_cheveux

[3] [PATCH 03/22] infiniband: ib_copy_from_udata(): check input length
http://marc.info/?i=3D2bf102a41c51f61965ee09df827abe8fefb523a9.13768474=
03.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

[4] [PATCH 04/22] infiniband: ib_copy_to_udata(): check output length
http://marc.info/?i=3Dd27716a3a1c180f832d153a7402f65ea8a75b734.13768474=
03.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
