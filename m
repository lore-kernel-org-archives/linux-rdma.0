From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH] IB/srp: reduce number of interrupts
Date: Sun, 28 Feb 2010 12:02:38 +0100
Message-ID: <e2e108261002280302pc0a63b0l9d4dc16ec7b901d@mail.gmail.com>
References: <201002022023.54554.bart.vanassche@gmail.com>
	 <adamxyyxm9s.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adamxyyxm9s.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 25, 2010 at 12:10 AM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
>
> thanks, applied, and I added the following cleanup on top too.
> The old mess wasn't your fault of course but I think this makes things a
> bit safer, assuming I didn't mess it up:
>
> IB/srp: Clean up error path in srp_create_target_ib()
>
> Instead of repeating the error unwinding steps in each place an error
> can be detected, use the common idiom of gotos into an error flow.
>
> Signed-off-by: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

Thanks for applying the interrupt rate reduction patch, and thanks for
cleaning up the error path of srp_create_target_ib(). I'm afraid that
it's too late to add an acked-by to that patch ? Anyway:

Acked-by: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
