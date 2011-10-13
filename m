From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Building 3.1-rc9 in kernel infiniband support with OFED
 libraries
Date: Thu, 13 Oct 2011 17:31:39 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E6AD2E@ORSMSX101.amr.corp.intel.com>
References: <alpine.DEB.2.00.1110110900290.3388@router.home>
 <20111011173929.GH26965@obsidianresearch.com>
 <CAO+b5-pxyc0LpGQ4kkOXJVi7cgYm_cgyJ0qM-m81=fZ+MGXHwQ@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237316E6A98C@ORSMSX101.amr.corp.intel.com>
 <CAL1RGDW_usQ8o4FJzZqkmoZAvSTHBLZJuJ_YpsHL-=ErbgSw-A@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237316E6A9C0@ORSMSX101.amr.corp.intel.com>
 <CAL1RGDXm-v52ZRjvNd=jieEeE=rDkatvJcxfporue6x5XjFURA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXm-v52ZRjvNd=jieEeE=rDkatvJcxfporue6x5XjFURA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The result is pushed out to my github  for-next branch, with the
> expectation that I'll ask Linus to pull for 3.2.

Thanks - I'll take a look and test again.
 
> However I do have one question: the last patch
> ("RDMA/uverbs: Export ib_open_qp() capability to user space" in
> my tree) adds IB_USER_VERBS_CMD_OPEN_QP but I don't
> see any driver add that to its uverbs_cmd_mask... does this work?

ib_open_qp() is implemented entirely in the verbs layer (verbs.c).  The OFED API compatibility support that I added to libibverbs makes use of this call, which I tested by running OSU's mvapich2.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
