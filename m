From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v5 0/6] nvme-rdma device removal fixes
Date: Sun, 4 Sep 2016 10:01:37 +0300
Message-ID: <89eb2382-9a2f-48d1-c9fd-0c018e07cd9f@grimberg.me>
References: <cover.1472833420.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1472833420.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> This series addresses several problems when shutting down a nvme-rdma
> host when its controllers are attempting to reconnect to a target that
> is no longer reachable.
>
> To tickle these bugs:
>
> 1) attach over iw_cxgb4 to 10 devices on a target.
> 2) 'ifconfig down' the target's interface
> 3) wait for keep-alive to fire and begin reconnecting (~15-20 seconds)
> 4) do one of these on the host:
>    - rmmod iw_cxgb4
>    - reboot
>    - reboot -f
>
> Doug/Sagi, the first 2 iw_cxgb4 patches are included here because they're
> needed for the testing.  While I've also submitted them to linux-rdma,
> perhaps Sagi can merge them in nvmf-4.8-rc?  If that is acceptable
> with everyone.

Fine with me,

Queued for the next round of rc fixes.

Thanks Steve!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
