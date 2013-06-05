From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] libibverbs: A possible solution for allowing arbitrary
 MTU values.
Date: Wed, 5 Jun 2013 18:58:34 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736FD2D40A@ORSMSX109.amr.corp.intel.com>
References: <1370437223-14171-1-git-send-email-jsquyres@cisco.com>
 <20130605164639.GA30184@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65D690@xmb-rcd-x01.cisco.com>
 <20130605171916.GD30184@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DB61@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DB61-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > The concept of a libibverbs 2.0 has been NAK's by pretty much everyone
> > involved. This is why we are suffering with the complex extension
> > mechanism.
> 
> Are you saying that libibverbs must always always always be backwards
> compatible, and there will never be an ABI break at any version in the future?

I don't think this change is worth breaking the ABI.

But, I have started looking at what a version "2.0" could be.  I have a desire to merge the separate libraries (verbs, rdmacm, umad) together; but the feedback was that it didn't seem worth it if it simply exported the same APIs.  So I expanded my scope to unify those APIs, determine the best way to extend the verbs cmd APIs (used by the vendor libraries), include things like collective operations, support vendor specific calls, etc.  I think you end up with a new library, which would need a lot more thought and discussion.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
