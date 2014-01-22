From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v1] libibverbs: Add support for usNIC nodes and
 transports
Date: Wed, 22 Jan 2014 19:46:46 +0000
Message-ID: <4791BCBA-FF5C-4F4D-90D1-C5B7981B02E4@cisco.com>
References: <1390360721-14894-1-git-send-email-umalhi@cisco.com>
 <1828884A29C6694DAF28B7E6B8A8237388D1516D@ORSMSX109.amr.corp.intel.com>
 <97D33F82-21BA-4885-A909-7DCDBFCACD36@cisco.com>
 <1828884A29C6694DAF28B7E6B8A8237388D15319@ORSMSX109.amr.corp.intel.com>
 <D0DEB791-D0BE-489F-AA66-7055099108B0@cisco.com>
 <1828884A29C6694DAF28B7E6B8A8237388D155AC@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388D155AC-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Content-ID: <04C96C12098A574EA43FB60F15598420-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jan 22, 2014, at 10:47 AM, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrot=
e:

>> 	AFAIK can see from the code, the CA node type corresponds to the
>> "IBV_TRANSPORT_IB."  The packet format might change slightly dependi=
ng on
>> QP type, but the *base* transport remains IB.
>=20
> You're right from an API perspective.  The actual transport layer is =
reported by verbs using multiple fields: transport + QP type.

I don't know what you mean.  The transport is independent of the QP typ=
e.
static int print_hca_cap(struct ibv_device *ib_dev, uint8_t ib_port)
=2E..
	printf("\ttransport:\t\t\t%s (%d)\n",
	       transport_str(ib_dev->transport_type), ib_dev->transport_type);
=85
Am I looking in the right place?

>=20

>> usNIC supports two distinct transports; custom roce and UDP.  Unless=
 I am
>> missing something, the only way to represent these in the verbs code=
 is by
>> having two separate nodes.
>=20
> Verbs seems broken.  The node hasn't changed, and I don't see why som=
e version of usNIC couldn't run both transport protocols at once.  Mayb=
e a better way of mapping usNIC to verbs is to map custom RoCE (sounds =
like code for non-compliant) and UDP to a QP type?
Yes, this is a verbs limitation.  Sounds like also something to address=
 in your post-verbs proposal :)
Custom RoCE is indeed Cisco specific. =20
The QP type is independent of the transport and even if it wasn't, this=
 change complicates the design.  Having unreliable QP type per transpor=
t?  Apps would have to be rewritten for the new QP types.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
