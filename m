From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: nvmet_rdma crash - DISCONNECT event with NULL queue
Date: Tue, 1 Nov 2016 10:57:44 -0500
Message-ID: <01b401d23458$af277210$0d765630$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sagig <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey guys,

I just hit an nvmf target NULL pointer deref BUG after a few hours of keep-alive
timeout testing.  It appears that nvmet_rdma_cm_handler() was called with
cm_id->qp == NULL, so the local nvmet_rdma_queue * variable queue is left as
NULL.  But then nvmet_rdma_queue_disconnect() is called with queue == NULL which
causes the crash.

In the log, I see that the target side keep-alive fired:

[20676.867545] eth2: link up, 40Gbps, full-duplex, Tx/Rx PAUSE
[20677.079669] nvmet: ctrl 1 keep-alive timer (15 seconds) expired!
[20677.079684] nvmet: ctrl 1 keep-alive timer (15 seconds) expired!

Then all the queues are freed followed by the crash.

[20677.080066] nvmet_rdma: freeing queue 222
[20677.080074] nvmet_rdma: sending cmd response failed
[20677.080351] nvmet_rdma: freeing queue 227
[20677.080775] nvmet_rdma: freeing queue 230
[20677.081137] nvmet_rdma: freeing queue 232
[20677.081371] nvmet_rdma: freeing queue 234
[20677.081604] nvmet_rdma: freeing queue 236
[20677.081835] nvmet_rdma: freeing queue 237
[20677.082062] nvmet_rdma: freeing queue 238
[20677.082106] nvmet_rdma: freeing queue 239
[20677.082366] nvmet_rdma: freeing queue 240
[20677.082570] nvmet_rdma: freeing queue 241
[20677.082995] nvmet_rdma: freeing queue 242
[20677.083222] nvmet_rdma: freeing queue 243
[20677.083475] nvmet_rdma: freeing queue 244
[20677.083522] nvmet_rdma: freeing queue 245
[20677.083801] nvmet_rdma: freeing queue 246
[20677.084264] nvmet_rdma: freeing queue 247
[20677.084307] nvmet_rdma: freeing queue 248
[20677.084501] nvmet_rdma: freeing queue 249
[20677.084846] nvmet_rdma: freeing queue 250
[20677.085184] nvmet_rdma: freeing queue 252
[20677.085500] nvmet_rdma: freeing queue 254
[20677.085733] nvmet_rdma: freeing queue 256
[20677.085997] nvmet_rdma: freeing queue 258
[20677.086224] nvmet_rdma: freeing queue 260
[20677.086517] nvmet_rdma: freeing queue 262
[20677.086768] nvmet_rdma: freeing queue 264
[20677.087031] nvmet_rdma: freeing queue 266
[20677.087359] nvmet_rdma: freeing queue 268
[20677.087567] nvmet_rdma: freeing queue 270
[20677.087821] nvmet_rdma: freeing queue 272
[20677.088162] nvmet_rdma: freeing queue 274
[20677.088402] nvmet_rdma: freeing queue 276
[20677.090981] BUG: unable to handle kernel NULL pointer dereference at
0000000000000120
[20677.090988] IP: [<ffffffffa084b6b4>] nvmet_rdma_queue_disconnect+0x24/0x90
[nvmet_rdma]


So maybe there is just a race in that keep-alive can free the queue and yet a
DISCONNECTED event still received on the cm_id after the queue is freed?

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
