From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 26/28] Avoid gcc 5.4 warning -Wunused-result
Date: Wed, 12 Oct 2016 14:07:50 -0400
Message-ID: <4efde437-85f8-340d-3ec8-876727d84fd2@redhat.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1473109698-31408-27-git-send-email-jgunthorpe@obsidianresearch.com>
 <9ae84345-4427-4689-e6d1-0bfa3eb19630@dev.mellanox.co.il>
 <20161009231936.GA24139@obsidianresearch.com>
 <1e022827-f28c-e2cd-2b6a-edfb713ed0b5@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="wF5uSeGImEQ21VWnmLWW21CbfPfvp1xmD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1e022827-f28c-e2cd-2b6a-edfb713ed0b5-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--wF5uSeGImEQ21VWnmLWW21CbfPfvp1xmD
Content-Type: multipart/mixed; boundary="mNID4HbQFd0hlUlkpfDLACuWBM1BLuKhv";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>,
 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>,
 Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>,
 Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>,
 Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <4efde437-85f8-340d-3ec8-876727d84fd2-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 26/28] Avoid gcc 5.4 warning -Wunused-result
References: <1473109698-31408-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <1473109698-31408-27-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <9ae84345-4427-4689-e6d1-0bfa3eb19630-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
 <20161009231936.GA24139-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <1e022827-f28c-e2cd-2b6a-edfb713ed0b5-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
In-Reply-To: <1e022827-f28c-e2cd-2b6a-edfb713ed0b5-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

--mNID4HbQFd0hlUlkpfDLACuWBM1BLuKhv
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/10/2016 6:06 AM, Yishai Hadas wrote:
> On 10/10/2016 2:19 AM, Jason Gunthorpe wrote:
>> On Sun, Oct 09, 2016 at 04:31:17PM +0300, Yishai Hadas wrote:
>>
>>>> -    if (write(connfd, msg, sizeof msg) !=3D sizeof msg) {
>>>> -        fprintf(stderr, "Couldn't send local address\n");
>>>> +    if (write(connfd, msg, sizeof msg) !=3D sizeof msg ||
>>>> +        read(connfd, msg, sizeof msg) !=3D sizeof msg) {
>>>> +        fprintf(stderr, "Couldn't send/recv local address\n");
>>>
>>> At that step the server expects to read a "done" response from its
>>> client,
>>> checking whether the read was done for sizeof msg which is much
>>> larger will
>>> fail.
>>
>> This OK?
>=20
> Yes, below patch solves the issue.

Merged, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--mNID4HbQFd0hlUlkpfDLACuWBM1BLuKhv--

--wF5uSeGImEQ21VWnmLWW21CbfPfvp1xmD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX/nv2AAoJELgmozMOVy/dmgYQALd6cS8MsXQCkvirEMV0Bhl/
brITbRo8uX8RgAvTXwq3eU7kyLeCc0BpwoV3wNDY7asG2yajIF81jKgv5iVt1uCr
2swc8KZAlRnoHGLeNPcuQbI7YnPIaMcg1Px7ZiwF943rtvr9Iny0np+oaVoMZLqP
boXQ37NCnP7ju1/W9xco6v66PlCRWH1T6QvEpMMCxLNdFr+fI4vTKJHSyreI2JQl
tntnimkcX0UilZfLkewFfv6+O8L1n0HXbfB+hc2klODJ35HUqssdlsQPE5HMXdCo
j/Kwv/o4TuJQO5RbraZGKXbdFsBFENpnS72Ck5EdJ2rJo6pkHYSTJDQXlMYA+1g+
t4mRkkOrv5nQRkwfn4eTACevnvmJXjRZ8DuxF+tWGhSde30l1MDU67O/a4lWCjWK
3JeAye7fX661YqINUfDf0/eU8nXZuyic0IhQH2CHyb6fAf629aSYyBpUGLYzXtJc
Z1bJg7s9MBpuLk9qHc2aIg3hxQu00aMnQ9P/Ry4dPvHGS1n3roH74Oc7XHYDpUrv
/u6RWWDq2n3Ko0dpBDOeyK6rjZsLAndHRndyj4EIAUpabD4vFzMnlrQkP4Pb1YVj
R5P1g+YJ/ZIVrQJRb7kaCIDMG/QtdXwnvb1EUbo72EOwUa1j/iRYJtxB6UgMBtMS
/z2dx3l3QcK/bINqVt/C
=c+ah
-----END PGP SIGNATURE-----

--wF5uSeGImEQ21VWnmLWW21CbfPfvp1xmD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
