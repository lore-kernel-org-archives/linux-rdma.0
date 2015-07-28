From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 07/13] IB/cma: Helper functions to access port space
 IDRs
Date: Tue, 28 Jul 2015 11:55:09 +0300
Message-ID: <55B7436D.40003@mellanox.com>
References: <1437924832-18327-1-git-send-email-haggaie@mellanox.com>
 <1437924832-18327-8-git-send-email-haggaie@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A901F965@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A901F965-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yotam Kenneth <yotamke-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 28/07/2015 01:48, Hefty, Sean wrote:
>> Add helper functions to access the IDRs by port-space and port number.
>>
>> Pass around the port-space enum in cma.c instead of using pointers to
>> port-space IDRs.
> 
> Why?
> 
>>  drivers/infiniband/core/cma.c | 81 ++++++++++++++++++++++++++++++++------
>> -----
>>  1 file changed, 60 insertions(+), 21 deletions(-)
> 
> This change adds code, and AFAICT makes it less efficient.  What purpose does it serve?
> 

As I wrote before [1], this change is intended to help reuse the code finding
an IDR for a port space, and it is used by patch 9.

As for efficiency, cma_idr, cma_ps_alloc, and cma_ps_remove are completely inlined by my compiler. cma_ps_find does end up adding a function call, but I doubt it would have a significant effect. cma_select_ib_ps and cma_select_inet_ps were already inlined before the patch.

Regards,
Haggai

[1] https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg25496.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
