From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v1 iproute2-next 2/4] Sync up rdma_netlink.h
Date: Fri, 22 Feb 2019 00:10:52 +0200
Message-ID: <20190221221052.GG23561@mtr-leonro.mtl.com>
References: <cover.1550773362.git.swise@opengridcomputing.com>
 <ff4f692bee0d683c0638cf88cbf14faf94ea87af.1550773362.git.swise@opengridcomputing.com>
 <20190221105631.7dfa5217@shemminger-XPS-13-9360>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="n/aVsWSeQ4JHkrmm"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190221105631.7dfa5217@shemminger-XPS-13-9360>
Sender: netdev-owner@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Steve Wise <swise@opengridcomputing.com>, dsahern@gmail.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--n/aVsWSeQ4JHkrmm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 21, 2019 at 10:56:31AM -0800, Stephen Hemminger wrote:
> On Thu, 21 Feb 2019 08:19:07 -0800
> Steve Wise <swise@opengridcomputing.com> wrote:
>
> > Pull in the latest rdma_netlink.h to get the RDMA_NLDEV_CMD_NEWLINK /
> > RDMA_NLDEV_CMD_DELLINK API.
> >
> > Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> > ---
> >  rdma/include/uapi/rdma/rdma_netlink.h | 74 +++++++++++++++++++++++++++--------
> >  1 file changed, 58 insertions(+), 16 deletions(-)
> >
> > diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
> > index 04c80cebef49..23a90ad52485 100644
> > --- a/rdma/include/uapi/rdma/rdma_netlink.h
> > +++ b/rdma/include/uapi/rdma/rdma_netlink.h
> > @@ -5,8 +5,7 @@
> >  #include <linux/types.h>
> >
> >  enum {
> > -	RDMA_NL_RDMA_CM = 1,
> > -	RDMA_NL_IWCM,
> > +	RDMA_NL_IWCM = 2,
> >  	RDMA_NL_RSVD,
> >  	RDMA_NL_LS,	/* RDMA Local Services */
> >  	RDMA_NL_NLDEV,	/* RDMA device interface */
>
> You can't just drop elements from user ABI headers.
> That is a break of kernel ABI guarantee.

In RDMA subsystem, we have less pedantic rules and are removing
unused and mistakenly added code. This removal scheme was suggested
by Linus  - remove and see who is complaining.

The big advantage of RDMA is that we know exactly what is in use
by our consumers.

In this case, we knew for sure that no one is using RDMA_NL_RDMA_CM,
and it never was backed by working user space. More on that,
the talks of RDMA_NL_RDMA_CM removal started a long time ago,
but took time till the patch was actually sent.

So yes, if people use this enum value as subsidiary to 1, they will break.

>
> Instead, mark unused elements:
> enum {
> 	RDMA_NL_RDMA_CM = 1, /* deprecated */
> 	RDMA_NL_IWCM,
> ...

--n/aVsWSeQ4JHkrmm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcbyHrAAoJEORje4g2clinpXQP/127kXNG5UuY/Stoz1yD+g56
5jEFMX4uax/wV15AeEoNbx/KWNzbITmYGx8lVWj7+brMECdUBvH8V62TY6ppqGMd
xjJ8eJ9SYJxSQrjn1/AqWGAJ/2wROppM2tpjxesezvDfW+OXQpSAKrDYbH+JhlII
sK+fr6QQLmyukJkMKjGECzwLqZCtjDgVOzcwqOH0bp5R6Vb9vBmDhPM83wAfmEqO
RbYn3TWMtkz/X4gIkt8S/R9fGaBDs+/o3o7kllClkef3bEqtKrHpGYINwgkXwzPX
sExL5/AJU4IIbnZBgQFDWea/NdPbShVLsSr6o1eU+r8IsPzR+n0D2IW4CnzekkX0
JbAbEx3pambTpvd4dfB2Asq7vZ22yDdE7rpEsjVpqsnMhOAJse+3CAMQpJjwKvia
tgfqdpX/HWF55bO06Rhk4PWnjBY2jltq8jJuQnSNNttB95jwE1pqVzREghweLqza
Cp0YDKPx6DH71uYiD4dN4IvTBZkNq4xerxxbzWjN+wJEZPMxIB56qjmjh5oFYHZu
Y7aniBuI5ixAelUv34l9KK1cFPqtVKk9Y7IrD1ITaVZvpd5HpQKXD4ly60C3V9If
MiRxS5PADkzkub3ZWMk1cUspT1mSt3NL1Y3PuQKvUT1gdhxDgb8q5v0LhEQ+CgvB
UBOWucJW1tCwM7vTKOqY
=0MMq
-----END PGP SIGNATURE-----

--n/aVsWSeQ4JHkrmm--
