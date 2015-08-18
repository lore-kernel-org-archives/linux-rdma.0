From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] Kconfig: add temporary PCI dependency
Date: Tue, 18 Aug 2015 10:00:39 -0700
Message-ID: <9D026CCE-9F4F-4F87-BA05-AAD6C2C6A417@redhat.com>
References: <20150818141542.4127.90517.stgit@phlsvslse11.ph.intel.com>
 <20150818161102.GA4040@kroah.com>
 <32E1700B9017364D9B60AED9960492BC25799762@fmsmsx120.amr.corp.intel.com>
 <20150818165026.GA25138@kroah.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/mixed; boundary="===============0025937457473470053=="
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20150818165026.GA25138@kroah.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Greg KH <greg@kroah.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "Marciniszyn,
 Mike" <mike.marciniszyn@intel.com>
List-Id: linux-rdma@vger.kernel.org


--===============0025937457473470053==
Content-Type: multipart/signed; boundary="Apple-Mail=_69EDDD37-3826-4555-8930-71023FB26F9D"; protocol="application/pgp-signature"; micalg=pgp-sha512


--Apple-Mail=_69EDDD37-3826-4555-8930-71023FB26F9D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Aug 18, 2015, at 9:50 AM, Greg KH <greg@kroah.com> wrote:
>=20
> On Tue, Aug 18, 2015 at 04:29:50PM +0000, Marciniszyn, Mike wrote:
>>> Subject: Re: [PATCH] Kconfig: add temporary PCI dependency
>>>=20
>>> On Tue, Aug 18, 2015 at 10:15:42AM -0400, Mike Marciniszyn wrote:
>>>> The move from infiniband to staging requires a temporary PCI
>>>> dependency to fix 0-day build issues.  The
>>>> drivers/infiniband/hw/Kconfig gratuitously added it for all =
drivers.
>>>>=20
>>>> Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
>>>> ---
>>>> drivers/staging/hfi1/Kconfig |    2 +-
>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>=20
>>> Why are these drivers not in drivers/staging/infiniband/ ?  Why do =
they all
>>> need their own drivers/staging/ directory?
>>>=20
>>=20
>> Greg, what is the path name convention for adding a driver to staging
>> when its eventual destination is part of a subsystem?  Perhaps it
>> should be drivers/staging/hw/hfi1?
>=20
> As I have no idea what this driver is, or what it is for,

It=E2=80=99s a driver for Intel=E2=80=99s newest RDMA capable fabric =
interface.  It=E2=80=99s not InfiniBand, but Intel=E2=80=99s answer to =
InfiniBand and will eventually live in the drivers/infiniband/hw tree =
with the other RDMA capable device drivers.

> or why it is
> in staging, I can't answer this=E2=80=A6

I put it in staging in my tree because it=E2=80=99s >50,000 lines of =
code, so repeated patch submissions to the mailing list were absolutely =
painful, but it has work that needs done as a result of review comments, =
and one item of work in particular (converting it to use an RDMA =
transfer engine library) will take a lot of work, so putting it in =
staging and requiring that to be complete before putting it in the =
regular tree is a decent carrot for getting that large bit of work done.

=E2=80=94
Doug Ledford <dledford@redhat.com>
	GPG Key ID: 0E572FDD






--Apple-Mail=_69EDDD37-3826-4555-8930-71023FB26F9D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJV02S3AAoJELgmozMOVy/d0b0QAKU46u8lqBeSqP7mfWUsqbZ3
UbTd0Z6m96x6zZ51vI2HQYblYf/N88MTgMRtdDb/+8tEEfqTYMNzQOCL/cNDyur5
4q5I039Hl67ZptV/pScuMLzO69S7a1jmkvg1V7kcZNUr4xsxqkhD2nYNnz1+1+dA
QUG/tww8HmQqY4WTCZH/6MPF6JUzTusK93gIJ3SXjRcOJlsNDjNC8N5IOdE/h21+
QKFWCyAMgWds7hK715YEWVT7jfUmqA/NYczBgRTQ4ecupnb1/hlHjCzJrdCBjcIb
dYnX31gp2dJTffR3iOwEMC6+8Bx8KCeFc5gBAl8Ffhf59cUwNfEY+a2z3gBhQT8h
8e5q7gdemebAO0dH8pQtbyukF79txMtTf+5aP3la+KPzsZyEmDncvpV8psLQyRJE
+D9WRFUFJsWZ+gXHoOdAUDlXOevJ0ok863Ei/3MDnxu0skDQQP3NYb/UiVZ4rQjc
Svu3uIk9qjZD0pO6jAips/cx6gxcbIzk0xlG0nqMZ9N4vvYIeyMAdvx83nw1w+pt
Y4zpQsiuMkUy1wtmYtCpJb+92/ADJXsbaoKyFIFhGD+tH65LrbZN0Ivf717fjYeX
24GyLVLpvKId/IErCkl/BBeFImE1zPeCIeKgUlEhFW+YBeWwCRDp0SbniFHqvmBY
JsBGdb5S+VynULJMuJEJ
=DRcr
-----END PGP SIGNATURE-----

--Apple-Mail=_69EDDD37-3826-4555-8930-71023FB26F9D--

--===============0025937457473470053==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
devel mailing list
devel@linuxdriverproject.org
http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

--===============0025937457473470053==--
