From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Wed, 27 Apr 2016 10:45:07 -0400
Message-ID: <5720D073.2070802@redhat.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160418130909.GD11508@infradead.org>
 <20160418174047.GB13865@obsidianresearch.com>
 <20160418182411.GA4904@infradead.org>
 <20160419173817.GF20844@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0439B0@ORSMSX109.amr.corp.intel.com>
 <5717EAC1.6020602@redhat.com> <571F6795.8020808@redhat.com>
 <2807E5FD2F6FDA4886F6618EAC48510E22EC6A98@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="S6V4dT9J9TRRGma0w8WFaiUdMbSBuCPT7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E22EC6A98-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--S6V4dT9J9TRRGma0w8WFaiUdMbSBuCPT7
Content-Type: multipart/mixed; boundary="ui5BB9K4lts2K2RpJhil3Ab08G7AOOphq"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <5720D073.2070802-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
References: <20160414153727.6387.96381.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
 <20160414164550.GC6247-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <20160418130909.GD11508-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
 <20160418174047.GB13865-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <20160418182411.GA4904-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
 <20160419173817.GF20844-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
 <1828884A29C6694DAF28B7E6B8A82373AB0439B0-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
 <5717EAC1.6020602-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> <571F6795.8020808-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <2807E5FD2F6FDA4886F6618EAC48510E22EC6A98-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E22EC6A98-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>

--ui5BB9K4lts2K2RpJhil3Ab08G7AOOphq
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 4/27/2016 1:21 AM, Weiny, Ira wrote:
>>=20
>> On 4/20/2016 4:46 PM, Doug Ledford wrote:

>> We already have precedent for requiring an IPoIB device, and it's
>> associate netdevice, in order to manage some non-IP, non-Ethernet,
>> IB specific items (the recent SRIOV patches being a perfect
>> example).
>=20
> I'm not sure this is always going to be the case.  I have heard a
> number of reports of IPoIBs inability to scale and a desire to not
> run it.

Then don't.  If you set the configuration file for the IPoIB device to
not start on bootup, the module will get loaded, the device will get
allocated, and then it will not transmit on the wire or join any
multicast groups.  It will then be a perfectly fine vessel for accessing
configuration, eeproms, etc. and it won't impact the fabric in any way.

If, at a later point in time, you wish to actually use it, then we can
look at making it better for scale.

> Isn't there a way we can create a netdevice that does not have the
> associated overhead of IPoIB?

Yes, load IPoIB with the device turned off.  Zero overhead.  At the
point at which you have a new IP emulation device that can be hooked
into the netstack, you can use it as the ndo entry point device instead.
 It makes no difference in the long run, the user space tools are the
same and the training for admins is the same, only the layer used to
create the user visible net device changes.

I snipped the rest of your email, it all centers around the incorrect
assumption that IPoIB devices must be up and running in order for the
configuration entry points to be used by user space tools.


--ui5BB9K4lts2K2RpJhil3Ab08G7AOOphq--

--S6V4dT9J9TRRGma0w8WFaiUdMbSBuCPT7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXINB5AAoJELgmozMOVy/dCuUP+weYhHKWVB/jezDbOrwxfoc0
VJY85SAuhrulqhAVzHkQN8b+OeWwsUVSbh0RuZIc617ZZz4qMgsHvevgqYZiGDLf
hIIGwt46/nyG/pSU9pvknzk3RnbUzbuW+Anw4+47EByWYL+Uq1p0bikpbyfU8syc
98jqwU7BVBbb+UG6Tg8bkW3kCxHDtnLi5q/04nBk6sr4/wHG5kdBQbL16ixX4eiu
AnvikhNFRYGWm22/eYuSZiCBOJoRClPeHdwgZ9rGjOMlK1cxsst5GTxGOVHoYJqx
m9vfb9l6p4BfyyD6aVS1DUKzw/uOK8v3hEBpwoUsRQhcKanYZX7Y9Oux16ixayVz
rD/aBCX2vSVnIDio6GnwrAwZORoU2+ihVy8xitL+o7SjExbYLQHJfagD3IsgfTZY
gE9k9RBmXgv/BlJCajQLdGe+4xwnS8iQzc0NrKgwQdwrg9ZhKW7kB/Bd6buEkVjr
uiswtH7vacd6dDW+y8FJrRb+p0V11veWlo5kb8VXCgFoiVVGrJ9UYOqV+TPs+qCB
Pp+54pikOI/9tlfZKbKUs3bOA/gptp2LBj1VvdOIeBqusa8EpHnRD9C1+pe4SJL1
wMv9QVk3ixG5iGkyaEySrkQwKfvHESQQJiWQpYx+u2OXFx0htG8sNGRREdg5lPYG
JieVla8KLmujQYv0L2hr
=02f6
-----END PGP SIGNATURE-----

--S6V4dT9J9TRRGma0w8WFaiUdMbSBuCPT7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
