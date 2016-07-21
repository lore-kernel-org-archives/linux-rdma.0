From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC ABI V2 2/8] RDMA/core: Refactor IDR to be per-device
Date: Thu, 21 Jul 2016 10:51:54 -0600
Message-ID: <20160721165154.GF19849@obsidianresearch.com>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com>
 <1468941812-32286-3-git-send-email-matanb@mellanox.com>
 <20160720174122.GJ21460@obsidianresearch.com>
 <13309138-dd3f-7411-d750-4ff370d55daa@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <13309138-dd3f-7411-d750-4ff370d55daa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 21, 2016 at 02:52:03PM +0300, Matan Barak wrote:
> On 20/07/2016 20:41, Jason Gunthorpe wrote:
> >On Tue, Jul 19, 2016 at 06:23:26PM +0300, Matan Barak wrote:
> >>From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>
> >>The current code creates an IDR per type. Since types are currently
> >>common for all vendors and known in advance, this was good enough.
> >>However, the proposed ioctl based infrastructure allows each vendor
> >>to declare only some of the common types and declare its own specific
> >>types.
> >>
> >>Thus, we decided to implement IDR to be per device and refactor it to
> >>use a new file.
> >
> >I still think this should be per-fd...
> >
> 
> If we unite rdma-cm and uverbs to one fd, so I agree - it's better to have
> one IDR per file (even though it might make sharing objects between
> processes a little bit harder). If we keep things as they are today
> (separate fds), I think both options are valid.

Sharing objects without having both fds in the same process for the
share seems inherently insecure.... Do we do sharing today? XRC?

I think namespaces are also a good motivation for the per-fd idr..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
