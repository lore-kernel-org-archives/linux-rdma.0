From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: buildlib/cbuild missing yaml on SLE12SP2
Date: Tue, 6 Dec 2016 13:15:08 -0700
Message-ID: <20161206201507.GA29370@obsidianresearch.com>
References: <02cc01d24ffb$79ad93d0$6d08bb70$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <02cc01d24ffb$79ad93d0$6d08bb70$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 06, 2016 at 02:01:04PM -0600, Steve Wise wrote:
> Hey Jason, 
> 
> I'm trying to run buildlib/cbuild build-images travis on rdma-core, and I'm
> missing yaml.  But I think I have it installed.  At least I have perl_YAML
> installed.  This is with SLE12 SP2 RC1.

You need python-yaml

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
