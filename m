From: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 09/10] NFS: SETCLIENTID XDR buffer sizes are incorrect
Date: Mon, 10 Nov 2014 10:22:50 -0500
Message-ID: <5460D84A.3050704@Netapp.com>
References: <20141109010328.8806.5861.stgit@manet.1015granger.net> <20141109011518.8806.36904.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141109011518.8806.36904.stgit-FYjufvaPoItvLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Chuck,

It looks like this patch and the next one are general client changes, so they might have to be submitted to Trond directly rather than going through my tree.  Trond, what do you think?

Anna

On 11/08/2014 08:15 PM, Chuck Lever wrote:
> Use the correct calculation of the maximum size of a clientaddr4
> when encoding and decoding SETCLIENTID operations. clientaddr4 is
> defined in section 2.2.10 of RFC3530bis-31.
>
> The usage in encode_setclientid_maxsz is missing the 4-byte length
> in both strings, but is otherwise correct. decode_setclientid_maxsz
> simply asks for a page of receive buffer space, which is
> unnecessarily large (more than 4KB).
>
> Note that a SETCLIENTID reply is either clientid+verifier, or
> clientaddr4, depending on the returned NFS status. It doesn't
> hurt to allocate enough space for both.
>
> Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/nfs/nfs4xdr.c |   10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
> index 206c08a..f8afa67 100644
> --- a/fs/nfs/nfs4xdr.c
> +++ b/fs/nfs/nfs4xdr.c
> @@ -141,13 +141,15 @@ static int nfs4_stat_to_errno(int);
>  				XDR_QUADLEN(NFS4_VERIFIER_SIZE) + \
>  				XDR_QUADLEN(NFS4_SETCLIENTID_NAMELEN) + \
>  				1 /* sc_prog */ + \
> -				XDR_QUADLEN(RPCBIND_MAXNETIDLEN) + \
> -				XDR_QUADLEN(RPCBIND_MAXUADDRLEN) + \
> +				1 + XDR_QUADLEN(RPCBIND_MAXNETIDLEN) + \
> +				1 + XDR_QUADLEN(RPCBIND_MAXUADDRLEN) + \
>  				1) /* sc_cb_ident */
>  #define decode_setclientid_maxsz \
>  				(op_decode_hdr_maxsz + \
> -				2 + \
> -				1024) /* large value for CLID_INUSE */
> +				2 /* clientid */ + \
> +				XDR_QUADLEN(NFS4_VERIFIER_SIZE) + \
> +				1 + XDR_QUADLEN(RPCBIND_MAXNETIDLEN) + \
> +				1 + XDR_QUADLEN(RPCBIND_MAXUADDRLEN))
>  #define encode_setclientid_confirm_maxsz \
>  				(op_encode_hdr_maxsz + \
>  				3 + (NFS4_VERIFIER_SIZE >> 2))
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
