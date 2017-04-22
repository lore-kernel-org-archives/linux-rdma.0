From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 195511] New: cxgb4: unchecked return value of alloc_skb() in
 function send_fw_pass_open_req()
Date: Sat, 22 Apr 2017 15:04:20 +0000
Message-ID: <bug-195511-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=195511

            Bug ID: 195511
           Summary: cxgb4: unchecked return value of alloc_skb() in
                    function send_fw_pass_open_req()
           Product: Drivers
           Version: 2.5
    Kernel Version: linux-4.11-rc7
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Infiniband/RDMA
          Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
          Reporter: bianpan2010-AvrBmmDjM4YnDS1+zs4M5A@public.gmane.org
        Regression: No

Function alloc_skb() will return a NULL pointer when there is no enough memory.
However, the return value of alloc_skb() is directly used without validation in
function send_fw_pass_open_req() (see lines 3802~3804). The related code
snippets are shown as follows.
send_fw_pass_open_req @@ drivers/infiniband/hw/cxgb4/cm.c: 
3791 static void send_fw_pass_open_req(struct c4iw_dev *dev, struct sk_buff
*skb,
3792                   __be32 laddr, __be16 lport,
3793                   __be32 raddr, __be16 rport,
3794                   u32 rcv_isn, u32 filter, u16 window,
3795                   u32 rss_qid, u8 port_id)
3796 {
3797     struct sk_buff *req_skb;
3798     struct fw_ofld_connection_wr *req;
3799     struct cpl_pass_accept_req *cpl = cplhdr(skb);
3800     int ret;
3801 
3802     req_skb = alloc_skb(sizeof(struct fw_ofld_connection_wr), GFP_KERNEL);
3803     req = (struct fw_ofld_connection_wr *)__skb_put(req_skb,
sizeof(*req));
3804     memset(req, 0, sizeof(*req));
         ...
3844 }

Generally, the return value of alloc_skb() should be checked against NULL, as
follows.
rfcomm_queue_disc @@ net/bluetooth/rfcomm/core.c: 855
 855 static int rfcomm_queue_disc(struct rfcomm_dlc *d)
 856 {
 857     struct rfcomm_cmd *cmd;
 858     struct sk_buff *skb;
 859 
 860     BT_DBG("dlc %p dlci %d", d, d->dlci);
 861 
 862     skb = alloc_skb(sizeof(*cmd), GFP_KERNEL);
 863     if (!skb)
 864         return -ENOMEM;
 865 
 866     cmd = (void *) __skb_put(skb, sizeof(*cmd));
 867     cmd->addr = d->addr;
 868     cmd->ctrl = __ctrl(RFCOMM_DISC, 1);
 869     cmd->len  = __len8(0);
 870     cmd->fcs  = __fcs2((u8 *) cmd);
 871 
 872     skb_queue_tail(&d->tx_queue, skb);
 873     rfcomm_schedule();
 874     return 0;
 875 }


Thanks very much for your attention!

Pan Bian

-- 
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
