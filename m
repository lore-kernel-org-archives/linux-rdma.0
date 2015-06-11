From: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 0/4] Sending kernel pathrecord query to user cache
 server
Date: Thu, 11 Jun 2015 12:34:27 +0000
Message-ID: <3F128C9216C9B84BB6ED23EF16290AFB0CABD058@CRSMSX101.amr.corp.intel.com>
References: <1433861837-26177-1-git-send-email-kaike.wan@intel.com>
 <55783D84.6040709@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373A8FE6677@ORSMSX109.amr.corp.intel.com>
 <55786ACC.4070704@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373A8FE680D@ORSMSX109.amr.corp.intel.com>
 <55789557.3080100@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55789557.3080100-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> Sent: Wednesday, June 10, 2015 3:52 PM
> 
> On 6/10/2015 1:04 PM, Hefty, Sean wrote:
> >> Not in the patches themselves but in the general issue when a PR changes.
> >>
> >> Do you think this needs addressing or are things fine as they are now ?
> >
> > IMO, I think it needs addressing in terms of "can the proposed netlink
> > architecture and design accommodate this sort of request in the future?"
> We shouldn't design in a limitation up front.  I don't see anything in the
> current approach that would cause an issue.  There would likely be a need for
> new messages and attributes.
> 
> Can user space say it can't
> service a request ?
Yes. It can NACK a request.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
