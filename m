From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: SQ overflow seen running isert traffic with high block sizes
Date: Fri, 6 Oct 2017 17:40:25 -0500
Message-ID: <20171006224025.GA23364@ssaleem-MOBL4.amr.corp.intel.com>
References: <BN3PR07MB25784033E7FCD062FA0A7855F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <210f538f-8c98-f480-64fc-f2124ed6d01b@grimberg.me>
 <BN3PR07MB25786338EADC77A369A6D493F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
 <1499970579.7987.8.camel@haakon3.daterainc.com>
 <BN3PR07MB2578E6561CC669922A322245F8A00@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BN3PR07MB2578E6561CC669922A322245F8A00-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 17, 2017 at 03:26:04AM -0600, Amrani, Ram wrote:
> Hi Nicholas,
> 
> > Just to confirm, the following four patches where required to get
> > Potnuri up and running on iser-target + iw_cxgb4 with a similarly small
> > number of hw SGEs:
> > 
> > 7a56dc8 iser-target: avoid posting a recv buffer twice
> > 555a65f iser-target: Fix queue-full response handling
> > a446701 iscsi-target: Propigate queue_data_in + queue_status errors
> > fa7e25c target: Fix unknown fabric callback queue-full errors
> > 
> > So Did you test with Q-Logic/Cavium with RoCE using these four patches,
> > or just with commit a4467018..?
> > 
> > Note these have not been CC'ed to stable yet, as I was reluctant since
> > they didn't have much mileage on them at the time..
> > 
> > Now however, they should be OK to consider for stable, especially if
> > they get you unblocked as well.
> 
> The issue is still seen with these four patches.
> 
> Thanks,
> Ram

Hi,

On X722 Iwarp NICs (i40iw) too, we are seeing a similar issue of SQ overflow being hit on
isert for larger block sizes. 4.14-rc2 kernel.

Eventually there is a timeout/conn-error on iser initiator and the connection is torn down.

The aforementioned patches dont seem to be alleviating the SQ overflow issue?

Initiator
------------

[17007.465524] scsi host11: iSCSI Initiator over iSER
[17007.466295] iscsi: invalid can_queue of 55. can_queue must be a power of 2.
[17007.466924] iscsi: Rounding can_queue to 32.
[17007.471535] scsi 11:0:0:0: Direct-Access     LIO-ORG  ramdisk1_40G     4.0  PQ: 0 ANSI: 5
[17007.471652] scsi 11:0:0:0: alua: supports implicit and explicit TPGS
[17007.471656] scsi 11:0:0:0: alua: device naa.6001405ab790db5e8e94b0998ab4bf0b port group 0 rel port 1
[17007.471782] sd 11:0:0:0: Attached scsi generic sg2 type 0
[17007.472373] sd 11:0:0:0: [sdb] 83886080 512-byte logical blocks: (42.9 GB/40.0 GiB)
[17007.472405] sd 11:0:0:0: [sdb] Write Protect is off
[17007.472406] sd 11:0:0:0: [sdb] Mode Sense: 43 00 00 08
[17007.472462] sd 11:0:0:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[17007.473412] sd 11:0:0:0: [sdb] Attached SCSI disk
[17007.478184] sd 11:0:0:0: alua: transition timeout set to 60 seconds
[17007.478186] sd 11:0:0:0: alua: port group 00 state A non-preferred supports TOlUSNA
[17031.269821]  sdb:
[17033.359789] EXT4-fs (sdb1): mounted filesystem with ordered data mode. Opts: (null)
[17049.056155]  connection2:0: ping timeout of 5 secs expired, recv timeout 5, last rx 4311705998, last ping 4311711232, now 4311716352
[17049.057499]  connection2:0: detected conn error (1022)
[17049.057558] modifyQP to CLOSING qp 3 next_iw_state 3
[..]


