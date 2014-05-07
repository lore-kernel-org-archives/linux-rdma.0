From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/5] ib/mad: update module to pr_* style print messages
Date: Wed, 7 May 2014 14:30:04 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E04B82C73@CRSMSX101.amr.corp.intel.com>
References: <1399340690-27677-1-git-send-email-ira.weiny@intel.com>
 <1399340690-27677-3-git-send-email-ira.weiny@intel.com>
 <20140506025356.GB2307@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140506025356.GB2307-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Mon, May 05, 2014 at 09:44:47PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > Also combine previously line broken user-visible strings as per
> > Documentation/CodingStyle
> 
> These seem like nice cleanups, however it would be much nicer to use the
> dev_* versions when a struct device is available, I think many of these cases
> can reach the /dev/umadX struct device..

Ok, this works nice for ib_umad:

infiniband_mad umad1: ib_umad_reg_agent2 failed: invalid registration flags specified 0x2; supported 0x1
vs.
user_mad: ib_umad_reg_agent2 failed: invalid registration flags specified 0x2; supported 0x1


However in ib_mad I'm not so sure.  The error now implies it is the driver which is flagging the error, _not_ ib_mad.

For example here is what you get when you change pr_notice to dev_notice in ib_mad.

ib_qib 0000:01:00.0: ib_register_mad_agent: invalid RMPP Version 2

OR (There are 2 "struct device" in the struct ib_device passed to the register function: dma_device vs dev)

infiniband qib0: ib_register_mad_agent: invalid RMPP Version 2

vs.

ib_mad: ib_register_mad_agent: invalid RMPP Version 2

Either message implies it is the HCA driver which is flagging the error.  Which I think is misleading but maybe this is more correct and is the "kernel way"?

Ira

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
