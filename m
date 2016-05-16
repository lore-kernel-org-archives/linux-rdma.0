From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/core: Do not require CAP_NET_ADMIN for flow steering
Date: Mon, 16 May 2016 12:19:20 -0400
Message-ID: <2994c976-8ed1-75f9-7534-2d0e5f5303b8@redhat.com>
References: <alpine.DEB.2.20.1605131020320.13832@east.gentwo.org>
 <alpine.DEB.2.20.1605131051170.27372@east.gentwo.org>
 <cf61efc8-e426-dd7c-7065-e46bbfb323b0@redhat.com>
 <alpine.DEB.2.20.1605160853050.23895@east.gentwo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IW0059JvL9IPn67q5Bmo3o4W38BNBbWU5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1605160853050.23895-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, marinav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IW0059JvL9IPn67q5Bmo3o4W38BNBbWU5
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/16/2016 09:53 AM, Christoph Lameter wrote:
> On Fri, 13 May 2016, Doug Ledford wrote:
>=20
>>>  	if (cmd.flow_attr.flags >=3D IB_FLOW_ATTR_FLAGS_RESERVED)
>>>
>>
>> I'm not at all convinced this is the right thing to do.  Sniffing of
>> packets is definitely a privileged operation.  Tcpdump needs to be run=

>> as root to do this on regular devices.  If not CAP_NET_ADMIN, then a
>> root check seems appropriate.  CAP_NET_RAW does not seem sufficient fo=
r
>> sniffing other people's packets.
>=20
> CAP_NET_RAW is sufficient for tcpdump and this is not more than that.


That's not true.  In order to set promisc on an interface, tcpdump calls
ioctl with SIOCSIFFLAGS as the ioctl and IFF_PROMISC set in the flags,
and in net/core/dev_ioctl.c we see this check for SIOCSIFFLAGS:


               if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
                        return -EPERM;
                /* fall through */


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--IW0059JvL9IPn67q5Bmo3o4W38BNBbWU5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXOfMIAAoJELgmozMOVy/d4KkP/0fjz6o0S6SlDkoH4K7suQLe
FKyK+DNCsmr9Xjo0eyGsxXS6WwH2VqGpckykmCikd+40kVHNcwPjSRdM5eyRq/tO
j8yt9yTLmWHgxE/O2/VN8A5k32dFML61UOCvTmAgYXNouePMem1DBJNAATXjSIVp
r2zfY01/svL90lqbE/Pp1H3ZJs0UtJ1Md4MrPyegBPdhU/CjH/mpNKHuyoy+cP5q
PIb4xa5oSRmFpq+rfhIwplA+rDhnENcusK04TeSoRg0/Qkpyyh0jl84iVp0xag6b
lrG3IryPFfxUpW+1MiBS3BcEQS/3bI8d6u7m0IqVWRjTyDbwxew1jcyrO63V4QcL
iAY34wQWRmyUHkL2M9bTT6KqPfyWm1gieyZqpPW71QhOCN43It0fvu24e2Z7iBGF
TbBe7bg8OyAyrz0C3ciQR8R+yAM2V0yOckwjxpX2oV9Mmo+MvbQY7NY4BkXPmZ0F
7hKSSklOrOlxpDU53g+xjCxJif2bgQZLkUQbQe4AMsGtmmijmmxOxlJIqwXGJtqD
r7aUq7BMM7rg+XN1Tv+TnPgwwZOhHIsaWxbbmFrADkLlc9sye84yUWbrXrbB2XgS
raM5bPmazuTksGAUp/GSoFmh8xsvS1lsq+//iW3vLYbJB4xDLFdefzqohjtKK7lV
L2ZJZpmTQ1M1cznA5JIo
=4/NC
-----END PGP SIGNATURE-----

--IW0059JvL9IPn67q5Bmo3o4W38BNBbWU5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
