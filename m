From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-cm] IB/core: Fix use after free of ifa
Date: Thu, 15 Oct 2015 13:37:22 -0400
Message-ID: <561FE452.3050304@redhat.com>
References: <1444910463-5688-1-git-send-email-matanb@mellanox.com>
 <1444910463-5688-2-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Tw9oha5coh0bFH298cot7Q7vfq3v7xgdj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444910463-5688-2-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Tw9oha5coh0bFH298cot7Q7vfq3v7xgdj
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/15/2015 08:01 AM, Matan Barak wrote:
> When using ifup/ifdown while executing enum_netdev_ipv4_ips,
> ifa could become invalid and cause use after free error.
> Fixing it by protecting with RCU lock.
>=20
> Fixes: 03db3a2d81e6 ('IB/core: Add RoCE GID table management')
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
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

This doesn't look like a good fix to me.  In particular, I think you
merely shifted the bug around, you didn't actually resolve it.

In the original code, you called update_gid_ip while holding a reference
to in_dev.  The reference to in_dev was not enough to keep the ifa list
from changing while you were doing your work.  It's not surprising that
you hit a race with the ifa list because update_gid_ip being called
synchronously can both A) sleep because of the mutexes it takes and B)
be slow because of how many locks it takes (and it can really take a lot
due to find_gid) and C) be slow again because of updating the gid table
calling into the low level driver and actually writing a mailbox command
to the card.  So, for all those reasons, not only did you hit this race,
but you were *likely* to hit this race.

Now, you've put an rcu_read_lock on ndev instead.  And you're no longer
seeing the race.  However, does taking the rcu_read_lock on ndev
actually protect the ifa list on ndev, or is the real fix the fact that
you moved update_gid_ip out of the main loop?  Before, you blocked while
processing the ifa list, making hitting your race likely.  Now you
process the ifa list very fast and build your own sin_list that is no
longer impacted by changes to the ifa list, but I don't know that the
rcu_read_lock you have taken actually makes you for sure safe here
versus the possibility that you have just made the race much harder to
hit and hidden it.

And even if the rcu_read_lock is for sure safe in terms of accessing the
ifa list, these changes may have just introduced a totally new bug that
your QE tests haven't exposed but might exist none the less.  In
particular, we have now queued up adding a bunch of gids to the ndev.
But we drop our reference to the rcu lock, then we invoke a (possibly
large number) of sleeping iterations.  What's to prevent a situation
where we get enum_netdev_ipv4_ips() called on say a vlan child interface
of a primary RoCE netdev, create our address list, release our lock,
then the user destroys our vlan device, and we race with del_netdev_ips
on the vlan device, such that del_netdev_ips completes and removes all
the gids for that netdev, but we still have backlogged gid add events in
enum_netdev_ipv4_ips and so we add back in what will become permanently
stale gids?  I don't think we hold rtnl_lock while running in
enum_netdev_ipv4_ips and that's probably the only lock that would
exclude the user from deleting the vlan device, so as far as I can tell
we can easily call del_netdev_ips while the tail end of
enum_netdev_ipv4_ips is sleeping.  Am I wrong here?  A test would be to
take whatever QE test you have that hit this bug in the first place, and
on a different terminal add a while loop of adding/removing the same
vlan interface that you are updating gids on and see if the gid table
starts filling up with stale, unremovable entries.

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



--Tw9oha5coh0bFH298cot7Q7vfq3v7xgdj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWH+RSAAoJELgmozMOVy/dVuMP/im5HJ6P2beB9DYYc+NSLKMF
N3AkQThfC6qY3z1S6aZSUA67uVS7VSXDad4HvgD16t7T/3vGNZv0+9ZfKULd9373
jRk9d9aJ8xCPRvhHuf+YB6ZF7w2/KNSRIIqGCJtcyPENWbDeo0UmmU1E9x2LIXcv
uXvVs32ogU+gDp/92NlaOj1Egf+bm7lunlJg3Gqsl7bQlppTYswBkkbGgtc3zfj/
mtzF2mBX9jmrpLBlfiO+50s14cPWPuFWOqqDpkgxoxLWIPH4omGiE/UqxKFAXSdM
UdDtL9iTHVKjpdxhLVezY5fJDxzY5F72RyT8PkYiVc2adad9xC680IXcFpCfIA8F
jnRETK0ghENMS4mvvkPSqc4sP3VuaU9TKWLK9T2/AbtVcm5nmzCTjEWXUXg1enGj
rRgTuLJDSBYFYzyS4rsd93pPRB2w5AjO8b6ePG8xEiiGbIE7hk5bNCsu8ciNkRrs
Ut7cJFx+yAsr+yKN+1q8WIm0EkDg+ub7nUxnQNReNhLs0xl2cV/RNe5XaICC2gxS
B9wbKBV0j9PlJwXGBp8f+z3DHXf3yjISDSVabIixEN/9ZYK68H95efkkxIAhIxx4
lhA0jviwX7zqdbnQvy6Ff2SVLZg1wdegq14UQvj7oybj9x1tRNV4z0W08tFmFcTK
TIXx0Vkp1p7algeIDak9
=+RA2
-----END PGP SIGNATURE-----

--Tw9oha5coh0bFH298cot7Q7vfq3v7xgdj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
