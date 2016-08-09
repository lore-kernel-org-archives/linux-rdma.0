From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/hfi1: Using kfree_rcu() to simplify the code
Date: Tue, 9 Aug 2016 20:51:06 +0300
Message-ID: <20160809175106.GB23921@leon.nu>
References: <1470649818-30040-1-git-send-email-weiyj.lk@gmail.com>
 <32E1700B9017364D9B60AED9960492BC2D09F703@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC2D09F703-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 09, 2016 at 04:20:08PM +0000, Marciniszyn, Mike wrote:
>=20
>=20
> > -----Original Message-----
> > From: Wei Yongjun [mailto:weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> > Sent: Monday, August 8, 2016 5:50 AM
> > To: Marciniszyn, Mike <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Dalessandro, Dennis
> > <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>;
> > Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Hal Rosenstock
> > <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: [PATCH] IB/hfi1: Using kfree_rcu() to simplify the code
> >=20
> > The callback function of call_rcu() just calls a kfree(), so we can use
> > kfree_rcu() instead of call_rcu() + callback function.
> >=20
> > Signed-off-by: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/hfi1/mad.c | 9 +--------
> >  1 file changed, 1 insertion(+), 8 deletions(-)
> >=20
> > diff --git a/drivers/infiniband/hw/hfi1/mad.c
> > b/drivers/infiniband/hw/hfi1/mad.c
> > index 1263abe..95c43e1 100644
> > --- a/drivers/infiniband/hw/hfi1/mad.c
> > +++ b/drivers/infiniband/hw/hfi1/mad.c
> > @@ -3398,7 +3398,7 @@ static void apply_cc_state(struct hfi1_pportdata
> > *ppd)
> >=20
> >  	spin_unlock(&ppd->cc_state_lock);
> >=20
> > -	call_rcu(&old_cc_state->rcu, cc_state_reclaim);
> > +	kfree_rcu(old_cc_state, rcu);
> >  }
> >=20
>=20
> This patch misses another call_rcu() that needs to be replaced in cleanup=
_device_data()
> and that seems to be causing 0day issues.
>=20
> Doug, have you put this anywhere to elicit the 0day issues?

0day bot runs on patches in mailing list too.

>=20
> Nacked-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXqhgKAAoJEORje4g2clinuxwQAInAgDxY8tN9S+fk5pCOVxk3
10Riq1APTJwJjtgmVQG7kmlCM706YjXL6gthvs2dx+6rlYbGrRrPd6QtZRDKDIdw
BAa+g1GYPefm+pu235QbI5MEaZSBcABa0JfXDRBd7hZCcpWJLz5CYu32llRgD1CI
4JHQ99va+bR/R4DZayeCTmSnuFjeYAfFT/fnB5/EoqEoxogtzyilet4qUP0QVxdx
rfQIuA5ku3GZMebylSV49//+wo7kzEkwjLb89GCctI7YYQqnN/3BYxFd06tekclZ
2MEwlThU/wnkBkbEi7+mQTicY8VTj8TzwpGOo6jVBzNzPN5rlhSzY2XZPgmPR0zm
Ots6iWktwcNqu6QHgmsAnWnKaPBb/aTK4VwuN7YgN23CgC7YGBZVkBnzdXWfLVsb
54LZonmHGjMnp5gMxzc888Q+IKzdXOQ5HO31DwXmJxWn2/XcT2a/aIlmORZrRGeg
2mIYX4sz5hhD5x1Xc1inRA3r2qh/Xq0fYKMxwi4VFev+OWR0N1JgFjGCcX/MFelj
atcnfFtCZP+7kUeBaJ6zxWHwtfz66rMUYNWOPfX/yrw5ZWxDzpGvlZyDqj0T+xkb
IxZycnRXAzfk39bIK/Zs8qHXo5UlnoI8J8icpivZrAmk9TbMID7uh7DmCT69zqRG
nAMkta+EROCltxvC4FQa
=s6r+
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
