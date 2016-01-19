From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Expose ioctl command to retrieve SGID of a
 given socket
Date: Tue, 19 Jan 2016 16:06:46 -0500
Message-ID: <569EA566.2000401@redhat.com>
References: <1451572875-24961-1-git-send-email-yuval.shaia@oracle.com>
 <56854AEB.50802@mellanox.com> <20160106110344.GB5070@yuval-ThinkPad-X220>
 <568D07D0.8080404@mellanox.com> <20160106131019.GC5070@yuval-ThinkPad-X220>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="c2mkGhXRJRlNnLGv4ph4I6Nlb2WdVXXgR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106131019.GC5070@yuval-ThinkPad-X220>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--c2mkGhXRJRlNnLGv4ph4I6Nlb2WdVXXgR
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/06/2016 08:10 AM, Yuval Shaia wrote:
> On Wed, Jan 06, 2016 at 02:25:52PM +0200, Haggai Eran wrote:
>> On 06/01/2016 13:03, Yuval Shaia wrote:
>>> On Thu, Dec 31, 2015 at 05:34:03PM +0200, Haggai Eran wrote:
>>>>> +	sock =3D sockfd_lookup(fd, &rc);
>>>>> +	if (IS_ERR_OR_NULL(sock))
>>>>> +		return -EINVAL;
>>>>> +
>>>>> +	inetsock =3D inet_sk(sock->sk);
>>>>> +
>>>>> +	neigh =3D neigh_lookup(&arp_tbl, &inetsock->inet_daddr, dev);
>>>>
>>>> Also, isn't inet_daddr the destination address? But the function cla=
ims=20
>>>> to return the SGID. I guess these can be ambiguous but still it seem=
s=20
>>>> confusing.
>>> Per description in include/net/inet_sock.h looks like that inet_daddr=
 is
>>> the address of source peer of the socket.
>>> * @inet_daddr - Foreign IPv4 addr
>>>>
>>
>> I meant it was confusing to have the foreign address in the socket des=
ignated=20
>> by "daddr" while the function you proposed returned the foreign GID as=
 SGID.
> I see.
> Function was meant to extract GID of source peer of the socket.
> Anyway, i gave up this this patch so we only talking semantics here :)

Per your comment, I've dropped this patch from any consideration.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--c2mkGhXRJRlNnLGv4ph4I6Nlb2WdVXXgR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnqVmAAoJELgmozMOVy/dHncP/07PP5ptz7p0QFWFUwtmJBv/
IeL/Y4bNcQ3XcZKNzOR+N/7jKUbXFXUdeRYXW1oS3WbaETsHdk62uazdhueMEiQ4
aTzlpSEKkeSbfsnUYw+g9OzuWWXeips1XX5rU4gJp8RMghPM9AvcxrTughP1Oc5J
1HQEFIzqoJkgkgVFO5Dyc3OnUHJOGCe5mlFvm/tFtEMLWQ3WWRXcbn9fiOR1B1sd
4E+E9NcmK0Xs6e91a1Uiq8EE6GWarEMGBAzbGycWS6NqxamBc7yICsBn0VyrwjvD
4i9gD+uzGeE9X8vdFZWG6SCJbY+8Qx7W+LNKaYB3KqwAvMlyLqgYY5hYBjHEasNU
IRKoU8jM636IqS97UPzNRYmI09ts1NVN6JU7JHWAE7tOU+7wbGEzfI/nqjD7kcM9
s07XkjtISiXS1Sg7P19BELZHOHR3g1MDQsTOVJuNPVr+RPAdaYhpOvJwXG1Z96+N
0kmK7ljlfui8pEp7Q+G770glNoh6iQb7ViUTkP1w2RVyENqjTVMKV1SF7gYKw68W
zX750G0WX/wnvugTHy2TQnndQVuRr0yiEWjEpkXXnE+ey8BdufY8rKqsuXZsdfSg
wNbXDRlVNCaQnJM7qh1ZsZMY7ms5+RdMboe7J8kbXO50VejP4mMypVseCJiriDfi
UwoBNuasBz8bZmygvex1
=37UX
-----END PGP SIGNATURE-----

--c2mkGhXRJRlNnLGv4ph4I6Nlb2WdVXXgR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
