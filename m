From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 1/3] verbs: Enable creating QP with a given
 source QP number
Date: Thu, 7 Sep 2017 21:46:39 +0300
Message-ID: <CAFgAxU8QqEQwCMnu=_1hjRVMHJ_242pXykxHuJ9PftxTV77TUw@mail.gmail.com>
References: <1504786327-820-1-git-send-email-yishaih@mellanox.com>
 <1504786327-820-2-git-send-email-yishaih@mellanox.com> <20170907151641.GC20644@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170907151641.GC20644-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 7, 2017 at 6:16 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Thu, Sep 07, 2017 at 03:12:05PM +0300, Yishai Hadas wrote:
>> +uint32_t                source_qpn;     /* Source QP number, creation flag IBV_QP_CREATE_SOURCE_QPN should be set */
>
> I think more discussion in the man page is required for this
> feature. Eg that it is a SEND ONLY QP and only works for UD.

Verbs UD QP can handle receive of ingress packets sent with
BTH.DestQPN = ibv_qp->qp_num. This is applicable also in this case.

Also, future implementation might include RC source qpn use case. This
can be accomplished by setting the HCA's QPN to be the same as the
'source qpn' value, and returning that to the user.

We prefer not to limit the API definition in the man page.

Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
