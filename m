From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: srp state in current mainline
Date: Mon, 16 Nov 2015 00:38:07 -0800
Message-ID: <20151116083807.GB22156@infradead.org>
References: <20151110171509.GA27781@infradead.org>
 <20151115180621.GA24488@infradead.org>
 <5648E178.9010106@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5648E178.9010106-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 15, 2015 at 11:48:08AM -0800, Bart Van Assche wrote:
> Did I understand correctly that page-aligned I/O works fine but I/O that is
> not aligned on a page boundary not ? Have you already had the time to verify
> whether the "IB/srp: Convert to new registration API" patch is the patch
> that introduced this issue ?

Hi Bart,

I haven't figured out what doesn't work.  This was just a wild guess
what could be different in XFS.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
