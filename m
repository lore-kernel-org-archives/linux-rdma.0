From: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC v1 for accelerated IPoIB 04/25] IB/verb: Add ipoib_options
 struct and API
Date: Tue, 14 Mar 2017 12:03:01 -0700
Message-ID: <20170314190300.GA80705@knc-06.sc.intel.com>
References: <1489429896-10781-1-git-send-email-erezsh@mellanox.com>
 <1489429896-10781-5-git-send-email-erezsh@mellanox.com>
 <20170313200136.GA2738@obsidianresearch.com>
 <CAAk-MO8dZJKYgpWT8p1fz0O6y2wTx4jxoJhYf21ikMOef_xUMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAk-MO8dZJKYgpWT8p1fz0O6y2wTx4jxoJhYf21ikMOef_xUMg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 14, 2017 at 03:25:01PM +0200, Erez Shitrit wrote:
>On Mon, Mar 13, 2017 at 10:01 PM, Jason Gunthorpe
><jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> On Mon, Mar 13, 2017 at 08:31:15PM +0200, Erez Shitrit wrote:
>>
>>> diff --git a/include/rdma/ib_ipoib_accel_ops.h b/include/rdma/ib_ipoib_accel_ops.h
>>> new file mode 100644
>>> index 000000000000..148a5529a559
>>> +++ b/include/rdma/ib_ipoib_accel_ops.h
>>
>> Both patches need a better naming scheme for this file..
>>
>> rn_opa_vnic.h
>> rn_ipoib.h
>>
>> Maybe?
>
>Can work for me.
>
>vnic?
>

I do see why it is an issue for ipoib (we don't want two ipoib.h files). We can 
add rn_ prefix for vnic, but probably opa_vnic.h is good enough.

>>> +     void *context;
>>
>> What is this? Why is something other than ipoib_priv or ipoib_dev_priv
>> needed?
>
>ipoib_priv is doesn't known in the lower layers, that context is used
>to keep data (qp pointer in that case) that is not available
>otherwise.
>

lower layers should be using ipoib_dev_priv() and no other context is needed. 
which patch is using this 'context'?

Niranjana
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
