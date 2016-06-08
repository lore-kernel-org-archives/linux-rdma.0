From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH v1 09/20] xprtrdma: Limit the number of rpcrdma_mws
Date: Wed, 8 Jun 2016 11:40:14 -0600
Message-ID: <20160608174014.GB30822@obsidianresearch.com>
References: <20160607194001.18401.88592.stgit@manet.1015granger.net>
 <20160607194732.18401.71941.stgit@manet.1015granger.net>
 <20160607204941.GA7991@obsidianresearch.com>
 <F1820E16-A2BF-4529-A5C9-59C9AD57369A@oracle.com>
 <20160607212831.GA9192@obsidianresearch.com>
 <D90190F5-ACCB-45D8-B08D-B75023ED6240@oracle.com>
 <20160607220107.GA9982@obsidianresearch.com>
 <c43e37cd-71ea-8629-20f2-bcd674d50b83@talpey.com>
 <8FF9BF11-C5BF-4418-9A84-AAD7A6D6321D@primarydata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8FF9BF11-C5BF-4418-9A84-AAD7A6D6321D-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Trond Myklebust <trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Cc: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 08, 2016 at 03:06:56PM +0000, Trond Myklebust wrote:

>    That would be a mount parameter which would only apply to RDMA sin=
ce
>    everything else uses dynamic slot allocation these days. I=E2d pre=
fer to
>    avoid that.

The only reason RDMA cannot allocate MRs on the fly is
performance.. Maybe a dynamic scheme is the right answer..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
