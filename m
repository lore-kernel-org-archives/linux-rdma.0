From: kenneth vitagliano <kenvitagliano-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Questions about IB_WR_RDMA_READ_WITH_INV and IB_WR_SEND_WITH_INV opcodes
Date: Fri, 26 Oct 2012 13:32:04 +0200
Message-ID: <CAKgG1fw4NKXWxtMsgC6iHe7FOMs1aBR3ouaWfjFAKmwFOaA-Uw@mail.gmail.com>
References: <CAKgG1fzodm5qPmokjOG_OTsXOFmU+nd4H1z3Kqq-A-ixpYDO_w@mail.gmail.com>
	<CAL1RGDUNX+hWScz5FGryp7bSV2-QBFGedAH5QtU3kJ-xJF=MJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUNX+hWScz5FGryp7bSV2-QBFGedAH5QtU3kJ-xJF=MJQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

Thanks for your answer.

I had a first quick look at the IB specs, but there are differences
between what's in the specs and what I understand or noticed in OFED.

Here is an example:

10.6.5 INVALIDATION OF MEMORY REGIONS
According to this chapter, there are 2 ways of invalidating:
A local post send local invalidate
A remote send with invalidate.

For the local invalidation, the consumer must provide both lkey and
rkey, and the MR handle.
But in OFED, as far as I saw, the IB_WR_LOCAL_INV opcode only comes
with wr.ex.invalidate_rkey. I looked at krping code as an example.

For the send with invalidate, it is said the consumer must supply the
remote rkey to be invalidated, which seems to match what's in OFED.

It is said both the lkey and rkey are paced in the Free State after
the invalidation.
But as we just said, in both cases in OFED, only one key is provided.

Which makes it unclear at the standard point of view: how is
invalidated the remote lkey (by the remote side) when only the rkey is
received in the send with invalidate operation? And as mentioned
above, both keys are to be invalidated by the operation.
And it's unclear at the OFED point of view, as all the information the
standard mentions are not provided for invalidating locally.

And there is no mention of a read with invalidate operation, which is
available in OFED. And then again, why there is no write with
invalidate in OFED?

So that's why I'll continue digging into those specs, but I would
prefer an OFED-specific explanations on those operations, or OFED
examples  / use cases.

Thanks,

Kenneth

2012/10/26 Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>:
> On Thu, Oct 25, 2012 at 2:09 AM, kenneth vitagliano
> <kenvitagliano-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> If there is any documentation with the answers to the questions below,
>> please link it to me, thanks.
>>
>> Can someone please confirm the usage of the post_send opcodes
>> IB_WR_RDMA_READ_WITH_INV and IB_WR_SEND_WITH_INV:
>
> The best place to look for an explanation of this is the InfiniBand spec,
> specifically the base memory management extensions.
>
>  - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
