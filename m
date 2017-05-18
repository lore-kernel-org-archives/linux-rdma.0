From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 09/14] RDMA/bnxt_re: Do not free the ctx_tbl
 entry if delete GID fails
Date: Thu, 18 May 2017 07:32:35 +0300
Message-ID: <20170518043235.GW3616@mtr-leonro.local>
References: <1494413139-11883-1-git-send-email-selvin.xavier@broadcom.com>
 <1494413139-11883-10-git-send-email-selvin.xavier@broadcom.com>
 <20170514061015.GP3616@mtr-leonro.local>
 <CA+sbYW2LtbCf=DLXfyTKBUZJh5t7ZEBNYGHwJp1tFX49p5QL9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sKHNLc4rGJHGY5Sn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+sbYW2LtbCf=DLXfyTKBUZJh5t7ZEBNYGHwJp1tFX49p5QL9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kalesh AP <kalesh-anakkur.purayil-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--sKHNLc4rGJHGY5Sn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 15, 2017 at 04:24:04PM +0530, Selvin Xavier wrote:
> On Sun, May 14, 2017 at 11:40 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Wed, May 10, 2017 at 03:45:34AM -0700, Selvin Xavier wrote:
> >> Do not free context table entry if delete GID fails. Stack may call
> >> back the add_gid for the same context again which could result in
> >> panic
> >
> > "may call" ??? Will you leave memory leak if this "may call" won't happen?
> >
> This fix was added only to avoid system crash in some a specific scenario.
> When bnxt_re driver is loaded and if user tries to change interface mac address,
> our delete GID fails because QP1 is still associated with existing MAC
> (default GID).
> If the above command fails GID tables are not modified in the h/w or
> driver, but the GID context
> memory is freed. Now, if the user changes the mac back to the original
> value, another add_gid
> comes to the driver where the driver reports that the GID is already
> present in its table
> and tries to access the context which was already freed.
>
> So, in this case, in order to  avoid NULL pointer de-reference, this
> patch removes the context memory
> free  if delete_gid fails and the same context memory is re-used in new add_gid.
> Memory cleanup will be taken care during driver unload, while deleting
> the GID table.
>
>
> I understood that the "may call" comment is not detailing this problem.
> I will update the commit log and send a v2.

Thanks

>
> Thanks for your comments.
> Selvin Xavier
>
> >
> >>
> >> Signed-off-by: Kalesh AP <kalesh-anakkur.purayil-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> >> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> >> ---
> >>  drivers/infiniband/hw/bnxt_re/ib_verbs.c | 16 +++++++++-------
> >>  1 file changed, 9 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> >> index 61703f3..525f4b0 100644
> >> --- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> >> +++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
> >> @@ -375,15 +375,17 @@ int bnxt_re_del_gid(struct ib_device *ibdev, u8 port_num,
> >>                       return -EINVAL;
> >>               ctx->refcnt--;
> >>               if (!ctx->refcnt) {
> >> -                     rc = bnxt_qplib_del_sgid
> >> -                                     (sgid_tbl,
> >> -                                      &sgid_tbl->tbl[ctx->idx], true);
> >> -                     if (rc)
> >> +                     rc = bnxt_qplib_del_sgid(sgid_tbl,
> >> +                                              &sgid_tbl->tbl[ctx->idx],
> >> +                                              true);
> >> +                     if (rc) {
> >>                               dev_err(rdev_to_dev(rdev),
> >>                                       "Failed to remove GID: %#x", rc);
> >> -                     ctx_tbl = sgid_tbl->ctx;
> >> -                     ctx_tbl[ctx->idx] = NULL;
> >> -                     kfree(ctx);
> >> +                     } else {
> >> +                             ctx_tbl = sgid_tbl->ctx;
> >> +                             ctx_tbl[ctx->idx] = NULL;
> >> +                             kfree(ctx);
> >> +                     }
> >>               }
> >>       } else {
> >>               return -EINVAL;
> >> --
> >> 2.5.5
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--sKHNLc4rGJHGY5Sn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkdI+MACgkQ5GN7iDZy
WKcnTw/+O8SlkJQRcTp5Vzkaioa1EdbiFGdU0k69XmBS4o5h9a2CSMaRD1SbLv5I
+zr2yR62Mp+A2mb0wxX66rrQqc0t1MbxxnUKeZOcERiOweFVMjfp80LrGqJno7eE
kZffrUXcgRPlAU5Yhcl2ir0O4Q+PrgPZUha8PZvvC4wwhkcUS3KjAO0dvx47OdVe
b5SOnz+YfC+H7FwWFJGq/eXKPqZ8q1JSVTEEfhc4jruwnzPRRwqOSku5mKXgZLiT
MkFkVvkL3s58RUn6IZpNCoDE3MEFJ9nvxwTTUuTuUlxJtL4d0yw8oQJlanALrD69
aSKu6S5W/EiMCAuMbkoRs15FPOas4SQApo5Eu9dEUKJMY7Kg5yneHlC7hAQFjN7T
Vz0fUdqwjLqbBrEuNgOnU7qtmgAJArCDq2Jd5L5/QeEmYnDPwi2aWnOkX+w26mZH
bk36poqLOCc88OoSr7DmeRS2iKKtxWiHaHqrWk7I7647SEThTqBBnSEgixPgWn65
f8dREi4JgzbGfVPcG9L2M1vQhTPqqNmemj9DChsIkw62S1lpDdzOrzSOjF9NvmQm
17Z8K0hDMBp/+spgwK4geA2ovz2BnnuGL0KXu+aYNr2scWb1tOTdMrry733stPJK
JSdi6i8sErYORQUwnEXNwW0y+qwJCv13HcVLVR2P/r8iZgfL5Nw=
=rc5O
-----END PGP SIGNATURE-----

--sKHNLc4rGJHGY5Sn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
