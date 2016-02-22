From: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org (J. Bruce Fields)
Subject: Re: [PATCH v3 01/10] svcrdma: Do not write xdr_buf::tail in a Write
 chunk
Date: Mon, 22 Feb 2016 13:32:11 -0500
Message-ID: <20160222183211.GA22270@fieldses.org>
References: <20160218173840.12825.26769.stgit@klimt.1015granger.net>
 <20160218174353.12825.14732.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160218174353.12825.14732.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 18, 2016 at 12:43:53PM -0500, Chuck Lever wrote:
> The fix is to send only the contents of the xdr_buf's page list in
> a Write chunk.

This isn't quite right either.  A large-enough non-readlike reply will
use the page list if that's the only way to fit the reply.

You might be able to hit such cases, for example, using nfs4_getfacl on
a file with a sufficiently large ACL.

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
