From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCHv2 1/1] IB/core: create struct ib_port_cache
Date: Fri, 13 Jan 2017 16:35:54 +0100
Message-ID: <2617abae-686e-c8c6-799a-8742156fcd08@profitbricks.com>
References: <CAMGffEn-fOOe7s2rniqwcaocoV+jxkeJDHZ6WYJkkXi+CBQbEA@mail.gmail.com>
 <b1fdf011-dc25-ad63-b223-0700f6e90bc6@profitbricks.com>
 <20170113150103.GP20392@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170113150103.GP20392-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 13.01.2017 16:01, Leon Romanovsky wrote:
> On Fri, Jan 13, 2017 at 02:12:19PM +0100, Jack Wang wrote:
>> Hi Doug, hi Jason and others,
>>
>> As Doug already merged the first 4 patches to his tree, so I rebased this patch also
>> on his latest for-4.11 branch (commit 102c5ce082), minor tweak on commit message.
>> I also configured my thunderbirds to keep the patch format as expected :), so here we go!
> 
> Hi Jack,
> I don't know what did you configure, but git send-email is a preferred
> way to send linux kernel patches.
> 
> Your attached patches are appearing wrongly (wrong subject and mbox garbage) in
> the patchworks https://patchwork.kernel.org/patch/9515651/
> 
> Thanks
> 
Hi Leon,

Thanks, I understand I changed subject in the patch because I notice Doug is using such naming.
But I don't follow "mbox garbage", what do you mean here?

About git send-email, I used to successfully sent patch with the tool, but somehow it's now always get reject 
by gmail. 

I'm not familiar with patchwork, will reply to same thread with proper subject fix the problem or I have to do it in a new thread?

Thanks,
Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
