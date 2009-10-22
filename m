From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] rdma/cm: support option to allow manually setting	IB path
Date: Wed, 21 Oct 2009 18:07:54 -0700
Message-ID: <AE35305D45DB49F591A45DADD822209A@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <A08104C1CF70400F8BEF492AD49C8491@amr.corp.intel.com> <20091020181458.GD14520@obsidianresearch.com> <46770152ACA04B6C8AA9497C45AC8FD0@amr.corp.intel.com> <20091020191404.GH14520@obsidianresearch.com> <9DFD8E65325F4EE990749EEBE4BC33CA@amr.corp.intel.com> <20091022004245.GV14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091022004245.GV14520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>I'm reluctant to override fields like this to save 4 bytes. The
>clarity and extensibility of using an additional flags field seems
>worth it to me, and the processing code is not complex. I cannot think
>of a motivation to save the 4 bytes?

I wasn't thinking about saving the 4 bytes.  struct ib_user_path_rec is already
part of the ABI for query route.  If the preference were used to indicate
primary versus alternate path, which seems reasonable, then query route can more
easily convey that information.

Preference is implementation defined and meaningless once a path has been
selected, so I really don't see any issue in using it however we want.  I
thought about using it to convey all of the flags, but it doesn't give much room
for expansion.  That led me to consider using the sgid and reversible bit to
determine if a path is outbound or inbound.

>As I said, in many ways I would actually much perfer it if the
>structure was:
>
>struct ibv_kern_path_rec2
>{
>    u32 flags;
>    u32 pr[512/8/4];
>}

I would have preferred using MAD definitions directly everywhere myself, but I
don't think it's worth breaking the ABI to change this.  struct ib_user_path_rec
is already in use by the ib_cm and rdma_cm at this point.  (The rdma_cm simply
copied its use by the ib_cm.)

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
