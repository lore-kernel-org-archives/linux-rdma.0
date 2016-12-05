From: <Tomita.Haruo-IGagC74glE2s6Rmoc/2Z03gSJqDPrsil@public.gmane.org>
Subject: I/O error on dd commands
Date: Mon, 5 Dec 2016 05:41:16 +0000
Message-ID: <b8b48041a15444bc9c62176d6807433a@TGXML382.toshiba.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: ja-JP
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tomita.Haruo-IGagC74glE2s6Rmoc/2Z03gSJqDPrsil@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Moni,

Does a rxe driver of vanilla 4.9-rc6 fine work?
When the dd command is tested for a read and write, it'll be the following error.

(read)
# dd if=/dev/nvme0n1 of=<readfile>.bin bs=1024 count=10000 iflag=direct

blk_update_request: I/O error, dev nvme0n1, sector 1860
nvme nvme0: reconnecting in 10 seconds
nvme nvme0: Successfully reconnected

or

nvme nvme0: failed nvme_keep_alive_end_io error=16391
nvme nvme0: reconnecting in 10 seconds
nvme nvme0: Successfully reconnected

(write)
# dd if=<writefile>.bin of=/dev/nvme0n1 bs=1024 count=10000 oflag=direct

blk_update_request: I/O error, dev nvme0n1, sector 1860
nvme nvme0: reconnecting in 10 seconds
nvme nvme0: Successfully reconnected

or

nvme nvme0: failed nvme_keep_alive_end_io error=16391
nvme nvme0: reconnecting in 10 seconds
nvme nvme0: Successfully reconnected

I'd like to investigate the root cause of this error, are there any ideas?

(PS)
I'm checking a rxe driver.
typo was found by release of skb in rxe_requester().
Is my patch right?

rxe_req.c |    9 +++++----
1 file changed, 5 insertions(+), 4 deletions(-)
--- linux-4.9-rc7/drivers/infiniband/sw/rxe/rxe_req.c.orig      2016-12-05 10:11:38.000000000 +0900
+++ linux-4.9-rc7/drivers/infiniband/sw/rxe/rxe_req.c   2016-12-05 10:15:43.000000000 +0900
@@ -705,12 +705,12 @@ next_wqe:
        skb = init_req_packet(qp, wqe, opcode, payload, &pkt);
        if (unlikely(!skb)) {
                pr_err("qp#%d Failed allocating skb\n", qp_num(qp));
-               goto err;
+               goto err1;
        }

        if (fill_packet(qp, wqe, &pkt, skb, payload)) {
                pr_debug("qp#%d Error during fill packet\n", qp_num(qp));
-               goto err;
+               goto err2;
        }

        /*
@@ -734,15 +734,16 @@ next_wqe:
                        goto exit;
                }

-               goto err;
+               goto err1;
        }

        update_state(qp, wqe, &pkt, payload);

        goto next_wqe;

-err:
+err2:
        kfree_skb(skb);
+err1:
        wqe->status = IB_WC_LOC_PROT_ERR;
        wqe->state = wqe_state_error;


--
Haruo

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
