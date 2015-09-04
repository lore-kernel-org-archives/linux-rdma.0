From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs] Add support for TX/RX checksum offload
Date: Fri, 4 Sep 2015 19:41:49 -0400
Message-ID: <55EA2C3D.2080904@redhat.com>
References: <1439826618-3015-1-git-send-email-bodong@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tA6xS3aIMoIQcw0TkDWXx4WSgmVahjK0T"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439826618-3015-1-git-send-email-bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tA6xS3aIMoIQcw0TkDWXx4WSgmVahjK0T
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/17/2015 11:50 AM, Bodong Wang wrote:
> Add a device capability flag IBV_DEVICE_IP_CSUM to denote IPv4 checksum=

> offload support. Devices should set this flag if they support
> insertion/verification of IPv4, TCP and UDP checksums on
> outgoing/incoming IPv4 packets sent over IB UD or ETH RAW PACKET QPs.

Correct me if I'm wrong, but the only reason this is only supported on
UD and RAW ETH QPs is a matter of current firmware.  There's no reason
it couldn't be supported on RC, right?

I know I'm probably not going to get an answer to that before I'm done
doing what I'm going to do, so I'm going to write a patch on the basis
that the above is true.  Because if it is, then I *really* don't like
putting the QP types supported into the API.  Instead, I think this
calls for a query_qp_ex verb to be added, and a new struct item,
qp_caps, and in that we can signal if this specific QP supports IP
checksum offload.

