From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma] infiniband: call ipv6 route lookup via the stub
 interface
Date: Fri, 28 Apr 2017 12:56:43 -0400
Message-ID: <1493398603.3041.156.camel@redhat.com>
References: <09d4a8a81a499ab61ed6883ae1aa17c5fa0a5b49.1493368728.git.pabeni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <09d4a8a81a499ab61ed6883ae1aa17c5fa0a5b49.1493368728.git.pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-04-28 at 11:20 +0200, Paolo Abeni wrote:
> The infiniband address handle can be triggered to resolve an ipv6
> address in response to MAD packets, regardless of the ipv6
> module being disabled via the kernel command line argument.
> 
> That will cause a call into the ipv6 routing code, which is not
> initialized, and a conseguent oops.
> 
> This commit addresses the above issue replacing the direct lookup
> call with an indirect one via the ipv6 stub, which is properly
> initialized according to the ipv6 status (e.g. if ipv6 is
> disabled, the routing lookup fails gracefully)
> 
> Signed-off-by: Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks Paolo, applied.  I also added a Cc: to stable for kernel 3.12+
since that's when the stub was added.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
