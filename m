From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] infiniband: nes: add unlikely() to assert()
Date: Wed, 5 Sep 2018 09:01:06 +0300
Message-ID: <20180905060106.GI2977@mtr-leonro.mtl.com>
References: <20180831192418.12346-1-igor.stoppa@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6cMF9JLEeZkfJjkP"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180831192418.12346-1-igor.stoppa@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Faisal Latif <faisal.latif@intel.com>, Igor Stoppa <igor.stoppa@huawei.com>, Chien Tung <chien.tin.tung@intel.com>, Roland Dreier <rolandd@cisco.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--6cMF9JLEeZkfJjkP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 31, 2018 at 10:24:18PM +0300, Igor Stoppa wrote:
> Typically the assert is expected to not fail.

This whole assert can be removed.

>
> Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
> Acked-by: Doug Ledford <dledford@redhat.com>

Most probably that I missed discussion, but anyway, does this
"Acked-by" come from internal or external discussion?

Thanks

--6cMF9JLEeZkfJjkP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbj3EiAAoJEORje4g2clinidUP/Rork9n9fN0ngNcahEEtYG9U
2qTbEKea5ZwHgXvT+0b8PNCdghqLc3WpaJh15aH7lxs4Faue1qCP8hD5djGu99To
G5eC6hYPGUdN0fR5TEn91pNls5Wsh+BgHhU1J81zR/9u15h8+QpE8KhqhNTi2VWs
gvD99s1qEhUvjDxxCbN3wEEVv//Ld9gcZfYK2GaVOaF57qRBFC+bS9xT0kEgOeC+
5Zm/hwh0Soamzar6jKqT5QakBK6TdxMOyGRY7vLGOgmE7/bS378/VML9pgsdA3ge
XQLWYgBDNIEb4bvVo8VUp6QzSA1faxgoRPz8g0XTg9NaYnFFokvAatTUZJyBkkwQ
9jRwjz1GthYMBAWzsx44QVUBs1qc0H2AahZN8dtn4mqI8zkPHQwvis4edfHc/J8S
f3///vRUhxvYI2OVCPXYpy3scGrG/RapO1asC40ymvWM4tI+9wWK7HZC6u+cXmDS
kPL/VCaLYStWiCxP65v2MTaHOTZ1kx2fZkGsBctUTB0c+F90GPe2zWcVyaNVuEK9
n2UPNXR7j2p5htjcZqslqGf/s62ReH1RoiaH+oj+HQhlKGIY6LG54iDaCbWSwV1g
vL6RiuhSQ6mbagxwuC38J/1WdrpT94/dApGnwuFfqlEVrZiuGYOWRt+ZWU9iFUz2
2z/lL+2+WvjiwqW8TYDI
=abR1
-----END PGP SIGNATURE-----

--6cMF9JLEeZkfJjkP--
