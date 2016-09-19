From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH libibverbs v2 3/3] Provide remote XRC SRQ number in
 kernel post_send.
Date: Mon, 19 Sep 2016 08:29:11 +0300
Message-ID: <20160919052911.GF3273@leon.nu>
References: <cover.0e6854f557aa8aa6ed7681cdf58397ef4f106505.1474063039.git-series.knut.omang@oracle.com>
 <d57e9dc45f6f4aed9dfb86a498226dab99e530a4.1474063039.git-series.knut.omang@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UBnjLfzoMQYIXCvq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d57e9dc45f6f4aed9dfb86a498226dab99e530a4.1474063039.git-series.knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--UBnjLfzoMQYIXCvq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 17, 2016 at 05:59:13AM +0200, Knut Omang wrote:
> Also proper end align the ibv_kern_send_wr struct.
>
> Requires a corresponding kernel change.
>
> Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  include/infiniband/kern-abi.h | 1 +
>  src/cmd.c                     | 2 ++
>  2 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
> index 8bdeef5..7b1d310 100644
> --- a/include/infiniband/kern-abi.h
> +++ b/include/infiniband/kern-abi.h
> @@ -800,6 +800,7 @@ struct ibv_kern_send_wr {
>  	union {
>  		struct {
>  			__u32 remote_srqn;
> +			__u32 reserved;
>  		} xrc;
>  	} qp_type;
>  };
> diff --git a/src/cmd.c b/src/cmd.c
> index a418ee1..a4e2f75 100644
> --- a/src/cmd.c
> +++ b/src/cmd.c
> @@ -1293,6 +1293,8 @@ int ibv_cmd_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
>  			tmp->wr.ud.remote_qpn  = i->wr.ud.remote_qpn;
>  			tmp->wr.ud.remote_qkey = i->wr.ud.remote_qkey;
>  		} else {
> +			if (ibqp->qp_type == IBV_QPT_XRC_SEND)
> +				tmp->qp_type.xrc.remote_srqn = i->qp_type.xrc.remote_srqn;

It will be checked for all QPTs and for all consumers. Any chances to
optimize it?

>  			switch (i->opcode) {
>  			case IBV_WR_RDMA_WRITE:
>  			case IBV_WR_RDMA_WRITE_WITH_IMM:
> --
> git-series 0.8.10
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--UBnjLfzoMQYIXCvq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX33emAAoJEORje4g2clin6OkP/jD0VFBXf+t3f6lzRM+j+6m/
IBiroBIvL7u4wkA3DZxq1dTXMoBuMe6SRVnXQocNEH6rfbulV5RuG3slIRqzA3uV
Oyh0aOraNfJE0wTcH2AuWa3eFsx8YaQectQqXjx5RgKaieIS+sHkcGF1U4abVFvW
kdRv+gX6XOKHz79Mq+anRl1+lAX7Aeskjpzn8tnrW6/4DDH9MXQbnUSlQ2qrzza9
7XuoJrF0aoiHFAIxboW20ROcd/kFcIjfFzW1uYpc/iRcWWsvTiDuBG38mH4QqGj/
174obOyuw0v934o9QVxAzLo+hsWqwtsRNr4jgu2HO6KN/JeiVTFPDBdbjUoaAUhN
gCKxOz4LXU/QD0ya3Mdwu4mYLDwdmXr8CSxEdYSKCophL2ZyIpCa+JJzBnkjDR0A
A4l7fQo9RcDATjRWTAXdfgcvDVdamBXvK9aykgRnD7iRCz3xirmbxD1iMeFIo59v
yM6ciNZzTlq2ZO7XN3pmiWW/ZxFeIxa9GHzkzRgDkREqMjWqJmSOhTvgYbAajMy9
GJzF6dGYi3KZJWaneADHgbi6Wl+QMpgksPbWRS3nB8ssUAHmbU/0L2ezJZnlH1qU
TWXzNEZy8iYx+JOr2wBHWzYrTiVG2kyRbvI//jb5gEUEgxqMxo0oIgE/fOMbxqPu
cZAN5/yCw8fgJU1bCzvO
=8B/1
-----END PGP SIGNATURE-----

--UBnjLfzoMQYIXCvq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
