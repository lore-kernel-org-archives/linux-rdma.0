From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: RoCE passive side failures on 4.4-rc5
Date: Fri, 18 Dec 2015 10:27:00 +0200
Message-ID: <5673C354.1030707@mellanox.com>
References: <5672BF85.6080005@mellanox.com>
 <5672C429.90803@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5672C429.90803-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/17/2015 4:18 PM, Sagi Grimberg wrote:
> I'm using 4.4-rc2+ and I have RoCE working. 

I tried 4.4-rc2 and I see the same problem. I will make my .config
available to you and Moni so you can try it out on your systems Sunday.

I see this over both CX2 and CX3-pro, both are in VPI config.

BTW getting the 28 (consumer defined) reject reason is something I saw 
coming
and going from time to time in various weird cases over the past years.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
