From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Kconfig: add temporary PCI dependency
Date: Tue, 18 Aug 2015 18:24:40 -0700
Message-ID: <08B07723-39A2-416E-92F9-E939B21EBBCA@redhat.com>
References: <20150818141542.4127.90517.stgit@phlsvslse11.ph.intel.com> <20150818161102.GA4040@kroah.com> <32E1700B9017364D9B60AED9960492BC25799762@fmsmsx120.amr.corp.intel.com> <20150818165026.GA25138@kroah.com> <9D026CCE-9F4F-4F87-BA05-AAD6C2C6A417@redhat.com> <20150818231150.GB32269@kroah.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_493D5BF9-6725-46A0-A54A-5DDB2B2BAAD8"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150818231150.GB32269-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_493D5BF9-6725-46A0-A54A-5DDB2B2BAAD8
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Aug 18, 2015, at 4:11 PM, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
>=20
> On Tue, Aug 18, 2015 at 10:00:39AM -0700, Doug Ledford wrote:
>>=20
>>> On Aug 18, 2015, at 9:50 AM, Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org> wrote:
>>>=20
>>> On Tue, Aug 18, 2015 at 04:29:50PM +0000, Marciniszyn, Mike wrote:
>>>>> Subject: Re: [PATCH] Kconfig: add temporary PCI dependency
>>>>>=20
>>>>> On Tue, Aug 18, 2015 at 10:15:42AM -0400, Mike Marciniszyn wrote:
>>>>>> The move from infiniband to staging requires a temporary PCI
>>>>>> dependency to fix 0-day build issues.  The
>>>>>> drivers/infiniband/hw/Kconfig gratuitously added it for all =
drivers.
>>>>>>=20
>>>>>> Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>>>> ---
>>>>>> drivers/staging/hfi1/Kconfig |    2 +-
>>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>=20
>>>>> Why are these drivers not in drivers/staging/infiniband/ ?  Why do =
they all
>>>>> need their own drivers/staging/ directory?
>>>>>=20
>>>>=20
>>>> Greg, what is the path name convention for adding a driver to =
staging
>>>> when its eventual destination is part of a subsystem?  Perhaps it
>>>> should be drivers/staging/hw/hfi1?
>>>=20
>>> As I have no idea what this driver is, or what it is for,
>>=20
>> It=E2=80=99s a driver for Intel=E2=80=99s newest RDMA capable fabric =
interface.  It=E2=80=99s
>> not InfiniBand, but Intel=E2=80=99s answer to InfiniBand and will =
eventually
>> live in the drivers/infiniband/hw tree with the other RDMA capable
>> device drivers.
>>=20
>>> or why it is
>>> in staging, I can't answer this=E2=80=A6
>>=20
>> I put it in staging in my tree because it=E2=80=99s >50,000 lines of =
code, so
>> repeated patch submissions to the mailing list were absolutely
>> painful, but it has work that needs done as a result of review
>> comments, and one item of work in particular (converting it to use an
>> RDMA transfer engine library) will take a lot of work, so putting it
>> in staging and requiring that to be complete before putting it in the
>> regular tree is a decent carrot for getting that large bit of work
>> done.
>=20
> Does it have a TODO file that lists what needs to be done with it?

Yes.

>  Are
> you going to be responsible for all of the patches sent to it and you
> just want me to ignore them, or will you send patches to me for me to
> apply?

I expect the patch load to be significant due to the required TODO item =
of making it use a transfer engine library.  I wouldn=E2=80=99t want to =
sign you up for that load.  If you are OK with me processing the =
patches, then I=E2=80=99m happy to do so.  If you would prefer the other =
way around, then I=E2=80=99ll defer to your wishes.

=E2=80=94
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_493D5BF9-6725-46A0-A54A-5DDB2B2BAAD8
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJV09rZAAoJELgmozMOVy/dl98P/1D5qxTFb9+yifgsgmoKtoQo
k0Zv2vQbtTkc86pXrlficIjeVq5gmr+46db3eswcphh4kg0IKkAmCdYFS+yYWmTT
j3qN/Leyt9ieMoWtPqRJNYmxffnlhApIABUJcDx7PfBnS9DECPloHFIjNofxqRNV
4LgX5flynittFpcPmJ6gSLsgZJuvbdS2UW0OgWkuYF2an0bvcOoaewX1hW7ndxdR
Z6o735MQakMTbuYXhpT+ByzIVs720TLnwg0WpU2S5oaa/GwcwHw+3fn/71TFoXdq
YcyIl1pDg8Crm1HauxRERVi+99YP3iA7KFTjPpvnQZOuTzI+flSeJSl4XMtUpIUj
ruaxA3iNUcHQiEMKGjxbYrNCvC/nuJIzyVf/Nsx8pTPsJH7TBjM4eUXNxFg5oIB1
ZHsr3pVQJ4GnrF+/VpOioxjlULk3Dp7usOlHIA1nSikMUgVB+3BXidPSZ1fZ0+ry
kSo0k6aTzir8mQHBKBAMkCoz0R9+iNBeqZ0kJ3vWdoZJajk4uvi2f0N+KyGO/278
7Y0UwyrwKqiHwrLi0xSWQLSvK2hNhMH0GSFg2M2Lgb5ZqS/csyEzUPmDt1S3DySa
zW6PRgiqWBr0Cj4gWh+jQy5kTGAyASf/2YvyKMYRKg8lHt1Ydfw5beDzLQtX67V2
6M5T0NZKlo8eamSYPIFw
=kz6v
-----END PGP SIGNATURE-----

--Apple-Mail=_493D5BF9-6725-46A0-A54A-5DDB2B2BAAD8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
