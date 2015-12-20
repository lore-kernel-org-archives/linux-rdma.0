From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 3/7] IB/ulps: Avoid calling ib_query_device
Date: Sun, 20 Dec 2015 18:58:29 +0200
Message-ID: <5676DE35.1080502@mellanox.com>
References: <1450429190-5898-1-git-send-email-ogerlitz@mellanox.com>
 <1450429190-5898-4-git-send-email-ogerlitz@mellanox.com>
 <567413C7.5040907@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <567413C7.5040907-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/18/2015 4:10 PM, Bart Van Assche wrote:
> Shouldn't this patch be split per ULP driver to make review easier ?

The patch is very simple and does the same practice in all ULPs. If it 
helps I can spit off the srp initiator and target bits into a different 
patch, let me know.

>
> If you have a look at the MAINTAINERS file then you will see that you 
> forgot to CC the SRP initiator maintainer. 

yes, sorry for that, will copy you on further versions if there are such.

Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
