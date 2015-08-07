From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC] split struct ib_send_wr
Date: Thu, 6 Aug 2015 23:35:07 -0700
Message-ID: <20150807063507.GB31458@infradead.org>
References: <20150804143447.GA22172@infradead.org>
 <20150806162438.GA27608@infradead.org>
 <CAG53R5VWR99OUmVTYWjvQiPKDuZ=ogbsEyfTJMcURjeohYyLmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5VWR99OUmVTYWjvQiPKDuZ=ogbsEyfTJMcURjeohYyLmQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 06, 2015 at 11:08:45PM +0530, Parav Pandit wrote:
> Do you see value in dividing ib_ud _wr into ib_ud_wr and ib_ud_gsi_wr
> to save 4 bytes?

For now I just wanted to split along the lines of the existing unions.
>From looking at the various drivers splitting the GSI path might not be
a bad idea, but it's not a priority for me.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
