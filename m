From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv10 08/12] mlx4: Add support for IBoE - address
 resolution
Date: Fri, 22 Oct 2010 01:03:07 +0200
Message-ID: <20101021230307.GD6367@mtldesk30>
References: <20100826141851.GI8795@mtldesk30>
 <adad3r38d0c.fsf@cisco.com>
 <ada8w1r8cxo.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ada8w1r8cxo.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 21, 2010 at 02:15:47PM -0700, Roland Dreier wrote:
>  > (It probably works in practice because the allocation of sqp structs
>  > gets rounded up enough)
> 
> And I guess also no one actually ends up sending MADs with immediate
> data, so that saves 4 bytes off the worst case too...

I don't get this. For IB, we have 72 without immediate - did you
forget to add the ICRC? I think we count it with the header...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
