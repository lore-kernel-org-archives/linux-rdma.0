From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] net/mlx4_core: print firmware version during driver
 loading
Date: Sat, 15 Sep 2018 11:50:09 +0300
Message-ID: <20180915085009.GD5257@mtr-leonro.mtl.com>
References: <c580ad9d-b63d-743b-2278-1c4cf3553186@oracle.com>
 <20180914181718.GD3811@lunn.ch>
 <c332f10a-5ad0-53fd-5111-1964443b3092@oracle.com>
 <20180914.141406.2211638662965115243.davem@davemloft.net>
 <1d4fe3c6-13aa-12a4-8da4-a83374b89fbf@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LiQwW4YX+w4axhAx"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1d4fe3c6-13aa-12a4-8da4-a83374b89fbf@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Qing Huang <qing.huang@oracle.com>
Cc: David Miller <davem@davemloft.net>, andrew@lunn.ch, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, tariqt@mellanox.com
List-Id: linux-rdma@vger.kernel.org


--LiQwW4YX+w4axhAx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 14, 2018 at 03:36:46PM -0700, Qing Huang wrote:
>
>
> On 9/14/2018 2:14 PM, David Miller wrote:
> > From: Qing Huang<qing.huang@oracle.com>
> > Date: Fri, 14 Sep 2018 11:33:40 -0700
> >
> > > On 9/14/2018 11:17 AM, Andrew Lunn wrote:
> > > > On Fri, Sep 14, 2018 at 10:15:48AM -0700, Qing Huang wrote:
> > > > > The FW version is actually a very crucial piece of information and
> > > > > only
> > > > > printed once here
> > > > > when the driver is loaded. People tend to get confused when switching
> > > > > multiple FW files
> > > > > back and forth without running separate utility tools, especially at
> > > > > customer sites.
> > > > > IMHO, this information is very useful and only takes up very little
> > > > > log file
> > > > > space. :-)
> > > > Why not use ethtool -i ?
> > > >
> > > > $ sudo ethtool -i eth0
> > > > driver: r8169
> > > > version: 2.3LK-NAPI
> > > > firmware-version: rtl8168g-2_0.0.1 02/06/13
> > > >
> > > >       Andrew
> > > Sure. You can also use ibstat or ibv_devinfo tool if they are
> > > installed. But it's not very
> > > convenient in some cases.
> > >
> > > E.g.
> > > A customer upgrades FW on HCAs and encounters issues. During triage,
> > > it's much easier
> > > to study customer uploaded log files when remotely testing different
> > > FW files.
> > Not a valid argument.  You can print the ethtool output from initramfs
> > if necessary for triage.
> >
> > I still stand by the fact that ethtool is the only fully reliable way
> > to obtain this information, the kernel log is not.
>
> This is more for Infiniband mode which depends more on features and
> functionalities

For pure infiniband devices you have rdmatool, part of iproute2.
[leonro@server-14-015 ~]$ rdma dev
1: mlx5_0: node_type ca fw 3.8.9999 node_guid 5254:00c0:fe12:3455 sys_image_guid 5254:00c0:fe12:3455

> provided in firmware and get much more frequent FW bug fixes than typical
> Ethernet
> devices. This is not meant to replace other ways of getting the information,
> more like
> an enhancement for checking log history.
>
> This can provide valuable information when tracing through system log
> history to
> discover what happened with a specific HCA drv ver and fw ver combination in
> the past.
>
> Regards,
> Qing

--LiQwW4YX+w4axhAx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbnMfBAAoJEORje4g2clins2MP/2ahQ8mb69Zi6lmm5NOnF6Jp
pRNzlNSTPzRZ9Fp2MXZYMU1tGny0099pN0kkUalecGjUjyIL5W3VU1kTKyhZJo9B
7mi/e1uTXVkT3dEyqsPhXdaig0C7EWv+pQRz6he2oc3QBhc1uUri7jKofjLG7K+q
o6/j7F2nZ0mIK4AzoQZJErFv4bZ7hXzcx48vNRg4jV6LLgKP//9C5KyNrjZ/GyUf
YDp3DOQzhbu4EHxQqm7bb08XHKj24SJ0AAaGKIJEcXY1iTrZqmg3LYSOpS0aGLy0
RV7q6uuKbbm7RiHqF+htAAobgoGqYorAep9ePvl2lvAzwnJh39Fcv25Hbrqly5EG
fXsCk4SvNROH8RwqLwOQ1j4is08omwVN0LeKGS3y0auIJkdjiTJh6VZMb2/+WKG+
BaL9mzQnl32Spl/uOQPepf4YSwWVHqpzATamZpm/FVsDp4g0dhkzJmTLvErhEfxu
b27VRmImB3mnGRhnQ/csRIy4aYlYXr811xbYs+QIFBMnU7Gj8587fAhA7Tpbe03u
7AusoUmICk5Z+CMaVWjLXsDY3BlwxRuSIzKrSWOy3eYEsNvgcn2750IoSrFF8ytD
//P2h9BKzUMMwnwlxV6FYne4mTYLLhiD3vAk+eI/Xdsv6TLYr67/e8CL24na83Z+
1nQgA1BF0TXoZBpShiR0
=dvjv
-----END PGP SIGNATURE-----

--LiQwW4YX+w4axhAx--
