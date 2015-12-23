From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: device attr cleanup (was: Handle mlx4 max_sge_rd correctly)
Date: Wed, 23 Dec 2015 16:31:16 -0500
Message-ID: <20151223213116.GB29650@fieldses.org>
References: <20151208225940.GB27609@obsidianresearch.com>
 <20151208230244.GA10701@infradead.org>
 <20151209005203.GD16976@phlsvsds.ph.intel.com>
 <20151209184235.GB4522@infradead.org>
 <20151210014556.GA32059@phlsvsds.ph.intel.com>
 <56693758.90808@dev.mellanox.co.il>
 <93E3DE8A-0589-436D-A9A1-7EAC66B12739@oracle.com>
 <20151210180703.GC21482@obsidianresearch.com>
 <20151210233047.GB26009@infradead.org>
 <09F96E8A-5E1E-4345-9069-C07108AF0BC7@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <09F96E8A-5E1E-4345-9069-C07108AF0BC7-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Anna Schumaker <schumakeranna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2015 at 07:49:59PM -0500, Chuck Lever wrote:
> 
> > On Dec 10, 2015, at 6:30 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > 
> > On Thu, Dec 10, 2015 at 11:07:03AM -0700, Jason Gunthorpe wrote:
> >> The ARM folks do this sort of stuff on a regular basis.. Very early on
> >> Doug prepares a topic branch with only the big change, NFS folks pull
> >> it and then pull your work. Then Doug would send the topic branch to
> >> Linus as soon as the merge window opens, then NFS would send theirs.
> >> 
> >> This is alot less work overall than trying to sequence multiple
> >> patches over multiple releases..
> > 
> > Agreed.  Staging has alaways been a giant pain and things tend to never
> > finish moving over that way if they are non-trivial enough.
> 
> In that case:
> 
> You need to make sure you have all the right Acks. I've added
> Anna and Bruce to Ack the NFS-related portions. Santosh should
> Ack the RDS part.
> 
> http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/ib_device_attr

Fine by me.

> Given the proximity to the holidays and the next merge window,
> Doug will need to get a properly-acked topic branch published
> in the next day or two so the rest of us can rebase and start
> testing before the relevant parties disappear for the holiday.

What branch should I be working from?

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
