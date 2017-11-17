From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core v4 0/4] ibacm: acmp retry issues
Date: Thu, 16 Nov 2017 17:11:56 -0700
Message-ID: <20171117001156.GB4276@ziepe.ca>
References: <20171115193155.470.85049.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171115193155.470.85049.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 15, 2017 at 02:34:25PM -0500, Michael J. Ruhl wrote:
> While testing the retry mechanism for the acmp provider, I observed
> that the retry event_wait() did not appear to be working correctly.
> After studying the issue a bit more, I discovered that there were a
> couple of issues.

I don't see anything else wrong with this, thanks for being so
dilligent.

Reviewed-by: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
