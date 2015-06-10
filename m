From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v4 0/4] Sending kernel pathrecord query to user cache
 server
Date: Wed, 10 Jun 2015 15:51:51 -0400
Message-ID: <55789557.3080100@dev.mellanox.co.il>
References: <1433861837-26177-1-git-send-email-kaike.wan@intel.com> <55783D84.6040709@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373A8FE6677@ORSMSX109.amr.corp.intel.com> <55786ACC.4070704@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373A8FE680D@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FE680D-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/10/2015 1:04 PM, Hefty, Sean wrote:
>> Not in the patches themselves but in the general issue when a PR changes.
>>
>> Do you think this needs addressing or are things fine as they are now ?
> 
> IMO, I think it needs addressing in terms of "can the proposed netlink architecture and design accommodate this 
> sort of request in the future?"  We shouldn't design in a limitation up front.  I don't see anything in the current approach that would cause an issue.  There would likely be a need for new messages and attributes.

The current proposal is focused around the PR attributes/styles
currently used in the kernel. The case I can see is if in future a new
attribute is added to the PR netlink API. How is that handled ? Can user
space say it can't service a request ? That seems a little different
from the no PR case.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
