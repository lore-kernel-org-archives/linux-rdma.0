From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] staging: ipath: fix build failure
Date: Tue, 1 Sep 2015 12:59:47 -0400
Message-ID: <55E5D983.6050209@redhat.com>
References: <1441112498-22057-1-git-send-email-sudipm.mukherjee@gmail.com>
 <55E5BBC7.1020007@redhat.com>
 <CA+r1ZhjwFP4Odiy_dUnFWNtjuW0KEZeGY1ynx9kf-WScPbYvQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="j8JT9RIVwuIT03cf3XGr3w2K2kx0mircX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+r1ZhjwFP4Odiy_dUnFWNtjuW0KEZeGY1ynx9kf-WScPbYvQA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Davis <jim.epost-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, devel <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--j8JT9RIVwuIT03cf3XGr3w2K2kx0mircX
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 09/01/2015 12:54 PM, Jim Davis wrote:
> On Tue, Sep 1, 2015 at 7:52 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
>> On 09/01/2015 09:01 AM, Sudip Mukherjee wrote:
>>> building of ipath depends on infiniband. And if ipath is selected and=

>>> infiniband is not then build fails with:
>>> ERROR: "ib_alloc_device" [drivers/staging/ipath/ib_ipath.ko] undefine=
d!
>>> ERROR: "ib_dealloc_device" [drivers/staging/ipath/ib_ipath.ko] undefi=
ned!
>>> ERROR: "ib_dispatch_event" [drivers/staging/ipath/ib_ipath.ko] undefi=
ned!
>>> ERROR: "ib_register_device" [drivers/staging/ipath/ib_ipath.ko] undef=
ined!
>>> ERROR: "ib_unregister_device" [drivers/staging/ipath/ib_ipath.ko] und=
efined!
>>> ERROR: "ib_modify_qp_is_ok" [drivers/staging/ipath/ib_ipath.ko] undef=
ined!
>>> ERROR: "ib_wq" [drivers/staging/ipath/ib_ipath.ko] undefined!
>>>
>>> Config at: https://lkml.org/lkml/2015/8/31/328
>>>
>>> Reported-by: Jim Davis <jim.epost-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> Signed-off-by: Sudip Mukherjee <sudip-ofJRbWXBVFamYgehrs7/Lw@public.gmane.org>
>>> ---
>>>  drivers/staging/ipath/Kconfig | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/staging/ipath/Kconfig b/drivers/staging/ipath/Kc=
onfig
>>> index 041ce06..1edc21b 100644
>>> --- a/drivers/staging/ipath/Kconfig
>>> +++ b/drivers/staging/ipath/Kconfig
>>> @@ -1,6 +1,7 @@
>>>  config INFINIBAND_IPATH
>>>       tristate "QLogic HTX HCA support"
>>>       depends on 64BIT && NET && HT_IRQ
>>> +     depends on INFINIBAND
>>>       ---help---
>>>       This is a driver for the deprecated QLogic Hyper-Transport
>>>       IB host channel adapter (model QHT7140),
>>>
>>
>> The ipath driver was moved to staging/rdma/ipath and has proper
>> protection against being built without the InfiniBand subsystem.  Wher=
e
>> are you seeing this tree?  I'm curious because I no longer have this
>> driver in this location in my tree and I never pushed it anywhere othe=
r
>> than one of my trees.  Is this maybe in linux-next?
>=20
> Yes; http://marc.info/?l=3Dlinux-kernel&m=3D144104080331664&w=3D3
>=20

OK.  The current setup has this in drivers/staging/rdma/Kconfig:

menuconfig STAGING_RDMA
        bool "RDMA staging drivers"
	depends on INFINIBAND
	depends on PCI || BROKEN
	depends on HAS_IOMEM
	depends on NET
	depends on INET
        default n
        ---help---
          This option allows you to select a number of RDMA drivers that
	  fall into one of two categories: deprecated drivers being held
	  here before finally being removed or new drivers that still need
	  some work before being moved to the normal RDMA driver area.

          If you wish to work on these drivers, to help improve them, or
          to report problems you have with them, please use the
	  linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org mailing list.

          If in doubt, say N here.


# Please keep entries in alphabetic order
if STAGING_RDMA

source "drivers/staging/rdma/amso1100/Kconfig"

source "drivers/staging/rdma/hfi1/Kconfig"

source "drivers/staging/rdma/ipath/Kconfig"

endif


As you can see, it has proper depends for all of the drivers, so no need
to add dependencies piecemeal any longer.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--j8JT9RIVwuIT03cf3XGr3w2K2kx0mircX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV5dmDAAoJELgmozMOVy/dE7IP/2jd7XmrgvOkXv9EmS+KoeZK
U806TZKXyuhXiMe8XnUR5WKRIKBtcDuAFogB4uaVazst2YMF4Pt5/kUmuzsZ9tm8
nR5Rd7fw+fHRxm0p7ArU1gRndweRE1WbiGPQn6DCQbr/O8oUj6ZiuVQ2UNKzxV2v
lDOy4WWroQZXcCc2UEqVGhEUjI39giAFy/OfvtnTOnmUDXPTfoAt7XotoRYjVRvR
rFBMW7C5UgjqVWOzNt0RMEvH3AdXZnxRjp0hit7ZJRfhvXxgBgVNF9WOrhuHH1DH
3AK92gmUM0ytS+HCLUNSSo+19X5+O9vZCbwsWZ9I6ClZF5Qjb4BGY1lGk9x0iXjv
rQU3VEHlKTrwd52RmNeBgBOL1ndaLIIGbuJvtJwOGKhtRc5+Ft5lukVqCZ2EQ3j2
V4aHzB653qKNNddBnIWDPDhyGsq3EN8MqgzGasehddIuNr8tS+Cxvw5FqyYhrtrR
5K+mJSwXoCGyRyT/Eh0MaAmjVk34w99G3c2WCdJoLNC7GT01ZKfm4FxEKbxEAwDk
qRVAGVWPNnOdFb8rRcrNXvBrN9lvZSK4ReOcIEUTtnNj6ZjgjarJN9ViAdmRWTCD
ROpHnN7V8ElCqQln5S7/pZ4kKB3t2AxVuYd0Inq18+TMKAJn6Hc4lVG/4sYuNeL+
Uf4eSVZqdSTd5Cr0QDId
=kGZe
-----END PGP SIGNATURE-----

--j8JT9RIVwuIT03cf3XGr3w2K2kx0mircX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
