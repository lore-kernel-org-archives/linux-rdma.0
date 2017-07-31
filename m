From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [rdma-rc 13/14] RDMA/mthca: Make explicit conversion to 64bit
 value
Date: Mon, 31 Jul 2017 16:57:24 +0000
Message-ID: <1501520241.2466.16.camel@wdc.com>
References: <20170731070924.7193-1-leon@kernel.org>
         <20170731070924.7193-14-leon@kernel.org> <1501514243.2466.5.camel@wdc.com>
         <20170731161636.GA13672@mtr-leonro.local>
         <1501518230.2466.14.camel@wdc.com>
         <20170731165010.GC13672@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170731165010.GC13672-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Content-ID: <1EE8C971B7194748BEE4F0DBEEBB3594-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-07-31 at 19:50 +0300, Leon Romanovsky wrote:
> On Mon, Jul 31, 2017 at 04:23:52PM +0000, Bart Van Assche wrote:
> > On Mon, 2017-07-31 at 19:16 +0300, Leon Romanovsky wrote:
> > > On Mon, Jul 31, 2017 at 03:17:24PM +0000, Bart Van Assche wrote:
> > > > On Mon, 2017-07-31 at 10:09 +0300, Leon Romanovsky wrote:
> > > > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > >=20
> > > > > The "lg" variable is declared as int so in all places where
> > > > > this variable is used as a shift operand, the output will be
> > > > > int too.
> > > > >=20
> > > > > This produces the following smatch warning:
> > > > > drivers/infiniband/hw/mthca/mthca_cmd.c:701 mthca_map_cmd() warn:
> > > > > 	should '1 << lg' be a 64 bit type?
> > > > >=20
> > > > > Simple declaration of "1" to be "1ULL" will fix the issue.
> > > > >=20
> > > > > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > > > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > > > ---
> > > > >  drivers/infiniband/hw/mthca/mthca_cmd.c | 2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >=20
> > > > > diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/in=
finiband/hw/mthca/mthca_cmd.c
> > > > > index 9d83a53c0c67..1052c35f2e75 100644
> > > > > --- a/drivers/infiniband/hw/mthca/mthca_cmd.c
> > > > > +++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
> > > > > @@ -698,7 +698,7 @@ static int mthca_map_cmd(struct mthca_dev *de=
v, u16 op, struct mthca_icm *icm,
> > > > >  		for (i =3D 0; i < mthca_icm_size(&iter) >> lg; ++i) {
> > > > >  			if (virt !=3D -1) {
> > > > >  				pages[nent * 2] =3D cpu_to_be64(virt);
> > > > > -				virt +=3D 1 << lg;
> > > > > +				virt +=3D 1ULL << lg;
> > > > >  			}
> > > > >=20
> > > > >  			pages[nent * 2 + 1] =3D
> > > >=20
> > > > Hello Leon,
> > > >=20
> > > > Is my analysis correct that lg can be equal to or larger than 32? I=
f so,
> > > > isn't this patch a bug fix that needs a "Fixes:" tag?
> > >=20
> > > This is the fix to commit introduced in pre-git era and I don't have
> > > adequate Fixes tag. The fact that no one complained about the problem
> > > suggests to me that no one is really important to have it in stable t=
rees.
> > >=20
> > > Tariq and me did the analysis for the same code issue with mlx4 (he i=
s
> > > planning to forward the fix to Dave) and our conclusion that it is no=
t
> > > bug.
> > >=20
> > > The reason to it in line 689:drivers/infiniband/hw/mthca/mthca_cmd.c
> > >  689                 lg =3D ffs(mthca_icm_addr(&iter) | mthca_icm_siz=
e(&iter)) - 1;
> > >=20
> > > The "lg" for sure will be less than 31, because ffs returns values fr=
om 0 to 31 and minus 1.
> > > The situation that ffs will return 0 is unlikely to happen.
> >=20
> > Hello Leon,
> >=20
> > mthca_icm_addr() returns a DMA address (dma_addr_t). Does that mean tha=
t
> > that function can return a 64-bit value on 64-bit systems? Shouldn't ff=
s()
> > be changed into a function that supports 64-bit values?
>=20
> Don't dismiss the second part of that ffs: "| mthca_icm_size(&iter)", to
> overflow ffs, the icm size should be more than 2^32. Is it real scenario?

Hello Leon,

The second part of the logical or expression is not relevant if the first p=
art
can be equal to or larger than 2^32. Has the mthca driver ever been tested =
on
a 64-bit system or should it perhaps be marked as not supporting 64-bit sys=
tems?

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
