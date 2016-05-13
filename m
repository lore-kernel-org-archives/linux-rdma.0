From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] ib core: Make device counter infrastructure dynamic
Date: Fri, 13 May 2016 15:18:07 -0400
Message-ID: <057c8ac8-1d34-e7b9-c0ad-91d805c81139@redhat.com>
References: <20160315155441.222586021@linux.com>
 <20160315155455.173645653@linux.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GFd1tTCL8PSoIBbkfPT5Hb6K9BawEkb36"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160315155455.173645653-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, alonvi-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GFd1tTCL8PSoIBbkfPT5Hb6K9BawEkb36
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 03/15/2016 11:54 AM, Christoph Lameter wrote:
> Index: linux/drivers/infiniband/hw/cxgb3/iwch_provider.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/infiniband/hw/cxgb3/iwch_provider.c
> +++ linux/drivers/infiniband/hw/cxgb3/iwch_provider.c
> @@ -1218,12 +1218,46 @@ static ssize_t show_board(struct device
>  		       iwch_dev->rdev.rnic_info.pdev->device);
>  }
> =20
> +char *names[] =3D {
> +	"ipInReceives",
> +	"ipInHdrErrors",
> +	"ipInAddrErrors",
> +	"ipInUnknownProtos",
> +	"ipInDiscards",
> +	"ipInDelivers",
> +	"ipOutRequests",
> +	"ipOutDiscards",
> +	"ipOutNoRoutes",
> +	"ipReasmTimeout",
> +	"ipReasmReqds",
> +	"ipReasmOKs",
> +	"ipReasmFails",
> +	"tcpActiveOpens",
> +	"tcpPassiveOpens",
> +	"tcpAttemptFails",
> +	"tcpEstabResets",
> +	"tcpCurrEstab",
> +	"tcpInSegs",
> +	"tcpOutSegs",
> +	"tcpRetransSegs",
> +	"tcpInErrs",
> +	"tcpOutRsts",
> +	"tcpRtoMin",
> +	"tcpRtoMax",
> +	NULL
> +};
> +
>  static int iwch_get_mib(struct ib_device *ibdev,
> -			union rdma_protocol_stats *stats)
> +			struct rdma_protocol_stats *stats,
> +			u8 port)
>  {
>  	struct iwch_dev *dev;
>  	struct tp_mib_stats m;
>  	int ret;
> +	u64 *p;
> +
> +	if (port !=3D 0)
> +		return 0;
> =20
>  	PDBG("%s ibdev %p\n", __func__, ibdev);
>  	dev =3D to_iwch_dev(ibdev);
> @@ -1231,45 +1265,53 @@ static int iwch_get_mib(struct ib_device
>  	if (ret)
>  		return -ENOSYS;
> =20
> -	memset(stats, 0, sizeof *stats);
> -	stats->iw.ipInReceives =3D ((u64) m.ipInReceive_hi << 32) +
> -				m.ipInReceive_lo;
> -	stats->iw.ipInHdrErrors =3D ((u64) m.ipInHdrErrors_hi << 32) +
> -				  m.ipInHdrErrors_lo;
> -	stats->iw.ipInAddrErrors =3D ((u64) m.ipInAddrErrors_hi << 32) +
> -				   m.ipInAddrErrors_lo;
> -	stats->iw.ipInUnknownProtos =3D ((u64) m.ipInUnknownProtos_hi << 32) =
+
> -				      m.ipInUnknownProtos_lo;
> -	stats->iw.ipInDiscards =3D ((u64) m.ipInDiscards_hi << 32) +
> -				 m.ipInDiscards_lo;
> -	stats->iw.ipInDelivers =3D ((u64) m.ipInDelivers_hi << 32) +
> -				 m.ipInDelivers_lo;
> -	stats->iw.ipOutRequests =3D ((u64) m.ipOutRequests_hi << 32) +
> -				  m.ipOutRequests_lo;
> -	stats->iw.ipOutDiscards =3D ((u64) m.ipOutDiscards_hi << 32) +
> -				  m.ipOutDiscards_lo;
> -	stats->iw.ipOutNoRoutes =3D ((u64) m.ipOutNoRoutes_hi << 32) +
> -				  m.ipOutNoRoutes_lo;
> -	stats->iw.ipReasmTimeout =3D (u64) m.ipReasmTimeout;
> -	stats->iw.ipReasmReqds =3D (u64) m.ipReasmReqds;
> -	stats->iw.ipReasmOKs =3D (u64) m.ipReasmOKs;
> -	stats->iw.ipReasmFails =3D (u64) m.ipReasmFails;
> -	stats->iw.tcpActiveOpens =3D (u64) m.tcpActiveOpens;
> -	stats->iw.tcpPassiveOpens =3D (u64) m.tcpPassiveOpens;
> -	stats->iw.tcpAttemptFails =3D (u64) m.tcpAttemptFails;
> -	stats->iw.tcpEstabResets =3D (u64) m.tcpEstabResets;
> -	stats->iw.tcpOutRsts =3D (u64) m.tcpOutRsts;
> -	stats->iw.tcpCurrEstab =3D (u64) m.tcpCurrEstab;
> -	stats->iw.tcpInSegs =3D ((u64) m.tcpInSegs_hi << 32) +
> -			      m.tcpInSegs_lo;
> -	stats->iw.tcpOutSegs =3D ((u64) m.tcpOutSegs_hi << 32) +
> -			       m.tcpOutSegs_lo;
> -	stats->iw.tcpRetransSegs =3D ((u64) m.tcpRetransSeg_hi << 32) +
> -				  m.tcpRetransSeg_lo;
> -	stats->iw.tcpInErrs =3D ((u64) m.tcpInErrs_hi << 32) +
> -			      m.tcpInErrs_lo;
> -	stats->iw.tcpRtoMin =3D (u64) m.tcpRtoMin;
> -	stats->iw.tcpRtoMax =3D (u64) m.tcpRtoMax;
> +	stats->dirname =3D "iw_stats";
> +	stats->name =3D names;
> +
> +	p =3D stats->value;
> +	*p++ =3D ((u64)m.ipInReceive_hi << 32) +
> +		m.ipInReceive_lo;
> +	*p++ =3D ((u64)m.ipInHdrErrors_hi << 32) +
> +		m.ipInHdrErrors_lo;
> +	*p++ =3D ((u64)m.ipInAddrErrors_hi << 32) +
> +		m.ipInAddrErrors_lo;
> +	*p++ =3D ((u64)m.ipInUnknownProtos_hi << 32) +
> +		m.ipInUnknownProtos_lo;
> +	*p++ =3D ((u64)m.ipInDiscards_hi << 32) +
> +		m.ipInDiscards_lo;
> +	*p++ =3D ((u64)m.ipInDelivers_hi << 32) +
> +		m.ipInDelivers_lo;
> +	*p++ =3D ((u64)m.ipOutRequests_hi << 32) +
> +		m.ipOutRequests_lo;
> +	*p++ =3D ((u64)m.ipOutDiscards_hi << 32) +
> +		m.ipOutDiscards_lo;
> +	*p++ =3D ((u64)m.ipOutNoRoutes_hi << 32) +
> +		m.ipOutNoRoutes_lo;
> +	*p++ =3D (u64)m.ipReasmTimeout;
> +	*p++ =3D (u64)m.ipReasmReqds;
> +	*p++ =3D (u64)m.ipReasmOKs;
> +	*p++ =3D (u64)m.ipReasmFails;
> +	*p++ =3D (u64)m.tcpActiveOpens;
> +	*p++ =3D (u64)m.tcpPassiveOpens;
> +	*p++ =3D (u64)m.tcpAttemptFails;
> +	*p++ =3D (u64)m.tcpEstabResets;
> +	*p++ =3D (u64)m.tcpOutRsts;
> +	*p++ =3D (u64)m.tcpCurrEstab;
> +	*p++ =3D ((u64)m.tcpInSegs_hi << 32) +
> +		m.tcpInSegs_lo;
> +	*p++ =3D ((u64)m.tcpOutSegs_hi << 32) +
> +		m.tcpOutSegs_lo;
> +	*p++ =3D ((u64)m.tcpRetransSeg_hi << 32) +
> +		m.tcpRetransSeg_lo;
> +	*p++ =3D ((u64)m.tcpInErrs_hi << 32) +
> +		m.tcpInErrs_lo;
> +	*p++ =3D (u64)m.tcpRtoMin;
> +	*p++ =3D (u64)m.tcpRtoMax;
> +
> +	/* Emsure we provided all values */
> +	BUG_ON(p - stats->value !=3D
> +	       (sizeof(names) / sizeof(char *)) - 1);
> +
>  	return 0;
>  }
> =20

I don't like this entire chunk.  Please handle both the cxgb3 and cxgb4
changes like you did the mlx4 changes.  Specifically, use an enum to
define the array index for names and an array of offsets so that the
textual names from the enum can be used to access the array.  The way
things are here is horribly fragile.

Secondly, do *not* use a BUG_ON in this patch.  I saw at least two of
them.  There is nothing in this patch so serious that we should crash
the kernel.  Any failure here is something we can work around and keep
running.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--GFd1tTCL8PSoIBbkfPT5Hb6K9BawEkb36
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXNihvAAoJELgmozMOVy/dMsQP/ipzbNZim0nozqF4SMpHuZJm
VJr+1W1UDyVBdXnwVcr0cNkWQ1xVFIKkk+eHCnKDtFET57l7qzdlSUtXgio/yfo3
0eZ6Ubms21wdBAbinx138lep8fw/bs3D0i9cI0t19gPuRceaAhv4+01ojxGVpiSG
mUiOkRqUi0ZVZAXRmEDQh4/Q5vIVjNuK2JreanZIZF2EBix/rQ/aT+ZxVh5S8Px4
7nHdS9BEPVEzxBSH9zfBc+91o2X/m+z+FzqMd1d0U7gC5z8ooDQwBNGgQbniR6VT
zJavdywgV3hmDXERNwq876y0gRJsiEr2WYSd2oNt8dPuajGYh2aOCqL9JjBazPvw
q9DbUfltlzaWCUCSmtZSfXV1bfrdCpSHTni7f45nhTeLQUldrZyE446CXhCklvo6
7+8DKZ8zAi0BNKSc57fLj7oO0/zOPW3SIr0avFMrG0ePxLpTKs5Y3i6Qd0FknM2m
IfJa+vgL22FagRW9YLXgk61T7mfksdtihU4FasRFN/5EBWi9tkSUgHYhK8EaDRNL
92oxfkFJVCH53BfijA0VwW37PLO09QaTQWxWVq/eYCts5McYjOpeyMj4q/QYgBYT
z3H9+37StwwX5Gpf3YAy0ggOPIIFgq/ojkhVrdpSxz73KVKPIdySeuKr35D493xT
oZLRPE0DDJ5foWm7Tlc+
=TbbH
-----END PGP SIGNATURE-----

--GFd1tTCL8PSoIBbkfPT5Hb6K9BawEkb36--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
