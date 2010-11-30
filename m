From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] replace (long*)(long) casting with transportable data
 type (uintptr_t)
Date: Tue, 30 Nov 2010 12:04:46 -0700
Message-ID: <20101130190446.GM16788@obsidianresearch.com>
References: <7C00F472050C412BABCB4F2A59CFBD63@amr.corp.intel.com>
 <20101130175555.GX11898@me>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B89244EC@orsmsx501.amr.corp.intel.com>
 <20101130185754.GY11898@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20101130185754.GY11898@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 30, 2010 at 08:57:54PM +0200, Sasha Khapyorsky wrote:
> On 10:22 Tue 30 Nov     , Hefty, Sean wrote:
> > > Wouldn't it be better to remove those additional castings at all?
> > > Like below?
> > > 
> > ..
> > > 	p_query_req_copy = (osmv_query_req_t *) p_req_madw->context.ni_context.node_guid;
> > 
> > I think the Windows compiler will complain about data loss on a 32-bit system.
> 
> p_req_madw->context.ni_context.node_guid has 64 bits type.

But the pointer has 32 bits, so the compiler warns you it chucked the
upper 32 bits of node_guid.

The correct cast in C99 is (osmv_query_req_t *)(unitptr_t)

But one should look upon all of these with great suspicion and take a
moment to figure out where the original non-pointer came from. It
better not be from network data or you have a security problem.

Just reading the line from here looks insane, casting a GUID to a
pointer? :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
