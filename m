From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Fri, 16 Sep 2016 11:04:05 -0600
Message-ID: <20160916170403.GB15159@obsidianresearch.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB07FB7A@ORSMSX109.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB07FBE1@ORSMSX109.amr.corp.intel.com>
 <20160913180342.GA6933@obsidianresearch.com>
 <9aaeb3e2-9283-9850-0dfa-d1ea150e7408@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9aaeb3e2-9283-9850-0dfa-d1ea150e7408-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 16, 2016 at 12:56:55PM -0400, Hal Rosenstock wrote:
> On 9/13/2016 2:03 PM, Jason Gunthorpe wrote:
> > opensm is not qualified since it rides on the other libraries.
> 
> I'm not sure whether opensm should be in or out. However, I don't
> understand the not qualified part. It does seem to be similar to both
> srptools and ibacm which are all daemons and live on top of libibverbs
> and libibumad (ibacm has addition netlink socket support).

srp_daemon and iwpmd are both bits of code that reasonably could have
lived in the kernel but have been punted to user space to keep the
kernel simpler. For instance srp_daemon's job is to collect service
record from the SM and tell the kernel about it.

ibacm can reasonably considered a linked subcomponent of librdmacm.

> What are the metrics for inclusion ?

Unclear :)

> What other libraries are you referring to ? OpenSM lives on top of
> libibumad and two internal libraries (complib and a "vendor" library).

Those are the libraries.

opensm is not bound to kernel, does not use the kernel 'uabi' headers,
is not a part of the kernel that was delgated to userspace, and is not
required/related to any of the subcomponents already in the tree.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
