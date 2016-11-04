From: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/rdmavt: Only put mmap_info ref if it exists
Date: Fri, 4 Nov 2016 13:33:28 -0400
Message-ID: <b67230ae-baf0-c932-4acd-b414a33c158f@redhat.com>
References: <1478033052-147252-1-git-send-email-foraker1@llnl.gov>
Reply-To: jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1478033052-147252-1-git-send-email-foraker1-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/01/2016 04:44 PM, Jim Foraker wrote:
> rvt_create_qp() creates qp->ip only when a qp creation request comes from
> userspace (udata is not NULL).  If we exceed the number of available
> queue pairs however, the error path always attempts to put a kref to this
> structure.  If the requestor is inside the kernel, this leads to a crash.
> 
> We fix this by checking that qp->ip is not NULL before caling kref_put().
> 

Fixes: 515667f8f8b4 ("IB/rdmavt: Add create queue pair functionality")

> Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>

Acked-by: Jonathan Toppins <jtoppins-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
