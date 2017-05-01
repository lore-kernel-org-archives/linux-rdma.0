From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 rdma-next 00/18] Enhance ib_ah_attr to specify types
Date: Mon, 01 May 2017 14:34:37 -0400
Message-ID: <1493663677.3041.181.camel@redhat.com>
References: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493491290-31621-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 2017-04-29 at 14:41 -0400, Dasaratharaman Chandramouli wrote:
> This patch series introduces a typed address handle attribute
> that replaces the exisiting IB specific version. One of the 
> drawbacks with the existing attibute was the lack of extensibility
> when underlying drivers wanted to leverage specific fields in the
> attribute structure. This resulted in some of the fields being used
> differently than what it was originally intended for.
> This patch addresses that drawback by defining three address handle
> types namely 'ib', 'roce' and 'opa'. While these these types share
> most
> of the original fields, the changes provide the infrastucture to 
> extend and cleanup the fields based on their types. 
> 
> Note that these patches apply on the earlier patch series with
> subject
> "[PATCH v3 0/7] Add support for OPA classport info"
> 
> Changes from v3:
> --------------
> 
> * Build fixes to ulp/opa_vnic/opa_vnic_vema.c to align with changes
>   to address handle attributes.

Thanks, series applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
