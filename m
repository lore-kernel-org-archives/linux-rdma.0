From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 rdma-next 0/6] Add support for OPA path records
Date: Mon, 01 May 2017 14:43:23 -0400
Message-ID: <1493664203.3041.182.camel@redhat.com>
References: <1493334362-24774-1-git-send-email-dasaratharaman.chandramouli@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1493334362-24774-1-git-send-email-dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dasaratharaman Chandramouli <dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-04-27 at 19:05 -0400, Dasaratharaman Chandramouli wrote:
> Traditional IB path records have 16 bit SLID and DLID
> fields that cannot really be used by applications and ULPs working
> with 32-bit LIDs. OPA path records add support for 32 bit
> SLIDs and DLIDs. Support for OPA path records is specified
> by bit 26 of the capmask2 field in the OPA class portinfo.
> 
> Note that these patches apply on the earlier patch series with
> subject
> "[PATCH v3 rdma-next 00/18] Enhance ib_ah_attr to specify types"

Thanks, series applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
