From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix initiator lockup
Date: Sat, 2 Jan 2010 18:52:03 +0100
Message-ID: <e2e108261001020952l2a9eab4cr19b3ba414569176b@mail.gmail.com>
References: <e2e108261001020419l36319156hb9d625edc2e15d06@mail.gmail.com>
	 <f3177b9e1001020805k4dce1991u3733c5a7f6d46aaa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f3177b9e1001020805k4dce1991u3733c5a7f6d46aaa-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jan 2, 2010 at 5:05 PM, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Would this fix effect the Window's SRP initiator too?

I'm not familiar with the WinOF codebase. But at first sight it looks
like the WinOF SRP initiator doesn't support processing SRP_CRED_REQ
information units either, which means that the WinOF SRP initiator is
vulnerable to the same initiator lockup issue as the Linux SRP
initiator.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
