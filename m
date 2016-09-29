From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH 1/9] Remove HAVE_CONFIG_H
Date: Thu, 29 Sep 2016 16:22:30 -0500
Message-ID: <00d701d21a97$95dba770$c192f650$@opengridcomputing.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com> <1475182076-5411-2-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475182076-5411-2-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Dennis Dalessandro' <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Tatyana Nikolova' <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Sean Hefty' <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Hal Rosenstock' <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Yishai Hadas' <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Vladimir Sokolovsky' <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Devesh Sharma' <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "'open list:HF1 USERSPACE PROVIDER (for hf1.ko)'" <intel-opa-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH 1/9] Remove HAVE_CONFIG_H
> 
> The cmake build system guarantees this header exists, we do not need
> the define or the test.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---

<snip>

>  libcxgb3/src/cq.c                   | 4 +---
>  libcxgb3/src/iwch.c                 | 4 +---
>  libcxgb3/src/qp.c                   | 4 +---
>  libcxgb3/src/verbs.c                | 4 +---
>  libcxgb4/src/cq.c                   | 4 +---
>  libcxgb4/src/dev.c                  | 4 +---
>  libcxgb4/src/qp.c                   | 4 +---
>  libcxgb4/src/verbs.c                | 4 +---

For the above changes:

Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
