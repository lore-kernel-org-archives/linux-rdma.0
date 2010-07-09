From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the infiniband tree
Date: Fri, 9 Jul 2010 11:04:27 +1000
Message-ID: <20100709110427.c05987cc.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__9_Jul_2010_11_04_27_+1000_5WCz/VCZhfwrMdic"
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>, linux-rdma@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>
List-Id: linux-rdma@vger.kernel.org

--Signature=_Fri__9_Jul_2010_11_04_27_+1000_5WCz/VCZhfwrMdic
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the infiniband tree, today's linux-next build (x86_64
allmodconfig) failed like this:

make[2]: *** No rule to make target `firmware/qlogic/sd7220.fw', needed by =
`__fw_modbuild'.  Stop.

Probably caused by commit bd4d621eacaa6455da1c23260909da89ef4c1a01
("IB/qib: Use request_firmware() to load SD7220 firmware").

I have used the version of the infiniband tree from next-20100708 for
today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__9_Jul_2010_11_04_27_+1000_5WCz/VCZhfwrMdic
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMNnWbAAoJEDMEi1NhKgbsTfwH/RiyT0e72A4h23qRP5BjJVBk
NN2R9018JEYAbas872hAopNuX0Q+bIKulzOiZ/eUMAg/Zr7xqdYMLbB/h8uDaQ+r
ydPs+Ee7N2FB/+GKHqTIEDwoGjYBsyQZd3qVn0tMlcND0tpYA/wjm9rM4pyQHGYO
2t9X5RsQTcXfUz2Iou2NwCEGe1cQ1f5UUnX8M5sZrqJm9mUwz/vhaPNVtKTDZxi1
epXoMx/APp9yNsnYmwIvdNk/Vv225zDxP31sWwBGNuHGRB0lwSxH/yUnBNtdqY+v
Gb97PluANOHb1NSyJDH4CvvOM90lBv2lwnBAJzxfeH+/acr2LcAs7GzPON/Tlgw=
=FTkA
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Jul_2010_11_04_27_+1000_5WCz/VCZhfwrMdic--
