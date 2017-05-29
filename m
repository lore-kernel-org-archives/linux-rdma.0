From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 1/4] IB/IPoIB: Convert IPoIB to
 memalloc_noio_* calls
Date: Mon, 29 May 2017 20:01:49 +0300
Message-ID: <20170529170149.GD17751@mtr-leonro.local>
References: <20170523113816.32657-1-leon@kernel.org>
 <20170523113816.32657-2-leon@kernel.org>
 <6f8f8d7b-40ba-f0ec-77cd-3c5b20dead23@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="apSYfA7d5AHMku3c"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6f8f8d7b-40ba-f0ec-77cd-3c5b20dead23-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--apSYfA7d5AHMku3c
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 29, 2017 at 12:44:46PM -0400, Dennis Dalessandro wrote:
> On 5/23/2017 7:38 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Commit 21caf2fc1931 ("mm: teach mm by current context info to not do I/O
> > during memory allocation") added the memalloc_noio_(save|restore) funct=
ions
> > to enable people to modify the MM behavior by disabling I/O during memo=
ry
> > allocation. This was further extended in Fixes: 934f3072c17c ("mm: clear
> > __GFP_FS when PF_MEMALLOC_NOIO is set"). memalloc_noio_* functions prev=
ent
> > allocation paths recursing back into the filesystem without explicitly
> > changing the flags for every allocation site.
> >
> > However the IPoIB hasn't been keeping up with the changes and missed
> > completely these memalloc_noio_* calls. This led to update of
> > allocation site with special QP creation flag, see commit 09b93088d750
> > ("IB: Add a QP creation flag to use GFP_NOIO allocations"), while this
> > flag is supported by small number of drivers in IB stack.
> >
> > Let's change it by updating to memalloc_noio_* calls and allow
> > for every driver underneath enjoy NOIO allocations.
> >
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> > @@ -1131,10 +1127,11 @@ static int ipoib_cm_tx_init(struct ipoib_cm_tx =
*p, u32 qpn,
> >   			    struct sa_path_rec *pathrec)
> >   {
> >   	struct ipoib_dev_priv *priv =3D ipoib_priv(p->dev);
> > +	unsigned int noio_flag;
>
> >   	int ret;
> > -	p->tx_ring =3D __vmalloc(ipoib_sendq_size * sizeof *p->tx_ring,
> > -			       GFP_NOIO, PAGE_KERNEL);
> > +	noio_flag =3D memalloc_noio_save();
>
> NIT: Maybe just call this "flags" since there could be other flags in
> current->flags when calling memalloc_noio_save()

I didn't want to be different from other callers :)
=E2=9E=9C  linux-rdma git:(master) =E2=9C=97 git grep memalloc_noio_save
drivers/base/power/runtime.c:           noio_flag =3D memalloc_noio_save();
drivers/md/dm-bufio.c:          noio_flag =3D memalloc_noio_save();
drivers/md/dm-ioctl.c:  noio_flag =3D memalloc_noio_save();
drivers/usb/core/hub.c: noio_flag =3D memalloc_noio_save();
fs/ocfs2/cluster/tcp.c: noio_flag =3D memalloc_noio_save();
fs/ocfs2/cluster/tcp.c: noio_flag =3D memalloc_noio_save();
include/linux/sched/mm.h:static inline unsigned int memalloc_noio_save(void)
net/ceph/crypto.c:      noio_flag =3D memalloc_noio_save();
net/ceph/messenger.c:   noio_flag =3D memalloc_noio_save();

>
> -Denny

--apSYfA7d5AHMku3c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlksU/0ACgkQ5GN7iDZy
WKfLLhAAiZJ0ab4exIqSdUX8QtS2LgypF7AHFqESLO+K3oayI9C9a3pnXaruBRXm
PvFwzey6uTE8/6V/aUcMjujIuHsae70Fz9n0gJU0aQyUrSkXGk4QqRyvlpY9jHUH
UZ1dIwakMXuOHoKMQu9T7uC6diu/3o29v5ZoQIAv6mtHLyDD7V27V6l2QrJoO5iZ
ZpN9Rx1DcbGrmzZZZmN7j7VunjY/VkO/qLqe/c7Fy31j47qRXiaYURgzzTcmXD5I
1CoK1MuwC6FhfN1JjZcW4tIrhJeQrkj7ch1xOnuup+SiwM7+Y+hw+s68cZMiTwCU
1VCRKWoYGFwYvNol/Kpbdzn4Q9QMVQqPbWjx3QK++C5VZsMT8yckzT5TEaM3gOmh
uZ0wqo432R0/B6wUccWfgVTsPdHLLT6JyW7WU/8XXhudyG4AmmE5npZzrt4SRvXe
dQl/R+2ehFwkqd829FPdAY/A/wS3/8CXAQ9L2Vrkstf6n5hsmrPqtcklh59s7RrR
eGemKpSSTTAWWOmR7zodLvp2ERoc72AFKgMPZ1tWRMYBlRD9tiuigVuKNdB5YHkX
A/2ZYJC7K0XQ8WsBWqgsMFUB8YWye6NreymmOTqTZQS1pqJios3r87RCUM3IJdBx
+FEswQdbH+CQ4Hw9Ew0MNCbnTwV2N+IWklYlPIpKXPhUT3jF3iQ=
=/eRD
-----END PGP SIGNATURE-----

--apSYfA7d5AHMku3c--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
