From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Seeing WARN_ON in ib_dealloc_pd from ipoib in kernel
 4.3-rc1-debug
Date: Mon, 12 Oct 2015 08:35:04 -0400
Message-ID: <561BA8F8.9030002@redhat.com>
References: <56153F71.2010801@dev.mellanox.co.il>
 <5615442D.2020007@redhat.com> <561A8591.4020608@dev.mellanox.co.il>
 <alpine.DEB.2.20.1510111848560.10812@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LkMuqV9ssQijFkOePfCx99wDLqfXJq2EP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1510111848560.10812-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LkMuqV9ssQijFkOePfCx99wDLqfXJq2EP
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/11/2015 07:49 PM, Christoph Lameter wrote:
> On Sun, 11 Oct 2015, Sagi Grimberg wrote:
>=20
>> Is someone looking at this? It really should be fixed before 4.3
>> final...
>=20
> The following fixup patch is needed:

Thanks Christoph.  I figured the issue had to have come from the new
code, but I hadn't had a chance to track it down yet.

>=20
>=20
> Subject: ipoib: For sendonly join free the multicast group on leave
>=20
> When we leave the multicast group on expiration of a neighbor we
> do not free the mcast structure. This results in a memory leak.
>=20
> Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
>=20
> Index: linux/drivers/infiniband/ulp/ipoib/ipoib.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/infiniband/ulp/ipoib/ipoib.h
> +++ linux/drivers/infiniband/ulp/ipoib/ipoib.h
> @@ -495,6 +495,7 @@ void ipoib_dev_cleanup(struct net_device
>  void ipoib_mcast_join_task(struct work_struct *work);
>  void ipoib_mcast_carrier_on_task(struct work_struct *work);
>  void ipoib_mcast_send(struct net_device *dev, u8 *daddr, struct sk_buf=
f *skb);
> +void ipoib_mcast_free(struct ipoib_mcast *mc);
>=20
>  void ipoib_mcast_restart_task(struct work_struct *work);
>  int ipoib_mcast_start_thread(struct net_device *dev);
> Index: linux/drivers/infiniband/ulp/ipoib/ipoib_main.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ linux/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1207,8 +1207,10 @@ static void __ipoib_reap_neigh(struct ip
>=20
>  out_unlock:
>  	spin_unlock_irqrestore(&priv->lock, flags);
> -	list_for_each_entry_safe(mcast, tmcast, &remove_list, list)
> +	list_for_each_entry_safe(mcast, tmcast, &remove_list, list) {
>  		ipoib_mcast_leave(dev, mcast);
> +		ipoib_mcast_free(mcast);
> +	}
>  }
>=20
>  static void ipoib_reap_neigh(struct work_struct *work)
> Index: linux/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ linux/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -106,7 +106,7 @@ static void __ipoib_mcast_schedule_join_
>  		queue_delayed_work(priv->wq, &priv->mcast_task, 0);
>  }
>=20
> -static void ipoib_mcast_free(struct ipoib_mcast *mcast)
> +void ipoib_mcast_free(struct ipoib_mcast *mcast)
>  {
>  	struct net_device *dev =3D mcast->dev;
>  	int tx_dropped =3D 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--LkMuqV9ssQijFkOePfCx99wDLqfXJq2EP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWG6j4AAoJELgmozMOVy/dZw0P/2yNp89uDjWwt/jwWWxB8JrU
snmT6sMiw/oZrQ6c791yFspwWcHo9S3MPn1l6lRQoo/u0wTtepshA595elxgWS7e
zbjmTZjwrafZkxQ6OetGNOB3KE9tz6zEfg8zxDjCyfYNM5R6BULHjeQvNY94fNEA
iL8iSXHsjkinncSlRymA6UKO+f0JgVJd2nOM4CGq3bsNSnA5UD08VC0QfhyTHnlu
8gllL07jssn06lRO6U8KspUTsOh0JX03165M0VNqb3W3kLwHBZJFoMNyoBTZyMXA
tMJfago1CT9jeqhse25FFdpO2ZpFTrA4Cad62ZsOZ5JcEcjvis6Ww8T5qoFNDyt5
YlWhD3RW0D6/lmbDXIN0vXWZTnl3wJzgnC05tyZzwiwTZenj3XkAEdD3rVJniI/B
bAoW9e0aq4FQoHztiixEG0XvU/J7yh7/x54WZXfYXRoMQca4LAzeteoWk39SxeCc
vYwS+JM4Neik7iN/yI6wehrKb3Pel2ynF6N6jo9HhR3bPIjqI1s83tOAsx5kA03l
C63wU6VR/qphXF3TCgogDEcLkP7nAZhypyCZFtJVzqiPRnyDLIHFmWyhXF79B6Wm
WieGhyQvF9VBB9hnZ+izfPfVExUiXbWQbdy+f/pt6wOIKle6ALW/1k09/EMW8ytf
OEbYTo9kvje1TarLoqUC
=XNmm
-----END PGP SIGNATURE-----

--LkMuqV9ssQijFkOePfCx99wDLqfXJq2EP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
