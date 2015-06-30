From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 4/5] RDMA/iser: support iWARP devices
Date: Tue, 30 Jun 2015 16:20:48 -0400
Message-ID: <5592FA20.2070808@redhat.com>
References: <20150629213332.4188.87551.stgit@build.ogc.int> <20150629213624.4188.94135.stgit@build.ogc.int> <559260BE.6060301@dev.mellanox.co.il> <002201d0b341$b706b2a0$251417e0$@opengridcomputing.com> <20150630164501.GC30149@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373A8FFB028@ORSMSX109.amr.corp.intel.com> <004901d0b364$7b7151f0$7253f5d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lIktee7rEJKkjTLJiu1PJpeLKMvkCblt0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <004901d0b364$7b7151f0$7253f5d0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "'Hefty, Sean'" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'infinipath' <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lIktee7rEJKkjTLJiu1PJpeLKMvkCblt0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/30/2015 02:42 PM, Steve Wise wrote:
>=20
>=20
>> -----Original Message-----
>> From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
>> Sent: Tuesday, June 30, 2015 12:04 PM
>> To: Jason Gunthorpe; Steve Wise
>> Cc: 'Sagi Grimberg'; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; sagig@mel=
lanox.com; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; infinipath;
>> eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
>> Subject: RE: [PATCH V2 4/5] RDMA/iser: support iWARP devices
>>
>>>> I prefer to decouple the iSER changes with this core work.
>>>> Jason/Sean... thoughts?  I could do the iSER w/o patch 3, and the
>>>> follow up with a series that includes our final solution on
>>>> transport independent memory registration and change all the TI
>>>> kernel users (iser and nfsrdma) along with it.
>>>
>>> There has a been a big push lately to drop the strange transport
>>> specific stuff - if you are comitted to seeing the access flag clean
>>> up series through then I don't see a problem with using whatever orde=
r
>>> you like.
>>
>> I agree.
>=20
> Ok, then I'll do this:
>=20
> 1) series with iser changes to enable iwarp including mlx/ipath/qib pat=
ches to set max_sge_rd
> 2) series on transport independent access flags / memory reg - updating=
 the kernel ULPs too.

I've quickly reviewed the series and you plan here seems fine.  I'm
bouncing this out of my queue and will wait for the next version.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--lIktee7rEJKkjTLJiu1PJpeLKMvkCblt0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVkvogAAoJELgmozMOVy/dHWcQAIal6sYn34nVdppYjWqLPcP8
vWmjCZ2w475WF6uKc8jTh4uAjtU87UZgjS7GyRlprwZXlJKUd9MaeNBhHXZB91vC
38liGMoILRsUktTGnDXTGS5LZyHzuybLS7Fv2a5LfeM/gEdAr7zwG83yjYiw7rVl
idq8rdzS0f60fouOwQmbpiEfyjFHhLL0LuhJua5Z06oR4ct9T/GnyEE4xo8tzYig
0w7PpJXNF163EwUpvUhvpr5v4l5OjtudeT52zeE1d/0WybmwGNk8UzZzpTYu9Snc
IAwFPaPX+7jGs49GniHIbT35mAHwjzXuzYTmU6xjLEf1zMrimZdMRr9vtp/6kyRK
eFcc3jiAKOdHTRdOlbVxrzqf20W0E0Y6JEeHdd85W+9bgT11w/h73EomTUVwK0Mo
WwR1EcRako0tJgR0V/YTMJEOJJKczNtlE5np8fpoBJbREhbJNSwmQlZHtXKq5T/d
Q1wvARCweKgHBik4hBfRKrWTBHe6Ulzr6uh917pUmZLDGa5XRNDJgSny2McVZ4uP
/RxCKm5H1WPnxNFgm326f2ciXPCDuFI5Ywkgd9pmY2pHTNocSzskoOH4NV2hBiVL
+AwyyZWVLcphLaghLNnb0nETYU0/P7orXNi9P0sCi99Ngy4uvmvynR+TNumap4Ce
gk1HqLN0Imk137zuqhfl
=VrXK
-----END PGP SIGNATURE-----

--lIktee7rEJKkjTLJiu1PJpeLKMvkCblt0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
