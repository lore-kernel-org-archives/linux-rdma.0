From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 6/9] IB/core: Add receive Flow Steering
 support
Date: Mon, 29 Apr 2013 19:40:53 +0000
Message-ID: <0000013e574fe16f-b841863a-d970-468e-83fa-0fbd31d65ef9-000000@email.amazonses.com>
References: <1366811932-28199-1-git-send-email-ogerlitz@mellanox.com> <1366811932-28199-7-git-send-email-ogerlitz@mellanox.com> <CAJZOPZLLxetr5muxWdQZxBZBNf8fUt5ZthTMaVt=Dh9UZ3Uc1w@mail.gmail.com> <517EC727.7070204@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <517EC727.7070204-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 29 Apr 2013, Steve Wise wrote:

> Hey Or,  This looks good at first glance.  I must confess I cannot tell yet if
> this will provide everything we need for chelsio's RAW packet requirements.
> But I think we should move forward on this, and enhance as needed.

Well we are using the raw qp s here too and would like to use receive
flow steering. Could we please get this merged?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
