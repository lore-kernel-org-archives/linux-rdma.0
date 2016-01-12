From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCHv2 for-4.5 0/2] iw_cxgb4: Fixes static checker warnings
Date: Tue, 12 Jan 2016 09:15:37 +0200
Message-ID: <CALq1K=JM1zX7eUR9ertFpTrUBOjxRPmyFKg1Gw=vy2hz-BZNXQ@mail.gmail.com>
References: <1452577477-13490-1-git-send-email-hariprasad@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452577477-13490-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 12, 2016 at 7:44 AM, Hariprasad Shenai
<hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org> wrote:
> Hi,
>
> This series fixes static checker warning's and fixes GW-Basic name labels
> to meaningful ones.
>
> This patch series has been created against Doug's linux tree and includes
> patches on iw_cxgb4 driver.
>
> We have included all the maintainers of respective drivers. Kindly review
> the change and let us know in case of any review comments.
>
> Thanks
>
> V2: Dropped an error message in Patch 1/2 ("iw_cxgb4: Fixes static checker
>     warning in c4iw_rdev_open()"), and updated commit message to be
>     consistent. Based on review comments by Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>

You didn't fix most of comments
Please take a look on the submitting patches documentation [1] and
resubmit them.

[1] http://lxr.free-electrons.com/source/Documentation/SubmittingPatches#L187

>
>
> Hariprasad Shenai (2):
>   iw_cxgb4: Fixes static checker warning in c4iw_rdev_open()
>   iw_cxgb4: Fixes GW-Basic labels to meaningful error names
>
>  drivers/infiniband/hw/cxgb4/device.c | 53 ++++++++++++++----------------------
>  1 file changed, 21 insertions(+), 32 deletions(-)
>
> --
> 2.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
