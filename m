From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next V6 0/5] HW Device hot-removal support
Date: Thu, 30 Jul 2015 10:50:14 -0600
Message-ID: <20150730165014.GD16659@obsidianresearch.com>
References: <1435659967-27173-1-git-send-email-yishaih@mellanox.com>
 <55BA54FC.8060905@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55BA54FC.8060905-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 30, 2015 at 12:46:52PM -0400, Doug Ledford wrote:

> I've pulled this series in for 4.3.  There were some additional items in
> some of Jason's comments that ought to be looked into, but I think this
> patch set has reached the point where it's no worse than existing in
> terms of locking, there were just some existing issues that should be
> addressed too.

Eh? V6 corrupts random kernel memory if you use the hot-removal.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
