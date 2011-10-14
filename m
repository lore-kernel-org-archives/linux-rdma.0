From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Building 3.1-rc9 in kernel infiniband support with OFED libraries
Date: Fri, 14 Oct 2011 16:38:13 -0400 (EDT)
Message-ID: <16183af4-664d-4a9e-ba8c-4a8acc4018f4@zmail05.collab.prod.int.phx2.redhat.com>
References: <CAL1RGDWfoNM+To+7NupJoWiwPRQT9Nip8VodG1pSaBfw3MKzsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWfoNM+To+7NupJoWiwPRQT9Nip8VodG1pSaBfw3MKzsQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

----- Original Message -----
> On Thu, Oct 13, 2011 at 10:24 AM, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>
> wrote:
> >> Clean reviewed patches for this are where?
> >
> > They are in OFED-1.5.3.1 so they were already released.
> 
> OFED is neither clean nor reviewed.  Really.  The stuff in OFED
> always
> needs a bunch
> of review before it is suitable for upstream.  Ignoring ABI stability
> is just one problem
> that OFED code typically has.

Indeed.  Because it is in OFED means it is in testing, nothing more.
A better acronym for OFED is Open Fabrics Experimental Distribution.
These issues are the primary reason we don't follow OFED in RHEL6.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
