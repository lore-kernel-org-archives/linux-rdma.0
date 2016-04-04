From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH V2] nfs: add mount proto=rdma6 option for NFS/RDMA IPv6
 addressing
Date: Mon, 4 Apr 2016 22:50:20 +0300
Message-ID: <20160404195020.GH5264@leon.nu>
References: <56E9A650.7060409@oracle.com>
 <56F19F28.9020504@Netapp.com>
 <5702AF3F.90500@oracle.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5702AF3F.90500-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Chuck Lever <Chuck.Lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 04, 2016 at 11:15:27AM -0700, Shirley Ma wrote:
> RFC 5666: The "rdma" netid is to be used when IPv4 addressing
> is employed by the underlying transport, and "rdma6" for IPv6
> addressing.
> Add mount -o proto=rdma6 option to support NFS/RDMA IPv6 addressing.
> 
> Changes from v1:
>  - Integrated comments from Chuck Level, Anna Schumaker, Trodt Myklebust
>  - Add a little more to the patch description to describe NFS/RDMA
>    IPv6 usage
>  - Removed duplicated rdma6 define
>  - Removed Opt_xprt_rdma mountfamily since this doesn't support 
> 
> Signed-off-by: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

It will be great if you can update the Documentation too.

Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
