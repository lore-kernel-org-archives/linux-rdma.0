From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 10/11] IB: only keep a single key in struct ib_mr
Date: Tue, 22 Dec 2015 15:50:12 +0200
Message-ID: <56795514.9090704@dev.mellanox.co.il>
References: <1448214409-7729-1-git-send-email-hch@lst.de>
 <1448214409-7729-11-git-send-email-hch@lst.de>
 <56791542.6020604@dev.mellanox.co.il> <20151222131326.GA25267@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151222131326.GA25267-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 22/12/2015 15:13, Christoph Hellwig wrote:
> On Tue, Dec 22, 2015 at 11:17:54AM +0200, Sagi Grimberg wrote:
>> What makes me worried here is that the IB/RoCE specification really
>> defines different keys for local and remote access. I'm less concerned
>> about our consumers but more about our providers. We keep seeing new
>> providers come along and its not impossible that a specific HW will
>> *rely* on this distinction. In such a case we'd need to revert this
>> patch altogether in that very moment.
>>
>> I think we're better off working on proper abstractions to help ULPs
>> get it right (and simple!), without risking future devices support.
>
> With the new API in the next patch ULPs simply can't request an lkey
> and a rkey at the same time, so for kernel use it's not a problmblem at
> all.

This is why I said that the problem here is not the ULPs. But if a new
HW comes along with distinction between rkeys and lkeys it will have a
problem. For example a HW allocates two different keys, rkey and lkey.
And, it chooses to fail SEND from a rkey, or incoming READ/WRITE to a
lkey. How can such a device be supported with an API that allows a
single key per MR?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
