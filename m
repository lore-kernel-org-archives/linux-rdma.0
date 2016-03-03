From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 libibverbs 2/2] Add MR re-registeration
Date: Wed, 2 Mar 2016 21:30:25 -0500
Message-ID: <56D7A1C1.8070306@redhat.com>
References: <1452524718-21575-1-git-send-email-yishaih@mellanox.com>
 <1452524718-21575-3-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2lGjBr7dxVhRQ4aJpdXWmwWT0X7mJx6MT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452524718-21575-3-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2lGjBr7dxVhRQ4aJpdXWmwWT0X7mJx6MT
Content-Type: multipart/mixed; boundary="XcBCgH7ucG364XnP3B4Wj8rtnBDDIb26R"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org,
 ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Message-ID: <56D7A1C1.8070306-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 libibverbs 2/2] Add MR re-registeration
References: <1452524718-21575-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
 <1452524718-21575-3-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
In-Reply-To: <1452524718-21575-3-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--XcBCgH7ucG364XnP3B4Wj8rtnBDDIb26R
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 1/11/2016 10:05 AM, Yishai Hadas wrote:
> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Memory re-registeration is a feature that enables one to change
> the attributes of a memory region, including PD, translation
> (address and length) and access flags.
>=20
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  include/infiniband/driver.h   |  5 ++++
>  include/infiniband/kern-abi.h | 20 ++++++++++++++
>  include/infiniband/verbs.h    |  9 ++++++-
>  man/ibv_rereg_mr.3            | 62 +++++++++++++++++++++++++++++++++++=
++++++++
>  src/cmd.c                     | 29 ++++++++++++++++++++
>  src/libibverbs.map            |  1 +
>  src/verbs.c                   | 56 +++++++++++++++++++++++++++++++++++=
+++
>  7 files changed, 181 insertions(+), 1 deletion(-)
>  create mode 100644 man/ibv_rereg_mr.3
>=20
> diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
> index 8227df0..5226784 100644
> --- a/include/infiniband/driver.h
> +++ b/include/infiniband/driver.h
> @@ -138,6 +138,11 @@ int ibv_cmd_reg_mr(struct ibv_pd *pd, void *addr, =
size_t length,
>  		   struct ibv_mr *mr, struct ibv_reg_mr *cmd,
>  		   size_t cmd_size,
>  		   struct ibv_reg_mr_resp *resp, size_t resp_size);
> +int ibv_cmd_rereg_mr(struct ibv_mr *mr, uint32_t flags, void *addr,
> +		     size_t length, uint64_t hca_va, int access,
> +		     struct ibv_pd *pd, struct ibv_rereg_mr *cmd,
> +		     size_t cmd_sz, struct ibv_rereg_mr_resp *resp,
> +		     size_t resp_sz);
>  int ibv_cmd_dereg_mr(struct ibv_mr *mr);
>  int ibv_cmd_create_cq(struct ibv_context *context, int cqe,
>  		      struct ibv_comp_channel *channel,
> diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-ab=
i.h
> index 800c5ab..8bab69f 100644
> --- a/include/infiniband/kern-abi.h
> +++ b/include/infiniband/kern-abi.h
> @@ -362,6 +362,26 @@ struct ibv_reg_mr_resp {
>  	__u32 rkey;
>  };
> =20
> +struct ibv_rereg_mr {
> +	__u32 command;
> +	__u16 in_words;
> +	__u16 out_words;
> +	__u64 response;
> +	__u32 mr_handle;
> +	__u32 flags;
> +	__u64 start;
> +	__u64 length;
> +	__u64 hca_va;
> +	__u32 pd_handle;
> +	__u32 access_flags;
> +	__u64 driver_data[0];
> +};
> +
> +struct ibv_rereg_mr_resp {
> +	__u32 lkey;
> +	__u32 rkey;
> +};
> +
>  struct ibv_dereg_mr {
>  	__u32 command;
>  	__u16 in_words;
> diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
> index 48e868c..69e4e29 100644
> --- a/include/infiniband/verbs.h
> +++ b/include/infiniband/verbs.h
> @@ -411,7 +411,8 @@ enum ibv_rereg_mr_flags {
>  	IBV_REREG_MR_CHANGE_TRANSLATION	=3D (1 << 0),
>  	IBV_REREG_MR_CHANGE_PD		=3D (1 << 1),
>  	IBV_REREG_MR_CHANGE_ACCESS	=3D (1 << 2),
> -	IBV_REREG_MR_KEEP_VALID		=3D (1 << 3)
> +	IBV_REREG_MR_KEEP_VALID		=3D (1 << 3),
> +	IBV_REREG_MR_FLAGS_SUPPORTED	=3D ((IBV_REREG_MR_KEEP_VALID << 1) - 1)=

>  };
> =20
>  struct ibv_mr {
> @@ -1228,6 +1229,12 @@ struct ibv_mr *ibv_reg_mr(struct ibv_pd *pd, voi=
d *addr,
>  			  size_t length, int access);
> =20
>  /**
> + * ibv_rereg_mr - Re-Register a memory region
> + */
> +int ibv_rereg_mr(struct ibv_mr *mr, int flags,
> +		 struct ibv_pd *pd, void *addr,
> +		 size_t length, int access);
> +/**
>   * ibv_dereg_mr - Deregister a memory region
>   */
>  int ibv_dereg_mr(struct ibv_mr *mr);
> diff --git a/man/ibv_rereg_mr.3 b/man/ibv_rereg_mr.3
> new file mode 100644
> index 0000000..ccb03cf
> --- /dev/null
> +++ b/man/ibv_rereg_mr.3
> @@ -0,0 +1,62 @@
> +.\" -*- nroff -*-
> +.\"
> +.TH IBV_REREG_MR 3 2014-08-27 libibverbs "Libibverbs Programmer's Manu=
al"
> +.SH "NAME"
> +ibv_rereg_mr \- re-register a memory region (MR)
> +.SH "SYNOPSIS"
> +.nf
> +.B #include <infiniband/verbs.h>
> +.sp
> +.BI "int ibv_rereg_mr(struct ibv_mr " "*mr" ", int " " flags" ,
> +.BI "                 struct ibv_pd * " "pd" ", void " " *addr",
> +.BI "                 size_t " " length" ", int " " access");
> +.fi
> +.fi
> +.SH "DESCRIPTION"
> +.B ibv_rereg_mr()
> +Modifies the attributes of an existing memory region (MR)
> +.I mr\fR.
> +Conceptually, this call performs the functions deregister memory regio=
n
> +followed by register memory region.  Where possible,
> +resources are reused instead of deallocated and reallocated.
> +.PP
> +.I flags\fR
> +is a bit-mask used to indicate which of the following properties of th=
e memory region are being modified. Flags should be a combination (bit fi=
eld) of:
> +.PP
> +.TP
> +.B IBV_REREG_MR_CHANGE_TRANSLATION \fR Change translation (location an=
d length)
> +.TP
> +.B IBV_REREG_MR_CHANGE_PD \fR Change protection domain
> +.TP
> +.B IBV_REREG_MR_CHANGE_ACCESS \fR Change access flags
> +.PP
> +When
> +.B IBV_REREG_MR_CHANGE_PD
> +is used,
> +.I pd\fR
> +represents the new PD this MR should be registered to.
> +.br
> +When
> +.B IBV_REREG_MR_CHANGE_TRANSLATION
> +is used,
> +.I addr\fR.
> +represents the virtual address (user-space pointer) of the new MR, whi=
le
> +.I length\fR
> +represents its length.
> +.PP
> +The access and other flags are represented in the field
> +.I access\fR.
> +This field describes the desired memory protection attributes; it is e=
ither 0 or the bitwise OR of one or more of ibv_access_flags.
> +.TP
> +.SH "RETURN VALUE"
> +.B ibv_rereg_mr()
> +returns 0 on success, or the value of errno on failure (which indicate=
s the failure reason).
> +.SH "NOTES"
> +If the memory re-registration call failed, the MR shouldn't be used.
> +Even on a failure, the user still needs to call ibv_dereg_mr on this M=
R.
> +.SH "SEE ALSO"
> +.BR ibv_reg_mr (3),
> +.BR ibv_dereg_mr (3),
> +.SH "AUTHORS"
> +.TP
> +Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> diff --git a/src/cmd.c b/src/cmd.c
> index e1914e9..e5a32bc 100644
> --- a/src/cmd.c
> +++ b/src/cmd.c
> @@ -334,6 +334,35 @@ int ibv_cmd_reg_mr(struct ibv_pd *pd, void *addr, =
size_t length,
>  	return 0;
>  }
> =20
> +int ibv_cmd_rereg_mr(struct ibv_mr *mr, uint32_t flags, void *addr,
> +		     size_t length, uint64_t hca_va, int access,
> +		     struct ibv_pd *pd, struct ibv_rereg_mr *cmd,
> +		     size_t cmd_sz, struct ibv_rereg_mr_resp *resp,
> +		     size_t resp_sz)
> +{
> +	IBV_INIT_CMD_RESP(cmd, cmd_sz, REREG_MR, resp, resp_sz);
> +
> +	cmd->mr_handle	  =3D mr->handle;
> +	cmd->flags	  =3D flags;
> +	cmd->start	  =3D (uintptr_t)addr;
> +	cmd->length	  =3D length;
> +	cmd->hca_va	  =3D hca_va;
> +	cmd->pd_handle	  =3D (flags & IBV_REREG_MR_CHANGE_PD) ? pd->handle : =
0;
> +	cmd->access_flags =3D access;
> +
> +	if (write(mr->context->cmd_fd, cmd, cmd_sz) !=3D cmd_sz)
> +		return errno;
> +
> +	(void)VALGRIND_MAKE_MEM_DEFINED(resp, resp_sz);
> +
> +	mr->lkey    =3D resp->lkey;
> +	mr->rkey    =3D resp->rkey;
> +	if (flags & IBV_REREG_MR_CHANGE_PD)
> +		mr->context =3D pd->context;
> +
> +	return 0;
> +}
> +
>  int ibv_cmd_dereg_mr(struct ibv_mr *mr)
>  {
>  	struct ibv_dereg_mr cmd;
> diff --git a/src/libibverbs.map b/src/libibverbs.map
> index 3b40a0f..cbccca7 100644
> --- a/src/libibverbs.map
> +++ b/src/libibverbs.map
> @@ -112,5 +112,6 @@ IBVERBS_1.1 {
>  		ibv_cmd_create_srq_ex;
>  		ibv_cmd_create_qp_ex;
>  		ibv_cmd_open_qp;
> +		ibv_cmd_rereg_mr;
> =20
>  } IBVERBS_1.0;
> diff --git a/src/verbs.c b/src/verbs.c
> index ada3515..5938ba0 100644
> --- a/src/verbs.c
> +++ b/src/verbs.c
> @@ -228,6 +228,62 @@ struct ibv_mr *__ibv_reg_mr(struct ibv_pd *pd, voi=
d *addr,
>  }
>  default_symver(__ibv_reg_mr, ibv_reg_mr);
> =20
> +int __ibv_rereg_mr(struct ibv_mr *mr, int flags,
> +		   struct ibv_pd *pd, void *addr,
> +		   size_t length, int access)
> +{
> +	int dofork_onfail =3D 0;
> +	int err;
> +	void *old_addr;
> +	size_t old_len;
> +
> +	if (flags & ~IBV_REREG_MR_FLAGS_SUPPORTED) {
> +		errno =3D EINVAL;
> +		return errno;
> +	}
> +
> +	if ((flags & IBV_REREG_MR_CHANGE_TRANSLATION) &&
> +	    (!length || !addr)) {
> +		errno =3D EINVAL;
> +		return errno;
> +	}
> +
> +	if (access && !(flags & IBV_REREG_MR_CHANGE_ACCESS)) {
> +		errno =3D EINVAL;
> +		return errno;
> +	}
> +
> +	if (!mr->context->ops.rereg_mr) {
> +		errno =3D ENOSYS;
> +		return errno;
> +	}
> +
> +	if (flags & IBV_REREG_MR_CHANGE_TRANSLATION) {
> +		err =3D ibv_dontfork_range(addr, length);
> +		if (err)
> +			return err;
> +		dofork_onfail =3D 1;
> +	}
> +
> +	old_addr =3D mr->addr;
> +	old_len =3D mr->length;
> +	err =3D mr->context->ops.rereg_mr(mr, flags, pd, addr, length, access=
);
> +	if (!err) {
> +		if (flags & IBV_REREG_MR_CHANGE_TRANSLATION) {
> +			ibv_dofork_range(old_addr, old_len);
> +			mr->addr    =3D addr;
> +			mr->length  =3D length;
> +		}
> +		if (flags & IBV_REREG_MR_CHANGE_PD)
> +			mr->pd =3D pd;
> +	} else if (dofork_onfail) {
> +		ibv_dofork_range(addr, length);

Although extremely unlikely, if the ibv_dofork_range fails, which it can
for temporary resource issues or the like, then this function will leave
things in an incorrect state and return success to the caller.  It
probably needs the return values enumerated in the man page along with
which ones leave the original memory range intact and which ones leave
things in an unknown state where the user would be well advised to
remove and recreate the existing memory region.

Other than that I'm OK with the patch.  Please fix this up and respin.

> +	}
> +
> +	return err;
> +}
> +default_symver(__ibv_rereg_mr, ibv_rereg_mr);
> +
>  int __ibv_dereg_mr(struct ibv_mr *mr)
>  {
>  	int ret;
>=20



--XcBCgH7ucG364XnP3B4Wj8rtnBDDIb26R--

--2lGjBr7dxVhRQ4aJpdXWmwWT0X7mJx6MT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW16HBAAoJELgmozMOVy/dcTwP/09b02H8qkxFEU7tZhNWjjZP
IvtyYIpwz60Krs8LBd+Hxm5pnGhFi++821k9ELGd64Ong7CbE+Sp9ubiLJIUTCNI
6l3VD8sNuW1gRmegAWUaihyzZZB5IKe0V9Tfmg+S5gNNE2DcH2tT2O0twkIJdZ6x
7M7kgOKqpMi+MP9BH4l2lgbTG2Hx76bHBq4BRr/8hmZOyp0EIYr82F7LDU4nE2Y7
WfoQ4p/4zEuC4JLET8HeH6dNVpcEM89RQVm1pHlw9c1ETAaeV9SP/doZjtAYIUPM
AcemHNHL+WxzZmRF1aC/Ce04fgkgnFNVuWVyE1iWf4BzLaCghmqwXPgCyKwtdit3
lYDHJNfTagltxH78NHuW4ZGcC+VZ+oqQW79DFanWCkQH26RukXHFZ0IxyZzreGG6
4K/igfHe/0wOQMpmWnSIvUv+D1dlws/pREjeAKYegOG9lJn+ZDqUhrJ/Y5SWHhvg
Ej5CvhdguchqfGF3lnHagWfyQL6ZFMc1s9FkdK0KxAHxCz95bIP934DF72qTXxc5
n+/fKcCPlWrnfIq+N0q5cfS4vxUejHs0PHaJGQ9p9sAsdpQmRNTyKmnRJ8MwUDn1
31QhAmh7pBphX4UKLb/M86K5Nq5EftsWev0WyFQ0nHEwrcdKO5al6KByFYNkKCJc
Irw0Hgp7GCfEJqZxt0na
=xKyv
-----END PGP SIGNATURE-----

--2lGjBr7dxVhRQ4aJpdXWmwWT0X7mJx6MT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
