From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv10 08/12] mlx4: Add support for IBoE - address resolution
Date: Thu, 21 Oct 2010 14:15:47 -0700
Message-ID: <ada8w1r8cxo.fsf@cisco.com>
References: <20100826141851.GI8795@mtldesk30> <adad3r38d0c.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adad3r38d0c.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> (Roland Dreier's message of "Thu, 21
	Oct 2010 14:14:11 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > (It probably works in practice because the allocation of sqp structs
 > gets rounded up enough)

And I guess also no one actually ends up sending MADs with immediate
data, so that saves 4 bytes off the worst case too...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
