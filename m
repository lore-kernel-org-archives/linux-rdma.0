From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: srp state in current mainline
Date: Sun, 22 Nov 2015 07:10:34 -0800
Message-ID: <20151122151034.GA29240@infradead.org>
References: <20151110171509.GA27781@infradead.org>
 <20151122135343.GA11703@infradead.org>
 <20151122143215.GA14667@infradead.org>
 <5651D775.9090500@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5651D775.9090500-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 22, 2015 at 04:55:49PM +0200, Sagi Grimberg wrote:
> >>Also note that 4.4-rc  prefer_fr=y register_always=n
> >>!register_always still blows up badly with XFS and ext4 due to
> >>data integrity errors.
> 
> So the register_always=N makes bad things happen? if we register
> all the frags we're OK (i.e. register_always=Y)?

No. register_always=Y is already broken in 4.3, but register_always=N is
now also broken in 4.4.

The 4.3+ issue that only affects register_always=Y is the FR mapping
of the indirect buffer that is not accounted for.

The 4.4+ issue that also affects register_always=N is something in your
MR patches when we hit a gappy SG list.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
