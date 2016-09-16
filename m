From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 4/7] IB/mlx4: Fix possible vl/sl field mismatch in
 LRH header in QP1 packets
Date: Fri, 16 Sep 2016 14:01:57 -0400
Message-ID: <4ad7c7fb-71a4-8ac4-f3a2-d0b4f2001385@redhat.com>
References: <1473696984-6161-1-git-send-email-leon@kernel.org>
 <1473696984-6161-5-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="aEGJO7SsEIFwDUbCAnt4eQ0b5bRr0DF2m"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473696984-6161-5-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aEGJO7SsEIFwDUbCAnt4eQ0b5bRr0DF2m
Content-Type: multipart/mixed; boundary="bJmWCV7uQAwH8A4El6HEHTd9c4DN09QFn";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Message-ID: <4ad7c7fb-71a4-8ac4-f3a2-d0b4f2001385-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 4/7] IB/mlx4: Fix possible vl/sl field mismatch in
 LRH header in QP1 packets
References: <1473696984-6161-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1473696984-6161-5-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
In-Reply-To: <1473696984-6161-5-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--bJmWCV7uQAwH8A4El6HEHTd9c4DN09QFn
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/12/2016 12:16 PM, Leon Romanovsky wrote:
> From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>=20
> In MLX qp packets, the LRH (built by the driver) has both a VL field
> and an SL field. When building a QP1 packet, the VL field should
> reflect the SLtoVL mapping and not arbitrarily contain zero (as is
> done now). This bug causes credit problems in IB switches at
> high rates of QP1 packets.
>=20
> The fix is to cache the SL to VL mapping in the driver, and look up
> the VL mapped to the SL provided in the send request when sending
> QP1 packets.
>=20
> For FW versions which support generating a port_management_config_chang=
e
> event with subtype sl-to-vl-table-change, the driver uses that event
> to update its sl-to-vl mapping cache.  Otherwise, the driver snoops
> incoming SMP mads to update the cache.
>=20
> There remains the case where the FW is running in secure-host mode
> (so no QP0 packets are delivered to the driver), and the FW does not
> generate the sl2vl mapping change event. To support this case, the
> driver updates (via querying the FW) its sl2vl mapping cache when
> running in secure-host mode when it receives either a Port Up event
> or a client-reregister event (where the port is still up, but there
> may have been an opensm failover).
> OpenSM modifies the sl2vl mapping before Port Up and Client-reregister
> events occur, so if there is a mapping change the driver's cache will
> be properly updated.
>=20
> Fixes: 225c7b1feef1 ("IB/mlx4: Add a driver Mellanox ConnectX InfiniBan=
d adapters")
> Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/mad.c        |  64 ++++++++++++++++++-
>  drivers/infiniband/hw/mlx4/main.c       | 110 ++++++++++++++++++++++++=
+++++++-
>  drivers/infiniband/hw/mlx4/mlx4_ib.h    |   7 ++
>  drivers/infiniband/hw/mlx4/qp.c         |  23 ++++++-
>  drivers/net/ethernet/mellanox/mlx4/fw.c |  13 ++--
>  include/linux/mlx4/device.h             |  13 +++-
>  6 files changed, 220 insertions(+), 10 deletions(-)

That's a lot more code churn than I would like to see in a late RC.  I'm
going to drop this patch and move it to 4.9 instead.  If this fixed an
oops or something like that, I would be more open to taking it now, but
the problem being resolved is credits on a switch.  That isn't the sort
of showstopper issue that would justify this large of a patch this late
in the cycle.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--bJmWCV7uQAwH8A4El6HEHTd9c4DN09QFn--

--aEGJO7SsEIFwDUbCAnt4eQ0b5bRr0DF2m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX3DOVAAoJELgmozMOVy/dkgoP/Az5l6Lb0DR/6JbKFOirbuyE
ZWIRZJ5FpWnPTGYK+o+4c+R+iRBmyaq7kXfOhsvSTQ1LCNpUVDM87SXVYkYyd57M
SXA/YKjIXplsT/wHbu3IIm9FlxYr6QGtBYX9j//02bvEIRFf9apsY8WQS+lWEmJS
HR7Isc/YyZFgcJCtwiqJp2Po1wKY/5jBKwhCMlRobH1L6mVL2GzE8meBMYvzKNKX
wtAoPemYwdei3DJ+55axXdWD9MS0V+tETsPBir08w3vrs9iZSAXEHfXmfDa4Vbkg
LkXeDevBkaHB7mV6J0AO/J8I8YTE0BN3ejzD2rhnuIwJKDLKEIyN4a3uGAgVf418
WSQQwgViU5EWlRDDRwm55xoyhv6fT0mUTcQAw2nPXN3VSUe1pqUDzmPvzy41PTaa
mTWo2p8GDLOdjm+5BwqWwXlT79I9Ihlv9VoofugYUuO7o6fMqeKhuKPWfjMVPXKx
MwGwBcsz+StVv5dc1EchSAJ9LG9UL9V9suJShbje6jyLsY5wD1pYEZQ1Ozk3D3M4
58gBN/FnG0s83EKab9m18nwhWTP9kJL4vuco3NHDYidKuCSf1h4GXI/wcB8czOcX
D9fRVOdtKUnVXRCKgyG1qnR8qMHyXsf8YYDeoDAmLaYEdoQSl0hxlSCPn92lfmVJ
j+HvnALH5KVAJyH+mHkg
=Ko9G
-----END PGP SIGNATURE-----

--aEGJO7SsEIFwDUbCAnt4eQ0b5bRr0DF2m--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
