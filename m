From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v1 for-next 00/16] On demand paging
Date: Mon, 18 Aug 2014 10:10:01 +0300
Message-ID: <53F1A6C9.7050509@dev.mellanox.co.il>
References: <1404377069-20585-1-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404377069-20585-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/3/2014 11:44 AM, Haggai Eran wrote:
> Hi Roland,
>
> I understand that you were reluctant to review these patches as long as there
> was an ongoing debate on whether or not the i_mmap_mutex should be changed into
> a spinlock.
>
> It seems that the debate concluded with the decision to change it into a rwsem
> [1], as apparently this provides the optimal performance with the new optimistic
> spinning patch [2].
>
> I believe this means that there will be no problem adding paging support to the
> RDMA stack that depends on sleepable MMU notifiers.
>
> Changes from V0: http://marc.info/?l=linux-rdma&m=139375790322547&w=2
>
> - Rebased against latest upstream / for-next branch.
> - Removed dependency on patches that were accepted upstream.
> - Removed pre-patches that were accepted upstream [3].
> - Add extended uverb call for querying device (patch 1) and use kernel device
>    attributes to report ODP capabilities through the new uverb entry instead of
>    having a special verb.
> - Allow upgrading page access permissions during page faults.
> - Minor fixes to issues that came up during regression testing of the patches.
>
> The following set of patches implements on-demand paging (ODP) support
> in the RDMA stack and in the mlx5_ib Infiniband driver.
>

Can we get someone to review/respond on this patch set?? pretty please?

Haggai can't just keep rebasing and resending this to lay around over
the mailing list...

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