>=20
> Flags IBV_SEND_IP_CSUM and IBV_WC_IP_CSUM_OK are added for utilizing th=
is
> capability for send and receive separately.
>=20
> Change-Id: Ie02d708dcbef07ca0d2eac1b156f12aafdba6a97
> Signed-off-by: Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  include/infiniband/verbs.h | 11 +++++++++--
>  man/ibv_poll_cq.3          |  3 +++
>  man/ibv_post_send.3        |  4 ++++
>  3 files changed, 16 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
> index 28e1586..6ae7e6e 100644
> --- a/include/infiniband/verbs.h
> +++ b/include/infiniband/verbs.h
> @@ -115,6 +115,7 @@ enum ibv_device_cap_flags {
>  	IBV_DEVICE_RC_RNR_NAK_GEN	=3D 1 << 12,
>  	IBV_DEVICE_SRQ_RESIZE		=3D 1 << 13,
>  	IBV_DEVICE_N_NOTIFY_CQ		=3D 1 << 14,
> +	IBV_DEVICE_IP_CSUM		=3D 1 << 18,
>  	IBV_DEVICE_XRC			=3D 1 << 20,
>  	IBV_DEVICE_MANAGED_FLOW_STEERING =3D 1 << 29
>  };
> @@ -314,9 +315,14 @@ enum ibv_wc_opcode {
>  	IBV_WC_RECV_RDMA_WITH_IMM
>  };
> =20
> +enum {
> +	IBV_WC_IP_CSUM_OK_SHIFT	=3D 2
> +};
> +
>  enum ibv_wc_flags {
>  	IBV_WC_GRH		=3D 1 << 0,
> -	IBV_WC_WITH_IMM		=3D 1 << 1
> +	IBV_WC_WITH_IMM		=3D 1 << 1,
> +	IBV_WC_IP_CSUM_OK	=3D 1 << IBV_WC_IP_CSUM_OK_SHIFT
>  };
> =20
>  struct ibv_wc {
> @@ -653,7 +659,8 @@ enum ibv_send_flags {
>  	IBV_SEND_FENCE		=3D 1 << 0,
>  	IBV_SEND_SIGNALED	=3D 1 << 1,
>  	IBV_SEND_SOLICITED	=3D 1 << 2,
> -	IBV_SEND_INLINE		=3D 1 << 3
> +	IBV_SEND_INLINE		=3D 1 << 3,
> +	IBV_SEND_IP_CSUM	=3D 1 << 4
>  };
> =20
>  struct ibv_sge {
> diff --git a/man/ibv_poll_cq.3 b/man/ibv_poll_cq.3
> index 57c6daa..539940d 100644
> --- a/man/ibv_poll_cq.3
> +++ b/man/ibv_poll_cq.3
> @@ -50,6 +50,9 @@ It is either 0 or the bitwise OR of one or more of th=
e following flags:
>  .B IBV_WC_GRH \fR      GRH is present (valid only for UD QPs)
>  .TP
>  .B IBV_WC_WITH_IMM \fR Immediate data value is valid
> +.TP
> +.B IBV_WC_IP_CSUM_OK \fR TCP/UDP checksum over IPv4 and IPv4 header ch=
ecksum are verified.
> +This feature is supported only when \fBIBV_DEVICE_IP_CSUM\fR flag is s=
et in the device capability flags.
>  .PP
>  Not all
>  .I wc
> diff --git a/man/ibv_post_send.3 b/man/ibv_post_send.3
> index 33fbb50..3b07bcb 100644
> --- a/man/ibv_post_send.3
> +++ b/man/ibv_post_send.3
> @@ -98,6 +98,10 @@ The attribute send_flags describes the properties of=
 the \s-1WR\s0. It is either
>  .TP
>  .B IBV_SEND_INLINE \fR Send data in given gather list as inline data
>  in a send WQE.  Valid only for Send and RDMA Write.  The L_Key will no=
t be checked.
> ++.TP
> ++.B IBV_SEND_IP_CSUM \fR Offload the IPv4 and TCP/UDP checksum calcula=
tion.
> ++Valid only for QPs with Transport Service Type \fBIBV_QPT_UD\fR or \f=
BIBV_QPT_RAW_PACKET\fR.
> ++This feature supported only when \fBIBV_DEVICE_IP_CSUM\fR the flag is=
 set in the device capability flags.
>  .SH "RETURN VALUE"
>  .B ibv_post_send()
>  returns 0 on success, or the value of errno on failure (which indicate=
s the failure reason).
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--tA6xS3aIMoIQcw0TkDWXx4WSgmVahjK0T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6iw9AAoJELgmozMOVy/dwasQAJi031egEQTYnxNq1arZOxvG
wQ8cY29xa66TB64ulnhobP+taIUIkQi1EO3gPRZuh7gsKW4xCXJ3wIgzWjUmW4OQ
qjc7Kbe1ke8crez4MHxXwRAGtMcA1LjHJ11vM5GC9MGFsxHpB+pwLa4++GknEeqz
PyXivlJdGZw9OVd9Di/NbwC77e4KAY6sFBMaa17jVntAo8yE1XwIW9TrGeLNqhq6
gGfdDy34IF5p+z8UDliG08S09le1lewLVvgO+ROOladJiTpI3FCyA6r275AHUTTe
qS22GY+AuqFhXvjc0T56CoRVoe5sa1BhA/fkHMeuoJlNUfmVnkEAoVRk7DQ6GV2A
C5xFZIg9O8Y03CE0xsmP9JusLnXvxNQYjobxVy5YYkYo2LNGwYc63gpyMNE+wAcG
JeudPOU8vEYubBHK0rx73k2n1g7TFjZ7McsOp50JP77jiRJuWjpyI0Y/HvSkE5ar
OgM0hoCpbngphhBAc5SPOvAgDp4sBr9erQhTyNeDs9YT406dR/VfQogvC1GDk5kR
u4bGBLE2K+5mF4+qKNpxxbkeUYp1kh/rbDHd483m6p2+SGSlAWxqBnPc5zheme9d
/ZnV3nzqEwAQ7inqfseV6A/WVl6CACnHuisIKqSxovUOREn2gnCTcV5kPFXBH41f
ytlj89hrfe51kCS7Jt2n
=a6fB
-----END PGP SIGNATURE-----

--tA6xS3aIMoIQcw0TkDWXx4WSgmVahjK0T--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
