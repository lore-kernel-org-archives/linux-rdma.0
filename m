From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv3 TRIVIAL] IB/core: Documentation fix to
 ib_mad_snoop_handler in the MAD header file
Date: Tue, 5 Jan 2016 13:49:12 -0500
Message-ID: <568C1028.3090309@dev.mellanox.co.il>
References: <568B98A6.3010908@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373AAFF512F@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AAFF512F-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/5/2016 12:38 PM, Hefty, Sean wrote:
>> In ib_mad.h, ib_mad_snoop_handler uses send_buf rather than send_wr
> 
> The MAD snooping should be removed from the mad stack.  

This last discussed on linux-rdma list back in late September when Ira
posted a partial RFC patch to do this.

> There are no in tree users and the only attempt at adding one was rejected.

There are no in tree users of this but there is your madeye tool (which
is out of tree). This is still a useful debug tool for MADs and there
are people who still use that.

Ira posted the start of MAD stack tracing but AFAIT it was not
equivalent and that thread died out.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
