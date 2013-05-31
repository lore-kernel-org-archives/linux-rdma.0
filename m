From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3] Add trap details to notice log message
Date: Fri, 31 May 2013 11:43:35 -0400
Message-ID: <51A8C527.5070306@dev.mellanox.co.il>
References: <a889a33d-2f26-4432-b912-3d531a60e019@default> <1828884A29C6694DAF28B7E6B8A823736FD2C024@ORSMSX109.amr.corp.intel.com> <51A85DE4.2000506@oracle.com> <1828884A29C6694DAF28B7E6B8A823736FD2C27A@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736FD2C27A-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Line Holen <line.holen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/31/2013 10:40 AM, Hefty, Sean wrote:
>> Are you suggesting to do this in addition to ib_types.h or instead of ?
>> umad_sm.h seems to hold only a small subset of what's found in ib_types.h.
> 
> umad_sm.h was only recently added.  

and there is no release yet with those files.

> I'm suggesting to put the definitions there instead of within the opensm header file, so that the definitions are available to applications other than opensm.

My preference would be in addition to rather than instead of. In the
future once there is libibumad release in the field for some time with
these headers, then OpenSM can migrate definitions as makes sense.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
