From: Doug Ledford <dledford@redhat.com>
Subject: Re: HFI1 code duplication todo
Date: Fri, 20 Nov 2015 10:41:16 -0500
Message-ID: <564F3F1C.4020508@redhat.com>
References: <20151112211317.GB11252@phlsvsds.ph.intel.com>
 <20151119222319.GA17605@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2179225829053809835=="
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20151119222319.GA17605@phlsvsds.ph.intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Dennis Dalessandro <dennis.dalessandro@intel.com>, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============2179225829053809835==
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oRsFW6x77x9xi9AKDVlNHb3LAQEKvdga7"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oRsFW6x77x9xi9AKDVlNHb3LAQEKvdga7
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/19/2015 05:23 PM, Dennis Dalessandro wrote:
> On Thu, Nov 12, 2015 at 04:13:18PM -0500, Dennis Dalessandro wrote:
>> The major todo for the hfi1 driver in staging is getting rid of the
>> verbs code duplication between ipath, qib, and now hfi1. The ipath
>> driver has been deprecated and is going to be deleted soon. So that
>> leaves qib and hfi. To address this we have proposed rdmavt which will=

>> be a common kmod that provides software RDMA verbs support. qib and
>> hfi1 will both use this as well as other forthcoming drivers such as
>> soft-roce. See this thread for some details:
>> http://www.spinics.net/lists/linux-rdma/msg29922.html.
>>
>> Since that initial RFC we have been accumulating patches in a GitHub
>> repo for an early look at the development. At some point soon we want
>> to actually start posting the patches to the mailing list. This is
>> where it gets tricky.  The code basically not only adds a new driver
>> but it modifies two existing ones, heavily. To make it more murky one
>> driver is in staging the other is in the usual drivers/infiniband tree=
=2E
>>
>> The question is, how do we go about this logistically due to the 2
>> drivers being in separate sub-trees?
>>
>> Greg, Doug,
>> As the maintainers of the two trees involved we'd kind of like to get
>> your thoughts on this.
>=20
> Hi Greg and Doug,
>=20
> Just wanted to ping you guys again in case my mail last week slipped
> through the cracks. We are at the point now where we have some patches
> we can start posting. Looking for some logistical guidance.

Sorry, I've been out for a while now with the birth of my second child.
 Things have settled down enough around here that I should be able to
get things going again (at least well enough to be more responsive to
email anyway).

So, as to the hfi1/qib/rxe transport library.  The qib driver is in the
rdma tree, and we aren't going to move it to staging just because it
depends on something in staging, so we need to start adding the library
in the core tree to avoid dependency issues.  As for the hfi1 driver,
I'm of the opinion that putting it in staging because of the code
duplication issue was probably not the right thing to do.  It's
benefited from the extra eyes on it to help make it a better driver, but
I think I'm ready to move it to the main RDMA tree and start working on
it from there where there won't be any cross tree dependency issues.

To that end, I've opened my 4.4-rc branch and deleted the three
deprecated drivers from staging and moved hfi1 to the rdma tree.  I've
sent an email to Linus to see if he's ok taking those changes, and if
so, I'll get them submitted and then open up my for-4.5 branch early to
be able to start taking for-next patches.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--oRsFW6x77x9xi9AKDVlNHb3LAQEKvdga7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWTz8cAAoJELgmozMOVy/d/jcQAJRJruGqv37LeDTrU/bG2u4j
B7m8JmUTcBNVEdkHJscoB3cWQTU1JzhpWdc1TcPzYSdC8M8z6lma5mFAIuqsUwII
vkwG07At2uCrO7dqA8zJbeRYsbEGqxbU5GhuBd1r+OQhiKMmLEBB3jdP9RYuOvwg
YtucfkJ4No8Qa4slh8JekcChySJVaA6NCbFXsGD9UWKCiQmLr8coWnmhXxajenWm
yiPD5gyvzaFubJQzVvhDL11/Zll6P4JzaKMd1kp1jQnqjhcTWnjjQhHURMf5IXWA
GCq1ezxXCtFs69sKKshgiDXirNEt29hwhApMlN2o0ddkemhNS61eIwFWrutOr4Xw
AmoLDoUx8nA3gnktkIj225/aVajx9+GRSF5CtbaR43RYBga8G5wxVHLGuD/gplz/
F0VP5RTlHRrlIp1gIjwJ3aoIQgCP3mGJ8T6lVP7Sb1vDXZJiYZtd+TGd9J+WhUTL
jmC2sYRJdInwaQCLQg0UCwBPUI7Y4K6bWfhuQPEHU/pniErMGbxnrsLNLpqTy0/q
xukzj980eiLcEfXBcwdaSdo6eXJ4nt9bI7rCMgtRUN7F+Z53sBoxLMmE3/1qUrsY
B/A3Ll28ebUE73VdR4rb6h7wsTDFuN74h+gLn+C4zYlT8c4k3nSknmBk2hhMRsQ+
20RpE6E8BADpQqXRwbfE
=0WAD
-----END PGP SIGNATURE-----

--oRsFW6x77x9xi9AKDVlNHb3LAQEKvdga7--

--===============2179225829053809835==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
devel mailing list
devel@linuxdriverproject.org
http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

--===============2179225829053809835==--
