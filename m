From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v4 0/4] Sending kernel pathrecord query to user cache
 server
Date: Wed, 10 Jun 2015 12:50:20 -0400
Message-ID: <55786ACC.4070704@dev.mellanox.co.il>
References: <1433861837-26177-1-git-send-email-kaike.wan@intel.com> <55783D84.6040709@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373A8FE6677@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FE6677-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/10/2015 11:21 AM, Hefty, Sean wrote:
>> While this appears to address the current upstream use model for ACM
>> with it's multicast overlay backend where PRs are static, it does not
>> appear to address PR changes.
> 
> Although this ties into ibacm, from the viewpoint of the kernel, there's no requirement on the user space implementation.

True. This is not how it works in the kernel today. It is meant as
future thinking/exploring.

>> Should aging/revalidation of PRs be supported ? If so, would this make
>> PRs similar at "high" level to IP neighbor cache in kernel ?
> 
> This is requesting a new feature not supported by anything in the kernel today, and would seem to fall well
> outside the scope of the suggested changes.  

Outside scope of suggested changes but where does the kernel need to
head in the longer term ?

> Is there a specific issue in the patches that you are seeing related to this?

Not in the patches themselves but in the general issue when a PR changes.

Do you think this needs addressing or are things fine as they are now ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
