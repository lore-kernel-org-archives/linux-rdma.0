From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofa-general] [Bug 14235] New: SRP initiator lockup
Date: Sat, 05 Dec 2009 13:49:58 -0800
Message-ID: <adatyw5t7jt.fsf@roland-alpha.cisco.com>
References: <bug-14235-11804@http.bugzilla.kernel.org/>
	<ada63b3xcdt.fsf@cisco.com>
	<e2e108260912050944k1228e964ta7a70dde493ba010@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108260912050944k1228e964ta7a70dde493ba010-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Sat, 5 Dec 2009 18:44:22 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > I'm not sure that the non-error path for ordinary SCSI commands is
 > that trivial. If my interpretation of the SRP initiator source code is
 > correct, the statements complete(&target->done) and
 > init_completion(&target->done) can be executed concurrently. Although
 > I do not know what the exact consequences are, and although I do not
 > know whether this is related to the issue I reported, this is a race
 > condition. I'm not sure that allowing such races is good kernel
 > programming practice.

target->done is only used in connection setup I think, so not related to
hangs during IO processing.  However I would like to know more details
of where you see this race, since yes we would want to fix that.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
