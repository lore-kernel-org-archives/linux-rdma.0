From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix possible use-after-free
Date: Tue, 11 Aug 2015 08:17:36 -0700
Message-ID: <55CA1210.90207@sandisk.com>
References: <1439216574-25936-1-git-send-email-sagig@mellanox.com>
 <55C8BB38.1060808@sandisk.com> <55CA09E5.2070208@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55CA09E5.2070208-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/11/2015 07:42 AM, Sagi Grimberg wrote:
> [PATCH] IB/srp: Fix possible protection fault
>
> srp_destroy_qp is designed to indicate we are safe to continue with
> freeing the channel resources by modifying the qp error state,
> posting a dummy wr on the queue-pair and waiting for it to flush.
> This also holds for the channel registration pool as we are unmapping
> the memory region when handling a scsi response. Destroying the
> channel registration pool before we make sure we processed all the
> inflight IO might introduce a use-after-free of the registration pool.
>
> This use-after-free is demonstrated in the stack trace below where
> srp is trying to unmap a used FMR after the fmr_pool was already destroyed.
 >
> Reported-by: Eliott Kespi <eliottk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Please consider Cc-ing "stable" for this patch. Anyway,

Reviewed-by: Bart Van Assche <bvanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>

> Sorry for the mixup. Does this patch make more sense?

Thank you for the quick respin. By posting this second patch quickly you 
saved me considerable time. I was going to verify whether any upstream 
patches were missing from the distro kernel that was used in your tests 
but this second description makes it clear that scsi_remove_host() was 
not involved in this crash.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
