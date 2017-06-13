From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
Date: Tue, 13 Jun 2017 08:29:38 +0300
Message-ID: <20170613052938.GE2576@mtr-leonro.local>
References: <20170612064918.12510-1-leon@kernel.org>
 <074a01d2e39f$edc28860$c9479920$@opengridcomputing.com>
 <VI1PR0502MB3008CE85A4F274886B74DF2BD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <3fa7a4b5-5c19-8c6a-d78b-93219a9be888@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB142A9B@ORSMSX109.amr.corp.intel.com>
 <VI1PR0502MB300885A1DD676E1649CDB268D1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <b5279c09-027f-e374-ffde-7f236c52322c@intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB142BEC@ORSMSX109.amr.corp.intel.com>
 <085201d2e3be$81070ce0$831526a0$@opengridcomputing.com>
 <20170612210259.GA25652@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="//IivP0gvsAy3Can"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170612210259.GA25652-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "'Dalessandro, Dennis'" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Parav Pandit' <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Idan Burstein' <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--//IivP0gvsAy3Can
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 12, 2017 at 03:02:59PM -0600, Jason Gunthorpe wrote:
> On Mon, Jun 12, 2017 at 03:57:29PM -0500, Steve Wise wrote:
> > > > > When transmitter and receiver is enabled to do so, as I described in
> > > > overview section of Documentation, it helps
> > > > > (a) to avoid retransmission - improves network utilization
> > > > > (b) reduces latency due to timers not kicking in.
> > > >
> > > > Yes those benefits are clear. I see no reason why it shouldn't always
> > > > be
> > > > done is my point. Application shouldn't have to care and there is no
> > > > need to make this an additional flag.
> > >
> > > The app cares when data from write 2 can be written at the target before data
> > > from write 1, especially if the writes target the same memory buffers.  (At least I
> > > think this is the intent of exposing this to the app.)
> > >
> > > Note that the provider can always provide stronger ordering than what the app
> > > needs.
> >
> > My understanding is that IB or IW apps should never assume ingress
> > write or read response data is _placed_ into local memory in the
> > order it was transmitted from the peer.  The only guarantee is that
> > the _indication_ of the arrived data preserve the sender's ordering.
> > However, I'm thinking that there are applications out there that
> > spin polling local memory that is the target of a write or read
> > response and assume the last bit of that memory will get written
> > last...
>
> That is with respect to the CPU, but IB requires strong ordering
> between messages within the same QP, eg if I do
>
> RDMA WRITE addr=0 data=1
> RDMA WRITE addr=0 data=2
> RDMA WRITE addr=0 data=3
> RDMA READ  addr=0
>
> I must always get 3, not something else.
>
> It would be notable if this 'out of order' feature violated that
> invariant, but many ULPs would probably still be OK.
>
> Frankly, Parav's original message doesn't seem to describe at all what
> this is about, so maybe we should all wait until v2, and maybe more
> people from Mellanox could contribute to sensibly describing it if
> they want it in ibverbs.

I sent this patch series in US timezone to allow Parav to answer on the
questions if they arise, but for other people from Mellanox it was night
and it limited number of participants.

Thanks

>
> Jason

--//IivP0gvsAy3Can
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk/eEIACgkQ5GN7iDZy
WKfrYg/+M6EOlkd6zAq8AZjmQoaxFZ2t0gqlmr4sHFOpDlq1a4YhHGg+DJJXciOj
63JHPDLo2zpdXk73xCEnGsg5M1MbkdDOYk3xUUs9ske7LNNmEtjAdro/4XrUax0d
wcrSK+OXb9Bacj9amm4Q44fLGHuaow4K0453APRtbClpPrwjqq3o2wGP5V7DP0It
I4OgGyoWBCDW1AVomLnl8wfS+pPzkmFUyTXcou9bvI43ugeO0IlDYfFoAX1XOsTb
rKaZ0R7495D2qsRyu9hVK6TRGsoQuDt+azpe7e9YdOvUKS7s22crUv95YjEKm2ry
QXiZOobq+zubdbhSdb//IEGQ6y4f1Ky+OXJ1LiLCb4yvGpIKuttgZPzVAq8sa/CS
1oTDcfJnqtLmSVr9jXteypejs0kwe/+kegUmjUwK+5AslxDFfkH/3lunnUgfw9aO
uzodZkRCF8pD58XUI9ZMhJmqlBr3kk44TMM6EhXc0vnofrLuRPFdQnltD5Xn0OCL
LLjLgaThD3wBCl50Dma83TDwTIa7gzeE7NFddTKTOpzlb1oienCcjsacTpbQ2vkV
Me2PQ0w8RslPdqbsbtKpRE6e9ORRSwZaqF+vmrlzZUm4x8oX87rkeObN88cmzh5/
0jLM2hhjhvzSKXHPzZQU5ven/dkl1sUK6oexfJVFUjwtNvxGMkM=
=USrZ
-----END PGP SIGNATURE-----

--//IivP0gvsAy3Can--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
