From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] configfs: switch ->default groups to a linked list
Date: Thu, 10 Mar 2016 21:19:01 -0500
Message-ID: <56E22B15.1030000@redhat.com>
References: <1456490031-7132-1-git-send-email-hch@lst.de>
 <1456615342.1750.49.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="NcLUCljE9OlfsXJ2GkuGMxj8DgUIsgvrP"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456615342.1750.49.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>
Cc: jlbec@evilplan.org, balbi@kernel.org, laurent.pinchart@ideasonboard.com, target-devel@vger.kernel.org, linux-usb@vger.kernel.org, linux-rdma@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--NcLUCljE9OlfsXJ2GkuGMxj8DgUIsgvrP
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 02/27/2016 06:22 PM, Nicholas A. Bellinger wrote:
> On Fri, 2016-02-26 at 13:33 +0100, Christoph Hellwig wrote:
>> Replace the current NULL-terminated array of default groups with a lin=
ked
>> list.  This gets rid of lots of nasty code to size and/or dynamically
>> allocate the array.
>>
>> While we're at it also provide a conveniant helper to remove the defau=
lt
>> groups.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>  Documentation/filesystems/configfs/configfs.txt |  11 +-
>>  drivers/infiniband/core/cma_configfs.c          |  31 ++--
>>  drivers/target/iscsi/iscsi_target_configfs.c    |  75 +++------
>>  drivers/target/target_core_configfs.c           | 203 +++++----------=
---------
>>  drivers/target/target_core_fabric_configfs.c    | 194 ++++++---------=
-------
>>  drivers/target/target_core_internal.h           |   1 -
>>  drivers/target/target_core_stat.c               |  41 ++---
>>  drivers/usb/gadget/configfs.c                   |  36 ++---
>>  drivers/usb/gadget/function/f_mass_storage.c    |   6 +-
>>  drivers/usb/gadget/function/f_rndis.c           |   1 -
>>  drivers/usb/gadget/function/uvc_configfs.c      | 198 +++++++++------=
--------
>>  fs/configfs/dir.c                               |  44 +++--
>>  fs/configfs/item.c                              |   1 +
>>  fs/dlm/config.c                                 |  38 +----
>>  fs/ocfs2/cluster/nodemanager.c                  |  22 +--
>>  include/linux/configfs.h                        |  11 +-
>>  include/target/target_core_base.h               |   3 -
>>  17 files changed, 284 insertions(+), 632 deletions(-)
>>
>=20
> This is a very nice simplification to drop the long-standing fixed size=

> ->default_groups[] usage tree-wide for configfs consumers.
>=20
> For the target parts:
>=20
> Acked-by: Nicholas Bellinger <nab@linux-iscsi.org>

For the (minor) RDMA parts:

Acked-by: Doug Ledford <dledford@redhat.com>

> Also, this applies cleanly to target-pending/for-next, so I don't see a=

> problem merging it up via your new configfs tree.
>=20
> Otherwise let me know, and I'll be happy to merge via target-pending.

Given that it touches target more than anything else, I'm happy to see
it merged through your tree.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD



--NcLUCljE9OlfsXJ2GkuGMxj8DgUIsgvrP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW4isVAAoJELgmozMOVy/dNvEQAL2nom6JnSKozR17nKefmX51
JTLY2Jg/GtCfAvVyBnxIe9+CRpTKORpOzVA47EtBcy0JVXjw6mC4FWnrKkr1RTu0
HZF2Eu4vi7+D3miUFVH6gppJBTNK+r83bWnK3+pwEo4K5Y8l/NON2priK9g59qpY
B+fD0hJJ2gDFBA9eRc6EONJpETfQhOWHI5ttZ+tJsVxbYdmUxTtt26klDg87qLjC
aAhk2rA3xR+ZlM5WZx5XC8wNKmMrXTu3Zt5ZtjozOxgeNd6Lc7ajCdsMwUBAuQbh
bvug74PIwrIrbT8zuzUQSt5uMuwaDjN8ev4MqxZwH0g5JII9IBm4RU15hwjv4SuQ
3WEMrtWXUjLxonc7UtqtQN8rBASVKHFj0zRDMAVOopsASo1GoOZrkf8TMSepg28n
zhzHT1g8LLzZp7j4E4Lv9BTQWLySrz99/z+F5o/fDNKCoitaQtGvcvYvJQl2RKLr
d5hjceopt5ib4yDpellgfjwlehxodcNbheNv3Lx28g984hXVc7Ib5JAF9F7SWfYz
avzN3xj5vwhnbjynwRNwbW0kc12bFRy80wKkaT95qgwh8V3F9mdplYZFMKJDyrJn
BhvvdxQjmOuSeUs9AscYL2bLj7Ddh36l26Ln9MUnEwQTYNpbQejbjCc5Hv+5bNab
D02yofXJ4FDiJ+yOOp6X
=ZH5w
-----END PGP SIGNATURE-----

--NcLUCljE9OlfsXJ2GkuGMxj8DgUIsgvrP--
