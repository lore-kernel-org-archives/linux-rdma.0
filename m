From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V5 libibverbs 0/7] Completion timestamping
Date: Wed, 8 Jun 2016 13:14:12 -0600
Message-ID: <20160608191412.GA27089@obsidianresearch.com>
References: <1464786340-7630-1-git-send-email-yishaih@mellanox.com>
 <1b0ea11b-3762-2335-28dd-eb3ac243104e@redhat.com>
 <20160606233325.GA28769@obsidianresearch.com>
 <bd0b54e6-70ae-27b3-fe1e-8ee729e20479@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <bd0b54e6-70ae-27b3-fe1e-8ee729e20479-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 06, 2016 at 10:20:12PM -0400, Doug Ledford wrote:

> Judging by the way yours and mines conversation went in v4 it seemed you
> were pretty much in favor of it.  If you have specific objections,
> please raise them, we can do incremental fixes.

In favor of the general approach, there were still lots of details to
be delt with, including what QPs can be joined, the exact set of
accessors and enablement flags, the compat layer, minor coding issues
and micro optimizations. Fruther, there hasn't seen sign off from any
other vendors which we said we wanted for these sorts of things.

All of these have been raised on the mailing list, but you killed the
discussion when you said you didn't like the series, so many issues
never reached a closure.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
