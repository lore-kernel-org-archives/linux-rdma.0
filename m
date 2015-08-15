From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/core: Make ib_dealloc_pd return void
Date: Fri, 14 Aug 2015 20:27:47 -0600
Message-ID: <20150815022747.GA30693@obsidianresearch.com>
References: <20150805203431.GB30271@obsidianresearch.com>
 <55CE9043.1030804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55CE9043.1030804-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chien Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 14, 2015 at 09:05:07PM -0400, Doug Ledford wrote:

> I'm not sure I like this patch.  I have my concerns that this will
> make debugging and catching problems more difficult.
[..]
> The change you put in here will make note of the driver that fails to
> return a clean return, but the error happens elsewhere.

Eh? I don't understand your comments.

Nothing is lost, in your specific example instead of seeing the little
one line printk from IPoIB, you'd get instead a full blown WARN_ON
with a stack trace from here:

+	   WARN_ON(atomic_read(&pd->usecnt));

The stack trace still fingers IPoIB as the culprit, and a WARN_ON
strongly motivates bug reports.

If the above WARN_ON triggers it unconditionally represents a bug in
the caller. There is no correct way to use the old error return.

> It serves as a final check on the ULP, and to me that has value.

Yes, which is why this patch extends that same basic check to all ~50
call sites and every single ULP instead of only having it in only two
places.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
