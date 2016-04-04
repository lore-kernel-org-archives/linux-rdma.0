From: sagig <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: iSER initiator in 4.5 is unhappy..
Date: Mon, 4 Apr 2016 20:29:19 +0300
Message-ID: <5702A46F.5070109@grimberg.me>
References: <20160404134656.GA30269@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160404134656.GA30269-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> When trying to use iSER with a 4.5 initiator it's rather unhappy and
> I get a spew of messages like:
>
> [  236.814107] iser: iser_fast_reg_fmr: ib_fmr_pool_map_phys failed: -22
> [  236.823100] iser: iser_prepare_read_cmd: Failed to set up Data-IN RDMA
> [  236.832101] iser: iser_send_command: conn ffff88002b16e328 failed task->itt 75 err -22
>
> If I manually comment out the FMR selection in iser_memory.c and force
> it to use FRs things seem to work fine.

Thanks for reporting,

This must be the bio splitting code again...

Christoph, any chance you can run the sg_gaps I/O generator
I sent a while back (Don't yet have access to rdma devices)?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
