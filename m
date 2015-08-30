From: Doug Ledford <dledford@redhat.com>
Subject: Re: [patch] IB/core: missing curly braces in ib_find_gid()
Date: Sun, 30 Aug 2015 18:24:20 -0400
Message-ID: <55E38294.7040404@redhat.com>
References: <20150818092210.GE3965@mwanda>
 <20150829011040.GA2713@phlsvsds.ph.intel.com> <55E12EEB.9070207@redhat.com>
 <CAJ3xEMgSQHvATJjydeLQbvOXSuS1LNwvf7hs-tvmP77_EJ12BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="J2tUfkxEbdRqawpk728p4NJl9NucAEB7w"
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <CAJ3xEMgSQHvATJjydeLQbvOXSuS1LNwvf7hs-tvmP77_EJ12BQ@mail.gmail.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: "ira.weiny" <ira.weiny@intel.com>, Dan Carpenter <dan.carpenter@oracle.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Michael Wang <yun.wang@profitbricks.com>, Yotam Kenneth <yotamke@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--J2tUfkxEbdRqawpk728p4NJl9NucAEB7w
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/30/2015 12:59 AM, Or Gerlitz wrote:
> On Fri, Aug 28, 2015 at 9:02 PM, Doug Ledford <dledford@redhat.com> wro=
te:
>> On 08/28/2015 09:10 PM, ira.weiny wrote:
>>> On Tue, Aug 18, 2015 at 12:22:10PM +0300, Dan Carpenter wrote:
>>>> Smatch says that, based on the indenting, we should probably add cur=
ly
>>>> braces here.
>>>>
>>>> Fixes: 230145ff8124 ('IB/core: Add RoCE GID table management')
>>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>>>
>>>
>>> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>>
>> I've picked this patch up (earlier today), so I missed your reviewed-b=
y:
>> tag.  Added.
>=20
> wait, Doug, when the offending patch goes upstream, their commit ID
> will not be the one
> denoted here, right?

Fair point...

> I would suggest that you either hold off with
> this fix till the other patch
> goes upstream in 4,3-rc1 and you have a proper ID

I have a proper ID now.  Since I've put together my final k.o/for-4.3
branch, the ID is fixed.

> or squash it there
> now.

This patch is from someone different than the patch it fixes, so it
wouldn't be right to squash it into their patch.  I fixed up the Fixes:
line instead.

> BTW - the way
> net-next is organized/managed, pre-linus-tree commit ID remain the
> same also after they land there,
> so in that respect and other linux-rdma maintenance related aspects we
> discussed during LPC  - it
> would be good if you can talk to Dave and see how he gets things going
> for net-next

I'm going to be doing things differently for 4.4.  We'll see if that
resolves the issues you are unhappy about.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--J2tUfkxEbdRqawpk728p4NJl9NucAEB7w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV44KUAAoJELgmozMOVy/dCYIP/2UJVKeCM9Vc9v3bXLR6sG8h
NjMoVKc73YKck67kG8BI90LqLDNFskCI5z265VUPnV9YbVcIY8XEKizgCVm0tb6g
qQpystITB//gn+1Cv0+HQpwET+c6xvYzAFa2drWuodvxiSSRp/69UMPrD7yGLxMM
wOl997vWS6TqJ6P7k0Szaz9edofsAVbZNZkWR/OKrTTgVGwSywzvliY/2uDqh1qf
DBpeS8TjQg/5tIDJScyq2DqQynhlj0EluiQDvFZE3r2fo8F4FBnDNp6Jc2KSRNSO
ERf9ssglRQGOcDP2v5mslYP1ncgR5DjAmApCQbvVpmE9L5zEPuaHklvIStPym+bg
IS63BAmgjpUvmj4zAFCSthO6mV81G406sRsUlm1lZi76WXrpPQj3xNHi8toWYZzD
aFn4vgUTQDmsZwZkWCgF4TixWaZ+3aFkf5bdycmr+niiAi9wjN+45IbH2fgobiwb
4HR1gDPaelyXVNUdjrfBxkXhYNaxS/YWHX0KkNPecQ9GIakMAOWiq2v98MniIpSl
iNz5tpTDpsDI4TiK3xaA6iSMv9D44j7mQcvbVfXK/grfW+r4QJER6TseNf25yBz0
SZS1VcnroCAHhiy2UfP36HZiU0tFhr2/w9OR1pDz6AYojEBn/E/t/FltTf4fpmxi
0ADe+dYjg7OziTjfjpej
=utxA
-----END PGP SIGNATURE-----

--J2tUfkxEbdRqawpk728p4NJl9NucAEB7w--
