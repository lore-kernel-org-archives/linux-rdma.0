From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [RFC] [PATCH 1/2] libibverbs: Allow 3rd party extensions to verb
 routines
Date: Mon, 06 Jun 2011 11:30:30 -0500
Message-ID: <4DED00A6.4010201@opengridcomputing.com>
References: <1828884A29C6694DAF28B7E6B8A82373012B5B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373012B5B-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 06/03/2011 07:34 PM, Hefty, Sean wrote:
> In order to support OFED or vendor specific calls, define a
> generic extension mechanism.  This allows OFED, an RDMA vendor,
> or another registered 3rd party (for example, the librdmacm)
> to define RDMA extensions.
>

Will this mechanism allow an RDMA provider driver to export a new qp-related operation for use internally bit the 
supporting provider library?  IE Not exposes to the RDMA application, but an internal interface between the library and 
driver.  I have need for this with the T4 driver.

> Users which make use extensions are aware that they are not
> only using an extended call, but are given information regarding
> how widely the extension by be supported.

Can you expand on the above sentence?  I don't get the "how widely supported" angle?

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
