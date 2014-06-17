From: bugzilla-daemon-590EEB7GvNiWaY/ihj7yzEB+6BGkLq7r@public.gmane.org
Subject: [Bug 78171] New: Missing NULL check of the return value of
 alloc_skb() in function st_int_recv()
Date: Tue, 17 Jun 2014 12:16:57 +0000
Message-ID: <bug-78171-11804@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=78171

            Bug ID: 78171
           Summary: Missing NULL check of the return value of alloc_skb()
                    in function st_int_recv()
           Product: Drivers
           Version: 2.5
    Kernel Version: 2.6.39
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Infiniband/RDMA
          Assignee: drivers_infiniband-rdma-ztI5WcYan/vQLgFONoPN62D2FQJk+8+b@public.gmane.org
          Reporter: rucsoftsec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
        Regression: No

In function st_int_recv() at drivers/misc/ti-st/st_core.c:230, the call to
alloc_skb() at line 338 may return a NULL pointer when there is no enough
memory, but its return value is never checked against NULL before it is
dereferenced in function skb_reserve()(called at line 341), and thus an invalid
memory access error may be triggered.
The related code snippets in function st_int_recv() are as followings.
st_int_recv @ drivers/misc/ti-st/st_core.c:230
230 void st_int_recv(void *disc_data,
231         const unsigned char *data, long count)
232 {
233         char *ptr;
234         struct st_proto_s *proto;
235         unsigned short payload_len = 0;
236         int len = 0, type = 0;
    ...
336                 default:
337                         type = *ptr;
338                         st_gdata->rx_skb = alloc_skb(
339                                        
st_gdata->list[type]->max_frame_size,
340                                         GFP_ATOMIC);
341                         skb_reserve(st_gdata->rx_skb,
342                                         st_gdata->list[type]->reserve);
    ...
356         return;
357 }

Generally, the return value of alloc_skb() shall be checked against NULL before
it is used, like the following code snippets in function rx_submit().
rx_submit @ drivers/usb/gadget/u_ether.c:207
207 rx_submit(struct eth_dev *dev, struct usb_request *req, gfp_t gfp_flags)
208 {
209         struct sk_buff  *skb;
210         int             retval = -ENOMEM;
211         size_t          size = 0;
    ...
242 
243         if (dev->port_usb->is_fixed)
244                 size = max_t(size_t, size, dev->port_usb->fixed_out_len);
245 
246         skb = alloc_skb(size + NET_IP_ALIGN, gfp_flags);
247         if (skb == NULL) {
248                 DBG(dev, "no rx skb\n");
249                 goto enomem;
250         }
251 
252         /* Some platforms perform better when IP packets are aligned,
253          * but on at least one, checksumming fails otherwise.  Note:
254          * RNDIS headers involve variable numbers of LE32 values.
255          */
256         skb_reserve(skb, NET_IP_ALIGN);
257 
    ...
275         return retval;
276 }
Thak you!

RUC_Soft_Sec, supported by China.X.Orion

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
