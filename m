From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 0/5] mlx5 IB RoCE LAG
Date: Sat, 1 Oct 2016 19:39:45 -0400
Message-ID: <83c14753-a732-dd16-e940-0d3df6bb0689@redhat.com>
References: <1474220884-21341-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iufGm3LRevNl6Hf5SchmNpDvV4rfMtD6D"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474220884-21341-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iufGm3LRevNl6Hf5SchmNpDvV4rfMtD6D
Content-Type: multipart/mixed; boundary="8495j4hS9O1IKA8UDealWO6VmEeiM0wEX";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <83c14753-a732-dd16-e940-0d3df6bb0689-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 0/5] mlx5 IB RoCE LAG
References: <1474220884-21341-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1474220884-21341-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--8495j4hS9O1IKA8UDealWO6VmEeiM0wEX
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/18/2016 1:47 PM, Leon Romanovsky wrote:
> This feature keeps track, using netdev LAG events,
> of the bonding and link status of each port's PF netdev.
>=20
> When both of the card's PF netdevs are enslaved exclusively
> to the same bond master, LAG state is active.
> Bond mode must be one of:
> 1 (active-backup), 2 (XOR), or 4 (802.3ad).
>=20
> During LAG, a single IB device is present for both ports.
> This allows for load balancing and high availability to be
> managed by the driver, abstracting it away from ULPs.
> Such an IB device is given a name of "mlx5_bond_X".
>=20
> LAG mode is determined by the bond driver.
> In load balancing (modes 2 and 4), QPs are assigned to ports
> in a round-robin fashion, on QP transition from RESET->INIT.
> In high availability (mode 1), all QPs are assigned to the active
> slave, determined by bond driver.
>=20
> Please note that if the link state of a port becomes down when
> mode is load balancing, all QPs will be moved to the other port,
> and will be moved back once both ports are up again.
>=20
> This feature itself split into mlx5_core and mlx5_ib parts, while mlx5_=
core was
> already submitted and accepted:
>   1) mlx5_core: Implements RoCE LAG infrastructure and API.
>     a) Bond device LAG events tracking.
>     b) Decisions as to whether LAG state is active.
>     c) Firmware commands to enter and exit LAG state.
>     d) Manages HA behavior.
>   2) mlx5_ib: Uses core infrastructure to implement RoCE LAG.
>     a) Chooses an "mlx5_bond_X" device name when LAG is active.
>     b) Implements QP load balancing.
>     c) Merges steering, such that both port's traffic arrives on
>        PF0's root flow table. This is used for processing
>        both port's usermode Ethernet traffic on PF0.
>     d) Creates a special flow table that diverts all
>        non-usermode Ethernet traffic received on port 2
>        back to PF1's root flow table (since non-usermode Ethernet
>        should not be affected by LAG).
>=20
> Available in the "topic/roce-lag-mlx5" topic branch of this git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git
>=20
> Or for browsing:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Dtopic/roce-lag-mlx5

Because I didn't take everything you submitted in the order you
submitted it, there were a number of conflicts I had to fix up, but
series applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--8495j4hS9O1IKA8UDealWO6VmEeiM0wEX--

--iufGm3LRevNl6Hf5SchmNpDvV4rfMtD6D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8ElBAAoJELgmozMOVy/dK3QQALy8o8nGsJbdNvvpxUZrQOK+
y9OzYG/C7VjOYmlNP3rHDQ3bMSR9h2d6yrsS/2epougJkIeXwwoLjCTKUIly4uhU
GrnlW7XpAR3/bZZPEisT7PtQKWPTVekICjpQm17d7DztLl6ZM/MtIh/JZMYwwDnh
ekyG1HW+skBCnDhntkYywFElK/Scyag+7EAPpj7T+cxH9leIuOG2+y55kiwvLlFb
iljt/vexRSBx7pXmKBXdQmYu82QPJrGZYA3fyQeb/6ZAlLiIHdfnHKrSKOrk1SRI
33h4as9amwIjj45wtESrwc1WWZFVEHfNAQXdLt0ADVeqAfr3o30epTDTwmT81YYM
dDxjYT1CUsL3/8Bi+xC/160XiLLOUbTZOoIDSZkbpkAP+2al2qasus6M+igCdXw5
6Go4PLQ1buiYKtZXHAEzEw1nTaGH1YFS/g6sV3G1IMCn4EWHtHOP5fypQPa4yVXV
Fsq/pF3F+s52Vs0sfrpIqQBh5udrpyvPAB0gUkfYG/NSXCFdZiGrnPFCCCySzAUu
YCf+/78Js7Kt4UYZK2E8ACqVLTO3jZvHhhhEeQbZNIggR/cY1wUTu7qWVdd2kKdh
0RZi0f/iGUmySlH2/U3K1WUbRa4cFqhZlDVCDVZhq2/A5Jjy8ZIGYQ2yap8B1B6N
8FkmxFxqd9mshSkmw8iZ
=EP64
-----END PGP SIGNATURE-----

--iufGm3LRevNl6Hf5SchmNpDvV4rfMtD6D--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
