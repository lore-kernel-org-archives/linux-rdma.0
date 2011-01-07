From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V4 5/6] RDMA CM: Netlink Client
Date: Fri, 7 Jan 2011 13:37:42 -0700
Message-ID: <20110107203742.GH1211@obsidianresearch.com>
References: <1294068834-17778-1-git-send-email-nirm@voltaire.com>
 <1294068834-17778-6-git-send-email-nirm@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1294068834-17778-6-git-send-email-nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 03, 2011 at 05:33:53PM +0200, Nir Muchtar wrote:
> Add callbacks and data types for statistics export.
> One callback is implemented that exports all of the current devices/ids.
> Add/remove the callback to IB Netlink on init/cleanup.

I don't have any new comments from this. If Sean and Roland are OK
with it then I think it should go in.

Please do update the git commit message for this to describe the
netlink message format so others can review it easily.

I think my points from earlier do need to be addressed in future
commits though:
 - We need an ifindex for RDMA devices
 - QP and IB CM information needs to be exported too
 - Info to make lsof work

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
