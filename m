From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 1/3] verbs: Enable creating QP with a given
 source QP number
Date: Tue, 12 Sep 2017 14:38:20 +0300
Message-ID: <06f15329-21f0-35ab-d6de-ef6d7183e4e6@dev.mellanox.co.il>
References: <1504786327-820-1-git-send-email-yishaih@mellanox.com>
 <1504786327-820-2-git-send-email-yishaih@mellanox.com>
 <20170907151641.GC20644@obsidianresearch.com>
 <CAFgAxU8QqEQwCMnu=_1hjRVMHJ_242pXykxHuJ9PftxTV77TUw@mail.gmail.com>
 <20170907192909.GA5364@obsidianresearch.com>
 <CAFgAxU8bkhb6tvB=1GUzqW2Dg-43Y+pZkDaXvFOE+5CEMLs6Mg@mail.gmail.com>
 <20170911162854.GE32117@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170911162854.GE32117-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 9/11/2017 7:28 PM, Jason Gunthorpe wrote:
> You need to mention what impact source_qpn has on the RX, assuming the
> user does nothing else.
>
> From what I can gather, without flow steering, RX should not be
> possible.
>

Correct.

> Yes. Describe what it does. The man page is not a spec, it documents
> what the software actually does.
>

Man page was updated in the PR to include above notes.

PR:
https://github.com/linux-rdma/rdma-core/pull/212
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
