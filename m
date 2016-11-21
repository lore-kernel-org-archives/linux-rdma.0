From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] infiniband: remove WARN that is not kernel bug
Date: Mon, 21 Nov 2016 14:14:08 +0200
Message-ID: <20161121121408.GC4158@leon.nu>
References: <1479723531-17940-1-git-send-email-dvyukov@google.com>
 <alpine.LNX.2.00.1611211123450.22752@pobox.suse.cz>
 <CACT4Y+ZO9sTbBGwNUUMkAQ5m0N-4aT0S9xypCRbBUch1pQNw9g@mail.gmail.com>
 <20161121114417.GA4158@leon.nu>
 <CACT4Y+Y1sL-8K7HhZ5M5ABVPG0kM=dKZh+6gvuNRvzXFtiA5aQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="XStn23h1fwudRqtG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+Y1sL-8K7HhZ5M5ABVPG0kM=dKZh+6gvuNRvzXFtiA5aQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: syzkaller <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--XStn23h1fwudRqtG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 21, 2016 at 12:48:35PM +0100, Dmitry Vyukov wrote:
> On Mon, Nov 21, 2016 at 12:44 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Mon, Nov 21, 2016 at 11:30:21AM +0100, Dmitry Vyukov wrote:
> >> On Mon, Nov 21, 2016 at 11:25 AM, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org> wrote:
> >> > On Mon, 21 Nov 2016, Dmitry Vyukov wrote:
> >> >
> >> >> WARNINGs mean kernel bugs.
> >> >> The one in ucma_write() points to user programming error
> >> >> or a malicious attempt. This is not a kernel bug, remove it.
> >> >>
> >> >> BUG/WARNs that are not kernel bugs hinder automated testing effots.
> >> >>
> >> >> Signed-off-by: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >> >> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> >> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >> >> Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> >> Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >> >> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> >> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> >> Cc: syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
> >> >>
> >> >> ---
> >> >> Changes since v1:
> >> >>  - added printk_once
> >> >> ---
> >> >>  drivers/infiniband/core/ucma.c | 5 ++++-
> >> >>  1 file changed, 4 insertions(+), 1 deletion(-)
> >> >>
> >> >> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> >> >> index 9520154..405d0ce 100644
> >> >> --- a/drivers/infiniband/core/ucma.c
> >> >> +++ b/drivers/infiniband/core/ucma.c
> >> >> @@ -1584,8 +1584,11 @@ static ssize_t ucma_write(struct file *filp, const char __user *buf,
> >> >>       struct rdma_ucm_cmd_hdr hdr;
> >> >>       ssize_t ret;
> >> >>
> >> >> -     if (WARN_ON_ONCE(!ib_safe_file_access(filp)))
> >> >> +     if (!ib_safe_file_access(filp)) {
> >> >> +             printk_once("ucma_write: process %d (%s) tried to do something hinky\n",
> >> >> +                     task_tgid_vnr(current), current->comm);
> >> >>               return -EACCES;
> >> >> +     }
> >> >>
> >> >>       if (len < sizeof(hdr))
> >> >>               return -EINVAL;
> >> >
> >> > FWIW, WARN_ON_ONCE came with commit e6bd18f57aad ("IB/security: Restrict
> >> > use of the write() interface"). Would it make sense to change the other
> >> > places as well?
> >>
> >>
> >> I guess so.
> >> Can I ask somebody of infiniband maintainers to take care of this?
> >
> > Please see below,
> > Hope it helps.
>
> In ib_ucm_write function there is a wrong prefix:
>
> + pr_err_once("ucm_write: process %d (%s) tried to do something hinky\n",

I did it intentionally to have the same errors for all flows.

>
> Otherwise looks good. Thanks.

--XStn23h1fwudRqtG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYMuUQAAoJEORje4g2clin6FcP/3JE4dxipnr2Ifbxf1dK8b16
J2m3GP1PjTF76r2jHWYwRUCpjPR/aNZQYvHa895E2x+oXR335BWQroHZ1E8EH/QC
ux4RmKFrOm4fUNbjkrHT6z482BlbnnkgRoBAhrCvralAObt81yVens1zOCdBLVEv
NHQcPeJfxSp3aZXr2VS9r/XqYRxRmbKsWX8l1YwCRFTGNflEAQIkOZs7z3mghwNh
icFDqWGpUj7eNURr5lfDRWZ2oJLWVK/f4r3pI22LlCjIeo/PhadGH7ptmJ05ysfs
/kGMa6fY0rpZtlNjnl0fREO3hOhBKEwicoXte1gpOrE19XoFwIxgO+5nLG8Il1sJ
0BrVECQEEQZ97npcvj1V69ZaIZ/xOQpu4sn57dhjl6wYtngojlgEnmwpIDNTU+sx
zx4O39DzaeKRdT6Wr80hgSPgnvimi3M5vVVze+CjITaWJE3wmMCmBix2b8Lq/UfE
6p32t1yY/4JEVcelWKm50CGINfYSF1PRrPY+cocYOWTW2ld7ecFTZvajRm9f7c6X
q9y3r9i2JsngaBFRQo1yxYKCE3wS0Onv3kC4hlu4Is+j18K1cvbZ7ZzdT3V549X0
BywMs6funEUSmzVBmgWL0SaOEzdMLMhpguFXHRoMAjLkzYncZtRQWjw9ilQPmKql
9L2V/rK3SKGvlaDxr1Yy
=Mc/T
-----END PGP SIGNATURE-----

--XStn23h1fwudRqtG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
