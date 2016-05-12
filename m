From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/5] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Thu, 12 May 2016 16:31:45 -0400
Message-ID: <aca92e27-6be5-1edd-f9de-12fe9abb924f@redhat.com>
References: <20160512171115.6198.77458.stgit@scvm10.sc.intel.com>
 <20160512173445.GA13553@obsidianresearch.com>
 <20160512190738.GA15146@phlsvsds.ph.intel.com>
 <20160512192508.GA17319@obsidianresearch.com>
 <20160512195304.GA10419@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="goe5rCBkMDcEhEdoM43B3L3asO2tm4PIc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160512195304.GA10419-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--goe5rCBkMDcEhEdoM43B3L3asO2tm4PIc
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/12/2016 03:53 PM, Dennis Dalessandro wrote:
> On Thu, May 12, 2016 at 01:25:08PM -0600, Jason Gunthorpe wrote:
>> On Thu, May 12, 2016 at 03:07:38PM -0400, Dennis Dalessandro wrote:
>>> >>There is also a driver software version being exported via a sysfs
>>> >>file. This is needed so that user space applications (psm) can
>>> >>determine if it needs to do ioctl() or write().
>>> >
>>> >Why? Don't do this, just call ioctl() and if it fails then use write=
().
>>>
>>> Is it really that big of a deal to export a version number?
>>
>> If it isn't needed, don't add it..
>=20
> For the reason I gave, I think it is needed so unless you are vehementl=
y
> opposed to it I would prefer to leave it.

I think Jason has a point here.  In particular, if you create an ioctl
to return a driver version, it is probably safe that all future hfi1/psm
user space code can try the ioctl, in the absence of the ioctl working
assume version 0, and in the current and all future versions of the
driver, get a valid return, including potential updates to the version
number, so it's completely possible to use this as an ongoing test of
more than just "is this pre-release code or release code".


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--goe5rCBkMDcEhEdoM43B3L3asO2tm4PIc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNOgxAAoJELgmozMOVy/d+44QAJmIJgbRx1uid3FX7KNIRGtH
1Bckis6ProS1icKJpUgRdufex2U8Zn6cNIMUqX8/6bENVqH4tcS5I6m/4uxGBd9i
Lzy4/yRpkt7CpFTNrx0gcl1eWtLvLZOHoBVmfp9mgDoxuRQK5WtGAbEAG1qpgtTk
vE9jZr0jgIXelCtFf1XriMPrm9CH0NhcG/bQlISbR6oXHgwiQ+tciSwYDPjD/EOV
Onen4lw2OaHt2bS6jb6YokmoRBlrJ27DOhjE57zcTuNO2eNb1R9/Aa4KhAAIySf3
pPNkrWwKNKI0nNsop2psmfatYYVmcy3KP3ARQcqQQwzyMO7MonPzEwxCbFsFgyDy
dqsRRaUGZBOS/SL8UmiTi9Tx23F+gUY10H/uwBLUWDvoQrjJOpiOqiCmEcOXAOw6
Qite0PL3HOOd5iOs5nKCGc1d37PeedIoJYb0Qj840u6FgILfGj5uf1YAlFJ7v3Nk
dixGiYq0keVojGFI4zlZalppIhtUOBw+cPB44IKTeKXKgfm7XstOgfc/krN64u0I
MEQarmJgFSqZ8EMQ3XmScS9IYpfXklc15wznSjfLfJJ1jAbQUnsm+COTbUPUgY6d
Mle6YsESM1BftJNXfp5zHXqE4+yeMGNv4R/BwuoXGA/wLXZ6/7bcbBQhBls5rfY6
5bapjQJVcQqyhqwEkcYI
=IYuY
-----END PGP SIGNATURE-----

--goe5rCBkMDcEhEdoM43B3L3asO2tm4PIc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
