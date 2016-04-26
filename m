From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Tue, 26 Apr 2016 09:05:25 -0400
Message-ID: <571F6795.8020808@redhat.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160418130909.GD11508@infradead.org>
 <20160418174047.GB13865@obsidianresearch.com>
 <20160418182411.GA4904@infradead.org>
 <20160419173817.GF20844@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0439B0@ORSMSX109.amr.corp.intel.com>
 <5717EAC1.6020602@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nPQTKBVHLkCRhNQH4sbFNi1UfKDnXMaAt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5717EAC1.6020602-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Dennis <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nPQTKBVHLkCRhNQH4sbFNi1UfKDnXMaAt
Content-Type: multipart/mixed; boundary="2DAMRA40RASQs45xDs0e1mWpJiPeKMvWa"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Dennis <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <571F6795.8020808-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
References: <20160414153727.6387.96381.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
 <20160414164550.GC6247-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <20160418130909.GD11508-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
 <20160418174047.GB13865-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <20160418182411.GA4904-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
 <20160419173817.GF20844-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <1828884A29C6694DAF28B7E6B8A82373AB0439B0-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
 <5717EAC1.6020602-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <5717EAC1.6020602-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--2DAMRA40RASQs45xDs0e1mWpJiPeKMvWa
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 4/20/2016 4:46 PM, Doug Ledford wrote:
> On 04/19/2016 04:44 PM, Hefty, Sean wrote:
>>> Right - and the RDMA uAPI has always had an integrated driver-bypass
>>> channel as part of the verb uAPI calls, extending that to allow for
>>> new-driver-specific calls seems very natural.
>>
>> I remain unconvinced that having the equivalent of:
>>
>> 1 open unrelated-interface
>> 2 ioctl open-file
>> 3 close unrelated-interface
>>
>> is desirable.  If you want to push for a generic mechanism for mapping=
 NIC resources into user space, then separate that from the device implem=
entation.
>>
>> Doug, can you weigh in here with your thoughts?
>>
>=20
> Yeah.  I've been off working on issues related to 4.6-rc (interfaces
> that are DOA).  Give me a little bit to catch up on the thread and I'll=

> weigh in.
>=20

I've spent a decent amount of time thinking about this as well as the
general questions posed in the "Furhter thoughts on uAPI" thread.

In regards to the specific issues brought up here, and not really
dealing with the concept of a Verbs 2.0 API.

I've been seeing more and more instances where we need to implement
something, but over and over again, it's already been done (albeit not
necessarily to our needs) in the core net stack.  It's actually so
common that I'm starting to feel like I'm in the "Simpson's Did It"
South Park episode.

I toyed for a bit with the idea that we could alter the core RDMA stack
to simply always allocate a netdevice and in some way transition the
RDMA stack to being a more fully integrated member of the net stack.
This does have some advantages, but also lots of difficulties.

However, in retrospect, the iWARP, RoCE, and usNIC devices all already
have netdevices because they are all Ethernet devices that support some
form of RDMA.  The only devices left out are OPA and IB.

We already have precedent for requiring an IPoIB device, and it's
associate netdevice, in order to manage some non-IP, non-Ethernet, IB
specific items (the recent SRIOV patches being a perfect example).

I think we simply need to standardize on this.  As such, I think I want
to make this a hard and fast rule: For those devices that aren't
netdevices in their own right, management that can be done via their
IPoIB device(s), should be done that way.  The Ethernet devices already
have their own EEPROM writing code, so I see no reason why we can't add
an EEPROM read/write hook to IPoIB and then pass that on down to the
hfi1 device.

Unless people have objections to this as a way forward, Dennis, as much
as possible, when you attempt to address the comments in this thread,
please do so via the IPoIB devices and existing core net stack
infrastructure.


--2DAMRA40RASQs45xDs0e1mWpJiPeKMvWa--

--nPQTKBVHLkCRhNQH4sbFNi1UfKDnXMaAt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXH2ebAAoJELgmozMOVy/ddjQP/j3IbJJRcH3PoPVDd2t19Sqb
jzJ94dkreDcVFOD9oDOt8yU/Jpns0IJ4uYqaT+LTUXWMK1cJYAcVMCM4hQjHJGOK
fVKR2J+2t1GwuXnxmdyn5oBKkI+NARnrwxAFVjk1QjEflqR5C93X/FcvhHtIyuRz
vnUFh+cV0mvoAnPCZmuSLb/PuNkiUrqtvT34uSgJ3OUoiicwkrgQzb9c2tvHGUk0
GnfT6+hF+1u2CA+uNvWwIDIvJh3v2v0yhQjDZTJVUsy0q7vdbFXmC09ic3+82ZgU
GZB2/bivEwR03+xv2QAKuCmYrFa8nzna67c1ldZ8mrSBA7v1XUXWe2mmGTg/zY+g
5lZz7BbeyEgxUmygPLuf0cRVwRyrzh490VjpnanSUYM6SkiCki+OchM0ZffdQYMd
zwFQ1tjxySMaza3pyBuRTnuIFeNwpdoT6xkQJ0t0cvBkkvo930SwkoGv0+C9nnPk
SLBfxPk+WHmTnhuQJntWFy4XgtwOwwSWOeEkp1XeMPjyftxga9vxIj5Jsn7YLT8U
qZGyZTmLutQvF71XE8L1pSebziFrvyZ9IpmiYhNAI6Bqh0ZHcepqTucJrg2wwRNX
q+P0HMHscC0KoO0Wza4mJuJtR0byEBLPI1yDVgNpfgbeNm5GsbsL9gNbLfXGGSoF
dnbC7qcHHIDtt3TLOu9e
=rOP2
-----END PGP SIGNATURE-----

--nPQTKBVHLkCRhNQH4sbFNi1UfKDnXMaAt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
