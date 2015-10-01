From: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/ucma: check workqueue allocation before usage
Date: Thu, 01 Oct 2015 10:54:23 -0400
Message-ID: <560D491F.7020200@oracle.com>
References: <1442520259-2248-1-git-send-email-sasha.levin@oracle.com> <20150917225934.GA22326@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150917225934.GA22326-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09/17/2015 06:59 PM, Jason Gunthorpe wrote:
> On Thu, Sep 17, 2015 at 04:04:19PM -0400, Sasha Levin wrote:
>> Allocating a workqueue might fail, which wasn't checked so far and would
>> lead to NULL ptr derefs when an attempt to use it was made.
> 
> Indeed.
> 
> Yishai, please check this and check the other patches you've sent to
> see if they have a similar error.

Ping? It doesn't seem that the patch got anywhere.


Thanks,
Sasha

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
