From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCHv3 1/1] RDMA/core: create struct ib_port_cache
Date: Tue, 17 Jan 2017 12:34:18 +0100
Message-ID: <a68939e6-62d3-0d83-16f4-e7784c6fedad@profitbricks.com>
References: <CAMGffEn-fOOe7s2rniqwcaocoV+jxkeJDHZ6WYJkkXi+CBQbEA@mail.gmail.com>
 <b1fdf011-dc25-ad63-b223-0700f6e90bc6@profitbricks.com>
 <20170113150103.GP20392@mtr-leonro.local>
 <2617abae-686e-c8c6-799a-8742156fcd08@profitbricks.com>
 <20170115085014.GB20392@mtr-leonro.local>
 <f08926e7-54c1-fa48-2105-308f82ddcc23@profitbricks.com>
 <20170117112426.GL32481@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170117112426.GL32481-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Leon,

On 17.01.2017 12:24, Leon Romanovsky wrote:
> On Tue, Jan 17, 2017 at 10:11:12AM +0100, Jack Wang wrote:
>>
>>
>> As Jason suggested, we have 4 elements for per port arrays,
>> it's better to have a separate structure to represent them.
>>
>> It simplifies code a bit, ~ 30 lines of code less :)
> 
> The commit message should be descriptive.
> You really NEED to read SubmittingPatches before sending patches.
> http://lxr.free-electrons.com/source/Documentation/SubmittingPatches#L106
Okay, I can improve the commit message.

> 
> 106 2) Describe your changes
> 107 ------------------------
> 108
> 109 Describe your problem.  Whether your patch is a one-line bug fix or
> 110 5000 lines of a new feature, there must be an underlying problem that
> 111 motivated you to do this work.  Convince the reviewer that there is a
> 112 problem worth fixing and that it makes sense for them to read past the
> 113 first paragraph.
> 
> And if I read email headers correctly, you still didn't use "git send-email" to send the patch.

Yes, you're right. But I thought I can have my own preference, or only git send-email is allowed?

Thanks,

> 
> Thanks
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
