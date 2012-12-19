From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: linux-next: build failure after merge of the infiniband tree
Date: Thu, 20 Dec 2012 09:44:33 +1100
Message-ID: <20121220094433.791d70e55ae5e3325a6190fc@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Dec_2012_09_44_33_+1100_jAai.vE.r+k=uDMJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--Signature=_Thu__20_Dec_2012_09_44_33_+1100_jAai.vE.r+k=uDMJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the infiniband tree, today's linux-next build (x86_64_
allmodconfig) failed like this:

In file included from drivers/scsi/csiostor/csio_wr.h:42:0,
                 from drivers/scsi/csiostor/csio_scsi.h:49,
                 from drivers/scsi/csiostor/csio_init.h:45,
                 from drivers/scsi/csiostor/csio_attr.c:45:
drivers/scsi/csiostor/t4fw_api_stor.h:43:6: error: nested redefinition of '=
enum fw_retval'
drivers/scsi/csiostor/t4fw_api_stor.h:43:6: error: redeclaration of 'enum f=
w_retval'
drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:42:6: note: originally define=
d here
drivers/scsi/csiostor/t4fw_api_stor.h:48:2: error: redeclaration of enumera=
tor 'FW_ENOEXEC'
drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:39:2: note: previous definiti=
on of 'FW_ENOEXEC' was here
drivers/scsi/csiostor/t4fw_api_stor.h:50:2: error: redeclaration of enumera=
tor 'FW_ENOMEM'
drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:43:2: note: previous definiti=
on of 'FW_ENOMEM' was here
drivers/scsi/csiostor/t4fw_api_stor.h:58:2: error: redeclaration of enumera=
tor 'FW_EADDRINUSE'
drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h:44:2: note: previous definiti=
on of 'FW_EADDRINUSE' was here

And several others similar.

Caused by commit f65b56b15931 ("RDMA/cxgb4: Fix LE hash collision bug for
active open connection").

I have used the infiniband tree from next-20121219 for today.

--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__20_Dec_2012_09_44_33_+1100_jAai.vE.r+k=uDMJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ0kNRAAoJEECxmPOUX5FENykP/1++jzbV7QPHvOZYPiZizK04
Ia1hYVzvWGRTePop2IYgAKHxXz7rBFqPj4ybemJGP9x61cVoG9yu4jm+LeyPqdyr
X7dC5BNTv1f/uFo651CIKH/cNXhb8QwGyLZCVI/YWcUm5RKq5+1/6vZOuRb/xj6z
PjdrBYCsIA8H/jVeCn87f7LRMB9s0DymHM4G1MVgFURR85hE8ycBOw8O9BeyByue
QUeFQxFdGMOPDTYtU86tBs8STYoHw3A8P3ENHPBoL9Xt/+v6x/EmQ+0HsMnz0hgw
KlPhjaaqOxRnU1cYMp3R75FaPs+wQgtE4mWiEewPJ0CdVdzRp6izJ5kKUe9Ex2tK
FsK384RTQcM29C6exqknDW01bzISuWH7lCsLYH43onvfioexaHCk7i4glqNlztZ5
p9C6OohhSL+BrSKmdQ5AvDQE0p1WXH0F1mDqt7uEowZ2S7kalGzsB8xvpiWXja4P
kOn5P4/RCiv1rKjZJEpXwZ8deG4RaRkj0wj/mGc7EpaeIgsK0o4sAAg1Wg2uO/rq
YjfI9lTKJ6GuYj5prbBTs/cv5nnBbhhfpXmE4z+uJkYfjL3gFTRO9hNtuEL5nSwu
Nki0y1bUo0QNY+9v0nt4jXEC2SLIjNibETqDClGbTwD5Z9Coek25m6lcUQbFShUq
7tzF75KTspWYOO0RI7Fg
=pb2n
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Dec_2012_09_44_33_+1100_jAai.vE.r+k=uDMJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
