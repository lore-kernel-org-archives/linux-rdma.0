From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: rdma-core release?
Date: Wed, 12 Oct 2016 09:43:08 -0500
Message-ID: <00c801d22496$f31798f0$d946cad0$@opengridcomputing.com>
References: <20161012105103.GA30534@infradead.org> <CALq1K=JEkvN_4tZL9D53c6-EH9E4efay8rmoyBEyB-7Sxr6H-w@mail.gmail.com> <59ebde13-0fcd-0640-e750-bb6e57bfb921@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <59ebde13-0fcd-0640-e750-bb6e57bfb921-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Leon Romanovsky' <leon-2ukJVAZIZ/Y@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On 10/12/2016 7:43 AM, Leon Romanovsky wrote:
> > On Wed, Oct 12, 2016 at 1:51 PM, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> >> Are we planning on having a rdma-core release now that 4.8 is out
> >> and we want a matching userspace release?
> >
> > As far as I remember, the initial plan was to use this library
> > immediately, but first release was planned to be at the 4.9
> > announcement to ensure that it runs smoothly.
> 
> Correct.
> 

I recommend we release something for OFED-4.8 to pull in.  That might help flush out the release process earlier rather than later.   Either way, though, I want the latest libcxgb4 in OFED-4.8 to support the new chelsio HW.   But we talked about the repo being "always stable", so I guess the OFA could just pull the code and use it?  Still would be nice to have it released...

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
