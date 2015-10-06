From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-rc] xprtrdma: Don't require LOCAL_DMA_LKEY support for fasterg
Date: Tue, 6 Oct 2015 11:05:53 -0400
Message-ID: <56C57483-17AA-47FF-8743-E1522BD8C351@oracle.com>
References: <1444124889-8957-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444124889-8957-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sagi-


> On Oct 6, 2015, at 5:48 AM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>=20
> There is no need to require LOCAL_DMA_LKEY support in order to
> use fast registration as the PD allocation makes sure that there
> is a local_dma_lkey.

In other words, all devices now have a local DMA lkey, so the
check is unnecessary.


> This caused a NULL pointer dereference in mlx5 which removed
> the support for LOCAL_DMA_LKEY.

Where was the bad dereference? in mlx5, or in xprtrdma?


> Fixes: bb6c96d72879 ("xprtrdma: Replace global lkey with lkey local t=
o PD")
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> net/sunrpc/xprtrdma/verbs.c |    7 ++-----
> 1 files changed, 2 insertions(+), 5 deletions(-)
>=20
> diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.=
c
> index eb081ad..7efd9ef 100644
> --- a/net/sunrpc/xprtrdma/verbs.c
> +++ b/net/sunrpc/xprtrdma/verbs.c
> @@ -543,11 +543,8 @@ rpcrdma_ia_open(struct rpcrdma_xprt *xprt, struc=
t sockaddr *addr, int memreg)
> 	}
>=20
> 	if (memreg =3D=3D RPCRDMA_FRMR) {
> -		/* Requires both frmr reg and local dma lkey */
> -		if (((devattr->device_cap_flags &
> -		     (IB_DEVICE_MEM_MGT_EXTENSIONS|IB_DEVICE_LOCAL_DMA_LKEY)) !=3D
> -		    (IB_DEVICE_MEM_MGT_EXTENSIONS|IB_DEVICE_LOCAL_DMA_LKEY)) ||
> -		      (devattr->max_fast_reg_page_list_len =3D=3D 0)) {
> +		if (!(devattr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) ||
> +		    (devattr->max_fast_reg_page_list_len =3D=3D 0)) {
> 			dprintk("RPC:       %s: FRMR registration "
> 				"not supported by HCA\n", __func__);
> 			memreg =3D RPCRDMA_MTHCAFMR;

Reviewed-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>


=E2=80=94
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
