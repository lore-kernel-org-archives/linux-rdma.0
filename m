From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 01/43] IB: Modify ib_create_mr API
Date: Sun, 26 Jul 2015 11:51:36 +0300
Message-ID: <55B49F98.1070204@dev.mellanox.co.il>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-2-git-send-email-sagig@mellanox.com>
 <20150722163405.GA26909@obsidianresearch.com>
 <20150722164421.GA6443@infradead.org> <55AFCBAF.2000504@dev.mellanox.co.il>
 <20150722190555.GB4527@obsidianresearch.com>
 <55B0BCFC.6040602@dev.mellanox.co.il>
 <20150723190855.GB31577@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150723190855.GB31577-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/23/2015 10:08 PM, Jason Gunthorpe wrote:
> On Thu, Jul 23, 2015 at 01:07:56PM +0300, Sagi Grimberg wrote:
>> On 7/22/2015 10:05 PM, Jason Gunthorpe wrote:
>> The reason I named max_entries is because might might not be pages but
>> real SG elements. It stands for maximum registration entries.
>>
>> Do you have a better name?
>
> I wouldn't try and be both..
>
> Use 'max_num_sg' and document that no aggregate scatterlist with
> length larger than 'max_num_sg*PAGE_SIZE' or with more entries than
> max_num_sg can be submitted?
>
> Maybe document with ARB_SG that it is not length limited?

OK, I can do that.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
