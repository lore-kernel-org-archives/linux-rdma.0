From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Thu, 23 Jul 2015 19:47:14 +0300
Message-ID: <55B11A92.9040406@dev.mellanox.co.il>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
 <20150722180203.GI26909@obsidianresearch.com>
 <55B0BFA4.4060509@dev.mellanox.co.il>
 <20150723161436.GC25174@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150723161436.GC25174-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/23/2015 7:14 PM, Jason Gunthorpe wrote:
> On Thu, Jul 23, 2015 at 01:19:16PM +0300, Sagi Grimberg wrote:
>>> Again, related to my prior comments, please have two of these:
>>>
>>> ib_map_mr_sg_rkey()
>>> ib_map_mr_sg_lkey()
>>>
>>> So we force ULPs to think about what they are doing properly, and we
>>> get a chance to actually force lkey to be local use only for IB.
>>
>> The lkey/rkey decision is passed in the fastreg post_send().
>
> That is too late to check the access flags.

Why? the access permissions are kept in the mr context?
I can move it to the post interface if it makes more sense.
the access is kind of out of place in the mapping routine anyway...

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
