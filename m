From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma/wip/jgg-for-next] RDMA/netlink: Hide unimplemented
 NLDEV commands
Date: Tue, 30 Jan 2018 20:39:42 +0200
Message-ID: <20180130183942.GH2055@mtr-leonro.local>
References: <20180130150716.16372-1-leon@kernel.org>
 <20180130155706.GC14797@nanopsycho>
 <20180130160337.GD17053@ziepe.ca>
 <20180130181814.GD14797@nanopsycho>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1sNVjLsmu1MXqwQ/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180130181814.GD14797@nanopsycho>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Pirko <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--1sNVjLsmu1MXqwQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 30, 2018 at 07:18:14PM +0100, Jiri Pirko wrote:
> Tue, Jan 30, 2018 at 05:03:37PM CET, jgg-uk2M96/98Pc@public.gmane.org wrote:
> >On Tue, Jan 30, 2018 at 04:57:06PM +0100, Jiri Pirko wrote:
> >> Tue, Jan 30, 2018 at 04:07:16PM CET, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
> >> >From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> >
> >> >The nldev was implemented by following devlink implementation,
> >> >including SET/DEL/NEW commands. However these commands were not
> >> >implemented and hence don't need to be exposed.
> >> >
> >> >Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >> > include/uapi/rdma/rdma_netlink.h | 14 ++++++--------
> >> > 1 file changed, 6 insertions(+), 8 deletions(-)
> >> >
> >> >diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
> >> >index 17e59bec169e..4c77e2a7b07e 100644
> >> >+++ b/include/uapi/rdma/rdma_netlink.h
> >> >@@ -227,16 +227,14 @@ enum rdma_nldev_command {
> >> > 	RDMA_NLDEV_CMD_UNSPEC,
> >> >
> >> > 	RDMA_NLDEV_CMD_GET, /* can dump */
> >> >-	RDMA_NLDEV_CMD_SET,
> >> >-	RDMA_NLDEV_CMD_NEW,
> >> >-	RDMA_NLDEV_CMD_DEL,
> >> >
> >> >-	RDMA_NLDEV_CMD_PORT_GET, /* can dump */
> >> >-	RDMA_NLDEV_CMD_PORT_SET,
> >> >-	RDMA_NLDEV_CMD_PORT_NEW,
> >> >-	RDMA_NLDEV_CMD_PORT_DEL,
> >> >+	/* 2 - 4 are free to use */
> >> >
> >> >-	RDMA_NLDEV_CMD_RES_GET, /* can dump */
> >> >+	RDMA_NLDEV_CMD_PORT_GET = 5, /* can dump */
> >> >+
> >> >+	/* 6 - 8 are free to use */
> >>
> >> I don't see reason for the wholes.
> >
> >We are stuck with the holes, it is fixed uABI at this point, can't
> >change the constants we actually implemented.
>
> If it is realeased already, we can't remove the defines either.

Why? There is exactly one consumer - rdmatool and it doesn't use removed
constants.

>
>
> >
> >> Also, Don't you use *_NEW for replies to *_GET, as it is common for
> >> Netlink?
> >
> >It appears not..
> >
> >IMHO that convention makes the most sense when there is a GET/NEW pair
> >with the idea the NEW is formed to be echoed back to the kernel -
> >these case are all GET only..
> >
> >Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--1sNVjLsmu1MXqwQ/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpwu+4ACgkQ5GN7iDZy
WKcaOg/+P/0nCvPvP71dglYkIRm5ol0lP9QVcfWln3rlJD5l5mOloQQOakY7fr2Q
3uwNME3OFjEW5ZmSSdcnVqQnZal0pbE4uUODif864yYChYqiPvN0vWGxPaWOubkG
U7ZNUmasjCr3QHJuP1CX7fNm6ZJWfs5SZmUHX7CuRXW6wHkA8XNg68EQRPO3P690
aI6lYSI3zP/z8jMU7yvjNsJKUTESR2XH0uF7Q2tucqyPOYLMi6XYKvn8YZd5TqR5
VLhCvaIqT4Q+5n4vnaDeCHiusd/ujwLD2QeyZv1sTHcwnN6Rc0GzUlh8uhSm2D35
6whGsQp0XnoyOSCCXKpAN3kBQt9bAnS5XLo7WTKPaXb6MQiVdJYF3xSNXpy3YAvg
nbfgs1CfuId/aIzg8u8+98l8bA0dYMfvsX90bwW+RhM7PxAKtckEwYEyPxOxgQ8Q
cMfkRVsRVaaC6Vr0DdG1p+gOVyLA22kU54L735Lxo2l/H+q3uE+sCWjbq62G2TaB
lgUiZSnFAtHV3KEO5Lk+nWyqa3zUqXVUXpldaAnuzsKCW71AiGNZINLgBt1nmNvG
O7G5wN8QIQx8MXeQA0sQx0fp2MtNLVfeluYTjo2UIduexyAOg98Pa7v/NLox7haO
/Qu0/438wox8ngoi8mlNgQfxXXY3VTRsS1IK7socrYG9jWBbqfE=
=nUJc
-----END PGP SIGNATURE-----

--1sNVjLsmu1MXqwQ/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
