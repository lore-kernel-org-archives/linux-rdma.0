From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 4/4] IB/core: Add IP to GID netlink offload
Date: Wed, 4 May 2016 15:33:37 -0600
Message-ID: <20160504213337.GA4469@obsidianresearch.com>
References: <1462376518-6725-1-git-send-email-leon@kernel.org>
 <1462376518-6725-5-git-send-email-leon@kernel.org>
 <20160504213211.GB10115@rhel.ra.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160504213211.GB10115-f85VyEmKvEatqXYlAKuG4QC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, May 04, 2016 at 05:32:12PM -0400, Ira Weiny wrote:

> support for the operation to the client.  If the client is not registered then
> it will need to be.  Who is responsible for the client registration and removal
> is the question.  IMO it is odd that the client registration is dynamic at
> all because we have an enum defining them.

Indeed, this dynamic stuff seems to be a side effect of too many
modules.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
