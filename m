From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: ibv_rc_pingpong, rping, and other tools hang with Linux 4.10.0
 and rdma-core 13
Date: Mon, 27 Feb 2017 11:59:38 -0700
Message-ID: <20170227185938.GN5891@obsidianresearch.com>
References: <CAE=AiOMqGzMC6sD-cXB_sGRH_L15annm_4WottmY17oCSNZveA@mail.gmail.com>
 <20170227171549.GG5891@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170227171549.GG5891-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Beavers <josh.beavers-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, GAFBlizzard <gtschemer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Youngjae Lee <dhrkaeh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 27, 2017 at 10:15:49AM -0700, Jason Gunthorpe wrote:
> On Mon, Feb 27, 2017 at 12:02:07PM -0500, Josh Beavers wrote:
> 
> > I just confirmed that reverting the C11 atomics commit (6b26a9e24739)
> > fixes ibv_rc_pingpong on my two at91 ARM boards.  For some reason the
> > first few packets seem to send slowly, but once it gets going the rest
> > send quickly.
> 
> How are you able to get it to compile? Without that commit ARM32
> should blow up?

https://github.com/linux-rdma/rdma-core/pull/84

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
