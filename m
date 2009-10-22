From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] rdma/cm: support option to allow manually setting	IB path
Date: Wed, 21 Oct 2009 17:14:59 -0700
Message-ID: <9DFD8E65325F4EE990749EEBE4BC33CA@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <A08104C1CF70400F8BEF492AD49C8491@amr.corp.intel.com> <20091020181458.GD14520@obsidianresearch.com> <46770152ACA04B6C8AA9497C45AC8FD0@amr.corp.intel.com> <20091020191404.GH14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091020191404.GH14520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Maybe something simple:
>
>struct ibv_kern_path_rec2
>{
>   u32 flags;
>   struct ibv_kern_path_rec rec;
>}

This is more as an RFC:

Looking at ib_user_path_rec / ibv_kern_path_rec, we could just make use of the
existing bits that are available.  We have 2 32-bit fields that are only used to
record a single bit of data, the gids, plus numb_path and preference fields.

We should be able to determine if a path is forward, reverse, or both by looking
at the sgid and the reversible bit.  Preference (flags) could be used to
indicate if a path is primary, alternate, or for the CM only.  With the
exception of the marking a path for the CM, the use of the fields in this manner
seems somewhat natural to me. 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
