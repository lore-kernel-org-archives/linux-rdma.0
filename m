From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 00/43] New fast registration API
Date: Thu, 23 Jul 2015 13:34:22 +0300
Message-ID: <55B0C32E.8090303@dev.mellanox.co.il>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <20150722171023.GA18934@infradead.org> <55AFD608.401@dev.mellanox.co.il>
 <20150723092857.GE32592@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150723092857.GE32592-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/23/2015 12:28 PM, Christoph Hellwig wrote:
> On Wed, Jul 22, 2015 at 08:42:32PM +0300, Sagi Grimberg wrote:
>> We can do that, but I'd prefer not to pollute the API just for this
>> single use case. What we can do, is add a pool API that would take care
>> of that. But even then we might end up with different strategies as not
>> all ULPs can use it the same way (protocol constraints)...
>>
>> Today SRP has this logic that registers multiple SG aligned partials.
>> We can just have it pass a partial SG list to what we have today instead
>> of building the page vectors...
>>
>> Or if we can come up with something that will keep the API trivial, we
>> can take care of that too.
>
>
> Supporting an array or list of MRs seems pretty easy.

I'm missing the simplicity here...

> If you ignore the
> weird fallback to physical DMA case when a MR fails case the SRP memory
> registration code isn't significanly more complex than that in iSER for
> example.  And I think NFS needs the same support as well, as it allows
> using additional MRs when detecting a gap.
>

This kinda changing the semantics a bit. With this we need to return a
value of how many MRs used to register. It will also make it a bit
sloppy as the actual mapping is driven from the drivers (which use their
internal buffers).

Don't you think that a separate pool API is better for addressing this?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
