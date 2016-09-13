From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Tue, 13 Sep 2016 22:13:10 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB08075C@ORSMSX109.amr.corp.intel.com>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB07FB7A@ORSMSX109.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB07FBE1@ORSMSX109.amr.corp.intel.com>
 <20160913180342.GA6933@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160913180342.GA6933-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The intent is to cover the user space component of the kernel.
> 
> So, if code is including uapi/rdma/* then it is a good candidate for
> this tree.

Based on discussions so far, I would limit the scope to the 'common' or 'shared' or non-vendor-specific areas of the uAPI.

> libacm, I am unclear on. Is it the recommended userspace component for
> the netlink socket that Kaike? Is it coupled to librdmacm? If yes it
> should probably come too.

Yes, this is the userspace daemon for the SA netlink socket.  And to be clear, it's ibacm, as it's a daemon not a library.  The librdmacm looks for and uses ibacm when present.

> psm/psm2, I have no knowledge about this, it seems to meet the
> qualification, but I haven't seen it follow a community model? I
> don't have an impression that Intel would view that favorably..

I couldn't say for certain, but my guess is that the psm team would like to maintain this separately.  AFAIK, it has no dependency on verbs or the verbs uapi.

> opensm is not qualified since it rides on the other libraries.
> 
> Not sure what distributed SA encompasses..

I'm not sure either at this point.  It used to ride completely on the other libraries.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
