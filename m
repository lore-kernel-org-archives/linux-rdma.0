From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: user verbs question
Date: Mon, 2 Oct 2017 16:29:34 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC3441F37D@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jason Gunthorpe (jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org)" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ruhl, Michael J" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We have run into an issue with perftest and the user verbs libraries. 

An {qib,hfi1} create_cq fails because of a driver limit in created a recv_cq for perftest.   We found this with new UD and UC tests.

We can increase the limit, but.

perftest runs on after having failed to create a  recv_cq:
and passes a NULL attr->recv_cq to the user libraries:

        if (create_cqs(ctx, user_param)) {
                fprintf(stderr, "Failed to create CQs\n");
                /* no return FAILUE */
        }

recv_cq is then NULL in a create_qp exposing issues with:

int ibv_cmd_create_qp(struct ibv_pd *pd,
                      struct ibv_qp *qp, struct ibv_qp_init_attr *attr,
                      struct ibv_create_qp *cmd, size_t cmd_size,
                      struct ibv_create_qp_resp *resp, size_t resp_size)
{
        IBV_INIT_CMD_RESP(cmd, cmd_size, CREATE_QP, resp, resp_size);

        cmd->user_handle     = (uintptr_t) qp;
        cmd->pd_handle       = pd->handle;
        cmd->send_cq_handle  = attr->send_cq->handle; <- potential NULL derefs
        cmd->recv_cq_handle  = attr->recv_cq->handle;

If either the send_cq or recv_cq are NULL, the job will seqfault.

This could have been checked before the deref here, but other spots in the code lack similar parameter validation.

Comments?

Mike

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
