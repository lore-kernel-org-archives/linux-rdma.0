From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 3/4] IB/core: Support new type of join-state for
 multicast
Date: Fri, 29 Apr 2016 12:10:40 -0400
Message-ID: <83e4ff00-c74e-274f-00ea-de1231a72b08@redhat.com>
References: <1461070287-13469-1-git-send-email-erezsh@mellanox.com>
 <1461070287-13469-4-git-send-email-erezsh@mellanox.com>
 <alpine.DEB.2.20.1604261514590.2663@east.gentwo.org>
 <1828884A29C6694DAF28B7E6B8A82373AB045BD0@ORSMSX109.amr.corp.intel.com>
 <20160427064239.GO7974@leon.nu> <5722C839.2070704@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0475AC@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MSCs6gj50ieaQIrcETWT2jXeKXEng4BuI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0475AC-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MSCs6gj50ieaQIrcETWT2jXeKXEng4BuI
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/29/2016 11:50 AM, Hefty, Sean wrote:
>> This doesn't seem to make any sense to me.  Without going back and
>> re-reading this part of the spec, as I recall, there is:
>>
>> UnJoined
>> SendOnly Join
>> Full Join
>=20
> The 1.2.1 version of the spec has:
>=20
> JoinState - 4 bits
>=20
> Join/Leave Status requested by the port. See discussion below.
> bit 0: FullMember: Include/delete this endport from the multicast group=
 as a
> member sender and receiver.
> bit 1: NonMember: Include/delete this endport from the multicast group =
as
> a non-member sender and receiver.
> bit 2: SendOnlyNonMember: Include/delete this endport from the multicas=
t
> group as a non-member sender only.
> bit 3: Reserved
>=20
> =95 FullMember: Group messages are routed both to and from the port.
> The port is considered a member for purposes of group creation and
> deletion, i.e.: if no member ports with FullMember=3D1 remain, the
> group may be deleted; otherwise it may not.
> =95 NonMember: Group messages are routed both to and from the port.
> The port is not considered a member for purposes of group creation/dele=
tion.
> =95 SendOnlyNonMember: Group messages are only routed from the
> port; none are routed to the port. The port is not considered
> a member for purposes of group creation/deletion.
>=20
> Any combination of the MCMemberRecord:JoinState bits may be 1. When
> multiple bits are 1, the qualities of the port's type of membership are=
 the
> union of the qualities specified by the bits that are 1.
>=20

OK, that makes more sense.  Thanks for the refresher.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--MSCs6gj50ieaQIrcETWT2jXeKXEng4BuI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXI4eAAAoJELgmozMOVy/dRewP/R9tsi46Zeq7RAL/2k4XnR4O
wcyW06UCZsRal0wHvg+f5j5IWhHsEg1HY6iqnZjXIpgSvXp2SWa9eipXQYVmeCb2
3ZxmnC1Uxcp9ckQL+4D/GtrzI8ZIMqzw/NzVHfypL3SVLYRCCBkuKZ+83alDATL4
tp6ZYmoK1z8/MMJ9JjjDN13APG+0hbDmrNWtOx8afFA3xenPp/L/QnDBzS3EqdYA
ndyfsIQWa2b1eWRHRwsexjSBpMmlwymohzx9eGrRIeSTDVPHShsJxhXrJOyx0lR+
pO7nxycIqsTus3OsW6NaISyTReyB3vzjXi173vL6OyZVYvojQQ5LC4WeXyAycgFn
3QBh1hFASjhzC19HMAFbVz3EJWt3KmZgaq8qwlCgwVyKLj/vJo2UXrvHIr1VviX6
vh9UTyZWu7E8ab497Ov7LqVSIaO5arHUfG5b0SYNAL19EARbgLmindWTiskzD2pD
tmSsxv8r+Gy3NqLYYPTynilxsYiabjfl+7FBgiFx4oPClf3yZVtaeOUi6F3XMTI9
2Y4+bNj25wA4YNkrXrehTqYqmloSaKiH82Pik8jFxJLxS9v3YZX/LsT1xl4cf8EH
bq7E9prhqUy9dP7KbuGlPHwFnvoy9TaYXugSuVPyiOI5z0xuohbA1KWYsM+25qSf
gPjq8EJaUmnBkt03X4Pm
=hX5A
-----END PGP SIGNATURE-----

--MSCs6gj50ieaQIrcETWT2jXeKXEng4BuI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
