From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH, RFC] rdma: split struct ib_send_wr
Date: Tue, 4 Aug 2015 20:54:47 +0300
Message-ID: <55C0FC67.1080104@dev.mellanox.co.il>
References: <1438672609-12599-1-git-send-email-hch@lst.de>
 <55C0F108.4090003@dev.mellanox.co.il> <20150804172328.GA22468@lst.de>
 <55C0F9FA.6060105@dev.mellanox.co.il> <20150804174720.GA22895@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150804174720.GA22895-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/4/2015 8:47 PM, Christoph Hellwig wrote:
> On Tue, Aug 04, 2015 at 08:44:26PM +0300, Sagi Grimberg wrote:
>> I do agree that the size on the stack is less of an issue now. What
>> still can matter is handling each wr one by one vs. doing a collective
>> post.
>
> But if structured correctly you can still do that with on-stack WRs.

No argues.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
