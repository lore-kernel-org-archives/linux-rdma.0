From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 0/6] Expanding raw packet capabilities
Date: Tue, 21 Mar 2017 13:33:44 -0400
Message-ID: <1490117624.2404.12.camel@redhat.com>
References: <1489591666-14062-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489591666-14062-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-03-15 at 17:27 +0200, Yishai Hadas wrote:
> Sending V1 to better describe the API as part of commit logs and man
> pages,
> details below.
> 
> This series from Noa is the complementary user space part
> of the kernel code that was merged into 4.11.
> 
> This series unifies all existing raw packet capabilities under a new
> field in ibv_device_attr_ex named raw_packet_caps. This field is
> defined
> by the ibv_raw_packet_caps enum.
> 
> The existing IP csum and scatter FCS capabilities were added to the
> enum and a new capability was introduced - cvlan stripping offload.
> 
> Cvlan stripping is the device's capability to remove the cvlan from
> an incoming raw packet and provide the data in the matching work
> completion.
> 
> This series also:
> - Allows creation of WQ and raw Ethernet QP with cvlan stripping
> capability.
> - Allows setting and unsetting of cvlan stripping capability for an
> existing WQ.
> - Allows creation of WQ with scatter FCS offload.
> - Allows reading the cvlan data from ibv_cq_ex.
> 
> Details for above was added as part of the commit logs and the
> relevant
> man pages.
> 
> Pull request was sent:
> https://github.com/linux-rdma/rdma-core/pull/96
> 
> Changes from V0:
> - Extend commit logs to better describe the usage from user point of
> view.
> - Per API change put the corresponding man page change in the same
> patch to
>   clarify the usage. 
> - Drop patch #6 which held the changes for all the man pages together
> as of
>   the above change.
> - Align involved man pages with current code where stuff was missing
> and extend
>   to better describe the new functionality.

Thanks, version 1 of the series merged.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
