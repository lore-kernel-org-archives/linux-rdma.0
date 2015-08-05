From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V7 6/6] IB/ucma: HW Device hot-removal support
Date: Wed, 05 Aug 2015 18:51:53 +0300
Message-ID: <55C23119.9040804@dev.mellanox.co.il>
References: <1438697008-26209-1-git-send-email-yishaih@mellanox.com> <1438697008-26209-7-git-send-email-yishaih@mellanox.com> <20150805002338.GB22959@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150805002338.GB22959-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/5/2015 3:23 AM, Jason Gunthorpe wrote:
> On Tue, Aug 04, 2015 at 05:03:28PM +0300, Yishai Hadas wrote:
>> Currently, IB/cma remove_one flow blocks until all user descriptor managed by
>> IB/ucma are released. This prevents hot-removal of IB devices. This patch
>> allows IB/cma to remove devices regardless of user space activity. Upon getting
>> the RDMA_CM_EVENT_DEVICE_REMOVAL event we close all the underlying HW resources
>> for the given ucontext. The ucontext itself is still alive till its explicit
>> destroying by its creator.
>
> Implementation aside,
>
> This changes the policy of the ucma from
>   Tell user space and expect it to synchronously clean up
> To
>   Tell user space we already nuked the RDMA device asynchronously
>
> Do we even want to do that unconditionally?

Yes, the kernel should not depend on userspace applications to approve 
when it has some fatal error or device is removed/unbinded.

>
> Shouldn't the kernel at least give userspace some time to respond to
> the event before nuking the world?

No, the kernel activity is asynchronous to user-space, has higher 
priority and should not wait for. The kernel raises up an event 
(RDMA_CM_EVENT_DEVICE_REMOVAL) let userspace to know that the device was 
removed and continue.
Application that handles events (as expected to do ..) should get it and 
take relevant action items. Further application calls will result in an 
error but application will stay alive.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
