From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/10] IB/hfi1: Add ioctl() interface for user commands
Date: Sat, 21 May 2016 15:34:04 +0300
Message-ID: <20160521123404.GB25500@leon.nu>
References: <20160519122318.22041.58871.stgit@scvm10.sc.intel.com>
 <20160519122622.22041.41686.stgit@scvm10.sc.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160519122622.22041.41686.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 19, 2016 at 05:26:24AM -0700, Dennis Dalessandro wrote:
> IOCTL is more suited to what user space commands need to do than the
> write() interface. Add IOCTL definitions for all existing write commands
> and the handling for those. The write() interface will be removed in a
> follow on patch.
>=20
> Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/staging/rdma/hfi1/common.h   |    5 +
>  drivers/staging/rdma/hfi1/file_ops.c |  204 ++++++++++++++++++++++++++++=
++++++
>  include/uapi/rdma/hfi/hfi1_user.h    |   40 +++++++
>  3 files changed, 248 insertions(+), 1 deletions(-)
>=20

<...>

> +#define IB_IOCTL_MAGIC 0x1b /* See Documentation/ioctl/ioctl-number.txt =
*/
> +
> +struct hfi1_cmd;
> +#define HFI1_IOCTL_ASSIGN_CTXT \
> +	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_ASSIGN_CTXT, struct hfi1_user_info)
> +#define HFI1_IOCTL_CTXT_INFO \
> +	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_CTXT_INFO, struct hfi1_ctxt_info)
> +#define HFI1_IOCTL_USER_INFO \
> +	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_USER_INFO, struct hfi1_base_info)
> +#define HFI1_IOCTL_TID_UPDATE \
> +	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_TID_UPDATE, struct hfi1_tid_info)
> +#define HFI1_IOCTL_TID_FREE \
> +	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_TID_FREE, struct hfi1_tid_info)
> +#define HFI1_IOCTL_CREDIT_UPD \
> +	_IO(IB_IOCTL_MAGIC, HFI1_CMD_CREDIT_UPD)
> +#define HFI1_IOCTL_RECV_CTRL \
> +	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_RECV_CTRL, int)
> +#define HFI1_IOCTL_POLL_TYPE \
> +	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_POLL_TYPE, int)
> +#define HFI1_IOCTL_ACK_EVENT \
> +	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_ACK_EVENT, unsigned long)
> +#define HFI1_IOCTL_SET_PKEY \
> +	_IOW(IB_IOCTL_MAGIC, HFI1_CMD_SET_PKEY, __u16)
> +#define HFI1_IOCTL_CTXT_RESET \
> +	_IO(IB_IOCTL_MAGIC, HFI1_CMD_CTXT_RESET)
> +#define HFI1_IOCTL_TID_INVAL_READ \
> +	_IOWR(IB_IOCTL_MAGIC, HFI1_CMD_TID_INVAL_READ, struct hfi1_tid_info)
> +#define HFI1_IOCTL_GET_VERS \
> +	_IOR(IB_IOCTL_MAGIC, HFI1_CMD_GET_VERS, int)
> =20

I think the overall consensus over participants in OFVWG call was to use
one IOCTL to enter into device specific handler which will do all
necessary parsing and not spamming common IOCTL interface.

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXQFW8AAoJEORje4g2clin+IIQAL7qdRS+XmuJnsJMwxT9i/jf
x9o4WxefldT9aziRTY32T5RbUaoUEf76RP16f4EMTI51fBQZxTQTXw+XzUxQi7sZ
LF3bGBRyaTitDrza+kSJVj8xtGxkSPiOiDLBPyQ0R64qgOC+iJn3fgCvlbHd1U38
QRKpvQ8j1w75IG6In1fcReeX/fP0LEpIFuK8BokFcu0P54fPvVpka/u4SDZElskD
2kmyov2m5K4wAB7JrfBCXXCh+4OLmH/PLlNUsStnlt6hms1UfxrLiTjd3h9O7C20
kuvKrm7OWhj8IloHdYF/G5c3JDIftha+AFCYuMYXEZn84m/SN7tC0uQkc3yEOboO
BJVhni7obHJvOXdy7r64aX3mlEIXPguNrwonZBinBmcpiBRvzOKYCpHSqG7U7tok
BDrh9fKvP4DbJ/H8N4UGFPSZSW08UycWpqE7+1ZTkX7jOrf3diHEhJvGEa7u0rRJ
SjLTDd52OfmbDPfwGYaREzgfCDcIf0bAjXQhWWrU3628ATApVViOo+fa0PWWJ7bF
D5Fd/nbrTrodlXTfSuc5VHwnqWBm10eB35TjbGDDa+vxjqTloxtYZS8TA7mXEpav
Fk29PV4N2QqiDq2i2ebH42UlTDYYu5nGCQgP0xiabR4HY+1cxiwENSGzMqk8fXyV
wuGzqbFiXZM9g1jYQeL8
=PPYf
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
