From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix initiator lockup
Date: Wed, 06 Jan 2010 23:57:51 -0800
Message-ID: <adak4vuqrcw.fsf@roland-alpha.cisco.com>
References: <e2e108261001020419l36319156hb9d625edc2e15d06@mail.gmail.com>
	<ada4omyud7c.fsf@roland-alpha.cisco.com>
	<e2e108261001062352l1925f4e1i24bdbdde08056c4c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108261001062352l1925f4e1i24bdbdde08056c4c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Thu, 7 Jan 2010 08:52:59 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > It was only recently that I had the time to analyze this issue in
 > depth and that I added SRP_CRED_REQ support in SCST (checked in that
 > support about one week ago). Before SRP_CRED_REQ support was added in
 > SCST, the SRP initiator could not log the "Unhandled SRP opcode"
 > message because it did not receive any unhandled SRP opcodes.

So it sounds like this is fixing something that was not the original
bug?  Because SCST wasn't sending SRP_CRED_REQ when the issue of the
initiator hanging was originally seen, if I understand correctly.

Do you understand the root cause of the original bug?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
