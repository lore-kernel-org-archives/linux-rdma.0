From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 6/9] IB/core: Add receive Flow Steering support
Date: Tue, 30 Apr 2013 23:37:55 +0300
Message-ID: <CAJZOPZ+t8NbrFOWvjEX18A1GpKxUP_H0V6iXJqQ3Neo3+02=Gg@mail.gmail.com>
References: <1366811932-28199-1-git-send-email-ogerlitz@mellanox.com>
	<1366811932-28199-7-git-send-email-ogerlitz@mellanox.com>
	<CAJZOPZLLxetr5muxWdQZxBZBNf8fUt5ZthTMaVt=Dh9UZ3Uc1w@mail.gmail.com>
	<517EC727.7070204@opengridcomputing.com>
	<0000013e574fe16f-b841863a-d970-468e-83fa-0fbd31d65ef9-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0000013e574fe16f-b841863a-d970-468e-83fa-0fbd31d65ef9-000000-p/GC64/jrecnJqMo6gzdpkEOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 29, 2013 at 10:40 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, 29 Apr 2013, Steve Wise wrote:

>> Hey Or,  This looks good at first glance.  I must confess I cannot tell yet if
>> this will provide everything we need for chelsio's RAW packet requirements.
>> But I think we should move forward on this, and enhance as needed.

> Well we are using the raw qp s here too and would like to use receive
> flow steering. Could we please get this merged?

Steve, Christoph -- thanks for the positive feedback.

So Roland, not that I expect this double ack to behave as our gerrit
system where a +2 feedback triggers acceptance... but still,  there's
real world need here and real patches that address that need - any
questions or comments on them? if not, are they going to get into
3.10?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
