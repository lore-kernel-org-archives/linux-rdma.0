From: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] RDMA/ocrdma: Fix arm logic to align with new cq API
Date: Fri, 12 Feb 2016 09:16:47 +0530
Message-ID: <CANjDDBgH-4Foq02f8wE2bdg7OprvT84gLNY6-9uPNgYWEFKLPg@mail.gmail.com>
References: <1455168112-12803-1-git-send-email-devesh.sharma@broadcom.com> <CAG53R5UnRqq9Gf5fFZJr+e_3DQvz7ViveJJAz6FBFYBaADtMJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG53R5UnRqq9Gf5fFZJr+e_3DQvz7ViveJJAz6FBFYBaADtMJA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Parav,

I have tested this patch with nfsrdma + linux-4.4 (i.e. without
Chuck's patches to use new CQ API)
iozone on nfsrdma mount point passed.

-Regards
Devesh

On Fri, Feb 12, 2016 at 2:43 AM, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Thu, Feb 11, 2016 at 10:51 AM, Devesh Sharma
> <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org> wrote:
>> CQ is never armed before calling poll on it. Most of the kernel
>> ULPs have already moved to use this new API or have a code where
>> poll is called before arming the CQ.
>
> You might want to wait for NFS whose patches are in pipe to migrate to
> newer APIs before merging this?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
