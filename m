From: santosh shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Future of FMR support, was: Re: [PATCH v1 5/9] xprtrdma: Add
 ro_unmap_sync method for FMR
Date: Wed, 25 Nov 2015 11:17:41 -0800
Message-ID: <56560955.2080705@oracle.com>
References: <20151123220627.32702.62667.stgit@manet.1015granger.net>
 <20151123221430.32702.86114.stgit@manet.1015granger.net>
 <5653B606.3070700@talpey.com> <20151124065225.GB29141@infradead.org>
 <5654DC7A.7080807@oracle.com> <20151125090009.GA11255@infradead.org>
 <5655EB40.8070508@oracle.com>
 <CAJ3xEMgC5aa8pvvvs0y8O+h_WBk-em07gHvOgP=DFDrv4ydGAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMgC5aa8pvvvs0y8O+h_WBk-em07gHvOgP=DFDrv4ydGAg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/25/2015 10:22 AM, Or Gerlitz wrote:
> On Wed, Nov 25, 2015 at 7:09 PM, santosh shilimkar
> <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>>> As already indicated to Sagi [1], RDS IB FR support is work in
>>>> progress and I was hoping to get it ready for 4.5.
>
> These are really good news! can you please elaborate a bit on the
> design changes this move introduced in RDS?
>
Yeah. It has been a bit of pain point since the need
was to keep the RDS design same and retrofit the FR
support so that it can co-exist with existing deployed
FMR code.

Leaving the details for the code review but at very high
level,

- Have to split the poll CQ handling so that
send + FR WR completion can be handled together.
FR CQ handler and reg/inv WR prep marks the MR state
like INVALID, VALID & STALE appropriately.
- Allocate 2X space on WR and WC queues during queue setup.
- Manage the MR reg/inv based on the space available
in FR WR ring(actually it is just a counter). This is
bit tricky because RDS does MR operation via sendmsg()
as well as directly through socket APIs so needs
co-ordination.

Am hoping that above remains true when code actually
makes to the list but that is how things stand as
of now.

Regards,
Santosh

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
