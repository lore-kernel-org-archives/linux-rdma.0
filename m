From: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/core: use IB_CQ_REPORT_MISSED_EVENTS to avoid
 missed CQ callbacks
Date: Fri, 02 Apr 2010 12:54:59 -0700
Message-ID: <4BB64B93.9050100@oracle.com>
References: <20100331175742.24522.17850.stgit@chromite.mv.qlogic.com>	<20100331175747.24522.88472.stgit@chromite.mv.qlogic.com>	<ada4ojwjqz7.fsf@roland-alpha.cisco.com>	<1270063245.4192.299.camel@chromite.mv.qlogic.com> <ada4ojwghey.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada4ojwghey.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

(sorry to reply late -- bad mail rules.)

RDS used to do send and recv processing in the event handler.

It currently uses a tasklet for recv, and send is still in the event
handler. When we moved the recv processing to a tasklet, we poll the cq,
arm the cq, then poll it again, because it seems like 1) we want to do
as much work as possible before rearming the event and 2) we need to
poll after, to be sure to catch CQEs added between the time when the
handler exited and we've gotten to this point in the tasklet. How does
this approach (re-polling after calling notify_cq) compare with using
REPORT_MISSED_EVENTS? Maybe it's two different ways to do the same thing?

Anyways, this is off the point from your original patch that changed the
send cq handling, which is all done in the event handler. I don't have
an explanation for you seeing the 0xdeads, except that the comment above
that code that mentions racing cleanly with the send path makes my
antennae twitch a little bit...

Regards -- Andy

PS FWIW my dev branch moves RDS to a single CQ for send & recv events
similar to srp, except using a tasklet, and notify_cq(IB_CQ_SOLICITED),
and doing poll/arm/poll.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
