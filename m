From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: Re: [PATCH 27/27] IB/hfi1: Code reuse with memdup_copy
Date: Mon, 13 Feb 2017 10:50:53 +0100
Message-ID: <e6ce8bb1-dad3-a88c-89e6-f3d0c5ced1f7@users.sourceforge.net>
References: <8a997282-09c7-0f9f-645e-d7c6e8c79e67@users.sourceforge.net>
 <b19e44b3-601f-c642-b8d3-12c000511ce2@users.sourceforge.net>
 <477c8499-93ad-253d-aa2b-8f209ecfad62@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <477c8499-93ad-253d-aa2b-8f209ecfad62-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Thanks for the patch, but this one is already taken care of along with other similar uses of kmalloc/copy:
> http://marc.info/?l=linux-rdma&m=148656088729538&w=2

Thanks for your information.

The shown source code is reasonable in the update step “[PATCH 27/27] IB/hfi1:
Code reuse with memdup_copy”.
https://patchwork.kernel.org/patch/9562565/
https://lkml.kernel.org/r/<20170208132830.16442.93943.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>

I find the commit subject and message partly inappropriate.
How do you think about to mention other function names there?

Regards,
Markus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
