From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: IB/mlx4: Build the port IBoE GID table properly under bonding
Date: Wed, 12 Mar 2014 11:17:23 +0100
Message-ID: <53203433.5060603@acm.org>
References: <20140217115235.GA27933@elgon.mountain> <53036A88.5030306@mellanox.com> <20140218142858.GN26776@mwanda> <53036F15.1080601@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53036F15.1080601-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/18/14 15:32, Moni Shoua wrote:
>> Ha ha. Take another look. That's what I was just explaining about! :) On
>> line 1743 when curr_master is non-NULL then Smatch doesn't complain
>> because it understands about the relationship between curr_master and
>> curr_netdev. But here it is complaining about line 1749 where
>> curr_master is NULL so the implication doesn't apply. Nice, huh?
>> regards, dan carpenter
> 
> You're right :)
> I'll write the fix.

Hello Moni,

Have you already had a chance to look further into this issue ?

Thanks,

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
