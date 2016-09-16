From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFCv2 00/15] RFCv2: Consolidated userspace RDMA library repo
Date: Fri, 16 Sep 2016 12:46:33 -0400
Message-ID: <91389627-0c4b-d8ee-ace3-3a39be48d91f@dev.mellanox.co.il>
References: <1471889618-1605-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB07FB7A@ORSMSX109.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB07FBE1@ORSMSX109.amr.corp.intel.com>
 <20160913180342.GA6933@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB08075C@ORSMSX109.amr.corp.intel.com>
 <20160913222539.GB29095@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB080798@ORSMSX109.amr.corp.intel.com>
 <edc4c963-847a-e973-f1f1-ab9b78ad9d19@redhat.com>
 <20160916161626.GB2833@obsidianresearch.com>
 <de8022d4-debb-2366-48c9-fdd8e391eb4b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <de8022d4-debb-2366-48c9-fdd8e391eb4b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/16/2016 12:34 PM, Doug Ledford wrote:
> On 9/16/2016 12:16 PM, Jason Gunthorpe wrote:
>> On Fri, Sep 16, 2016 at 11:12:17AM -0400, Doug Ledford wrote:
>>
>>> I would.  Mainly because it is tied to both the kernel uAPI (via
>>> netlink)and to librdmacm
>>
>> With what little I know about ibacm I'm inclined to agree. It seems
>> like a utility for librdmacm, and is consuming a kernel interface.
>>
>> Reconsider Sean?
>>
>>> (such that librdmacm changes how it builds when ibacm is present, so
>>> if we don't include it, then ibacm becomes a requirement of the
>>> larger package if you want librdmacm to support the ibacm cache
>>> service).
>>
>> I double checked and I couldn't find anything like
>> this. librdmacm/src/amc.c builds unconditionally and contains no
>> ifdefs, configure does not key on anything to do with acm.
> 
> Sorry, must have changed.  It used to do so (configure used to test for
> presence of ibacm header file and change compile settings accordingly as
> I recall).

Yes, you recall correctly; this change is in librdmacm 1.0.18 and beyond:

commit c8be3cfde6902e490fadd6a51206c1bcba3e3aa2
Author: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Mon Jun 10 10:57:56 2013 -0700

    init: Remove USE_IB_ACM configuration option

    When the librdmacm is configured, it sets the USE_IB_ACM option
    if infininband/acm.h is found.  We can remove this option with
    very little overhead, which would allow a user to install
    ACM after installing the librdmacm, and the librdmacm would be
    able to make use of ACM.

    Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
