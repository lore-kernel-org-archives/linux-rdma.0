From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v1 00/22] convert NFS server to new rdma_rw API
Date: Sun, 8 Jan 2017 06:34:02 -0800
Message-ID: <20170108143402.GA2243@infradead.org>
References: <20170107170258.14126.8503.stgit@klimt.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170107170258.14126.8503.stgit-Hs+gFlyCn65vLzlybtyyYzGyq/o6K9yX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 07, 2017 at 12:15:15PM -0500, Chuck Lever wrote:
> This series converts the Linux NFS server RPC-over-RDMA
> implementation to use the new core rdma_rw API and to poll its CQs
> in workqueue mode.
> 
> Previously published work prototyped only the path that sends RPC
> replies. This series converts both send and receive sides, and
> includes significant clean ups that result from using the new API.
> 
> This series has been successfully tested with NFSv3, 4.0, and 4.1;
> with clients that use FRWR and FMR; and with sec=sys, krb5, krb5i,
> and krb5p.

Any performane improvements (or regressions) with it?

>  10 files changed, 1621 insertions(+), 1656 deletions(-)

Hmm, that's not much less code, especially compared to the
other target side drivers where we remove a very substantial amount of
code.  I guess I need to spend some time with the individual patches
to understand why.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
