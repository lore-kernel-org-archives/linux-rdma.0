From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V3 0/8] Add completion timestamping support
Date: Fri, 12 Jun 2015 06:10:22 +0300
Message-ID: <CAJ3xEMggXGJA5uDzCMTQHLG=vbvabi8OW2YZ3FYXfVqek1ipSQ@mail.gmail.com>
References: <1434029727-6062-1-git-send-email-ogerlitz@mellanox.com>
	<20150611175307.GA20142@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150611175307.GA20142-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 11, 2015 at 8:53 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Thu, Jun 11, 2015 at 04:35:19PM +0300, Or Gerlitz wrote:
>> Jason had another comment calling for re-thinking / questioning the
>> need for a dedicated uverbs_ex_cmd_mask in the IB device. This goes
>> beyond the scope of this specific series.
>
> How is properly setting up the new verbs you added beyond the scope of
> this series?

We didn't add the extended query device uverb call, it was the ODP
series doing so 1-2 upstream releases ago.

> It is a trivial change to move this:
> +       ibdev->ib_dev.uverbs_ex_cmd_mask |=
> +               (1ull << IB_USER_VERBS_EX_CMD_QUERY_DEVICE) |
> +               (1ull << IB_USER_VERBS_EX_CMD_CREATE_CQ);
>
> Into the right core function so it is enabled for all drivers.

I'm really not sure, and if the consensus on the list would be doing
this is the right thing, lets do it in incremental patch around rc1 or
even on top of this series if there's time before the pull request or
if there's rc8

Doug - makes sense?

> That isn't re thinking at all, that is how the extension mechanism was
> always intended to work.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
