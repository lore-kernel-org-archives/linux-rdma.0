From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: SQ overflow seen running isert traffic with high block sizes
Date: Wed, 28 Jun 2017 09:25:45 +0000
Message-ID: <BN3PR07MB25784033E7FCD062FA0A7855F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We are hitting SQ overflow on iSER target side with high block sizes over R=
oCE
(see dmesg output below).

We are using Q-Logic/Cavium NIC with a capability of 4 sges.

Following the thread "SQ overflow seen running isert traffic" [1], I was wo=
ndering
if someone is working on SQ accounting, or more graceful handling of overfl=
ow,
as the messages are printed over and over.

Dmesg output:
2017-06-06T09:23:28.824234+05:30 SLES12SP3Beta3 kernel: [65057.799615] iser=
t: isert_rdma_rw_ctx_post: Cmd: ffff880f83cb2cb0 failed to post RDMA res
2017-06-06T09:23:29.500095+05:30 SLES12SP3Beta3 kernel: [65058.475858] iser=
t: isert_rdma_rw_ctx_post: Cmd: ffff880ec53ec020 failed to post RDMA res
2017-06-06T09:23:29.560085+05:30 SLES12SP3Beta3 kernel: [65058.533787] iser=
t: isert_rdma_rw_ctx_post: Cmd: ffff880ec622ae08 failed to post RDMA res
2017-06-06T09:23:29.984209+05:30 SLES12SP3Beta3 kernel: [65058.958509] iser=
t: isert_rdma_rw_ctx_post: Cmd: ffff880ff08e6bb0 failed to post RDMA res
2017-06-06T09:23:30.056098+05:30 SLES12SP3Beta3 kernel: [65059.032182] iser=
t: isert_rdma_rw_ctx_post: Cmd: ffff880fa6761138 failed to post RDMA res
2017-06-06T09:23:30.288152+05:30 SLES12SP3Beta3 kernel: [65059.262748] iser=
t: isert_rdma_rw_ctx_post: Cmd: ffff880ec3caf668 failed to post RDMA res
2017-06-06T09:23:30.444068+05:30 SLES12SP3Beta3 kernel: [65059.421071] iser=
t: isert_rdma_rw_ctx_post: Cmd: ffff880f2186cc30 failed to post RDMA res
2017-06-06T09:23:30.532135+05:30 SLES12SP3Beta3 kernel: [65059.505380] iser=
t: isert_rdma_rw_ctx_post: Cmd: ffff880ec6429bf0 failed to post RDMA res
2017-06-06T09:23:30.672098+05:30 SLES12SP3Beta3 kernel: [65059.645585] iser=
t: isert_rdma_rw_ctx_post: Cmd: ffff880fa5526bb0 failed to post RDMA res
2017-06-06T09:23:30.852121+05:30 SLES12SP3Beta3 kernel: [65059.828072] iser=
t: isert_rdma_rw_ctx_post: Cmd: ffff880f5c8a89d8 failed to post RDMA res
2017-06-06T09:23:31.464125+05:30 SLES12SP3Beta3 kernel: [65060.440092] iser=
t: isert_rdma_rw_ctx_post: Cmd: ffff880ffefdf918 failed to post RDMA res
2017-06-06T09:23:31.576074+05:30 SLES12SP3Beta3 kernel: [65060.550314] iser=
t: isert_rdma_rw_ctx_post: Cmd: ffff880f83222350 failed to post RDMA res
2017-06-06T09:24:30.532064+05:30 SLES12SP3Beta3 kernel: [65119.503466] ABOR=
T_TASK: Found referenced iSCSI task_tag: 103
2017-06-06T09:24:30.532079+05:30 SLES12SP3Beta3 kernel: [65119.503468] ABOR=
T_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 103
2017-06-06T09:24:31.428084+05:30 SLES12SP3Beta3 kernel: [65120.399433] ABOR=
T_TASK: Found referenced iSCSI task_tag: 101
2017-06-06T09:24:31.428101+05:30 SLES12SP3Beta3 kernel: [65120.399436] ABOR=
T_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 101
2017-06-06T09:24:31.556053+05:30 SLES12SP3Beta3 kernel: [65120.527461] ABOR=
T_TASK: Found referenced iSCSI task_tag: 119
2017-06-06T09:24:31.556060+05:30 SLES12SP3Beta3 kernel: [65120.527465] ABOR=
T_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 119
2017-06-06T09:24:31.556061+05:30 SLES12SP3Beta3 kernel: [65120.527468] ABOR=
T_TASK: Found referenced iSCSI task_tag: 43
2017-06-06T09:24:31.556062+05:30 SLES12SP3Beta3 kernel: [65120.527469] ABOR=
T_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 43
2017-06-06T09:24:31.556063+05:30 SLES12SP3Beta3 kernel: [65120.527470] ABOR=
T_TASK: Found referenced iSCSI task_tag: 79
2017-06-06T09:24:31.556064+05:30 SLES12SP3Beta3 kernel: [65120.527471] ABOR=
T_TASK: Found referenced iSCSI task_tag: 71
2017-06-06T09:24:31.556066+05:30 SLES12SP3Beta3 kernel: [65120.527472] ABOR=
T_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 79
2017-06-06T09:24:31.556067+05:30 SLES12SP3Beta3 kernel: [65120.527472] ABOR=
T_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 71
2017-06-06T09:24:31.556068+05:30 SLES12SP3Beta3 kernel: [65120.527506] ABOR=
T_TASK: Found referenced iSCSI task_tag: 122
2017-06-06T09:24:31.556068+05:30 SLES12SP3Beta3 kernel: [65120.527508] ABOR=
T_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 122
2017-06-06T09:24:32.452073+05:30 SLES12SP3Beta3 kernel: [65121.423425] ABOR=
T_TASK: Found referenced iSCSI task_tag: 58
2017-06-06T09:24:32.452080+05:30 SLES12SP3Beta3 kernel: [65121.423427] ABOR=
T_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 58
2017-06-06T09:24:32.516054+05:30 SLES12SP3Beta3 kernel: [65121.487380] ABOR=
T_TASK: Found referenced iSCSI task_tag: 100
2017-06-06T09:24:32.516061+05:30 SLES12SP3Beta3 kernel: [65121.487382] ABOR=
T_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 100
2017-06-06T09:24:32.584031+05:30 SLES12SP3Beta3 kernel: [65121.555374] ABOR=
T_TASK: Found referenced iSCSI task_tag: 52
2017-06-06T09:24:32.584041+05:30 SLES12SP3Beta3 kernel: [65121.555376] ABOR=
T_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 52
2017-06-06T09:24:33.412057+05:30 SLES12SP3Beta3 kernel: [65122.383341] ABOR=
T_TASK: Found referenced iSCSI task_tag: 43
2017-06-06T09:24:33.412065+05:30 SLES12SP3Beta3 kernel: [65122.383376] ABOR=
T_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 43
2017-06-06T09:24:33.476061+05:30 SLES12SP3Beta3 kernel: [65122.447354] ABOR=
T_TASK: Found referenced iSCSI task_tag: 63
2017-06-06T09:24:33.476070+05:30 SLES12SP3Beta3 kernel: [65122.447360] ABOR=
T_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 63

[1] https://patchwork.kernel.org/patch/9633675/

Thanks,
Ram
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
