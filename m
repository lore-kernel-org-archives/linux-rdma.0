From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/6] IB/SA: Add support to query OPA path
 records
Date: Wed, 19 Apr 2017 10:50:26 -0400
Message-ID: <b8def3c6-b289-a3b2-a3a8-a77f3dabf30e@dev.mellanox.co.il>
References: <1492462590-64866-1-git-send-email-dasaratharaman.chandramouli@intel.com>
 <1492462590-64866-7-git-send-email-dasaratharaman.chandramouli@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492462590-64866-7-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/17/2017 4:56 PM, Dasaratharaman Chandramouli wrote:
> When the bit 26 of capmask2 field in OPA classport info
> query is set, SA will query for OPA path records instead
> of querying for IB path records.

If/when additional SA query types are supported for OPA, will each
additional SA query type have separate CapMask2 bit or will they be
combined into 1 ? For example, would SA MCMemberRecord be different for
OPA (perhaps 32 bit MLID) and if so, would support be indicated by
different capability bit or same one ? Is that the only other one ?

Currently, IB SA is using up through bit 13 and new features continue to
be added (at least one more coming soon). There is some chance for
feature collision if OPA would care about supporting such new IB feature
if and when OPA and IB bitmasks meet with IB incrementing from bit 13
and OPA decrementing from bit 26. I wouldn't expect that to happen for a
while but best

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
