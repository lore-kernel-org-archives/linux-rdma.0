From: Joe Landman <landman-nyOC7EYE20mM0MU9lROt9DlRY1/6cnIP@public.gmane.org>
Subject: Re: rdma problems on Sun / ConnectX hardware
Date: Sun, 03 Jan 2010 15:19:47 -0500
Message-ID: <4B40FBE3.3070306@scalableinformatics.com>
References: <20100103200023.169DF1D90008@adint.net>
Reply-To: landman-nyOC7EYE20mM0MU9lROt9DlRY1/6cnIP@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100103200023.169DF1D90008-uDbadAYOwZ9eoWH0uzbU5w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jeff-ruUnomVL5WBWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Jeff Haferman wrote:
> I tried posting this to general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org and got an auto-reply saying that
> list is no longer active and to instead post here... I posted here a few days ago but
> no response, so, my question is, does anyone have any ideas, or, is there a more
> appropriate place to post?

Hi Jeff

   This should be fine.

[...]

> 
> I've made a bit of progress, with the latest ibtools there is a "-F" option that can be
> passed to "ib_write_lat" to ignore cpufreq stuff, and I now get latencies returned.  
> 
> "rping" however always seems to fail with CQ errors.
> 
> mvapich / openmpi over infiniband usually fails with CQ errors but sometimes my test
> programs run to completion.

[...]

>> lspci | grep -i infin
>> 0b:00.0 InfiniBand: Mellanox Technologies MT25418 [ConnectX IB DDR, PCIe 2.0 2.5GT/s] (rev a0)
>>
>> mstflint -d 0b:00.0 q 
>> Image type:      ConnectX
>> FW Version:      2.6.0

This is an old firmware.  Can you update to 2.6.100 or 2.7.0?

[...]

>> Linux kernel = 2.6.18-92.1.26.el5_lustre.1.6.7.2smp

This also could be an issue ... the 2.6.18 kernel is ancient.  Of course 
with the Lustre patches, you might not be able to use a more modern 
kernel.  1.8.x Lustre might allow you to update the kernel.  I don't 
know if 1.5 OFED works with Lustre just yet.  Which OFED stack are you 
using?


Joe

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics, Inc.
email: landman-nyOC7EYE20mM0MU9lROt9DlRY1/6cnIP@public.gmane.org
web  : http://scalableinformatics.com
        http://scalableinformatics.com/jackrabbit
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
