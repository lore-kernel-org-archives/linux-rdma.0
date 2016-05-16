From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address resolution
 module into core
Date: Mon, 16 May 2016 14:39:10 -0400
Message-ID: <5045d314-e2f5-bda6-5583-2212335593fd@redhat.com>
References: <1462563928-29164-1-git-send-email-leon@kernel.org>
 <1462563928-29164-6-git-send-email-leon@kernel.org>
 <ea50f1d2-6f05-66f7-18f7-0a569fd9cea5@redhat.com>
 <VI1PR05MB1391AD099C536541E79A09F9D2760@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <db369e8e-7993-dfb8-d459-2c4f3d6e5b14@redhat.com>
 <20160516163048.GB4662@leon.nu>
 <298657b0-6e57-745b-5eb3-001984bffbc3@redhat.com>
 <20160516182743.GF7248@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ONx1hBUgbNoD440rEsTHk3uWiLMxtTCvb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160516182743.GF7248-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ONx1hBUgbNoD440rEsTHk3uWiLMxtTCvb
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/16/2016 02:27 PM, Jason Gunthorpe wrote:
> On Mon, May 16, 2016 at 01:42:34PM -0400, Doug Ledford wrote:
>> Can you build netlink in and then init the ib_addr module after the
>> netlink init is complete?  Wouldn't that resolve the dependency orderi=
ng
>> issue without changing the module names?
>=20
> Why are you so worried about ib_addr's module name? Is that actually
> hand loaded instead of relying in the implicit dependencies???

It's hand unloaded.  Depending on the release of software you are
talking about, the init script has the ability to unload/reload the IB
stack.  In that case, it has to know about ib_addr so that it can unload
after ib_core.  I should know, when the order changed from ib_core first
and ib_addr second to the opposite it broke the Red Hat init script for
a release, including all the bug reports about the rdma stack failing to
shut down properly because it was unloading modules in the wrong order.
This falls in the same category of a lot of other things: you don't
break user space if you don't have to.

> Is failure to load a module going to break any existing scripts?
>=20
> Worse comes to worse, just make dummy empty ib_addr.ko, but
> I've never seen that in-kernel before.
>=20
> Jason
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--ONx1hBUgbNoD440rEsTHk3uWiLMxtTCvb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXOhPPAAoJELgmozMOVy/dMAIP/RbJFRODFRo/XyhNqoWrNYFT
d/DfsLNWH4TkBdKywBhYS+7JlUUaI+0gI8VWiXVgo34b+4AYscnyBzMGXWnD7lIR
I68M5Hc2NsVj2wpncVmAe0+h4YcLPrreIhIQ2S3Xg2gN0acSjb6HiSdBJ6AlCH7s
g2lM56oLB10bxLSak7yLVGOmh6e2KC/T54LI9s7ccAMpfkANzFxxqKTP9aedEcL5
s3zHcl4kK3lYi9b7hi0VDWDcCmXrcs1I6yDhxhgQfAdM6CdpvcNfsE37dgN92o9I
AbvqOdhKWRbQK4nCxzzz/wPtXtrYEV1RkYibFDCTtE5O/+WwriAcD/DgKKDCqs0D
acsJZObABiwnjAwtjl0XoiYvwCX/RKqeclWF4AeXLV1vzzDWWXxqGqNvrr2Xrls6
hcU31txCxKEMR33SN2QgQY3UyW1d+cE4nqPVk6wkHooS7Fq8lLf76SIRXSTXhswo
MuMzirPLWpBqF9hMOyIqqjuxmxGDSIV2kdcicXLutqyEeIGg88KgOYoAHJqJtVrD
PmzztcJbXiT4YRteeZbjfCODQl4Zi6u41p80NNw057R7GHmBZaLzI7t5eol8PVWL
2+2eDREfoby+eRAuM44QS3f2jbinXq1NQ+SnR9gb4k3o4d7OOVffyp9E8NX5Axuu
QJZYbt04QT6sTwZAGfcN
=ZTjt
-----END PGP SIGNATURE-----

--ONx1hBUgbNoD440rEsTHk3uWiLMxtTCvb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
