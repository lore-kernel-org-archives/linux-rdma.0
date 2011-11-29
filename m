From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Prevent hung task or softlockup processing
 multicast response
Date: Tue, 29 Nov 2011 13:21:25 -0800
Message-ID: <CAL1RGDUE2+HRhue+i=AVGuChe4FkY1Y=E7REGtadGrQ5uavWSQ@mail.gmail.com>
References: <20111121134354.26386.85093.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111121134354.26386.85093.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Applied, thanks.

Not sure I understand one thing though:

 > There are GFP_ATOMIC allocates in the provider routines, so this is
possible and
 > should be dealt with.

 > The test that induced the failure is associated with a host SM on the same
 > server during a shutdown.

how is a host SM and/or shutdown associated with ib_create_ah failing
due to GFP_ATOMIC allocations?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
