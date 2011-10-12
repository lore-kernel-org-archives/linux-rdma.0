From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: Building 3.1-rc9 in kernel infiniband support with OFED libraries
Date: Wed, 12 Oct 2011 09:38:18 -0700
Message-ID: <CAL1RGDUrkE4Ue_a=Aj77x-i0gN=c_Whn3ngVsQCaneqzEstK1g@mail.gmail.com>
References: <alpine.DEB.2.00.1110110900290.3388@router.home>
 <20111011173929.GH26965@obsidianresearch.com> <CAO+b5-pxyc0LpGQ4kkOXJVi7cgYm_cgyJ0qM-m81=fZ+MGXHwQ@mail.gmail.com>
 <CABgxfbEcYVF6LbmnJnx0UuYvn6-W+JiyNSNT2FAiuYZba65nsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABgxfbEcYVF6LbmnJnx0UuYvn6-W+JiyNSNT2FAiuYZba65nsQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 12, 2011 at 9:32 AM, Wendy Cheng <s.wendy.cheng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> The OFED package itself does include XRC support. The issue here (my
> guess) is that its build script needs to understand the running
> system's kernel version to decide what should be pulled (from the
> source). Linux 3.1 could be too new for OFED build script to make a
> correct decision. Nevertheless, mix-matching OFED modules/libraries is
> a *bad* idea.

No.  The same userspace build should work with all kernel versions.

We did have some ABI churn early in the history of the RDMA stack --
the last time we changed IB_USER_VERBS_ABI_VERSION was early
in 2006.  But we really need to add XRC and other support in such a
way that such ABI bumps are not necessary.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
