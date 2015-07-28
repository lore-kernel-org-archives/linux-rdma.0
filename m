From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RESEND 0/4] Use max_sge_rd device capability
Date: Tue, 28 Jul 2015 12:28:43 +0300
Message-ID: <55B74B4B.8000000@dev.mellanox.co.il>
References: <20150727230906.10102.88491.stgit@build2.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150727230906.10102.88491.stgit-PBeJgSbIpn97NCTnQtmixQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/28/2015 2:09 AM, Steve Wise wrote:
> Resending because I forgot to cc linux-rdma :(
>
> Some devices were not setting this capability, so fix those devices,
> and svcrdma to use max_sge_rd.  Also remove rdma_cap_read_multi_sge()
> since it isn't needed.
>
> These patches were originally part of:
>
> http://www.spinics.net/lists/linux-rdma/msg27436.html
>
> They really aren't part of iSER/iWARP at all, so I've split
> them out.
>
> Bruce: This hits svcrdma, but I suggest they get merged via Doug's tree
> to avoid any merge problems.
>
> ---

Looks good,

Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
