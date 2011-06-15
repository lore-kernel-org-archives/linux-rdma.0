From: "Woodruff, Robert J" <robert.j.woodruff-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: compile ofed 1.5.3 against lustre kernel
Date: Wed, 15 Jun 2011 16:50:15 -0700
Message-ID: <382A478CAD40FA4FB46605CF81FE39F4F92EC987@orsmsx507.amr.corp.intel.com>
References: <BANLkTin1Pg3e0S=2Hb3=0W=M_qo_TiqRrw@mail.gmail.com>
	<4DF7C80D.1060408@opengridcomputing.com>
	<alpine.DEB.2.00.1106151610040.4224@router.home>
	<382A478CAD40FA4FB46605CF81FE39F4F92EC95C@orsmsx507.amr.corp.intel.com>
 <BANLkTimz3h0C1Z9SUSXx3=LWqpt=T4v10g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimz3h0C1Z9SUSXx3=LWqpt=T4v10g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Di Domenico <mdidomenico4-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Michael wrote,
>For those of us that are not hardcore kernel developers can you
>explain what this change would actually do?  I'm not sure i understand
>how having a source tree with the patches already applied is any
>different then taking the base kernel and applying a patch tree.  But
>then again i probably don't understand what your talking about at all
>(me == admin not developer).

Well what I would like to understand is what would you like to see ?

A tar ball or complete patch with the OFED drivers for each kernel that OFED supports
that can be applied to the kernel tree so that the kernel can be built using
the normal kernel build process ?

Or

A complete kernel tree with all of the OFED drivers already included that could be
downloaded via tar balls or git ?

Other ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
