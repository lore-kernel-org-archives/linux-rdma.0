From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibverbs: Allow arbitrary int values for MTU
Date: Thu, 20 Jun 2013 20:02:47 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F694D9C@xmb-rcd-x01.cisco.com>
References: <1371502807-17026-1-git-send-email-jsquyres@cisco.com>
 <20130618184928.GE2204@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F6939C5@xmb-rcd-x01.cisco.com>
 <1828884A29C6694DAF28B7E6B8A823736FD358BC@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736FD358BC-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Content-ID: <BD1CFCF523B2C84193DFE86B143290F3-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jun 20, 2013, at 1:09 PM, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> int ibv_rate_to_mult(enum ibv_rate rate);
>> enum ibv_rate mult_to_ibv_rate(int mult);
>> 
>> int ibv_rate_to_mbps(enum ibv_rate rate);
>> enum ibv_rate mbps_to_ibv_rate(int mbps);
> 
> libibverbs uses the "ibv_" prefix for pretty much everything.

...except for those 2 functions above (mbps_to_ibv_rate and mult_to_ibv_rate).  See:

https://git.kernel.org/cgit/libs/infiniband/libibverbs.git/tree/include/infiniband/verbs.h#n392

and

https://git.kernel.org/cgit/libs/infiniband/libibverbs.git/tree/include/infiniband/verbs.h#n379

respectively.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
