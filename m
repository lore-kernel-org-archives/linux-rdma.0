From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [RFC] split struct ib_send_wr
Date: Tue, 4 Aug 2015 09:36:49 -0700
Message-ID: <55C0EA21.2070609@sandisk.com>
References: <20150804143447.GA22172@infradead.org>
 <1828884A29C6694DAF28B7E6B8A82373A902272C@ORSMSX109.amr.corp.intel.com>
 <20150804162924.GA4867@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150804162924.GA4867-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/04/2015 09:29 AM, Christoph Hellwig wrote:
> On Tue, Aug 04, 2015 at 04:07:42PM +0000, Hefty, Sean wrote:
>> This looks like a reasonable start.  It may help with feedback if you
>> could just post the changes to ib_verbs.h.
>
> Not sure it's all that useful, but here we go:
>
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
 > [ ... ]
>   struct ib_recv_wr {
> +	struct ib_send_wr	wr;
>   	struct ib_recv_wr      *next;
>   	u64			wr_id;
>   	struct ib_sge	       *sg_list;

Hello Christoph,

This part of the patch surprised me ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
