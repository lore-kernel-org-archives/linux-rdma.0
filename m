From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: {RFC] ibv_post_send()/ibv_post_recv() kernel path optimizations
Date: Fri, 06 Aug 2010 08:57:58 -0700
Message-ID: <adak4o320op.fsf@roland-alpha.cisco.com>
References: <BE2BFE91933D1B4089447C64486040805BD83E5F@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BE2BFE91933D1B4089447C64486040805BD83E5F-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
	(Miroslaw Walukiewicz's message of "Fri, 6 Aug 2010 11:03:36 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > The proposed path optimization is removing of dynamic allocations 
 > by redefining a structure definition passed to kernel. 

 > To 
 > 
 > struct ibv_post_send {
 >         __u32 command;
 >         __u16 in_words;
 >         __u16 out_words;
 >         __u64 response;
 >         __u32 qp_handle;
 >         __u32 wr_count;
 >         __u32 sge_count;
 >         __u32 wqe_size;
 >         struct ibv_kern_send_wr send_wr[512];
 > };

I don't see how this can possibly work.  Where does the scatter/gather
list go if you make this have a fixed size array of send_wr?

Also I don't see why you need to change the user/kernel ABI at all to
get rid of dynamic allocations... can't you just have the kernel keep a
cached send_wr allocation (say, per user context) and reuse that?  (ie
allocate memory but don't free the first time into post_send, and only
reallocate if a bigger send request comes, and only free when destroying
the context)

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
