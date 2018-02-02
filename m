From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH 16/24] ibnbd: client: main functionality
Date: Fri, 2 Feb 2018 08:11:53 -0700
Message-ID: <4f5c5941-c30f-51e8-619a-c03aa9e514b7@kernel.dk>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <20180202140904.2017-17-roman.penyaev@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180202140904.2017-17-roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/2/18 7:08 AM, Roman Pen wrote:
> This is main functionality of ibnbd-client module, which provides
> interface to map remote device as local block device /dev/ibnbd<N>
> and feeds IBTRS with IO requests.

Kill the legacy IO path for this, the driver should only support
blk-mq. Hence kill off your BLK_RQ part, that will eliminate
the dual path you have too.

-- 
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
