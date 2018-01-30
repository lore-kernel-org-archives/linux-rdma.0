From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: NULL ptr dereference in rpcrdma_regbuf_is_mapped
Date: Tue, 30 Jan 2018 11:46:41 -0500
Message-ID: <0AEFFE48-ECD8-40A4-87EB-D78B1D1686B0@oracle.com>
References: <CY1PR0701MB2012AAA5AC6B70B3E2EA5B7E88E40@CY1PR0701MB2012.namprd07.prod.outlook.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY1PR0701MB2012AAA5AC6B70B3E2EA5B7E88E40-UpKza+2NMNLHMJvQ0dyT705OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> On Jan 30, 2018, at 11:43 AM, Kalderon, Michal =
<Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> wrote:
>=20
> Hi Chuck,=20
>=20
> Different issue, so started different thread.=20
> If I unload our driver while there is an open NFS connection I get a =
null pointer dereference in rpcrdma_regbuf_is_mapped
> the pointer to buf received in this function is NULL.

Hi Michal, let's see the backtrace.


> If I check buf for NULL and return false I am able to unload the =
driver, though I'm not sure this is sufficient.
>=20
> diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h =
b/net/sunrpc/xprtrdma/xprt_rdma.h
> index 1342f743..73066a6 100644
> --- a/net/sunrpc/xprtrdma/xprt_rdma.h
> +++ b/net/sunrpc/xprtrdma/xprt_rdma.h
> @@ -588,7 +588,7 @@ struct rpcrdma_regbuf =
*rpcrdma_alloc_regbuf(size_t, enum dma_data_direction,
> static inline bool
> rpcrdma_regbuf_is_mapped(struct rpcrdma_regbuf *rb)
> {
> -       return rb->rg_device !=3D NULL;
> +       return rb && (rb->rg_device !=3D NULL);
> :
>=20
>=20
> Will be great if you could take a look=20
> Thanks,
> Michal
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
