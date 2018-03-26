From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2 iproute2-next 3/6] rdma: Add CM_ID resource tracking
 information
Date: Mon, 26 Mar 2018 18:08:26 +0300
Message-ID: <20180326150826.GH1877@mtr-leonro.local>
References: <cover.1520020530.git.swise@opengridcomputing.com>
 <743dc7a5306f9b3368fcd4c143cdd822250444a6.1520020530.git.swise@opengridcomputing.com>
 <f6dd4255-69b2-bb90-de92-bb633f7248ef@gmail.com>
 <0443b8e0-17ff-1e62-51ba-ba1fa0e0d529@opengridcomputing.com>
 <8d788e10-c170-9b94-09f0-98515fdd5bac@gmail.com>
 <783e600a-9296-8ea0-003e-59e48fd5234b@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OzxllxdKGCiKxUZM"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <783e600a-9296-8ea0-003e-59e48fd5234b@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: David Ahern <dsahern@gmail.com>, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--OzxllxdKGCiKxUZM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 26, 2018 at 09:55:46AM -0500, Steve Wise wrote:
>
>
> On 3/26/2018 9:44 AM, David Ahern wrote:
> > On 3/26/18 8:30 AM, Steve Wise wrote:
> >>
> >> On 3/26/2018 9:17 AM, David Ahern wrote:
> >>> On 2/27/18 9:07 AM, Steve Wise wrote:
> >>>> diff --git a/rdma/rdma.h b/rdma/rdma.h
> >>>> index 5809f70..e55205b 100644
> >>>> --- a/rdma/rdma.h
> >>>> +++ b/rdma/rdma.h
> >>>> @@ -18,10 +18,12 @@
> >>>>  #include <libmnl/libmnl.h>
> >>>>  #include <rdma/rdma_netlink.h>
> >>>>  #include <time.h>
> >>>> +#include <net/if_arp.h>
> >>>>
> >>>>  #include "list.h"
> >>>>  #include "utils.h"
> >>>>  #include "json_writer.h"
> >>>> +#include <rdma/rdma_cma.h>
> >>>>
> >>> did you forget to add rdma_cma.h? I don't see that file in my repo.
> >> It is provided by the rdma-core package, upon which rdma tool now
> >> depends for the rdma_port_space enum.
> >>
> > You need to add a check for the package, and only build rdma if that
> > package is installed. See check_mnl in configure for an example.
>
> Ok, that makes sense.

IMHO, better solution will be to copy those files to iproute2.

Thanks

>
> Steve.

--OzxllxdKGCiKxUZM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlq5DOoACgkQ5GN7iDZy
WKdLSA/+IS9qx4FTkwmJAZCIglQponhjcoVwDBxMDjf7ZBbExMmlfoiwPXTW4c2W
nxkyO4hR41SslA1E1i+3IB5VS3uWFwGqm8mR/cPBI5biLllk29arQR5nxhilusji
ZxyOv7hiOJI+jUUtAocLf7mvWCicz92d2E1eqm/WmEWomRYNG62Ti6qJrbvTxwJb
9a6vC476ecINT5CkkThyw+fNlIz+Bi1rJTD+e1bR9VXOpea/963nSl5sR3rL2gBs
gi6HXQ2cX9DGLreSHc2ZhT1CcDNQd0CeCaNfUnb2hWj9qNIA4J8tMu4IETwnarSV
rYYjVNNqq1tj+XXkpZPQ9//Q1JWeXebKySezNoiyiNEthAx37uyiaEK/ISatZEIB
t07dN+HSoBF57XpissOjoThoI289GhHrQbP5wr9jXl0K6Esq/dxEEjrtyJcy1Kqm
ztg+3lQpKqlEgEEmslmAjAHbbUIK8+6BQ1btv5R834HHCvmDEU88a4ABmBAuJQPI
2g4YTSrdd4MHDDgsgOi3LWxvZZb9Mz6nkRAGP1UCXaifUyEJv3w7C/CH6XHx4GS5
DkIl4MGZGzGi7HnzQs7m+5jrEkO+J5K8/hKVVS24Ws312TNkt/LP8OyxEE/Bmdqw
Ze0/K+hoTSfk3bU0Deq68IBWIJKCGe3+AhieGKDt1vd4HHyPFbc=
=cDVb
-----END PGP SIGNATURE-----

--OzxllxdKGCiKxUZM--
