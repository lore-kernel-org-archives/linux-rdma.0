From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH V3 0/2] Add support for enhanced atomic operations
Date: Wed, 10 Mar 2010 17:57:49 +0200
Message-ID: <20100310155749.GA25964@vlad-laptop>
Reply-To: vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Roland,

This patchset adds support for the following enhanced atomic
operations:
- Masked atomic compare and swap
- Masked atomic fetch and add

These operations enable using a smaller amount of memory when using
multiple locks by using portions of a 64 bit value in an atomic
operation.
For some applications the memory savings are very significant. One
example is fine grain lock implementations for huge data sets. In
other cases, the benefit is the ability to update multiple fields with
a single io operation.

Vladimir Sokolovsky(2):
IB/core: Add support for enhanced atomic operations
mlx4/IB: Add support for enhanced atomic operations

changes from V2:
- patch #1: 
  Updated description
  Renamed:
        IB_WR_ATOMIC_MASKED_CMP_AND_SWP -> IB_WR_MASKED_ATOMIC_CMP_AND_SWP
        IB_WR_ATOMIC_MASKED_FETCH_AND_ADD -> IB_WR_MASKED_ATOMIC_FETCH_AND_ADD
  In the ib_send_wr struct the new fields added before the rkey field

- patch #2:
  Set IB_DEVICE_MASKED_ATOMIC flag with other flags that get set for
  all devices

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
