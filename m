From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: build failure after merge of the infiniband tree
Date: Wed, 18 Feb 2015 13:32:21 +1100
Message-ID: <20150218133221.7aa89df7@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.97FGISwXeQ+9GswA2cCgRH"; protocol="application/pgp-signature"
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Mike Marciniszyn <mike.marciniszyn@intel.com>
List-Id: linux-rdma@vger.kernel.org

--Sig_/.97FGISwXeQ+9GswA2cCgRH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the livepatching tree, today's linux-next build (powerpc
allyesconfig) failed like this:

In file included from drivers/infiniband/hw/qib/qib_cq.c:41:0:
drivers/infiniband/hw/qib/qib.h: In function 'qib_flush_wc':
drivers/infiniband/hw/qib/qib.h:1470:1: error: expected ';' before '}' token
 }
 ^

and it went badly down hill from there :-(

Caused by commit f72c1c08efbc ("IB/qib: Fix checkpatch warnings").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/.97FGISwXeQ+9GswA2cCgRH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJU4/m+AAoJEMDTa8Ir7ZwVGCYP/3w2STxOtFoBIiWmGMjvoY3d
0aVJmq0SD7vRfARU3a/hV6h0JuCiQr5ZP/nXaWtG1J6cRskxRETR7/73jGlvnq4g
dbwfQ9yqgFYB2VIXzqozqCNhO4xKMabvl1g2HmNQFEBDwTEpcjqZ6qmICHdap10L
K67eXQmZHrae3lRW+HZIi/afmvgQQJX4wubWoNHCQoyDhLxjT6eCSXD2rvREB6FE
z8E4bamJkxCXXZb7dpQ1wnCHGzR/qpEknYaLzMsh1miLLh1iYd9Iij5d6u8c4JDj
IaG4naGeE7N++NNsK456UJUFlo+WCOB32FDx+XJTiHRY5TtCvWYgqaRAJOLzmcs7
aM/w9sS6YKAydLTDFhMyXBQab0AVf8ZgnFtTm4MhSlhh/TT4yIdQHfisbu6miobD
E62kClXDZqyRykWxmkMqtv6q3f/BTSyEFTH1qRygKdLQfEy5rgSMlLavyRWSZDZk
MobG0ZzqJQcMDqLQFJNsUR5VGBE/N77j/S2H/pt4UA2gFp22mEiP1RVwcYA+JFFK
O64z2ExJmS+JixSeLzJbtRVp49SXTs5wqi42N/WpLhdUJScI0bSoclh61+qhkfNv
1rWo1O71qXlM3kXH4DJDH0BqjoHMXqqM4b9l+9gvcFiEChU43GXmqipKQ3EA1UmA
AgwQTMwjXHzGT1wiw/uY
=KM1k
-----END PGP SIGNATURE-----

--Sig_/.97FGISwXeQ+9GswA2cCgRH--
