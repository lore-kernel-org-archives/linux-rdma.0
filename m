From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: next-20170728 build: 1 failures 2 warnings (next-20170728)
Date: Fri, 28 Jul 2017 11:41:49 +0100
Message-ID: <20170728104149.jqt7tuvytouuebdn@sirena.org.uk>
References: <E1db2Vq-0000IU-Ew@optimist>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="glxe6cs4ptnf2axg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <E1db2Vq-0000IU-Ew@optimist>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: kernel-build-reports-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--glxe6cs4ptnf2axg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 28, 2017 at 11:28:54AM +0100, Build bot for Mark Brown wrote:

Today's -next fails to build an arm64 allmodconfig due to:

> 	arm64-allmodconfig
> ../drivers/infiniband/hw/hns/hns_roce_eq.c:477:8: error: unknown type name 'irqreturn_t'
> ../drivers/infiniband/hw/hns/hns_roce_eq.c:485:9: error: implicit declaration of function 'IRQ_RETVAL' [-Werror=implicit-function-declaration]
> ../drivers/infiniband/hw/hns/hns_roce_eq.c:711:9: error: implicit declaration of function 'request_irq' [-Werror=implicit-function-declaration]
> ../drivers/infiniband/hw/hns/hns_roce_eq.c:726:3: error: implicit declaration of function 'free_irq' [-Werror=implicit-function-declaration]
> ../drivers/staging/fsl-dpaa2/ethernet/../../fsl-mc/include/dpaa2-io.h:86:1: error: unknown type name 'irqreturn_t'

since the file uses the interrupt API but doesn't explicitly include the
header for it, I'm just about to send a patch.  Presumably something
else was implicitly including it but that header changed.

--glxe6cs4ptnf2axg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAll7FOwACgkQJNaLcl1U
h9CBFwf9GFpuLlPNFsGAdpndUvMwLXjbYJBY22KRR2PwYkPAc0pv/OAxo/Vx78pZ
ekmG0Glwyy4CKxFY4huaI0mfK/6iV1Ehfh7MP+zIk8VPztllHTR1gp/5OQrY3fBC
S+men8lysPaJPA+KO0QQK19Po75fAGppK969ZS2Kd8LIeQY1cLkRalmXhgJPCR5D
7oPk7dqHtlZUbi0s+IWxmUvTcKPkx56druvvmG2TrWEeOwTUQRZcQSg3DvB4Lt1P
4AhQyrAAnqmGF7OP8rnJxHAOnJANuIV+xI+x6PaRNLUyhYr1NKsc+GPhOFkImlC4
fe2wZ7BGQXTV4LCpVnHTj/2NrN+VBg==
=B0jm
-----END PGP SIGNATURE-----

--glxe6cs4ptnf2axg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
