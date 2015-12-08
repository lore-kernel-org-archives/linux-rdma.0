From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] net/mlx5_core: Configure HW to support
 atomic request in host endianness
Date: Tue, 8 Dec 2015 11:12:15 -0700
Message-ID: <20151208181215.GA21156@obsidianresearch.com>
References: <1449593656-8437-1-git-send-email-eranbe@mellanox.com>
 <1449593656-8437-2-git-send-email-eranbe@mellanox.com>
 <20151208171757.GC13549@obsidianresearch.com>
 <CAKHjkj=5nd5O+EfjtLKVs_QDJaMq0U7iC1g3CCdPffCkm+mh=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKHjkj=5nd5O+EfjtLKVs_QDJaMq0U7iC1g3CCdPffCkm+mh=g@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eran ben elisha <eranlinuxmellanox-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 08, 2015 at 08:08:02PM +0200, eran ben elisha wrote:
> On Tue, Dec 8, 2015 at 7:17 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Tue, Dec 08, 2015 at 06:54:15PM +0200, Eran Ben Elisha wrote:
> >> HW is capable of 2 requestor endianness modes for standard 8 Bytes
> >> atomic: BE (0x0) and host endianness (0x1). Read the supported modes
> >> from hca atomic capabilities and configure HW to host endianness mode if
> >> supported.
> >
> > Uh, isn't this a user visible thing?
> >
> > How will apps know if they need to swap or not?
> >
> > Jason
> 
> The problem is that some HWs cannot support IB spec regarding
> requester respond endianness.
> By default, HWs are set to return BE respond.
> If it can be configured to host endianness -> return IB_ATOMIC_HCA
> if not -> return IB_ATOMIC_NONE
> (Done in patch #2 in this series)
> 
> The state of BE respond is not visible to the user (atomic cap =
> IB_ATOMIC_NONE),
> App should behave according to the existing API and IB spec.

Okay, that sounds fine, details like that belong in the patch comments.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
