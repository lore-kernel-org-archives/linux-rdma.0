From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 4/7] IB/mlx4: Fix possible vl/sl field mismatch in
 LRH header in QP1 packets
Date: Fri, 23 Sep 2016 12:48:08 -0400
Message-ID: <b79f57ef-4dc2-5d54-9533-0d4e1e939ebb@redhat.com>
References: <1473696984-6161-1-git-send-email-leon@kernel.org>
 <1473696984-6161-5-git-send-email-leon@kernel.org>
 <4ad7c7fb-71a4-8ac4-f3a2-d0b4f2001385@redhat.com>
 <20160918065356.GA2923@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LFQcbv2PS5smnhgPnkWJ9QMEXVU1uTUFK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160918065356.GA2923-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LFQcbv2PS5smnhgPnkWJ9QMEXVU1uTUFK
Content-Type: multipart/mixed; boundary="GAWtwum1U9N45vM2HKvfqQmCcfAk7iigG";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Message-ID: <b79f57ef-4dc2-5d54-9533-0d4e1e939ebb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc 4/7] IB/mlx4: Fix possible vl/sl field mismatch in
 LRH header in QP1 packets
References: <1473696984-6161-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1473696984-6161-5-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <4ad7c7fb-71a4-8ac4-f3a2-d0b4f2001385-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20160918065356.GA2923-2ukJVAZIZ/Y@public.gmane.org>
In-Reply-To: <20160918065356.GA2923-2ukJVAZIZ/Y@public.gmane.org>

--GAWtwum1U9N45vM2HKvfqQmCcfAk7iigG
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/18/2016 2:53 AM, Leon Romanovsky wrote:
> On Fri, Sep 16, 2016 at 02:01:57PM -0400, Doug Ledford wrote:
>> On 9/12/2016 12:16 PM, Leon Romanovsky wrote:
>>> From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>>>
>>> In MLX qp packets, the LRH (built by the driver) has both a VL field
>>> and an SL field. When building a QP1 packet, the VL field should
>>> reflect the SLtoVL mapping and not arbitrarily contain zero (as is
>>> done now). This bug causes credit problems in IB switches at
>>> high rates of QP1 packets.
>>>
>>> The fix is to cache the SL to VL mapping in the driver, and look up
>>> the VL mapped to the SL provided in the send request when sending
>>> QP1 packets.
>>>
>>> For FW versions which support generating a port_management_config_cha=
nge
>>> event with subtype sl-to-vl-table-change, the driver uses that event
>>> to update its sl-to-vl mapping cache.  Otherwise, the driver snoops
>>> incoming SMP mads to update the cache.
>>>
>>> There remains the case where the FW is running in secure-host mode
>>> (so no QP0 packets are delivered to the driver), and the FW does not
>>> generate the sl2vl mapping change event. To support this case, the
>>> driver updates (via querying the FW) its sl2vl mapping cache when
>>> running in secure-host mode when it receives either a Port Up event
>>> or a client-reregister event (where the port is still up, but there
>>> may have been an opensm failover).
>>> OpenSM modifies the sl2vl mapping before Port Up and Client-reregiste=
r
>>> events occur, so if there is a mapping change the driver's cache will=

>>> be properly updated.
>>>
>>> Fixes: 225c7b1feef1 ("IB/mlx4: Add a driver Mellanox ConnectX InfiniB=
and adapters")
>>> Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>>> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>> ---
>>>  drivers/infiniband/hw/mlx4/mad.c        |  64 ++++++++++++++++++-
>>>  drivers/infiniband/hw/mlx4/main.c       | 110 ++++++++++++++++++++++=
+++++++++-
>>>  drivers/infiniband/hw/mlx4/mlx4_ib.h    |   7 ++
>>>  drivers/infiniband/hw/mlx4/qp.c         |  23 ++++++-
>>>  drivers/net/ethernet/mellanox/mlx4/fw.c |  13 ++--
>>>  include/linux/mlx4/device.h             |  13 +++-
>>>  6 files changed, 220 insertions(+), 10 deletions(-)
>>
>> That's a lot more code churn than I would like to see in a late RC.  I=
'm
>> going to drop this patch and move it to 4.9 instead.  If this fixed an=

>> oops or something like that, I would be more open to taking it now, bu=
t
>> the problem being resolved is credits on a switch.  That isn't the sor=
t
>> of showstopper issue that would justify this large of a patch this lat=
e
>> in the cycle.
>=20
> No problem, Thanks.

This is now in my 4.9-misc branch.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--GAWtwum1U9N45vM2HKvfqQmCcfAk7iigG--

--LFQcbv2PS5smnhgPnkWJ9QMEXVU1uTUFK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX5VzIAAoJELgmozMOVy/dPfIQALmFBABXP23acVZWZsu6WPvj
7K3Q+QUP6lEh2qQ4h6BntW3WFZEx1lyoX/c/3aH4rxffmj9ZwdDbM3ojFAWhCxcY
p6KkpzR4HnLAyiYhqQvA5bY3xl4kzY1eOcMjt6omcTTGc2Mer8cKLQ+ucqgSQ+Lp
Q+V+rUS12H8tiVGoRH0Cl6Od3vfU74cVmUPaD6d+hg16jKL9ermVgo/+WS6B6bW+
9kYAx2Ye40W6sMlADk53E3HNPYKQ9Hm21goiT5oygLOR10QQvtp7ugoohcJJq4+u
HH+dO3edaexfoyZRWfZaYyFih+QBqlqFB1HuA+NlqtXhgPljbUi7jp4X0hN1kr7z
crMDIt26CR2QSUbrKMIj+MYOIUAS1o18WBZF6QwT9fkyK3UP0bgeU5XlMd7ezihi
aa3yl/k7uQl+QAioXerXHzWGGS1YwOBAw/JmuSCQoalOv+HRWzPg/qSkCL+MOM+X
drLMMT2smYjNop0uwwjRvMaszAXcyXhrRN/avt+1H6+Y4FnoYs3Z4iwXr9ta8s6e
fX5GbJhESXmo1tZ4tvf+r9xtvbIHUvA82WwFskEzgDXTdgXCl2ysknFCpdDU3e5t
ZvMhsf/MN76UFB63u0wz+cb25gZphRqiS0lE70ZIp4S8A0yTPVTZvVnQjrKT07pz
3ZgqKHWTgAvS7SM93UWU
=X9E9
-----END PGP SIGNATURE-----

--LFQcbv2PS5smnhgPnkWJ9QMEXVU1uTUFK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
