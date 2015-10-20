From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-cm] IB/core: Fix use after free of ifa
Date: Tue, 20 Oct 2015 16:17:34 -0400
Message-ID: <5626A15E.7080800@redhat.com>
References: <1444910463-5688-1-git-send-email-matanb@mellanox.com>
 <1444910463-5688-2-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XnxArCatoaX0bjTAjEvPurHtn7Ts0ix28"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444910463-5688-2-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XnxArCatoaX0bjTAjEvPurHtn7Ts0ix28
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/15/2015 08:01 AM, Matan Barak wrote:
> When using ifup/ifdown while executing enum_netdev_ipv4_ips,
> ifa could become invalid and cause use after free error.
> Fixing it by protecting with RCU lock.
>=20
> Fixes: 03db3a2d81e6 ('IB/core: Add RoCE GID table management')
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This is in my tree for -rc.  Thanks.

> ---
>=20
> Hi Doug,
>=20
> This patch fixes a bug in RoCE GID table implementation. Under stress c=
onditions
> where ifup/ifdown are used, the ifa pointer could become invalid. Using=
 a
> RCU lock in order to avoid freeing the ifa node (as done in other inet =
functions
> (for example, inet_addr_onlink).
>=20
> Our QA team verified that this patch fixes this issue.
>=20
> Thanks,
> Matan
>=20
>  drivers/infiniband/core/roce_gid_mgmt.c | 35 +++++++++++++++++++++++++=
--------
>  1 file changed, 27 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/roce_gid_mgmt.c b/drivers/infiniba=
nd/core/roce_gid_mgmt.c
> index 6b24cba..178f984 100644
> --- a/drivers/infiniband/core/roce_gid_mgmt.c
> +++ b/drivers/infiniband/core/roce_gid_mgmt.c
> @@ -250,25 +250,44 @@ static void enum_netdev_ipv4_ips(struct ib_device=
 *ib_dev,
>  				 u8 port, struct net_device *ndev)
>  {
>  	struct in_device *in_dev;
> +	struct sin_list {
> +		struct list_head	list;
> +		struct sockaddr_in	ip;
> +	};
> +	struct sin_list *sin_iter;
> +	struct sin_list *sin_temp;
> =20
> +	LIST_HEAD(sin_list);
>  	if (ndev->reg_state >=3D NETREG_UNREGISTERING)
>  		return;
> =20
> -	in_dev =3D in_dev_get(ndev);
> -	if (!in_dev)
> +	rcu_read_lock();
> +	in_dev =3D __in_dev_get_rcu(ndev);
> +	if (!in_dev) {
> +		rcu_read_unlock();
>  		return;
> +	}
> =20
>  	for_ifa(in_dev) {
> -		struct sockaddr_in ip;
> +		struct sin_list *entry =3D kzalloc(sizeof(*entry), GFP_ATOMIC);
> =20
> -		ip.sin_family =3D AF_INET;
> -		ip.sin_addr.s_addr =3D ifa->ifa_address;
> -		update_gid_ip(GID_ADD, ib_dev, port, ndev,
> -			      (struct sockaddr *)&ip);
> +		if (!entry) {
> +			pr_warn("roce_gid_mgmt: couldn't allocate entry for IPv4 update\n")=
;
> +			continue;
> +		}
> +		entry->ip.sin_family =3D AF_INET;
> +		entry->ip.sin_addr.s_addr =3D ifa->ifa_address;
> +		list_add_tail(&entry->list, &sin_list);
>  	}
>  	endfor_ifa(in_dev);
> +	rcu_read_unlock();
> =20
> -	in_dev_put(in_dev);
> +	list_for_each_entry_safe(sin_iter, sin_temp, &sin_list, list) {
> +		update_gid_ip(GID_ADD, ib_dev, port, ndev,
> +			      (struct sockaddr *)&sin_iter->ip);
> +		list_del(&sin_iter->list);
> +		kfree(sin_iter);
> +	}
>  }
> =20
>  static void enum_netdev_ipv6_ips(struct ib_device *ib_dev,
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--XnxArCatoaX0bjTAjEvPurHtn7Ts0ix28
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWJqFeAAoJELgmozMOVy/d6g4QAJsZNk8XTuCmGmW7ywdfk1Ut
EoXf3OZartt6OS5UJ+VEfmorU7Vz3bkweScyqKEq1c+0Xf01/DVZ5BJw0oGrj/CK
yx4X/XZrIpjyUSuyXYV0we0t8BolNVkXBHJoHZmgwm3oReMueHzmcPPvjI8ULVhe
qWmpjaQ9SiurtzE/ZUWWuwGaDyQZ9UF7yzcM2wr7sT3temCJ/yyI55ohIfmRQ/Ri
pC0ktAI59mu5XYP6Zh0ZdIlbtePLDpZzNWAJswPQlAPi5zmBtE3acWvawf+LGw1P
Ca7irRJzBkk4xKy2Q6B5LMS4YCxVqCwQa18I9kRJkChYndf+VWJEE2FQ+wTRp2h2
8YiS5Ye6wsX4X9y69yAZ0HO8CLGOrWaJc3jzyUXRLvm0MrQK9C/mP0dJpOnyYRFx
RRCgr+Pdz7UjMJefl7I43DzJ1fDa+/CY09o5LFZypajSh8IYOvapY+XvgoJcVjLO
ORaVDk0XeuZwyfMOss06is3RaD5Ewxk76N+licawjQXZfdOhx58+YgPtsL3r/jso
BT203vZrJDwzdDYh+7qI+hHRF64UkOrrG9SLPrmaBf6R0P/Qkg08bSGCceKJJOwh
hEJFbtVt40YBE8XpZoPAOpJLoD05KhUd3OCsBPT3N1SyhUsKfvljGf4MK28bLvsj
r4dcmNS8K0Go/frfmB8e
=0w9H
-----END PGP SIGNATURE-----

--XnxArCatoaX0bjTAjEvPurHtn7Ts0ix28--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
