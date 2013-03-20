From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] libibmad: To reserve upper 8 bits of tid used by solaris
 SRIOV driver
Date: Wed, 20 Mar 2013 16:33:22 -0600
Message-ID: <20130320223322.GB30100@obsidianresearch.com>
References: <513F8386.5070208@oracle.com>
 <CAMLCd9LOuajya0_s4NhuUD4hUtHnc_NLi8sELnsEprash6t5Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAMLCd9LOuajya0_s4NhuUD4hUtHnc_NLi8sELnsEprash6t5Eg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 20, 2013 at 03:11:51PM -0700, Ira Weiny wrote:
> Why does this need to be done in user space?  This seems like
> something which should be done in the kernel for all Transaction ID's
> which might be sent to the umad layer.

Agreed, if Solaris is going to emulate the Linux umad dev FD it should
be done properly. The kernel overrides some bits and returns the TRID
it actually put on the wire after the MAD is sent.

Linux is already doing this to add per-process uniqueness, per-guest
SRIOV uniqueness should use the same mechanism.

Thus, this masking is either redundant, or hiding a kernel bug..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
