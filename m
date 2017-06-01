From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] nes: MPA connection establishment flow fixes
Date: Thu, 01 Jun 2017 18:07:01 -0400
Message-ID: <1496354821.7171.56.camel@redhat.com>
References: <1494452800-25896-1-git-send-email-tatyana.e.nikolova@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494452800-25896-1-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-05-10 at 16:46 -0500, Tatyana Nikolova wrote:
> The following patch series contains fixes related to the MPA
> connection
> establishment flow in the nes driver.
> 
> Tatyana Nikolova (2):
>   nes: Don't set 0-length FULPDU RTR indication control flag
>   nes: ACK MPA Reply frame
> 
>  drivers/infiniband/hw/nes/nes_cm.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)

Thanks, series applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
