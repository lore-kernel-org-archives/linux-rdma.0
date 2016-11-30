From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
Date: Wed, 30 Nov 2016 14:35:34 -0500
Message-ID: <0f905c52-b167-4b7d-4fd0-091056997e47@redhat.com>
References: <1480258296-27032-1-git-send-email-leon@kernel.org>
 <1480258296-27032-2-git-send-email-leon@kernel.org>
 <20161128170056.GC28381@obsidianresearch.com>
 <05bd01d2499a$1c75f750$5561e5f0$@opengridcomputing.com>
 <cfdf28c6-4715-28d4-7da6-453fb6794c29@redhat.com>
 <20161130163621.GB24639@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AM7nFskeox3c6b0hqoXXjWs9IhGVHjM8o"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161130163621.GB24639-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Dennis Dalessandro' <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Lijun Ou' <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "'Wei Hu(Xavier)'" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Faisal Latif' <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Selvin Xavier' <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Devesh Sharma' <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Mitesh Ahuja' <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Christian Benvenuti' <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Dave Goodell' <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AM7nFskeox3c6b0hqoXXjWs9IhGVHjM8o
Content-Type: multipart/mixed; boundary="jGFAie9IeqOrQlxfCMT2uKbGdgxpf8p1W";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>,
 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>,
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
Message-ID: <0f905c52-b167-4b7d-4fd0-091056997e47-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
References: <1480258296-27032-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <1480258296-27032-2-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
 <20161128170056.GC28381-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <05bd01d2499a$1c75f750$5561e5f0$@opengridcomputing.com>
 <cfdf28c6-4715-28d4-7da6-453fb6794c29-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161130163621.GB24639-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20161130163621.GB24639-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--jGFAie9IeqOrQlxfCMT2uKbGdgxpf8p1W
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/30/2016 11:36 AM, Jason Gunthorpe wrote:
> On Tue, Nov 29, 2016 at 09:07:52PM -0500, Doug Ledford wrote:
>> On 11/28/2016 12:08 PM, Steve Wise wrote:
>>>>
>>>> On Sun, Nov 27, 2016 at 04:51:27PM +0200, Leon Romanovsky wrote:
>>>>
>>>>> +static inline bool rdma_protocol_raw_packet(const struct ib_device=
 *device,
>>> u8
>>>> port_num)
>>>>> +{
>>>>> +	return device->port_immutable[port_num].core_cap_flags &
>>>> RDMA_CORE_CAP_PROT_RAW_PACKET;
>>>>> +}
>>>>
>>>> Does the mlx drivers really register ports with different capabiliti=
es
>>>> as the same ib_device? I'm not sure that should be allowed.
>>>>
>>>> I keep talking about how we need to get rid of the port_num in these=

>>>> sorts of places because it makes no sense...
>>>>
>>>
>>> I agree.   Requiring the port number has implications that ripple up =
into the
>>> rdma-rw api as well...
>>> =20
>>>
>>
>> In all fairness, there is no requirement that any two ports on the sam=
e
>> device be the same link layer, or if the link layer is Ethernet, there=

>> is no requirement that they can't support both iWARP and RoCE.
>=20
> There actually is a requirement. The RDMA CM hard requires all ports
> be iWARP or !iWARP at least. I'm sure there are other subtle things
> floating around.
>=20
> There are also things that become very confusing for user space, and
> we don't have the infrastructure to support, if ports can switch
> configurations on the fly.
>=20
> The simplest, approach, most in line with how verbs was designed, is
> to require each ib_device to have a single kind of AH.

Sorry, we're conflating two separate things here.  I was merely
referring to the hardware.  Not our implementation of a stack.  I was
attempting to point out that our stack implementation is placing
artificial restrictions on the hardware that the hardware does not share.=


>> The idea that the parent device defined the supported protocols for
>> all ports of a device became wrong with the first mlx4 device that
>=20
> Arguably it was sort of OK for roceev1, is less OK for v2, but
> shouldn't have been done anyhow.
>=20
> The uapi question here is do we want to double down and try and make
> this work (and what does that even *mean*) or admit mlx4 was an error
> and stop doing that going forward..
>=20
> Or do something else? eg Specifying the AH type when creating the PD
> could potentially solve some of the problems...
>=20
>> could do both IB and Ethernet.  And I think I've heard rumblings of
>> a combined RoCE/iWARP device possibly in the future from someone
>> else.
>=20
> Two struct ib_devices for the same port then... Certainly ugly.

I'm not entirely sure I agree....I would have to think about it more,
but the underlying problem I'm concerned with is exactly what I point
out above: what restrictions would we be placing on the hardware that
are artificial and a result of our stack that the hardware itself does
not share?  Could the hardware support automatic migration from iWARP to
RoCE or vice versa if both endpoints supported it?  Would that work if
we required two separate ib_devices?  Things like that.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--jGFAie9IeqOrQlxfCMT2uKbGdgxpf8p1W--

--AM7nFskeox3c6b0hqoXXjWs9IhGVHjM8o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYPyoGAAoJELgmozMOVy/dRDYQAJWuNyv3oD6ErmLBeaWscb4N
tWrDRyPylaCL0x7RcihLrJXBUHZ0vrY0nvardcYNErznwIuqB2Tb5Ai12W+kR0O3
2Z50LgeN8d0hDbSRfqqkky1ZNlRlxgoKAMkfQSV5OKGH1BDIJ20HxUbYbDmZG1tK
u9GTj2XVvsYrHv+MDQwuW5WkLxaAhQT0EvPU3Kyok7u76T/3zmYeayenE7Q7wMht
Qpuxqm+w0s2Q8VLTHDJEnp5LVHILZruQcPiofKVt+LJ8NO6QntsRiwhAw79MNfEn
TTep+MKWl7OmedtdvL0ZEZRR3Pph/pDPDBTe5LbPjIgz+NsjCUdH/rFXntTHR3kc
8erFTSEvaasExAs1lUuvSnOp/l8abRKlKN+9DBWdg0S8R6J4ZVsfaAUGaG87zCm2
NK5Qo8ECbeAkoPDY+ZfCIxKuBH5LOvl+Wy+vmKH1KsJcMZ6qyx6vFtBtKRsxZ5Ma
NzRWDnZOyYLH7pcetU1SQvrekajenkiatnonLfLbiB79gkBljS+lsKCLL3d/w5bC
XuD6XcvQyhgXvg+j7ilnDqju7sa6R0DRUc8BnxttRe8pJanTOA9uQ8GIPvGFdZwg
z/DrpCalM3xoWnp8kB/nTnYtsejyb+o6tEupFr5lri6gWc7xyP+mDdbOzOnNShAr
A1OjRW9gWZefBc8I2Swt
=cbmo
-----END PGP SIGNATURE-----

--AM7nFskeox3c6b0hqoXXjWs9IhGVHjM8o--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
