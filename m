From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
Date: Tue, 29 Nov 2016 21:07:52 -0500
Message-ID: <cfdf28c6-4715-28d4-7da6-453fb6794c29@redhat.com>
References: <1480258296-27032-1-git-send-email-leon@kernel.org>
 <1480258296-27032-2-git-send-email-leon@kernel.org>
 <20161128170056.GC28381@obsidianresearch.com>
 <05bd01d2499a$1c75f750$5561e5f0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="XN6VnD03PQ6DFumGqXVcRace7TmtLe94E"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <05bd01d2499a$1c75f750$5561e5f0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Dennis Dalessandro' <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Lijun Ou' <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "'Wei Hu(Xavier)'" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Faisal Latif' <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Selvin Xavier' <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Devesh Sharma' <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Mitesh Ahuja' <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Christian Benvenuti' <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Dave Goodell' <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--XN6VnD03PQ6DFumGqXVcRace7TmtLe94E
Content-Type: multipart/mixed; boundary="PKd55SlmGPACjTn2T0oBrFxFMRq1ngnoE";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>,
 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>,
 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 'Dennis Dalessandro' <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 'Lijun Ou' <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "'Wei Hu(Xavier)'"
 <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Faisal Latif' <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 'Selvin Xavier' <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>,
 'Devesh Sharma' <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>,
 'Mitesh Ahuja' <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>,
 'Christian Benvenuti' <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Dave Goodell'
 <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <cfdf28c6-4715-28d4-7da6-453fb6794c29-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
References: <1480258296-27032-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1480258296-27032-2-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <20161128170056.GC28381-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <05bd01d2499a$1c75f750$5561e5f0$@opengridcomputing.com>
In-Reply-To: <05bd01d2499a$1c75f750$5561e5f0$@opengridcomputing.com>

--PKd55SlmGPACjTn2T0oBrFxFMRq1ngnoE
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/28/2016 12:08 PM, Steve Wise wrote:
>>
>> On Sun, Nov 27, 2016 at 04:51:27PM +0200, Leon Romanovsky wrote:
>>
>>> +static inline bool rdma_protocol_raw_packet(const struct ib_device *=
device,
> u8
>> port_num)
>>> +{
>>> +	return device->port_immutable[port_num].core_cap_flags &
>> RDMA_CORE_CAP_PROT_RAW_PACKET;
>>> +}
>>
>> Does the mlx drivers really register ports with different capabilities=

>> as the same ib_device? I'm not sure that should be allowed.
>>
>> I keep talking about how we need to get rid of the port_num in these
>> sorts of places because it makes no sense...
>>
>=20
> I agree.   Requiring the port number has implications that ripple up in=
to the
> rdma-rw api as well...
> =20
>=20

In all fairness, there is no requirement that any two ports on the same
device be the same link layer, or if the link layer is Ethernet, there
is no requirement that they can't support both iWARP and RoCE.  The idea
that the parent device defined the supported protocols for all ports of
a device became wrong with the first mlx4 device that could do both IB
and Ethernet.  And I think I've heard rumblings of a combined RoCE/iWARP
device possibly in the future from someone else.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--PKd55SlmGPACjTn2T0oBrFxFMRq1ngnoE--

--XN6VnD03PQ6DFumGqXVcRace7TmtLe94E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYPjR4AAoJELgmozMOVy/djlUP+wcB9sfOlDR2tZu4FOxSzpua
BSQ2x/jjSvclvPD8HBdQUsiGhitifkqn28seSZIlxkdAKECY7CWM8t1D9gbudZI1
rN4esCabgRhdM7SmCtHqheVUnKdaKmocWa/v90DpToSqgkaOBZFgt6xPcMc0Rc+x
gjahajTMiNOt6NsWBmHvvNbb91BQtNbULxM9dWGObiPIEqAyA5UCmi6Q/OZzpQBx
UPmOzTs8SJISIE9s9MY0pJyb98i1BbA5CBtaLT6Dk5cHzV6neky/Vk3rZQ3NH8xv
Oqc/7TYPFFXrPKxcDLgo7kdWXkTAhXx/Nv591dWFo0RCRph2KndBCPCYHoU5LWoB
ZnlkRWApDmcFZy4GnKYlzYMOXj4VyKjt5Z0099lF5eOFRfQu0KvxHRz7OeE/6dtf
NKMbQrKr/AaHm3g1ND0AfNgXYsEepdxHqUNQwCofl7hTdZWAS7zjPsyxKCB3KJkD
T0iBByfDcM9jfFDrG5REMlnbOxK8s8PL/ldHGexVUra5tYaGxsRmfQUnsUXSQHDX
PqiU+4cUH4sT+gwYlDdeb5A+qaAnWqX/xI5pWcb7AX1fpe9PyCSh4nnGMfWTzvJd
UUgdDufADkfg735astWaqFo7S8+o6E6mXespg7NuU5TGwau3ZfQ1TyLxCm9H5Jom
qjY5gyNjL+0imtNk9H2V
=QpIS
-----END PGP SIGNATURE-----

--XN6VnD03PQ6DFumGqXVcRace7TmtLe94E--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
