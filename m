From: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 00/28] Broadcom RoCE Driver (bnxt_re)
Date: Tue, 6 Dec 2016 11:08:15 +0530
Message-ID: <CA+sbYW21h+704uQwbV9KpTwrLym7B+uAg03bs458Kzq9C_an+g@mail.gmail.com>
References: <1480919912-1079-1-git-send-email-selvin.xavier@broadcom.com> <ee2b9e6f-de43-ab80-d2a7-d431e33c45ba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ee2b9e6f-de43-ab80-d2a7-d431e33c45ba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Chan <michael.chan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 5, 2016 at 8:47 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Please be clear about what you are expecting done with those four
> patches.  If Dave is currently reviewing them, then I need to know
> if/when he takes them so I can rebase the bnxt_en branch on his net-next
> and pick them up that way.

These patches are pulled to net-next already. Now, since David
insisted on splitting this patch series to two,
Michael will push the bnxt_en patch series to net-next.  I will push
the bnxt_re v2 patch set on top of these changes.
You can rebase bnxt_re branch before applying v2 changes. Let me know
if you think otherwise.

Thanks,
Selvin
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
