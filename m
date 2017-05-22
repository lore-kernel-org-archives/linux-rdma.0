From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V3 for-next 14/15] RDMA/bnxt_re: Sync up the module
 version to internal release version
Date: Mon, 22 May 2017 15:33:40 +0530
Message-ID: <CA+sbYW1B8QNhe-xLkByhtWC+jfsx5K8ceXew7tw5HhG4-qc2hg@mail.gmail.com>
References: <1495169074-12641-1-git-send-email-selvin.xavier@broadcom.com>
 <1495169074-12641-15-git-send-email-selvin.xavier@broadcom.com> <7f6e879e-175b-d126-17c3-e1314025ae33@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7f6e879e-175b-d126-17c3-e1314025ae33-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Dennis,
 I am dropping this patch from this series. Posting v4 without this patch.
Thanks,
Selvin Xavier

On Fri, May 19, 2017 at 6:18 PM, Dennis Dalessandro
<dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On 5/19/2017 12:44 AM, Selvin Xavier wrote:
>>
>> Updates the module version. The new version number will enable us to
>> map the upstream driver to the level of supported features in the
>> internal code base.
>
>
> Your internal code base doesn't mean anything at all to the kernel. If you
> don't have a valid reason why the kernel needs this version number get rid
> of this patch please.
>
> -Denny
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
