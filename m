From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] IW_CXGB4: Fix iw_cxgb4 recv cqe
Date: Thu, 13 Oct 2011 11:19:10 -0700
Message-ID: <CAL1RGDUES044eZ9BAo7u_N+hB9e07q-Y90ieMQ66=wzmMG1ytQ@mail.gmail.com>
References: <20111013181528.29250.15355.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111013181528.29250.15355.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Lallinger <jonathan-/Yg/VP3ZvrM@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 13, 2011 at 11:15 AM, Jonathan Lallinger <jonathan-/Yg/VP3ZvrM@public.gmane.org> wrote:
> Upon completion of a work request on the recieve queue the
> IW_CXGB4 driver was incorrectly posting a completion back to
> the recieve queue instead of the send queue

Wait, what?

On a receive completion you want to add a completion to the send queue??

#needbetterchangelog

Thanks,
  Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
