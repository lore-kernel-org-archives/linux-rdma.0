From: Hoang-Nam Nguyen <HNGUYEN-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ib_ehca: fix compile failure on ppc64
Date: Mon, 19 Mar 2012 11:05:54 +0100
Message-ID: <OFBEB10BA3.46413E84-ONC12579C6.0037606E-C12579C6.00377AF4@de.ibm.com>
References: <20120227220255.GE29211@redacted.bos.redhat.com> <CAL1RGDXjF-Y-UABiondu6y9k9HRoxgE9oVAbp-BJ4x+iuRjiWg@mail.gmail.com> <20120228151545.GF29211@redacted.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120228151545.GF29211-nxOev/eQj6CGu0OVIAPS5KfLeoKvNuZc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kyle McMartin <kmcmartin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The patch below looks fine to me.
Sorry for this so late reply.
Thanks!
Nam

Kyle McMartin <kmcmartin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote on 02/28/2012 04:15:46 PM:

> From:
>
> Kyle McMartin <kmcmartin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> To:
>
> Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
>
> Cc:
>
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hoang-Nam Nguyen/Germany/IBM@IBMDE,
> Christoph Raisch/Germany/IBM@IBMDE
>
> Date:
>
> 02/28/2012 04:15 PM
>
> Subject:
>
> Re: [PATCH] ib_ehca: fix compile failure on ppc64
>
> On Mon, Feb 27, 2012 at 09:18:35PM -0800, Roland Dreier wrote:
> > On Mon, Feb 27, 2012 at 2:02 PM, Kyle McMartin <kmcmartin-H+wXaHxf7aJhl2p70BpVqQ@public.gmane.org=
m>
wrote:
> > > =A0static u64 ehca_get_max_hwpage_size(struct ehca_shca *shca)
> > > =A0{
> > > - =A0 =A0 =A0 return 1UL << ilog2(shca->hca_cap_mr_pgsize);
> > > + =A0 =A0 =A0 u32 pgsize =3D shca->hca_cap_mr_pgsize;
> > > + =A0 =A0 =A0 return 1UL << ilog2(pgsize);
> > > =A0}
> >
> > How about using rounddown_pow_of_two(shca->hca_cap_mr_pgsize)?
> > Does that build?  Because that seems to me to be a cleaner way of
> > expressing this anyway...
> >
>
> Yeah, that works too, good catch, I should have noticed that sooner.
>
> > Something about that ilog2() implementation seems to trigger gcc
> > bugs, I seem to remember some other bogus compile failure on
> > sparc involving it as well...
> >
>
> I suspect it's the 64 deep trinary operators ;-) (It seems to trip up=
 on
> the __builtin_constant_p and hit the second ____ilog2_NaN) It's a pre=
tty
> weird .config dependent bug, I'm very confused by it.
>
> Suggested-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
> Signed-off-by: Kyle McMartin <kmcmarti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> --- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
> +++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
> @@ -112,7 +112,7 @@ static u32 ehca_encode_hwpage_size(u32 pgsize)
>
>  static u64 ehca_get_max_hwpage_size(struct ehca_shca *shca)
>  {
> -   return 1UL << ilog2(shca->hca_cap_mr_pgsize);
> +   return rounddown_pow_of_two(shca->hca_cap_mr_pgsize);
>  }
>
>  static struct ehca_mr *ehca_mr_new(void)
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
