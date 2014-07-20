From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/4] IB/uverbs: check userspace output buffer size in ib_uverbs_poll_cq()
Date: Sun, 20 Jul 2014 21:51:11 +0200
Message-ID: <5e4defa2410d0a5b3f3a28508e850dd5d6c287b1.1405884453.git.ydroneaud@opteya.com>
References: <cover.1405884453.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1405884453.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1405884453.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1405884453.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Makes ib_uverbs_poll_cq() check the length of the output buffer
against number of wc: this will prevent the function from writing
past userspace provided buffer.

Note that it might affect existing userspace programs that were
setting 'struct ibv_poll_cq' field 'ne' to a value too large
compared to the size of the buffer allocated to hold the work
completion items.

Perhaps such userspace programs were hoping to have allocated
enough memory to hold the maximum number of work completions
that can be returned on this particular completion queue or
it would have been broken with random memory corruption due
to the kernel writting past the response buffer.

Example:

    int vendor_poll_cq_broken(struct ibv_cq *cq, int ne, struct ibv_wc *wc)
    {
        struct ibv_poll_cq       cmd;
        struct ibv_poll_cq_resp *resp;
        int                      resp_size;
        ssize_t                  sret;
        int                      ret = -1;

        cmd.cq_handle = cq->handle;
        cmd.ne        = ne;

         /* forget about ne * sizeof(struct ibv_kern_wc) */
        resp_size = sizeof(*resp);

        resp = malloc(resp_size);
        assert(resp != NULL);

        IBV_INIT_CMD_RESP(&cmd, sizeof(cmd),
                          POLL_CQ,
                          resp, resp_size);

        sret = write(cq->context->cmd_fd,
                     &cmd, sizeof(cmd));

        if (sret != sizeof(cmd))
            goto leave;

        ret = resp->count;

        /* ignore the response */

    leave:

        free(resp);

        return ret;
    }

Since libibverbs is the most common (if not the only) userspace
component that access the uverbs API directly, it should be safe
to have the kernel ensure coherency between the request number
of entries and the size of the response buffer that will be used
to hold the entries.

Link: http://marc.info/?i=cover.1405884453.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 9b971514db88..3626143db6ef 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1427,6 +1427,9 @@ ssize_t ib_uverbs_poll_cq(struct ib_uverbs_file *file,
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	if ((out_len - sizeof resp)/(sizeof(struct ib_uverbs_wc)) < cmd.ne)
+		return -ENOSPC;
+
 	cq = idr_read_cq(cmd.cq_handle, file->ucontext, 0);
 	if (!cq)
 		return -EINVAL;
-- 
1.9.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
