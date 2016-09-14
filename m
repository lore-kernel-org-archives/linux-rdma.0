From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 19/28] verbs: Avoid gcc 6.1 warning -Wunused-variable
Date: Wed, 14 Sep 2016 10:57:23 -0600
Message-ID: <20160914165723.GD16014@obsidianresearch.com>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1473109698-31408-20-git-send-email-jgunthorpe@obsidianresearch.com>
 <7d6553e1-d4a8-a4da-8ccb-ed25d9ba1d91@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7d6553e1-d4a8-a4da-8ccb-ed25d9ba1d91-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 14, 2016 at 07:46:15PM +0300, Yishai Hadas wrote:
> On 9/6/2016 12:08 AM, Jason Gunthorpe wrote:
> >gcc remarks:
> >
> >../libibverbs/src/neigh.c:339:6: warning: 'sock_fd' may be used uninitialized in this function [-Wmaybe-uninitialized]
> >  err = try_send_to(sock_fd, buff, sizeof(buff), &addr_dst);
> 
> 
> Why not just initializing 'sock_fd' to any value (e.g. to 0) when it's
> declared and drop all below patch ? as the code checks the return code from
> create_socket() it should be safe.

Because that is a lazy fix. This code is full of cruft computing an
error value that is never used. There is no reason to do that so the
best approach is to remove the dead code cruft.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
