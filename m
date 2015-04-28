From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 01/26] IB/Verbs: Implement new callback
 query_transport()
Date: Tue, 28 Apr 2015 16:03:32 -0400
Message-ID: <1430251412.102408.8.camel@redhat.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
	 <1429878230-11749-2-git-send-email-yun.wang@profitbricks.com>
	 <DB4PR05MB086367DF92CEE1977D8EB0AEB1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com>
	 <553DE799.5050608@profitbricks.com>
	 <20150427215229.GD5347@phlsvsds.ph.intel.com> <553ED159.2090006@talpey.com>
	 <1430181360.44548.35.camel@redhat.com> <553EDA01.9040708@talpey.com>
	 <1430184275.44548.44.camel@redhat.com>
	 <20150428185612.GA15216@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-D3MCT4Ty9LiFkJB5LPjk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150428185612.GA15216-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-D3MCT4Ty9LiFkJB5LPjk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-04-28 at 12:56 -0600, Jason Gunthorpe wrote:
> On Mon, Apr 27, 2015 at 09:24:35PM -0400, Doug Ledford wrote:
> > On Mon, 2015-04-27 at 17:53 -0700, Tom Talpey wrote:
>=20
> > Having some of it refer to things as IBOE and some as ROCE would be
> > similarly confusing, and switching existing IBOE usage to ROCE would
> > cause pain to people with out of tree drivers (Lustre is the main one I
> > know of).  There's not a good answer here.  There's only less sucky
> > ones.
>=20
> The tide has already turned, we should ditch iboe:
>=20
> $git grep -i roce_ drivers/infiniband/ | wc -l
> 91
> $git grep -i iboe_ drivers/infiniband/ | wc -l
> 37
>=20
> It isn't really mainline's role to be too concerned about out of tree
> things like Lustre.

While I generally agree, one need not be totally callous about out of
tree things either.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-D3MCT4Ty9LiFkJB5LPjk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJVP+eUAAoJELgmozMOVy/d3bUQAKscEYbrdFMjqCr/RP9S58uw
b7i+y75QyziZvk1SUrLpxvoScHLAmzqHsOp2LD11vOE4FYrHqlLrzqlbklH43+X2
tgWG1JEB63FrnE/JOKtO3Aq3CUb2I5zM9hzko+Gv40KCw/heeapbwj1QeMFZMEIr
Wbtgh3n+CU5v3EsAC/ikWw+U65tlf6TaKQL5w3dybGfOZEaNIeRrqN5hQmfIt9bF
MO7bcCCyZPz5qGrGpDaKYJwRsatPtZdmjUa5y9gIiNnrWj22BcotSfEQXMnLY9eI
BPK6uJjJOJYarAGh2gIhBetH9ehNOG3TGRy7q1fZOU0cUSTHjajV9c1coZ5hi1fV
fpub0ovl/fPVcpIScDV4SgQzp+VJtxfCANgEdYNBGiSO8OIc5bMhGVGFxOOdJ+0Q
CwZhl+JaXqDh0TUHdneSaWmtQ21wiPtH2TlVwXICuDGq12R/fTZdXHiOgaArKbmA
I+Z65DJ3fhc89SNV655+WQraIVhA19u8KLkAUA3AsyMHayo8cypF8AntDCTYzmJ9
lhTvJHuVaGBSJyFxuk3+oOo5F6czTd72wyS4g60YPYAc6eEq+KQJte8ScpDUEmvX
AHu45PFE4AMzgqc0Uzjvu1hvT/rzbSeZqxgbsAFyUHTtKoSBFe81zg4AyqdfuhzA
4Sik91R6ZusNg8JKBQKL
=gi2c
-----END PGP SIGNATURE-----

--=-D3MCT4Ty9LiFkJB5LPjk--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
