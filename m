From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2 iproute2-next 3/6] rdma: Add CM_ID resource tracking
 information
Date: Tue, 27 Mar 2018 18:15:44 +0300
Message-ID: <20180327151544.GZ1877@mtr-leonro.local>
References: <cover.1520020530.git.swise@opengridcomputing.com>
 <743dc7a5306f9b3368fcd4c143cdd822250444a6.1520020530.git.swise@opengridcomputing.com>
 <f6dd4255-69b2-bb90-de92-bb633f7248ef@gmail.com>
 <0443b8e0-17ff-1e62-51ba-ba1fa0e0d529@opengridcomputing.com>
 <20180326211505.GF15554@ziepe.ca>
 <b5f651c2-8f71-bc1b-32b8-f4c5175fb4a0@opengridcomputing.com>
 <20180326223033.GK15554@ziepe.ca>
 <20180327032141.GS1877@mtr-leonro.local>
 <20180327144455.GG12318@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gXx2FYK2AghGE4Yq"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180327144455.GG12318@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Steve Wise <swise@opengridcomputing.com>, David Ahern <dsahern@gmail.com>, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--gXx2FYK2AghGE4Yq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 27, 2018 at 08:44:55AM -0600, Jason Gunthorpe wrote:
> On Tue, Mar 27, 2018 at 06:21:41AM +0300, Leon Romanovsky wrote:
> > On Mon, Mar 26, 2018 at 04:30:33PM -0600, Jason Gunthorpe wrote:
> > > On Mon, Mar 26, 2018 at 04:34:44PM -0500, Steve Wise wrote:
> > > >
> > > > On 3/26/2018 4:15 PM, Jason Gunthorpe wrote:
> > > > > On Mon, Mar 26, 2018 at 09:30:41AM -0500, Steve Wise wrote:
> > > > >>
> > > > >> On 3/26/2018 9:17 AM, David Ahern wrote:
> > > > >>> On 2/27/18 9:07 AM, Steve Wise wrote:
> > > > >>>> diff --git a/rdma/rdma.h b/rdma/rdma.h
> > > > >>>> index 5809f70..e55205b 100644
> > > > >>>> +++ b/rdma/rdma.h
> > > > >>>> @@ -18,10 +18,12 @@
> > > > >>>>  #include <libmnl/libmnl.h>
> > > > >>>>  #include <rdma/rdma_netlink.h>
> > > > >>>>  #include <time.h>
> > > > >>>> +#include <net/if_arp.h>
> > > > >>>>
> > > > >>>>  #include "list.h"
> > > > >>>>  #include "utils.h"
> > > > >>>>  #include "json_writer.h"
> > > > >>>> +#include <rdma/rdma_cma.h>
> > > > >>>>
> > > > >>> did you forget to add rdma_cma.h? I don't see that file in my r=
epo.
> > > > >> It is provided by the rdma-core package, upon which rdma tool now
> > > > >> depends for the rdma_port_space enum.
> > > > > It is a kernel bug that enum is not in an include/uapi/rdma header
> > > > >
> > > > > Fix it there and don't try to use rdma-core headers to get kernel=
 ABI.
> > > > >
> > > > > Jason
> > > >
> > > > I wish you'd commented on this just a little sooner.=A0 I just rese=
nt v3
> > > > of this series... with rdma_cma.h included. :)
> > > >
> > > > How about the restrack/nldev code just translates the port space fr=
om
> > > > enum rdma_port_space to a new ABI enum, say nldev_rdma_port_space, =
that
> > > > i add to rdma_netlink.h?=A0 I'd hate to open the can of worms of tr=
ying to
> > > > split rdma_cma.h into uabi and no uabi headers. :(
> > >
> > > If port space is already part of the ABI there isn't much reason to
> > > translate it.
> > >
> > > You just need to pick the right header to put it in, since it is a ve=
rbs
> > > define it doesn't belong in the netlink header.
> >
> > I completely understand Steve's concerns.
> >
> > I tried to do such thing (expose kernel headers) in first incarnation of
> > rdmatool with attempt to clean IB/core as well to ensure that we won't =
expose
> > anything that is not implemented. It didn't go well.
>
> rdma-core is now using the kernel uapi/ headers natively, seems to be
> going OK. What problem did you face?

I didn't agree to move to UAPI defines which are not implemented and not
used in the kernel, so I sent small number of patches similar to those [1, =
2].

Those patches were rejected.

So please don't mix Steve's need to use 3 defines with very large and
painful task to expose proper UAPIs.

Thanks

[1] https://patchwork.kernel.org/patch/9901319/
[2] https://patchwork.kernel.org/patch/9901317/

>
> Jason

--gXx2FYK2AghGE4Yq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlq6YB8ACgkQ5GN7iDZy
WKd0Lw/9EE4binrL3CeYLPKV+mhN5p37T82i0IRvHvdSgIHe3VuIkeQW28qmYy6y
l9WBjF0+mX9R8K1LIEsku1MxieWSdUgAHU+QsV1JAcaUCayj1HrU7pYohhheQrB/
YPZDAOwOWedoTmPtTCcH5X7feC82uHZkRj3x/sMnJCh7RgMMM783xBq8M2+n63P7
HVJyAcfv4WKz09Edp2o25m7M7rwi5a7PDapPYQ4oztDjU+mbEhCI7lzmBrIXgULI
oxtNdvNTuqEc1SPHpuVLDdbWtkVoEus3JFbewWK71v/ofb/hKsDROdKK3SODqLzw
UPnOa2qcD/ScTzhVn1q0AB6dxofvHH7cXL5C3UofVht2mceowX9lMXji5Ufxz3Sn
8d+Qr8+ByQaxGneMjZXgAKkfXLuOActBTrmNu3R3WCYYCJJNsPUd59PeOOYrkywm
Om7yzlCiazpWsyhu8KEc68FOYqhlY3ulYZxaaMhYEE9D+9rXWBYfXqmFJwgMoMQN
RIbnZvjI9M6LLw47vHfCtPPyVltVTz99S3Yd+IqfVeUvvBAGxRlL1AAA8NwFIa0D
MtX/JQfyUbts9Ws099V9FKi8qWLZ6E5pFnPam07KC18pUe6lklED7iHWrxv9H4In
OYJXAYQMj3dOTwq6JuwOUtFZIrZlouvz3xNnWXhosQaQylKatI0=
=bZkv
-----END PGP SIGNATURE-----

--gXx2FYK2AghGE4Yq--
