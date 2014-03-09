From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v5 00/10] Introduce Signature feature
Date: Sun, 09 Mar 2014 12:57:27 +0200
Message-ID: <531C4917.3010604@dev.mellanox.co.il>
References: <1393157953-24834-1-git-send-email-sagig@mellanox.com> <CAL1RGDXG2yU5mVi=e4A2NFyFo33Um=y03u7yyXL7GZ-J-y3KRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXG2yU5mVi=e4A2NFyFo33Um=y03u7yyXL7GZ-J-y3KRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 3/7/2014 9:43 PM, Roland Dreier wrote:
> So I went ahead and applied this for 3.15,

Hey Roland,

Thanks for taking the time to take a look and pick this up.

> although I suspect the
> verbs API is probably the wrong one.

I will be more than happy to here your concerns, share our approach and 
fix what is needed.

>    I understand that the mlx5
> microarchitecture requires some of this signature binding stuff to go
> through a work queue, but conceptually I don't think the
> IB_WR_REG_SIG_MR work request makes sense as the right interface.  Why
> do I need to do both a synchronous create_mr and an asynchronous work
> request for what's conceptually a single operation?

Hmm, well create_mr and REG_SIG_MR work request are not a single operation
even conceptually. create_mr is a memory key allocation while REG_SIG_MR 
is the
actual (fast) memory registration operation.
* create_mr is the equivalent of ib_alloc_fast_reg_mr and other memory 
key allocation
    routines. Note that we proposed a general routine that can 
replace/unite all memory
    allocations routines in the future.
* REG_SIG_MR is the equivalent of fastreg work request - the actual 
registration.
    It will be taken in the fast-path upon each transaction.

Note that for each data-transfer the user (iSER/SRP) will fast register 
signature MR
as this is a fast path operation and that's why it is a work request. 
REG_SIG_MR may
be seen as fastreg extension. Moreover it would be useful for the user to
pipeline WRs by using a post-list of REG_SIG_MR+RDMA and save a HW doorbell.

> Similarly the ib_check_mr_status() operation doesn't really make sense
> to me as an additional synchronous operation -- why do I not just get
> signature information as part of the completion entry for the
> transaction that generated it?

We actually thought about it more then once. But we chose this way due 
to a couple of reasons:
- Providing the data-integrity status in the completion introduces an 
asymmetric verbs behavior for the
   target and initiator. While the target is the RDMA requester posting 
RDMA operation, it may get the
   data-integrity info in the work completion of the RDMA work request. 
But the initiator can only get the
   data-integrity information in the receive completion of the SCSI 
response as this is the only indication
   that the transaction completed. As you know post recvs are not 
correlated with transactions be any means.

-  Data-integrity does not really belong to the transport completions, 
it belongs to the data itself.
    Meaning RDMA may have completed successfully but the data is 
corrupted. We aimed to keep this
    layering as most applications will handle each differently and may 
wish to explore each error in a different
    stage (for example iSER needs to construct a specific sense for 
data-integrity errors and needs to have the
    iSCSI task at reach, which is provided in a different processing stage).

So we chose to go with a simple lightweight routine that is easy to 
handle and will keep a symmetrical
implementation on all ends. In case this can be improved, I'm open to 
other ideas.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