Target
----------
[....]
[17066.397179] i40iw_post_send: qp 3 wr_opcode 0 ret_err -12
[17066.397180] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8ec020 failed to post RDMA res
[17066.397183] i40iw_post_send: qp 3 wr_opcode 0 ret_err -12
[17066.397183] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8ea1f8 failed to post RDMA res
[17066.397184] i40iw_post_send: qp 3 wr_opcode 0 ret_err -12
[17066.397184] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8e9bf0 failed to post RDMA res
[17066.397187] i40iw_post_send: qp 3 wr_opcode 0 ret_err -12
[17066.397188] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8ecc30 failed to post RDMA res
[17066.397192] i40iw_post_send: qp 3 wr_opcode 0 ret_err -12
[17066.397192] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8f20a0 failed to post RDMA res
[17066.397195] i40iw_post_send: qp 3 wr_opcode 0 ret_err -12
[17066.397196] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8ea800 failed to post RDMA res
[17066.397196] i40iw_post_send: qp 3 wr_opcode 0 ret_err -12
[17066.397197] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8ede48 failed to post RDMA res
[17066.397200] i40iw_post_send: qp 3 wr_opcode 0 ret_err -12
[17066.397200] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8ec020 failed to post RDMA res
[17066.397204] i40iw_post_send: qp 3 wr_opcode 0 ret_err -12
[17066.397204] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8ea1f8 failed to post RDMA res
[17066.397206] i40iw i40iw_process_aeq ae_id = 0x503 bool qp=1 qp_id = 3
[17066.397207] i40iw_post_send: qp 3 wr_opcode 0 ret_err -12
[17066.397207] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8e9bf0 failed to post RDMA res
[17066.397211] i40iw_post_send: qp 3 wr_opcode 0 ret_err -12
[17066.397211] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8ecc30 failed to post RDMA res
[17066.397215] i40iw_post_send: qp 3 wr_opcode 0 ret_err -12
[17066.397215] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8f20a0 failed to post RDMA res
[17066.397218] i40iw_post_send: qp 3 wr_opcode 0 ret_err -12
[17066.397219] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8ea800 failed to post RDMA res
[17066.397219] i40iw_post_send: qp 3 wr_opcode 0 ret_err -12
[17066.397220] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8ede48 failed to post RDMA res
[17066.397232] i40iw_post_send: qp 3 wr_opcode 0 ret_err -12
[17066.397233] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8ec020 failed to post RDMA res
[17066.397237] i40iw_post_send: qp 3 wr_opcode 0 ret_err -12
[17066.397237] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8ea1f8 failed to post RDMA res
[17066.397238] i40iw_post_send: qp 3 wr_opcode 0 ret_err -12
[17066.397238] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8e9bf0 failed to post RDMA res
[17066.397242] i40iw_post_send: qp 3 wr_opcode 0 ret_err -12
[17066.397242] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8ecc30 failed to post RDMA res
[17066.397245] i40iw_post_send: qp 3 wr_opcode 0 ret_err -12
[17066.397247] i40iw i40iw_process_aeq ae_id = 0x501 bool qp=1 qp_id = 3
[17066.397247] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8f20a0 failed to post RDMA res
[17066.397251] QP 3 flush_issued
[17066.397252] i40iw_post_send: qp 3 wr_opcode 0 ret_err -22
[17066.397252] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8ea800 failed to post RDMA res
[17066.397253] Got unknown fabric queue status: -22
[17066.397254] QP 3 flush_issued
[17066.397254] i40iw_post_send: qp 3 wr_opcode 0 ret_err -22
[17066.397254] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8ede48 failed to post RDMA res
[17066.397255] Got unknown fabric queue status: -22
[17066.397258] QP 3 flush_issued
[17066.397258] i40iw_post_send: qp 3 wr_opcode 0 ret_err -22
[17066.397259] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8ec020 failed to post RDMA res
[17066.397259] Got unknown fabric queue status: -22
[17066.397267] QP 3 flush_issued
[17066.397267] i40iw_post_send: qp 3 wr_opcode 0 ret_err -22
[17066.397268] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8ea1f8 failed to post RDMA res
[17066.397268] Got unknown fabric queue status: -22
[17066.397287] QP 3 flush_issued
[17066.397287] i40iw_post_send: qp 3 wr_opcode 0 ret_err -22
[17066.397288] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8e9bf0 failed to post RDMA res
[17066.397288] Got unknown fabric queue status: -22
[17066.397291] QP 3 flush_issued
[17066.397292] i40iw_post_send: qp 3 wr_opcode 0 ret_err -22
[17066.397292] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8ecc30 failed to post RDMA res
[17066.397292] Got unknown fabric queue status: -22
[17066.397295] QP 3 flush_issued
[17066.397296] i40iw_post_send: qp 3 wr_opcode 0 ret_err -22
[17066.397296] isert: isert_rdma_rw_ctx_post: Cmd: ffff8817fb8f20a0 failed to post RDMA res
[17066.397297] Got unknown fabric queue status: -22
[17066.397307] QP 3 flush_issued
[17066.397307] i40iw_post_send: qp 3 wr_opcode 8 ret_err -22
[17066.397308] isert: isert_post_response: ib_post_send failed with -22
[17066.397309] i40iw i40iw_qp_disconnect Call close API
[....]

Shiraz 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
