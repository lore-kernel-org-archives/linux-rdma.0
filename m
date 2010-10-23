From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] RDMA/cxgb3: When a user QP is marked in error, also mark the CQs in error.
Date: Fri, 22 Oct 2010 22:07:56 -0700
Message-ID: <adar5fhts2b.fsf@cisco.com>
References: <20101021123705.7604.20848.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101021123705.7604.20848.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org> (Steve Wise's
	message of "Thu, 21 Oct 2010 07:37:06 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I applied this, but can you check if there are any alignment/size issues
with 32-bit userspace on 64-bit kernel?  Specifically:

 >  struct iwch_create_cq_resp {
 >  	__u64 key;
 >  	__u32 cqid;
 >  	__u32 size_log2;
 > +	__u32 memsize;
 >  };

this structure now has size 20 on i386 (32-bit) but size 24 on x86-64 I
think so a 64-bit kernel might falsely think that the 32-bit library was
old.

The fix is to add a __u32 reserved field at the end of the struct so it
always gets padded to 24 bytes.  But I don't want to do that to this
patch until you change the userspace library too.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
