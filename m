From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 00/37] Add rdma verbs transport library
Date: Wed, 9 Dec 2015 14:21:54 +0200
Message-ID: <CAG9sBKPYwG3ug+CEOV--tLXcaa-M_1k5W6+LUeO7RciiRmeh7Q@mail.gmail.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204046.8144.18752.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 7, 2015 at 10:42 PM, Dennis Dalessandro
<dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> The following series implements rdmavt. This is the rdma verbs transport
> software library which will help to solve the problem of code duplication
> between hardware drivers when it comes to a verbs implementation.
>
> Rdmavt is basically just another verbs provider and lives in the Infiniband tree
> in a new sw directory. It provides a software implementation of the Infiniband
> verbs API. More details can be found in the following threads:
>
> http://www.spinics.net/lists/linux-rdma/msg29064.html
> http://www.spinics.net/lists/linux-rdma/msg29922.html
>
> This patch series is based on 4.4-rc3.
>
> ---
Hi Denny

Can you tell how you see the end of this project?
Wouldn't it be right to start with goals and design RFC with more
details than the one you have in the links above, like target drivers
and interfaces?
But since you've already posted this, can we at least have this
discussion now before you proceed so we can all have a chance to
influence the final result?

To be more specific, I always imagined the send path like this
[1] Application -> [2] ib_core -> [3] rdmavt -> [4] rvt-backend
The interfaces from [1] to [3] are like the ones we have today and IMO
the one from [3] t0 [4] should look like

int qib_verbs_send(struct qib_qp *qp, struct qib_ib_header *hdr,
                   u32 hdrwords, struct qib_sge_state *ss, u32 len);

With what I see now, what RDMAVT does is to forward the call to to the
rvt-backend  as is. I'm sure that you are not going to keep it this
way or the goal for removing code duplication won't be achieved.
However, I still would like to know about the plans for being there.

Also, you  you've out yourself as the maintainer of this project. You
deserve it technically of course but since RDMA_VT is not going to
serve just Intel's backends, wouldn't it be right if we add other
co-maintainers that have an interest on this project?

To conclude, RDMA_VT is a project with importance for more than one
vendor and as such it needs to be developed in cooperation or else it
would not serve its purpose.

Thanks

Moni
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
