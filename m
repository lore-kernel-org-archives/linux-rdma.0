From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU
Date: Wed, 17 Jul 2013 18:12:21 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F725B8C@xmb-rcd-x01.cisco.com>
References: <1372768306-6786-1-git-send-email-jsquyres@cisco.com>
 <CAL1RGDVU9otyMtoit1PJR5JkVy4XvU=4xjL1rN1QB7pq0rVcxA@mail.gmail.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F6F31A6@xmb-rcd-x01.cisco.com>
 <CAL1RGDU+4CSJyF0TAfAv-YYcjA4FG+XNeg5pGCHPeW5iqhvwpA@mail.gmail.com>
 <20130708172621.GA3852@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F70BF83@xmb-rcd-x01.cisco.com>
 <1828884A29C6694DAF28B7E6B8A82373805AAB74@ORSMSX109.amr.corp.intel.com>
 <20130716144747.GA7304@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F7211E6@xmb-rcd-x01.cisco.com>
 <1828884A29C6694DAF28B7E6B8A82373805AECC0@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373805AECC0-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Content-ID: <1231C8B4268616459548F2F8BC5E92AE-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jul 17, 2013, at 12:06 AM, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> I don't remember.  Is it known how the mtu is communicated with the kernel?  

I hadn't looked at the kernel side yet; I was waiting for the userspace side to sort itself out first.

> Looking at kern-abi.h, the mtu fields are:
> 
> struct ibv_query_port_resp {
> 	__u8  max_mtu;
> 	__u8  active_mtu;
> 
> struct ibv_kern_qp_attr {
> 	__u32	path_mtu;
> 
> struct ibv_query_qp_resp {
> 	__u8  path_mtu;
> 
> struct ibv_modify_qp {
> 	__u8  path_mtu;
> 
> In most cases, we only have 8 bits available to/from the kernel.  (There are at least 16 bits of reserved space in these structures.)

Hmm.  16 bits is probably enough for the MTU values, but still, changing kern-abi.h will be problematic from an ABI perspective.  Do people care about the kernel ABI, or is that mainly a userspace issue?

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
