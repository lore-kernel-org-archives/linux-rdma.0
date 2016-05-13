From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 0/5] Add scatter FCS support
Date: Fri, 13 May 2016 17:18:56 -0600
Message-ID: <20160513231856.GA18260@obsidianresearch.com>
References: <1460902778-5977-1-git-send-email-matanb@mellanox.com>
 <92e9a494-c363-db42-894c-17d67fe96ecc@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <92e9a494-c363-db42-894c-17d67fe96ecc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 13, 2016 at 04:39:23PM -0400, Doug Ledford wrote:

> This patchset is a uAPI extending patchset.  Recently, there has been
> talk of requiring a higher level of review and acknowledgment from
> various vendors for such patches.  However, in this case, it extends the
> QP creation code, which is already an extended function, and it extends
> it in a manner consistent with the original extension mechanism.

You've missed the point - the extension mechanism is explicitly not
for vendor-specific stuff, the question to ask is this FCS thing
driver specific, is it sufficiently general, and can other vendors
implement it.

I'd say yes to those questions, what it does seems well defined and
generic.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
