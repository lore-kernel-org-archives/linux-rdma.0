From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb4: Convert timers to use timer_setup()
Date: Wed, 18 Oct 2017 12:21:26 -0400
Message-ID: <1508343686.2951.5.camel@redhat.com>
References: <20171016225231.GA98935@beast>
         <08af01d34753$cb0fe2f0$612fa8d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <08af01d34753$cb0fe2f0$612fa8d0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Kees Cook' <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Hal Rosenstock' <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-10-17 at 09:25 -0500, Steve Wise wrote:
> > 
> > In preparation for unconditionally passing the struct timer_list
> > pointer to
> > all timer callbacks, switch to using the new timer_setup() and
> > from_timer()
> > to pass the timer pointer explicitly. Also removes an unused timer
> > and
> > drops a redundant initialization.
> > 
> > Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> > Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> 
> Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
