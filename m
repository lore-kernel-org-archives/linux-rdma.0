From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: infiniband-diags/perfquery.c: Use ib_types.h defines for CapabilityMask
Date: Thu, 28 Apr 2011 12:29:02 -0400
Message-ID: <4DB995CE.8070203@dev.mellanox.co.il>
References: <4DB97DF4.3020004@dev.mellanox.co.il> <CF9C39F99A89134C9CF9C4CCB68B8DDF261A1F3A02@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF261A1F3A02-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/28/2011 11:54 AM, Hefty, Sean wrote:
>> rather than hard coded values now that these have been added to ib_types.h
> 
> I've lost track.  Is ib_types.h still an opensm include file?

Yes.

This patch was mirroring the change Ira proposed to ibqueryerrors.c
yesterday.

Also, there are other infiniband-diags (and library) including
ib_types.h (e.g. saquery and libibnetdisc).

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
