From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH 4/6] IB/srp: use IB_PD_UNSAFE_GLOBAL_RKEY
Date: Tue, 30 Aug 2016 18:35:11 +0300
Message-ID: <ee2000ac-350e-dad0-77e8-4fbc6c53f202@grimberg.me>
References: <1472464943-29450-1-git-send-email-hch@lst.de>
 <1472464943-29450-5-git-send-email-hch@lst.de>
 <df613e79-7c01-5fa6-5586-6f567254224b@sandisk.com>
 <20160830124705.GA7585@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160830124705.GA7585-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


>> Keeping the two global_mr variables would
>> reduce the number of load instructions the CPU has to perform while mapping
>> SRP requests.
>
> We can add pointers to the pd in the same places, that should give you
> the same number of load instructions.

Not sure how much it makes a real difference.

Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
