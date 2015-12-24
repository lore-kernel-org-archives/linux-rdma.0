From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] IB/cma: cma_match_net_dev needs to take into account
 port_num
Date: Thu, 24 Dec 2015 10:18:39 +0200
Message-ID: <567BAA5F.8000507@mellanox.com>
References: <1450710084-22547-1-git-send-email-matanb@mellanox.com>
 <56792A4B.8060101@mellanox.com> <56799D61.9010206@redhat.com>
 <CAAKD3BDmenFsiZTDiw8OEW-F0GqK62+zJ-TVywyYd4YDtzxrCA@mail.gmail.com>
 <567AC6E4.3030100@redhat.com>
 <CAAKD3BAt2YBB-Y-VH29w5B7rLfbBEq2EuH6BtDwb0O3W8-PGwg@mail.gmail.com>
 <567AE07A.10003@redhat.com>
 <CAAKD3BADP_Jf2zNJDcx8YOv1zt4=pp5V+eYugfn-tBuVgFxBCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BADP_Jf2zNJDcx8YOv1zt4=pp5V+eYugfn-tBuVgFxBCw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/24/2015 9:57 AM, Matan Barak wrote:
> I totally agree that it's better to use the local IP address and not
> just get a random device by using 127.0.0.1. You could get a specific
> device by binding it, but then - use its local IP instead of
> 127.0.0.1.

Yes guys, it might be better but the user can do that. However, loopback 
ala 127.0.0.1 is working in the rdma-cm since the 2.6.18 day one and was 
broken recently when Eth ports are around.

Lets fix.

Indeed, this is 4.5 and not 4.4 material.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
