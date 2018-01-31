From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core] iwpmd: fix double mutex unlock
Date: Wed, 31 Jan 2018 16:06:42 -0500
Message-ID: <1517432802.19117.41.camel@redhat.com>
References: <1517413071-20438-1-git-send-email-bharat@chelsio.com>
         <010901d39aa9$d4d66fd0$7e834f70$@opengridcomputing.com>
         <012d01d39aad$228c34f0$67a49ed0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-e9UJEo4fO0jOs6PmQnVG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <012d01d39aad$228c34f0$67a49ed0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Potnuri Bharat Teja' <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, jgg-uk2M96/98Pc@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-e9UJEo4fO0jOs6PmQnVG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-31 at 10:04 -0600, Steve Wise wrote:
> > >=20
> > > pthread_mutex_unlock() is used twice and this patch fixes it.
> > >=20
> > > Fixes: be3fbf85b ("iwpmd: use ccan list.h for pending_messages")
> > > Signed-off-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> > > ---
> > >  iwpmd/iwarp_pm_helper.c | 1 -
> > >  1 file changed, 1 deletion(-)
> > >=20
> > > diff --git a/iwpmd/iwarp_pm_helper.c b/iwpmd/iwarp_pm_helper.c
> > > index bebc151f329b..b8c230189d50 100644
> > > --- a/iwpmd/iwarp_pm_helper.c
> > > +++ b/iwpmd/iwarp_pm_helper.c
> > > @@ -578,7 +578,6 @@ int add_iwpm_pending_msg(iwpm_send_msg
> > > *send_msg)
> > >=20
> > >  	pthread_mutex_lock(&pending_msg_mutex);
> > >  	list_add(&pending_messages, &pending_msg->entry);
> > > - 	pthread_mutex_unlock(&pending_msg_mutex);
> > >  	pthread_mutex_unlock(&pending_msg_mutex);
> > >  	/* signal the thread that a new message has been posted */
> > >  	pthread_cond_signal(&cond_pending_msg);
> >=20
> > Good catch.
> >=20
> > Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>=20
> And this definitely needs to flow to stable.
>=20

Applied to master branch, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-e9UJEo4fO0jOs6PmQnVG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpyL+IACgkQuCajMw5X
L91qkhAAu9fIQZ4B4ZRaZdTmRq9S6pZvKf5NZigBMIjhnOGA3jYVpzfVYXi0D8U/
Du/wrWoACRtVf6hIjXckhP4Bbm5ydyeSCfGKhuFnfYsoE7G0N8hg6eGt3dxdG5vc
Tm9fy8jZpP2ypd7lq0f0sAcydyYsTqd7hCcADnlbqIyloHKqY6uaNLtLmvV4QtFP
+J1rb2YkGR+AJSWH96Lvdl/dTPOFuIGDvMkwm+/EE3D9xIJ6ZdT0I1jv/1ewuWZi
+VWxSzOfAs1Yq5M4uCNsJEbqh6wySbsViCYyUF4JEc6/tdLT+zQSX7InTK7zLJts
0vCknqT76w8nYY0vySRkFX8PTp4dBPDk5Wr01Zqmo12pgsc+Gswmmla76Lf6AK4y
7uTuAp1TBUKwMrymFJ/j2VSGfk7TH5YD7E0h+RWN+pNt8qZaKHpu0HwrAf1CmcSd
cNCeVfIzH6bPIXzMQNZCzTINFlfVHGTg2dbNqdlr2PDVebeMUdMdz7UYq+vKsIR4
0IivJo8qMii7WziQMQE76aUs+tWIuG325p5CYO+jMzjBmESej9iJZ3HjhWNUyOS3
4heicFkqS5wOhC0+ItcdoranCubkbN6cHiw1ydydEJ4A7KD3dhRQE2Q8pApZALLW
B4/MRc3c1FZCzz6JjRg3SInafPksXj2g+W7EHRioKaupEWfDZug=
=yTWM
-----END PGP SIGNATURE-----

--=-e9UJEo4fO0jOs6PmQnVG--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
