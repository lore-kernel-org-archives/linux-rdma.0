From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH v3 1/2] Driver core: add bus_find_device_by_fwnode
Date: Tue, 9 Oct 2018 16:15:33 +0100
Message-ID: <20181009151533.GC20774@sirena.org.uk>
References: <1539080245-25818-1-git-send-email-svellattu@mvista.com>
 <20181009110210.i6xphyuy5jkcfaug@katana>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181009110210.i6xphyuy5jkcfaug@katana>
Sender: netdev-owner@vger.kernel.org
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Silesh C V <svellattu@mvista.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, devicetree@vger.kernel.org, linux-spi@vger.kernel.org, Mathieu Poirier <mathieu.poirier@linaro.org>, Lijun Ou <oulijun@huawei.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Yisen Zhuang <yisen.zhuang@huawei.com>, Salil Mehta <salil.mehta@huawei.com>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, "David S. Miller" <davem@davemloft.n>
List-Id: linux-rdma@vger.kernel.org


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 09, 2018 at 01:02:10PM +0200, Wolfram Sang wrote:

> We recently had this discussion in I2C world about using the parent if
> the (logical) device has a NULL fw_node [1]. I don't know if the other
> subsystems you modify use logical devices as well? If no, it seems we
> need an additional check for the parent in the I2C core only. If yes,
> this might be considered in your patchset?

SPI has a logical controller device as well.

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlu8xhQACgkQJNaLcl1U
h9AH2gf8C9kz4kG030ID6648vQo9YUHUoHqyzVjXg2u/cPM6H4/AVpiOaeJqSMij
Pl2KZbqPFisjnybJq3lPJaDx3f53TRfGL8/P5Q2AjVPvWMXWDO98JuQ0AA2MhHl2
i7FcqD3mn8QkQu5wbJZOrYj//rnaWXcrVWyDotQXWSKwzHaZp6tBHdfVoUMWgo6w
c45J4E19sRqtAlqFq2/GAR6Mo8Q0nRM410agaluau0zmBIZeTbL1SEDZO0DoVM2p
XgspSOm1lWaSBoRA9wc/+gVG5V/g+5IdLqm+UmOdWasBd4loPAr6Bl9f/CNrlVig
BBjsiPDh9yO9eGKeBQ/CMU7nXOlYqQ==
=Jk+F
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--
