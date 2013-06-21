From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V2] libibverbs: Allow arbitrary int values for MTU.
Date: Fri, 21 Jun 2013 01:03:48 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD35A71@ORSMSX109.amr.corp.intel.com>
References: <1371738080-18537-1-git-send-email-jsquyres@cisco.com>
 <51C32EFC.8060202@redhat.com> <20130620165305.GA19800@obsidianresearch.com>
 <51C36692.7000507@redhat.com> <20130620211454.GA2434@obsidianresearch.com>
 <51C39ECB.3040006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51C39ECB.3040006-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Jeff Squyres (jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I would argue that this is because the libraries are so disjoint (that
> librdmacm needs the deep internal knowledge it needs of libibverbs
> indicates that maybe these two shouldn't be separate from each other for
> example, or that maybe libibverbs should provide a unified connection
> API to the user and internally use both librdmacm and libibcm on the
> back end to work IP v. GUID connection setup).  So, I think there is
> significant room to improve the layout of the overall RDMA APIs and
> doing that would address this particular issue and is probably the right
> way to go.
... 
> That would address structures, but I think the API itself could use some
> love and care, and that wouldn't be addressed by just the verbs
> extension mechanism (and in fact if you rethink some of the exposed API,
> it might drastically change how you might want to handle
> extensions...who knows).

I agree with Doug.  A merged library that can evolve the RDMA APIs with fewer compatibility constraints could be beneficial.  I just think such an approach would require some thought and a lot of discussion.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
