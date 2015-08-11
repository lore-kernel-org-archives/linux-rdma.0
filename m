From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 00/12] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Tue, 11 Aug 2015 13:50:19 -0700
Message-ID: <55CA600B.1050706@sandisk.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55BBF4B8.2050700@sandisk.com> <20150731223153.GA1518@obsidianresearch.com>
 <55BBFF03.7000505@sandisk.com> <20150731231430.GA1955@obsidianresearch.com>
 <55BD2689.3080602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55BD2689.3080602-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/01/2015 01:05 PM, Doug Ledford wrote:
> On 07/31/2015 07:14 PM, Jason Gunthorpe wrote:
>> On Fri, Jul 31, 2015 at 04:04:35PM -0700, Bart Van Assche wrote:
>>
>>> With only patches 1/12 and 8/12 applied my test passes.
>>
>> Thanks Bart!
>>
>> If you like, I can try and work on #9 (no promises :(), but I think
>> I'll need some way to test it here.
>>
>> Do you by chance have a straightforward recipe to setup SRP and SRPT
>> on two Linux's for this simple purpose?
>>
>> Doug, just drop #9 'IB/srp: Do not create an all physical insecure
>> rkey by default' please, thanks.
>
> I've pulled in the series for 4.3.  I've included patch #9, but that's
> on the understanding that if it can't be fixed before the initial pull
> request, I'll drop it at that time.  I have the resources to test this,
> so I can work on it, and that factors into my path forward here.

Hi Doug,

Do you feel comfortable enough to queue the nine patches that replace 
Jason's patch #9 for kernel v4.3 (see also 
http://thread.gmane.org/gmane.linux.drivers.rdma/28153/focus=28419) or 
would you rather prefer to take out patch #9 and queue these nine 
patches for kernel v4.4 ? Please advise.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
