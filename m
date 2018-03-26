From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2 iproute2-next 3/6] rdma: Add CM_ID resource tracking
 information
Date: Mon, 26 Mar 2018 20:06:47 +0300
Message-ID: <20180326170647.GL1877@mtr-leonro.local>
References: <cover.1520020530.git.swise@opengridcomputing.com>
 <743dc7a5306f9b3368fcd4c143cdd822250444a6.1520020530.git.swise@opengridcomputing.com>
 <f6dd4255-69b2-bb90-de92-bb633f7248ef@gmail.com>
 <0443b8e0-17ff-1e62-51ba-ba1fa0e0d529@opengridcomputing.com>
 <8d788e10-c170-9b94-09f0-98515fdd5bac@gmail.com>
 <783e600a-9296-8ea0-003e-59e48fd5234b@opengridcomputing.com>
 <20180326150826.GH1877@mtr-leonro.local>
 <09f5080f-04d2-3b5e-74fd-7aba85516097@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VIOdPewhitSMo36n"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <09f5080f-04d2-3b5e-74fd-7aba85516097@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: David Ahern <dsahern@gmail.com>, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--VIOdPewhitSMo36n
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 26, 2018 at 10:24:25AM -0500, Steve Wise wrote:
>
>
> On 3/26/2018 10:08 AM, Leon Romanovsky wrote:
> > On Mon, Mar 26, 2018 at 09:55:46AM -0500, Steve Wise wrote:
> >>
> >> On 3/26/2018 9:44 AM, David Ahern wrote:
> >>> On 3/26/18 8:30 AM, Steve Wise wrote:
> >>>> On 3/26/2018 9:17 AM, David Ahern wrote:
> >>>>> On 2/27/18 9:07 AM, Steve Wise wrote:
> >>>>>> diff --git a/rdma/rdma.h b/rdma/rdma.h
> >>>>>> index 5809f70..e55205b 100644
> >>>>>> --- a/rdma/rdma.h
> >>>>>> +++ b/rdma/rdma.h
> >>>>>> @@ -18,10 +18,12 @@
> >>>>>>  #include <libmnl/libmnl.h>
> >>>>>>  #include <rdma/rdma_netlink.h>
> >>>>>>  #include <time.h>
> >>>>>> +#include <net/if_arp.h>
> >>>>>>
> >>>>>>  #include "list.h"
> >>>>>>  #include "utils.h"
> >>>>>>  #include "json_writer.h"
> >>>>>> +#include <rdma/rdma_cma.h>
> >>>>>>
> >>>>> did you forget to add rdma_cma.h? I don't see that file in my repo.
> >>>> It is provided by the rdma-core package, upon which rdma tool now
> >>>> depends for the rdma_port_space enum.
> >>>>
> >>> You need to add a check for the package, and only build rdma if that
> >>> package is installed. See check_mnl in configure for an example.
> >> Ok, that makes sense.
> > IMHO, better solution will be to copy those files to iproute2.
>
> Hey Leon,
>
> Why is it better in your opinion?=A0 My gut tells me adding rdma_cma.h to
> iproute2 means more uabi type syncing.

Making rdmatool be dependant on rdma-core will require that distributions
will update their specs to install rdma-core as a dependency for every
iprotue2 install.

The rdma-core dependency makes sense for RDMA users, but doesn't for most of
the iproute2 users.

Thanks

>
>

--VIOdPewhitSMo36n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlq5KKcACgkQ5GN7iDZy
WKfDYxAAmyfdaqSaOGIMJ7pwitUUxzWIdRi8RqMGT8UU2HtnAq7MfI50+3pyo29s
0YkWxWEebTNe2f+BBLPmyw7JO98v5JfPjXvK4V+3rtzEJCkr24Yb0VVZElY4DJGJ
DO3E2Hemfa430hVbVD0sKcm5Zzs5V0JpWWIUK5r7iNFx2dmrm4ApbYjJc4OjJug+
7VlrG0IHnLXvEgRvlQJhdBWyIOD/G0+ZXXxk8SEmgbkkNd32QN7h2yALkQwofVxS
BGPCEheqFhIbxDcyQ48ccUKDAk2JvtSDZrvOMLHevA/M/eXxXQIIDQ4SkUVs7Cnj
i9KT/UhvvDk/UL8uQuAg1LSr+yoUTWuSnWIiiCEHYqlkJxJjoHo5xci2gPIcOGOk
0D85asKZu8bhf1+NDLbTyB0uUp4o1U1uRB9is43ey7jNDSAp0HhFPIJjqw5B+2ZB
cDCL0eefkq0x2hgbSOa24SjzymUFPiyFVHJiJD5zQlGEmij0CmYtn3EXpuDqvsg4
0orCFs5zTqMR5I54DSvt0A/8esB/226Sw9RH0blK+INTjF4N4ljuDUtASTbr9bz5
t7vleV6xnayzEI8IJBebgI2TMhnIgLQyRV4Kgn1v53tjZ78xLZkiPtCqIP8kahJu
fT3sp84JZOgHeqHgXWv+aANPr7xll0Q/A7AVudblidXsVHXSBFU=
=tKez
-----END PGP SIGNATURE-----

--VIOdPewhitSMo36n--
