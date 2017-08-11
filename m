From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next v3 0/7] Add OPA extended LID support
Date: Fri, 11 Aug 2017 11:56:18 -0400
Message-ID: <1502466978.3080.43.camel@redhat.com>
References: <1496943469-44017-1-git-send-email-don.hiatt@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496943469-44017-1-git-send-email-don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-06-08 at 13:37 -0400, Don Hiatt wrote:
> This patch series primarily increases sizes of variables that hold
> lid values from 16 to 32 bits. Additionally, it adds a check in
> the IB mad stack to verify a properly formatted MAD when OPA
> extended LIDs are used.
> 
> Changes from v2:
> ---------------
> * Remove 'IB/mad: Ensure DR MADs are correctly specified when using
>   OPA devices' as this will be handled in a lower layer.

Hi Don,

Thanks, series applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
