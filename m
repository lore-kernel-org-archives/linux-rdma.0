From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-rc 13/14] RDMA/mthca: Make explicit conversion to 64bit
 value
Date: Mon, 31 Jul 2017 19:50:10 +0300
Message-ID: <20170731165010.GC13672@mtr-leonro.local>
References: <20170731070924.7193-1-leon@kernel.org>
 <20170731070924.7193-14-leon@kernel.org>
 <1501514243.2466.5.camel@wdc.com>
 <20170731161636.GA13672@mtr-leonro.local>
 <1501518230.2466.14.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1y/7ip9Z0l6NTTti"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1501518230.2466.14.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--1y/7ip9Z0l6NTTti
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 31, 2017 at 04:23:52PM +0000, Bart Van Assche wrote:
> On Mon, 2017-07-31 at 19:16 +0300, Leon Romanovsky wrote:
> > On Mon, Jul 31, 2017 at 03:17:24PM +0000, Bart Van Assche wrote:
> > > On Mon, 2017-07-31 at 10:09 +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > >
> > > > The "lg" variable is declared as int so in all places where
> > > > this variable is used as a shift operand, the output will be
> > > > int too.
> > > >
> > > > This produces the following smatch warning:
> > > > drivers/infiniband/hw/mthca/mthca_cmd.c:701 mthca_map_cmd() warn:
> > > > 	should '1 << lg' be a 64 bit type?
> > > >
> > > > Simple declaration of "1" to be "1ULL" will fix the issue.
> > > >
> > > > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > > ---
> > > >  drivers/infiniband/hw/mthca/mthca_cmd.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
> > > > index 9d83a53c0c67..1052c35f2e75 100644
> > > > --- a/drivers/infiniband/hw/mthca/mthca_cmd.c
> > > > +++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
> > > > @@ -698,7 +698,7 @@ static int mthca_map_cmd(struct mthca_dev *dev, u16 op, struct mthca_icm *icm,
> > > >  		for (i = 0; i < mthca_icm_size(&iter) >> lg; ++i) {
> > > >  			if (virt != -1) {
> > > >  				pages[nent * 2] = cpu_to_be64(virt);
> > > > -				virt += 1 << lg;
> > > > +				virt += 1ULL << lg;
> > > >  			}
> > > >
> > > >  			pages[nent * 2 + 1] =
> > >
> > > Hello Leon,
> > >
> > > Is my analysis correct that lg can be equal to or larger than 32? If so,
> > > isn't this patch a bug fix that needs a "Fixes:" tag?
> >
> > This is the fix to commit introduced in pre-git era and I don't have
> > adequate Fixes tag. The fact that no one complained about the problem
> > suggests to me that no one is really important to have it in stable trees.
> >
> > Tariq and me did the analysis for the same code issue with mlx4 (he is
> > planning to forward the fix to Dave) and our conclusion that it is not
> > bug.
> >
> > The reason to it in line 689:drivers/infiniband/hw/mthca/mthca_cmd.c
> >  689                 lg = ffs(mthca_icm_addr(&iter) | mthca_icm_size(&iter)) - 1;
> >
> > The "lg" for sure will be less than 31, because ffs returns values from 0 to 31 and minus 1.
> > The situation that ffs will return 0 is unlikely to happen.
>
> Hello Leon,
>
> mthca_icm_addr() returns a DMA address (dma_addr_t). Does that mean that
> that function can return a 64-bit value on 64-bit systems? Shouldn't ffs()
> be changed into a function that supports 64-bit values?

Don't dismiss the second part of that ffs: "| mthca_icm_size(&iter)", to
overflow ffs, the icm size should be more than 2^32. Is it real scenario?

>
> Thanks,
>
> Bart.
>

--1y/7ip9Z0l6NTTti
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll/X8IACgkQ5GN7iDZy
WKeXmw//a4mDayFlZ831IFlW6pIteMPmJJtqg4tLsIoVPYXbPrxn/elBgJ4qqJjY
69LZyyGzclaiXl4y/419kXEwAlNILjzif9OM5cjqWdZZE04UhbZ90rRbmjYbm4fS
D3WhAPPIUpZ2ZmuF050BkdOQGS3+30LsZj+Om9isdWHcwexA/SRvBX6fjPwTvXwS
jP8cS7feu9hzIfbRMR1UzaBvAIDDDSL9NU8lJDxggStirgP7mbCOiCl4vIDrlLUo
Gtjc2rE2fTagOMj/pJ4Hvxq2oDSciH+lDs6zFJjIl88ZngR5xH86njn6Buq62ut7
DSt4LA55djfTxgvIPyiS48KpOPWt4QyQ4s+30xvJqAHKy8NlYHYgceBNUJB1SdT7
ijyaY/RKC6581d77F0eb1djNvYJuoPjc6O8DGe4VoVSi4+HtQFSfqfD8oc5AV+TP
ZPWM17oVOxqnUGTX9yUXqrPXn6rAVLxqvm9yZ7W8NJDhdOX5jHTC1wTtby97d3dD
zvva0NY2FtKF1/Evh7taxJwQlpIysb94faiS7RHrqqnNfF3BCDfvXkQf7aht0H0z
sNATliIt76i6ufJ2PTWwPhIU3G84LiAaWHQvydJdQ4U5FUegXN8flsDsD7P7Sg6U
bG1P2sbAg5I/mvzLyHvpeYtbntjmr0DJ3REVxviEI2O2hy0a/ew=
=mb8R
-----END PGP SIGNATURE-----

--1y/7ip9Z0l6NTTti--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
