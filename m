From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Fwd: [PATCH] svcrdma: Do not send XDR roundup bytes for a write chunk
Date: Thu, 12 Nov 2015 09:47:13 -0500
Message-ID: <648A8847-9836-42EC-9D62-77C01C6E9ACF@oracle.com>
References: <20151112144433.13507.34603.stgit@klimt.1015granger.net>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I wish git send-mail had an address book. I=E2=80=99m really tired
of misspelling the to/cc addresses on patches.

Resending so there is one thread for all replies. Apologies
for the noise.


> Begin forwarded message:
>=20
> From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Subject: [PATCH] svcrdma: Do not send XDR roundup bytes for a write c=
hunk
> Date: November 12, 2015 at 9:44:33 AM EST
> To: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
> Cc: linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rmda-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>=20
> Minor optimization: when dealing with write chunk XDR roundup, do
> not post a Write WR for the zero bytes in the pad. Simply update
> the write segment in the RPC-over-RDMA header to reflect the extra
> pad bytes.
>=20
> The Reply chunk is also a write chunk, but the server does not use
> send_write_chunks() to send the Reply chunk. That's OK in this case:
> the server Upper Layer typically marshals the Reply chunk contents
> in a single contiguous buffer, without a separate tail for the XDR
> pad.
>=20
> The comments and the variable naming refer to "chunks" but what is
> really meant is "segments." The existing code sends only one
> xdr_write_chunk per RPC reply.
>=20
> The fix assumes this as well. When the XDR pad in the first write
> chunk is reached, the assumption is the Write list is complete and
> send_write_chunks() returns.
>=20
> That will remain a valid assumption until the server Upper Layer can
> support multiple bulk payload results per RPC.
>=20
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> net/sunrpc/xprtrdma/svc_rdma_sendto.c |    7 +++++++
> 1 file changed, 7 insertions(+)
>=20
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtr=
dma/svc_rdma_sendto.c
> index 1dfae83..6c48901 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
> @@ -342,6 +342,13 @@ static int send_write_chunks(struct svcxprt_rdma=
 *xprt,
> 						arg_ch->rs_handle,
> 						arg_ch->rs_offset,
> 						write_len);
> +
> +		/* Do not send XDR pad bytes */
> +		if (chunk_no && write_len < 4) {
> +			chunk_no++;
> +			break;
> +		}
> +
> 		chunk_off =3D 0;
> 		while (write_len) {
> 			ret =3D send_write(xprt, rqstp,
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever




--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
