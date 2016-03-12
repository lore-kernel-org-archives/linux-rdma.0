From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH] nfs/rdma: add IPv6 rdma6 support
Date: Sat, 12 Mar 2016 12:50:46 +0200
Message-ID: <20160312105046.GC15703@leon.nu>
References: <56E35820.7070609@oracle.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56E35820.7070609-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Chuck Lever <Chuck.Lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Mar 11, 2016 at 03:43:28PM -0800, Shirley Ma wrote:
> Add rdma6 option to support NFS/RDMA IPv6.
> Allow both IPv4 and IPv6 to bind same port at the same time,
> and restricts use of the IPv6 socket to IPv6 communication.
> 
> Signed-off-by: shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org

The SOB is not valid.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
