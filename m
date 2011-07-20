From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: ibv_query_qp returns incorrect sq_sig_all
Date: Wed, 20 Jul 2011 14:09:00 -0500
Message-ID: <4E2727CC.4020308@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

It seems that sq_sig_all is not properly set when creating the QP or
when querying it. The following programs creates a bunch of QP with
sq_sig_all set to 0 and then queries them. Often sq_sig_all is returned
to be 1.
I tested some other returned values and they seem correct.

I didn't see anything wrong in the libraries nor in the drivers.
Tested with an mthca on OFED 1.5.1 and mlx4 on OFED 1.3.1.

Any idea ?

Frank.



For instance:
[fzago]$ ./testqp
failed at loop 167 (sq_sig_all=1)

Regards,
  Frank.

/*
 * Invalid sq_sig_all test
 *
 * Compile with   gcc -Wall -O2  -libverbs  testqp.c   -o testqp
 */

#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>

#include <infiniband/verbs.h>

#define NUM 10000

int main(void)
{
	struct ibv_context *context;
    struct ibv_pd      *pd;
    struct ibv_device **dev_list;
    struct ibv_device *ib_dev;
	struct ibv_qp_init_attr qp_init_attr;
	struct ibv_qp *qp[NUM];
	struct ibv_cq *cq;
	struct ibv_qp_attr attr;
	int rc;
	int i;

    dev_list = ibv_get_device_list(NULL);

	ib_dev = dev_list[0];
	assert(ib_dev);

    context = ibv_open_device(ib_dev);
    assert(context);

	pd = ibv_alloc_pd(context);
	assert(pd);

	cq = ibv_create_cq(context, 10, NULL, NULL, 0);
	assert(cq);

	for (i=0; i<NUM; i++) {
		memset(&qp_init_attr, 0, sizeof(qp_init_attr));

		qp_init_attr.send_cq = cq;
		qp_init_attr.recv_cq = cq;
		qp_init_attr.cap.max_send_wr  = 10;
		qp_init_attr.cap.max_recv_wr  = 10;
		qp_init_attr.cap.max_send_sge = 1;
		qp_init_attr.cap.max_recv_sge = 1;
		qp_init_attr.qp_type = IBV_QPT_RC;

		assert(qp_init_attr.sq_sig_all == 0);

		qp[i] = ibv_create_qp(pd, &qp_init_attr);
		assert(qp[i]);

		rc = ibv_query_qp(qp[i], &attr, 0xffffffff, &qp_init_attr);
		assert(rc == 0);

		if (qp_init_attr.sq_sig_all != 0) {
			printf("failed at loop %d (sq_sig_all=%d)\n", i,
qp_init_attr.sq_sig_all);
			abort();
		}
	}

	return 0;
}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
