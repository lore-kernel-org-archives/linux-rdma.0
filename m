From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 0/7] Enrich DEVX support
Date: Tue, 4 Dec 2018 22:34:20 +0200
Message-ID: <20181204203420.GD15544@mtr-leonro.mtl.com>
References: <20181126062838.5907-1-leon@kernel.org>
 <95c8a200842de2a78af89ad2d5c051db0577fdfe.camel@redhat.com>
 <CALEgSQvYCUQ-ONQK=73jjpDpav8G4pE3_y0oChc4uiQHok6kUA@mail.gmail.com>
 <c44fe51963ba6e04f068f6001d845ffebc53b16c.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YD3LsXFS42OYHhNZ"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c44fe51963ba6e04f068f6001d845ffebc53b16c.camel@redhat.com>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Jason Gunthorpe <jgg@mellanox.com>, linux-rdma <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--YD3LsXFS42OYHhNZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 04, 2018 at 02:45:56PM -0500, Doug Ledford wrote:
> On Tue, 2018-12-04 at 12:15 -0700, Jason Gunthorpe wrote:
> > On Tue, Dec 4, 2018 at 12:02 PM Doug Ledford <dledford@redhat.com> wrote:
> > > On Mon, 2018-11-26 at 08:28 +0200, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@mellanox.com>
> > > >
> > > > From Yishai,
> > > > -----------------------------------
> > > > This series enriches DEVX support in few aspects: it enables interoperability
> > > > between DEVX and verbs and improves mechanism for controlling privileged DEVX
> > > > commands.
> > > >
> > > > The first patch updates mlx5 ifc file.
> > > >
> > > > Next 3 patches enable modifying and querying verbs objects via the DEVX
> > > > interface.
> > > >
> > > > To achieve that the core layer introduced the 'UVERBS_IDR_ANY_OBJECT' type
> > > > to match any IDR object. Once it's used by some driver's method, the
> > > > infrastructure skips checking for the IDR type and it becomes the driver
> > > > handler responsibility.
> > > >
> > > > The DEVX methods of modify and query were changed to get any object type via
> > > > the 'UVERBS_IDR_ANY_OBJECT' mechanism. The type checking is done per object as
> > > > part of the driver code.
> > > >
> > > > The next 3 patches introduce more robust mechanism for controlling privileged
> > > > DEVX commands. The responsibility to block/allow per command was moved to be
> > > > done in the firmware based on the UID credentials that the driver reports upon
> > > > user context creation. This enables more granularity per command based on the
> > > > device security model and the user credentials.
> > > >
> > > > In addition, by introducing a valid range for 'general commands' we prevent the
> > > > need to touch the driver's code any time that a new future command will be
> > > > added.
> > > >
> > > > The last patch fixes the XRC verbs flow once a DEVX context is used. This is
> > > > needed as XRCD is some shared kernel resource and as such a kernel UID (=0)
> > > > should be used in its related resources.
> > > >
> > > > Thanks
> > > >
> > > > Yishai Hadas (7):
> > > >   net/mlx5: Update mlx5_ifc with DEVX UCTX capabilities bits
> > > >   IB/core: Introduce UVERBS_IDR_ANY_OBJECT
> > > >   IB/core: Enable getting an object type from a given uobject
> > > >   IB/mlx5: Enable modify and query verbs objects via DEVX
> > > >   IB/mlx5: Enforce DEVX privilege by firmware
> > > >   IB/mlx5: Update the supported DEVX commands
> > > >   IB/mlx5: Allow XRC usage via verbs in DEVX context
> > > >
> > > >  drivers/infiniband/core/rdma_core.c   |  27 +++--
> > > >  drivers/infiniband/core/rdma_core.h   |  21 ++--
> > > >  drivers/infiniband/core/uverbs_uapi.c |  10 +-
> > > >  drivers/infiniband/hw/mlx5/devx.c     | 142 ++++++++++++++++++++++----
> > > >  drivers/infiniband/hw/mlx5/main.c     |   4 +-
> > > >  drivers/infiniband/hw/mlx5/mlx5_ib.h  |   6 +-
> > > >  drivers/infiniband/hw/mlx5/qp.c       |  12 +--
> > > >  drivers/infiniband/hw/mlx5/srq.c      |   2 +-
> > > >  include/linux/mlx5/mlx5_ifc.h         |  26 ++++-
> > > >  include/rdma/uverbs_ioctl.h           |   6 ++
> > > >  include/rdma/uverbs_std_types.h       |  12 +++
> > > >  11 files changed, 215 insertions(+), 53 deletions(-)
> > > >
> > > > --
> > > > 2.19.1
> > > >
> > >
> > > Hi Leon,
> > >
> > > I've put this into my wip/dl-for-next branch.  Because it pulled in the
> > > mlx5-next tree (which was significant because the patch we wanted was at
> > > the tip and a whole slew of other patches were before it),
> >
> > Yes, this is how the shared branch works, DaveM merges it, we don't
> > have to unless we have a dependency, so it can accumulate a bit.
>
> I get how it works :-P.  I was just commenting that it had in fact built
> up an accumulation.
>
> > > the changeset
> > > for this patch looks much bigger.  And it had the merge conflict you
> > > mentioned.  You might want to double check my work before it gets moved
> > > over to the official for-next branch.
> >
> > It is a bit easier to follow the git log if merges are done with the
> > --log option to summarize what was pulled in.
>
> I'll modify my merge alias to add it.  As it stands, I'll repush this to
> my wip branch with the --log option added.

Thanks, I looked on the merge commit 33cb7e760de ("Merge 'mlx5-next'
into mlx5-devx") and it looks exactly as I have.

Thanks again.

>
> --
> Doug Ledford <dledford@redhat.com>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD



--YD3LsXFS42OYHhNZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcBuTMAAoJEORje4g2clinfCMP/jmWscr+eZPhow9bor7iCEp3
NOBuWo8zVEhHTqb0h3Hr1wb+C167svadbTsWMuzyV/iBWW+i5X2GshBuk7P12SAD
u3XLg6jhy3R/pym0mNEKHPRHU6meSHkcpnPQ+fbnV7NnkptPKpy9Hryu7xeyd49i
3TUFes+qvChzC6b+NRpaVCWMFsfZdpRmq60ezk3bZsYvvRptyvQSsyAUJRhBQBNW
On+8rN47uG5XmdV9ajWN4nJSd45tdK2XrHT2K9ypCnBr+ovdJ5xEt7/ndMeZzx4p
sWi7J1TsFWA08rEuhaAE68ks2ez0AC/CDADbAReuCKHiLF014Kk8YCkRXMkKPZm6
/wwFr1KkAIbJg+43RxljqkBgfYbowGEakDHUjIQhThAEZuVTsxJ+iXqcmNaBontr
rRFBsqcQse6SnyrB+IsvCRxNxplrtwfZM3X9NfLMYdYDCiWjNBAXDqbaoWJhD/yA
uuF+HfxgOdtwvN4v36XEvXIMuoo6rm2Y4cnF2S8q+eBJf7d69j24J8kf9cFOi1dH
PJ6avDSvArbaL/p7Il7Wy/w90LxEUf5+DhGRGQVBAVS56Er5S8v+lLfSU1QrV8Sm
xVJsuKzwbtkdFfRYcYXCGURTPqW/irf4stPpNzgk9kNcCTrYf3si7fyLK2q8zVRN
ltObvBnThqS2vkZeEK4H
=+pf1
-----END PGP SIGNATURE-----

--YD3LsXFS42OYHhNZ--
