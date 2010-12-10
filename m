From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] mlx4: Change a warning message to debug
Date: Fri, 10 Dec 2010 14:27:59 +0200
Message-ID: <20101210122759.GA28088@mtldesk30>
References: <20101208080602.GA9649@mtldesk30>
 <adaipz4jddc.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adaipz4jddc.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 08, 2010 at 11:03:43AM -0800, Roland Dreier wrote:
>  > This workaround presented in 58d74bb is not something we should alert the user
>  > on.  Debug level message is enough.
> 
> Not sure I agree ... surely the point of this message is for the user to
> see it and know to update firmware?  Otherwise why print anything at
> all, since I'm sure you guys have already fixed the firmware and have a
> regression test so this bug doesn't reappear?
> 
Right :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
