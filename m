From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Future of FMR support, was: Re: [PATCH v1 5/9] xprtrdma: Add
 ro_unmap_sync method for FMR
Date: Wed, 25 Nov 2015 20:22:07 +0200
Message-ID: <CAJ3xEMgC5aa8pvvvs0y8O+h_WBk-em07gHvOgP=DFDrv4ydGAg@mail.gmail.com>
References: <20151123220627.32702.62667.stgit@manet.1015granger.net>
	<20151123221430.32702.86114.stgit@manet.1015granger.net>
	<5653B606.3070700@talpey.com>
	<20151124065225.GB29141@infradead.org>
	<5654DC7A.7080807@oracle.com>
	<20151125090009.GA11255@infradead.org>
	<5655EB40.8070508@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5655EB40.8070508-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: santosh shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 25, 2015 at 7:09 PM, santosh shilimkar
<santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>> As already indicated to Sagi [1], RDS IB FR support is work in
>>> progress and I was hoping to get it ready for 4.5.

These are really good news! can you please elaborate a bit on the
design changes this move introduced in RDS?
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
