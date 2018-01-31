From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next v2 15/16] IB/core: Map iWarp AH type to
 undefined in rdma_ah_find_type
Date: Wed, 31 Jan 2018 10:31:22 -0500
Message-ID: <1517412682.19117.9.camel@redhat.com>
References: <20180126211126.12097.47410.stgit@scvm10.sc.intel.com>
         <20180126213043.12097.88707.stgit@scvm10.sc.intel.com>
         <20180126223252.GE23869@ziepe.ca>
         <368266b8-ae79-3804-38d0-e7730126b532@intel.com>
         <e2a7ac03-539f-9427-b2bb-03ba7f54cbf3@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-WgqtM8BwtmqFRxMGuz+0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2a7ac03-539f-9427-b2bb-03ba7f54cbf3-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-WgqtM8BwtmqFRxMGuz+0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-31 at 08:55 -0500, Dennis Dalessandro wrote:
> On 1/29/2018 8:24 AM, Dennis Dalessandro wrote:
> > On 1/26/2018 5:32 PM, Jason Gunthorpe wrote:
> > > >       if (rdma_protocol_roce(dev, port_num))
> > > >           return RDMA_AH_ATTR_TYPE_ROCE;
> > > > +    else if (rdma_protocol_iwarp(dev, port_num))
> > > > +        return RDMA_AH_ATTR_TYPE_UNDEFINED;
> > > >       else if ((rdma_protocol_ib(dev, port_num)) &&
> > > >            (rdma_cap_opa_ah(dev, port_num)))
> > > >         return RDMA_AH_ATTR_TYPE_OPA;
> > >=20
> > > Let's not add an UNDEFINED type in the middle of an if casecade with=
=20
> > > an all
> > > other cases fall through please:
> >=20
> > Sounds reasonable to me, we will fix that up.
> >=20
> > > I'm not sure sending all these unrelated patches in one series is suc=
h
> > > a helpful idea. Lot of trouble for everyone just to respond to one
> > > minor comment.
> > >=20
> > > This series looks like 4-5 topics to me:
> > >   - Optimize HFI
> > >   - 2 patches realted to the interrupt race
> > >   - Random driver fixes
> > >   - IPoIB fix
> > >   - This patch
> >=20
> > Totally agree. I have been just batching up all our patches at once and=
=20
> > sending as that is what Doug preferred at one time. Driver is a=20
> > different animal though at this point I guess. So I can start breaking=
=20
> > them into logical series again.
> >=20
> > How about just drop this series from patchworks and I'll resubmit with=
=20
> > it broken out into multiple patch sets?
>=20
> Looks like you did drop this from patchworks so I'll assume you want me=
=20
> to break up and re-send. Will try to get that out soon.

Sorry Denny, I saw your comment and I dropped it from patchworks, but
didn't realize you were waiting on confirmation before reposting, so I
didn't say anything.  My bad.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-WgqtM8BwtmqFRxMGuz+0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpx4UoACgkQuCajMw5X
L92SpxAAhAf8kA2HM7/2rqHH9pRzn9r2YZVxYPwUnqBs2lkUk/RmFhTSRwzHOTzz
rsCaHqI+Y9PUZmFkVYSvHxzOBzEogv5w8E/x0AR/qpISNds9fYEWtoSy2KnlrGin
20ImgMczY4m9dh4k4+Ab2/gzyGZbwTxOgeHc6zY4OzsKG6DqJ8hi7u/cHaFrWdkE
ismISl0fMZAcXlENnwrbaGwE87Y454Ju1VHcV72VZEcvK8n2fqbSiQ6qfGYng3Bt
nl4pEXBZJfu+6H74/DLPgMrxcQ2phHGykmnDUDFDuwoADoy4b0WES4Tr+AKbS8Yh
Ww+rRLxp4NQdD6JXggj4MwQRop2J2ZQ9HpaKUDwpk7CzYHFlsAUtmHwGMiEP0i9Y
Op2CyDu1MnYVpXHNa0GYKO/mPs5Wcf+8tNP+AL5a11nR1ye7rC4qjg7hRE8cotih
lxbVFbNM1IyuxEr1tSFuTE294SrWncm8ZlUXKr4h4dqXTKOh6s4U1ojbK3MjPlYW
SkIUggYU6H2fTc6NV4SGy/ZcPbyH6IogBqjjBtaw7aUTbnP/0Fc8Sd6bx9B9u6dD
Sof4mKMuwQ6PzRsKnGtR7QcFOxu8Pf/ZgOitlcF2kJXuIfUDTt92wdRm9ki+PerV
BJQXXpm/Gt69WmdQ6q9Az4uCqOcyoAdCad8mc8/ZQZLXIN85r7A=
=jsU4
-----END PGP SIGNATURE-----

--=-WgqtM8BwtmqFRxMGuz+0--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
