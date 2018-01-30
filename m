From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma/wip/jgg-for-next] RDMA/netlink: Hide unimplemented
 NLDEV commands
Date: Tue, 30 Jan 2018 20:38:30 +0200
Message-ID: <20180130183830.GG2055@mtr-leonro.local>
References: <20180130150716.16372-1-leon@kernel.org>
 <20180130155706.GC14797@nanopsycho>
 <20180130160337.GD17053@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2JFBq9zoW8cOFH7v"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180130160337.GD17053-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Jiri Pirko <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--2JFBq9zoW8cOFH7v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 30, 2018 at 09:03:37AM -0700, Jason Gunthorpe wrote:
> On Tue, Jan 30, 2018 at 04:57:06PM +0100, Jiri Pirko wrote:
> > Tue, Jan 30, 2018 at 04:07:16PM CET, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
> > >From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >
> > >The nldev was implemented by following devlink implementation,
> > >including SET/DEL/NEW commands. However these commands were not
> > >implemented and hence don't need to be exposed.
> > >
> > >Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > include/uapi/rdma/rdma_netlink.h | 14 ++++++--------
> > > 1 file changed, 6 insertions(+), 8 deletions(-)
> > >
> > >diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
> > >index 17e59bec169e..4c77e2a7b07e 100644
> > >+++ b/include/uapi/rdma/rdma_netlink.h
> > >@@ -227,16 +227,14 @@ enum rdma_nldev_command {
> > > 	RDMA_NLDEV_CMD_UNSPEC,
> > >
> > > 	RDMA_NLDEV_CMD_GET, /* can dump */
> > >-	RDMA_NLDEV_CMD_SET,
> > >-	RDMA_NLDEV_CMD_NEW,
> > >-	RDMA_NLDEV_CMD_DEL,
> > >
> > >-	RDMA_NLDEV_CMD_PORT_GET, /* can dump */
> > >-	RDMA_NLDEV_CMD_PORT_SET,
> > >-	RDMA_NLDEV_CMD_PORT_NEW,
> > >-	RDMA_NLDEV_CMD_PORT_DEL,
> > >+	/* 2 - 4 are free to use */
> > >
> > >-	RDMA_NLDEV_CMD_RES_GET, /* can dump */
> > >+	RDMA_NLDEV_CMD_PORT_GET = 5, /* can dump */
> > >+
> > >+	/* 6 - 8 are free to use */
> >
> > I don't see reason for the wholes.
>
> We are stuck with the holes, it is fixed uABI at this point, can't
> change the constants we actually implemented.
>
> > Also, Don't you use *_NEW for replies to *_GET, as it is common for
> > Netlink?
>
> It appears not..
>
> IMHO that convention makes the most sense when there is a GET/NEW pair
> with the idea the NEW is formed to be echoed back to the kernel -
> these case are all GET only..

Back then, I didn't find any reason to return _NEW, and I don't see it
now either.

There is NLM_F_ECHO flag for echo and sequence number to distinguish
between messages.

>
> Jason

--2JFBq9zoW8cOFH7v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpwu6YACgkQ5GN7iDZy
WKc0Zw//VHQxQrq5lzTmCIEx3x2aPQc7XmupJmq7gwaSEKR7G+0fkncAahNQXpYy
uizVYhEsNl7M3BDZYAzPab6ScQmNtD4deTtacYQbAo5esqjO9nNVhphyAzuPtqmZ
pDMQ4nIu62b6dXzs0n7kXeGQT6W2sepxCzqLG1mvRlUUUovUPfzY/YlQI8epQeiu
qXwdaReKvrUl4WCM5PFquTrRJruTtGemYkYUn+5dXLqoqA1qQupoXNRNHTthsoF6
IlHTDi33oIyY5BhgC+yrpiOMRY2qNQ7Zk/eLFJyZHKnbul/Q9146bcwapPIcWpkf
h3x7o9u6jBh+pS0/u0RmCPGNhLsSi7vomkSoc5kKx1FPMYtWM4n4Nj3YJC9mhahL
weGMj33qtgHj0K4inEfvvNeHY/2my2Vqtv8nKSS0CsjFUqjEJT+Y7K8YUNmvBEoW
6Xyv1ZBjL+Dc716zX9I9pCm1Z9NS/ocTTlB8CZydylTKr8YLl1eFgCljkIo2DyMy
VD9KId93q5Xvi1r6m03lLbfm1NOPVaOtSxNFex2BzqwiECN9PYIUA8OzzpzRwgfZ
aEQYBisJHws0UdT5tar1oHYFdtI+LeD9vSUA+bNIpOgjtbgZajpIlIg29+6WXbFH
Z4oDW5jthRKkYivfQAwqaq7nWbGheaRBI690AoxMrPV4wwagmhQ=
=8rJz
-----END PGP SIGNATURE-----

--2JFBq9zoW8cOFH7v--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
