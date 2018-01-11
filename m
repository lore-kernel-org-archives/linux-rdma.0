From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/rxe: Fix a race condition related to the QP error
 state
Date: Thu, 11 Jan 2018 21:00:45 +0200
Message-ID: <20180111190045.GE15760@mtr-leonro.local>
References: <20180109192340.25702-1-bart.vanassche@wdc.com>
 <1515620434.3403.169.camel@redhat.com>
 <1515621700.3403.174.camel@redhat.com>
 <20180111062252.GP7368@mtr-leonro.local>
 <1515686552.2752.2.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1515686552.2752.2.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 11, 2018 at 04:02:33PM +0000, Bart Van Assche wrote:
> On Thu, 2018-01-11 at 08:22 +0200, Leon Romanovsky wrote:
> > The proposed patch definitely decreases the chance of races, but it is not fixing them.
> > There is a chance to have change in qp state immediately after your "if ..." check.
>
> Hello Leon,
>
> Please have a look at rxe_qp_error() and you will see that the patch I posted
> is a proper fix. In the scenario you described rxe_qp_error() will trigger a
> run of rxe_completer().

Bart,

What am I missing?

CPU1							CPU2
							if (unlikely....
						<---
/* move the qp to the error state */
void rxe_qp_error(struct rxe_qp *qp)
{
        qp->req.state = QP_STATE_ERROR;
        qp->resp.state = QP_STATE_ERROR;
        qp->attr.qp_state = IB_QPS_ERR;
						--->
							rxe_run_task(&qp->req.task, must_sched);



It is more or less the same as without "if (unlikely..."

Thanks

>
> Bart.

--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpXtF0ACgkQ5GN7iDZy
WKc0ww//YtwC996gfre5P5Dlaeefo382CVhCtjaqQKjGx8AfccxmT8xKIgV0L4Sj
nO2RtohuGSxZii9qEmpZg96rJBl7PxMkmwiZDPFXYuoeuBZLFqQTYG73z5VW9TiZ
3NzE7Y2FLQyYO07g09OvitMm8gaJ9+/RsmmEbMqhFbCoqYfswyF9gvQBfJWwZlzX
W7HnBjC7ga56h9ewEqv4FwcGWriXNVsquAdBBCqf7U+xvstBcnRjfluXBf3Iaxl4
aOKPfmIwvPAVjOAlqjCDas9+0Nx4CPlqePXDmLxRie7vfbtArkUAZJHJLVNAtIBb
5Nv8llxzNjSPGiaXlhn0lzFpPxpfgVrQf2vCIkBOT0SoFvv0xHW0qdWk/73shcez
+VeXnPc+glIemRJUsUWyycvX7TTzJNzdvcianRBU5ovg1pikYgT/XvH6KOR5ZrKZ
Ek4UQzdqdU/XicvpQoGh0+UO7DJH5FM2L1oKdMtFzRmov8aqikbYkju+7ypd37cG
mXA5ElEVPvt8pPsX+jed1cOsRuDZbS9MabPmS0d1wQvVO3ZDSEWhCIw8zHpf0gbP
t2EaFL5fXzymX3WOfM288L1LokS8K2bnBkrJ2zlYbVPIQGR3gg5cMHR+NcgQA2Ui
2f3ksftZBghMNpZLi2NCUCTROwshaLuJOvUCAXo34Ycv7spKWIY=
=XAwO
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
