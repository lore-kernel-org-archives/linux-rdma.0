From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC] split struct ib_send_wr
Date: Wed, 12 Aug 2015 20:24:49 +0300
Message-ID: <55CB8161.8040702@dev.mellanox.co.il>
References: <20150804143447.GA22172@infradead.org>
 <20150806162438.GA27608@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150806162438.GA27608-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/6/2015 7:24 PM, Christoph Hellwig wrote:
> I've pushed out a new version.  Updates:
>
>   - the ib_recv_wr change Bart notices has been fixed.
>   - iser and isert have been converted
>   - the handling of the embedded WR in the qib software queue entry
>     has been fixed.
>
> Which means we're basically done now and the patch could use
> broader testing.

This went very smooth with iser, isert and ipoib...

You can add:

Tested-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Just a nit that I've noticed, in mlx4 set_fmr_seg params are not
aligned to the parenthesis (maybe in other locations too but I haven't
noticed such...)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
