From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 09/28] mlx5: Fix gcc 6.4 uninitialized variable warning
Date: Mon, 19 Sep 2016 18:02:25 +0300
Message-ID: <e2d83b20-ee00-bf1b-48b2-44739eee496a@dev.mellanox.co.il>
References: <1473109698-31408-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1473109698-31408-10-git-send-email-jgunthorpe@obsidianresearch.com>
 <0ba444b7-6af4-72f3-d3d6-c27b73421679@dev.mellanox.co.il>
 <20160914163716.GB16014@obsidianresearch.com>
 <f54fd76a-975f-900a-d996-2ae208402ae8@dev.mellanox.co.il>
 <20160915162136.GA26111@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160915162136.GA26111-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Devesh Sharma <Devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/15/2016 7:21 PM, Jason Gunthorpe wrote:
> On Thu, Sep 15, 2016 at 05:26:33PM +0300, Yishai Hadas wrote:
>
>> This 'if' can be omitted and its body can be embedded above for both
>> lazy/non-lazy modes.
> Sure
>> Will handle that in our side and put into our regression system, once the
>> patch will be approved will take it into my formal GIT so that you can take
>> it from there.
>
> Great on both patches

Made the above change in addition to some changes in the commit logs and 
applied both.

The other patches for libmlx4/5 were applied as well, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
