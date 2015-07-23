From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 00/10] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Thu, 23 Jul 2015 12:47:25 -0600
Message-ID: <20150723184725.GB30303@obsidianresearch.com>
References: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55B0F06E.8000603@sandisk.com>
 <20150723183044.GA1868@obsidianresearch.com>
 <55B13583.5010208@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55B13583.5010208-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chien Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Dominique Martinet <dominique.martinet-KCE40YydGKI@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Van Hensbergen <ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ido Shamay <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ron Minnich <rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Simon Derr <simon.derr-6ktuUTfB/bM@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org" <rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 23, 2015 at 11:42:11AM -0700, Bart Van Assche wrote:
> >diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> >index fb9fed0fac28..a1e3818d0791 100644
> >+++ b/drivers/infiniband/ulp/srp/ib_srp.c
> >@@ -69,7 +69,7 @@ static unsigned int cmd_sg_entries;
> >  static unsigned int indirect_sg_entries;
> >  static bool allow_ext_sg;
> >  static bool prefer_fr;
> >-static bool register_always;
> >+static bool register_always = true;
> 
> If we want security by default then I propose not only to change the default
> value of register_always from false into true but also to change the default
> value of prefer_fr from false into true such that fast registration becomes
> the default instead of FMR.

Yes, I was frowning at that stuff too.. We are trying to get rid of
FMR, so nothing should prefer it over FRWR...

Sagi, perhaps that belongs in your MR unification series?

> >+	if (register_always)
> >+		mr_flags |= IB_ACCESS_REMOTE_READ | IB_ACCESS_REMOTE_WRITE;
> 
> Hmm ... did you perhaps intend if (!register_always) instead ?

I did, thank you. For your testing convenience, the updated version is
on github now:

https://github.com/jgunthorpe/linux/commits/remove-ib_get_dma_mr

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
