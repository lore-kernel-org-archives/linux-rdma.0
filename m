From: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: SQ overflow seen running isert traffic with high block sizes
Date: Wed, 28 Jun 2017 16:05:07 +0530
Message-ID: <20170628103505.GA27517@chelsio.com>
References: <BN3PR07MB25784033E7FCD062FA0A7855F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BN3PR07MB25784033E7FCD062FA0A7855F8DD0-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Here is some more discussion regarding SQ overflow.
https://www.spinics.net/lists/linux-rdma/msg47635.html

Current SQ overflow handling is post error handling to keep the IO running and 
We still see SQ post failures filling the dmesg.
We are still working on fixing SQ overflow.

Thanks,
Bharat.

On Wednesday, June 06/28/17, 2017 at 14:55:45 +0530, Amrani, Ram wrote:
>    We are hitting SQ overflow on iSER target side with high block sizes over
>    RoCE
>    (see dmesg output below).
> 
>    We are using Q-Logic/Cavium NIC with a capability of 4 sges.
> 
>    Following the thread "SQ overflow seen running isert traffic" [1], I was
>    wondering
>    if someone is working on SQ accounting, or more graceful handling of
>    overflow,
>    as the messages are printed over and over.
> 
>    Dmesg output:
>    2017-06-06T09:23:28.824234+05:30 SLES12SP3Beta3 kernel: [65057.799615]
>    isert: isert_rdma_rw_ctx_post: Cmd: ffff880f83cb2cb0 failed to post RDMA
>    res
>    2017-06-06T09:23:29.500095+05:30 SLES12SP3Beta3 kernel: [65058.475858]
>    isert: isert_rdma_rw_ctx_post: Cmd: ffff880ec53ec020 failed to post RDMA
>    res
>    2017-06-06T09:23:29.560085+05:30 SLES12SP3Beta3 kernel: [65058.533787]
>    isert: isert_rdma_rw_ctx_post: Cmd: ffff880ec622ae08 failed to post RDMA
>    res
>    2017-06-06T09:23:29.984209+05:30 SLES12SP3Beta3 kernel: [65058.958509]
>    isert: isert_rdma_rw_ctx_post: Cmd: ffff880ff08e6bb0 failed to post RDMA
>    res
>    2017-06-06T09:23:30.056098+05:30 SLES12SP3Beta3 kernel: [65059.032182]
>    isert: isert_rdma_rw_ctx_post: Cmd: ffff880fa6761138 failed to post RDMA
>    res
>    2017-06-06T09:23:30.288152+05:30 SLES12SP3Beta3 kernel: [65059.262748]
>    isert: isert_rdma_rw_ctx_post: Cmd: ffff880ec3caf668 failed to post RDMA
>    res
>    2017-06-06T09:23:30.444068+05:30 SLES12SP3Beta3 kernel: [65059.421071]
>    isert: isert_rdma_rw_ctx_post: Cmd: ffff880f2186cc30 failed to post RDMA
>    res
>    2017-06-06T09:23:30.532135+05:30 SLES12SP3Beta3 kernel: [65059.505380]
>    isert: isert_rdma_rw_ctx_post: Cmd: ffff880ec6429bf0 failed to post RDMA
>    res
>    2017-06-06T09:23:30.672098+05:30 SLES12SP3Beta3 kernel: [65059.645585]
>    isert: isert_rdma_rw_ctx_post: Cmd: ffff880fa5526bb0 failed to post RDMA
>    res
>    2017-06-06T09:23:30.852121+05:30 SLES12SP3Beta3 kernel: [65059.828072]
>    isert: isert_rdma_rw_ctx_post: Cmd: ffff880f5c8a89d8 failed to post RDMA
>    res
>    2017-06-06T09:23:31.464125+05:30 SLES12SP3Beta3 kernel: [65060.440092]
>    isert: isert_rdma_rw_ctx_post: Cmd: ffff880ffefdf918 failed to post RDMA
>    res
>    2017-06-06T09:23:31.576074+05:30 SLES12SP3Beta3 kernel: [65060.550314]
>    isert: isert_rdma_rw_ctx_post: Cmd: ffff880f83222350 failed to post RDMA
>    res
>    2017-06-06T09:24:30.532064+05:30 SLES12SP3Beta3 kernel: [65119.503466]
>    ABORT_TASK: Found referenced iSCSI task_tag: 103
>    2017-06-06T09:24:30.532079+05:30 SLES12SP3Beta3 kernel: [65119.503468]
>    ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 103
>    2017-06-06T09:24:31.428084+05:30 SLES12SP3Beta3 kernel: [65120.399433]
>    ABORT_TASK: Found referenced iSCSI task_tag: 101
>    2017-06-06T09:24:31.428101+05:30 SLES12SP3Beta3 kernel: [65120.399436]
>    ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 101
>    2017-06-06T09:24:31.556053+05:30 SLES12SP3Beta3 kernel: [65120.527461]
>    ABORT_TASK: Found referenced iSCSI task_tag: 119
>    2017-06-06T09:24:31.556060+05:30 SLES12SP3Beta3 kernel: [65120.527465]
>    ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 119
>    2017-06-06T09:24:31.556061+05:30 SLES12SP3Beta3 kernel: [65120.527468]
>    ABORT_TASK: Found referenced iSCSI task_tag: 43
>    2017-06-06T09:24:31.556062+05:30 SLES12SP3Beta3 kernel: [65120.527469]
>    ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 43
>    2017-06-06T09:24:31.556063+05:30 SLES12SP3Beta3 kernel: [65120.527470]
>    ABORT_TASK: Found referenced iSCSI task_tag: 79
>    2017-06-06T09:24:31.556064+05:30 SLES12SP3Beta3 kernel: [65120.527471]
>    ABORT_TASK: Found referenced iSCSI task_tag: 71
>    2017-06-06T09:24:31.556066+05:30 SLES12SP3Beta3 kernel: [65120.527472]
>    ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 79
>    2017-06-06T09:24:31.556067+05:30 SLES12SP3Beta3 kernel: [65120.527472]
>    ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 71
>    2017-06-06T09:24:31.556068+05:30 SLES12SP3Beta3 kernel: [65120.527506]
>    ABORT_TASK: Found referenced iSCSI task_tag: 122
>    2017-06-06T09:24:31.556068+05:30 SLES12SP3Beta3 kernel: [65120.527508]
>    ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 122
>    2017-06-06T09:24:32.452073+05:30 SLES12SP3Beta3 kernel: [65121.423425]
>    ABORT_TASK: Found referenced iSCSI task_tag: 58
>    2017-06-06T09:24:32.452080+05:30 SLES12SP3Beta3 kernel: [65121.423427]
>    ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 58
>    2017-06-06T09:24:32.516054+05:30 SLES12SP3Beta3 kernel: [65121.487380]
>    ABORT_TASK: Found referenced iSCSI task_tag: 100
>    2017-06-06T09:24:32.516061+05:30 SLES12SP3Beta3 kernel: [65121.487382]
>    ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 100
>    2017-06-06T09:24:32.584031+05:30 SLES12SP3Beta3 kernel: [65121.555374]
>    ABORT_TASK: Found referenced iSCSI task_tag: 52
>    2017-06-06T09:24:32.584041+05:30 SLES12SP3Beta3 kernel: [65121.555376]
>    ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 52
>    2017-06-06T09:24:33.412057+05:30 SLES12SP3Beta3 kernel: [65122.383341]
>    ABORT_TASK: Found referenced iSCSI task_tag: 43
>    2017-06-06T09:24:33.412065+05:30 SLES12SP3Beta3 kernel: [65122.383376]
>    ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 43
>    2017-06-06T09:24:33.476061+05:30 SLES12SP3Beta3 kernel: [65122.447354]
>    ABORT_TASK: Found referenced iSCSI task_tag: 63
>    2017-06-06T09:24:33.476070+05:30 SLES12SP3Beta3 kernel: [65122.447360]
>    ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 63
> 
>    [1] [1]https://patchwork.kernel.org/patch/9633675/
> 
>    Thanks,
>    Ram
>    --
>    To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>    the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>    More majordomo info at  [2]http://vger.kernel.org/majordomo-info.html
> 
> References
> 
>    Visible links
>    1. https://patchwork.kernel.org/patch/9633675/
>    2. http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
