From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
 misinterpreted flag
Date: Tue, 24 Oct 2017 12:31:55 -0400
Message-ID: <1508862715.3325.22.camel@redhat.com>
References: <20171024123957.32207.70888.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171024123957.32207.70888.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-10-24 at 08:41 -0400, Michael J. Ruhl wrote:
> From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> rdma_nl_rcv_msg() checks to see if it should use the .dump() callback
> or the .doit() callback.  The check is done with this check:
> 
> if (flags & NLM_F_DUMP) ...
> 
> The NLM_F_DUMP flag is two bits (NLM_F_ROOT | NLM_F_MATCH).
> 
> When an RDMA_NL_LS message (response) is received, the bit used for
> indicating an error is the same bit as NLM_F_ROOT.
> 
> NLM_F_ROOT == (0x100) == RDMA_NL_LS_F_ERR.

What are the remaining flags in the failing error case?

Or to be more specific,

> 
>  	/* FIXME: Convert IWCM to properly handle doit callbacks */
>  	if ((nlh->nlmsg_flags & NLM_F_DUMP)
             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This test is technically faulty.  Since NLM_F_DUMP is a multi-bit flag,
it must be ((nlh->nlmsg_flags & NLM_F_DUMP) == NLM_F_DUMP) to be
technically correct.  So, my question then becomes, if we correct this
test, will the RDMA_NL_LS_F_ERR return message still trigger this wrong
path?  I'd rather have a technically correct fix to this if statement
than a special case of the index value if possible.



-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
