From: Xi Wang <xi.wang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: IB/uverbs: multiple possible overflows
Date: Fri, 27 Apr 2012 05:13:50 -0400
Message-ID: <4F9A634E.5020400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Xi Wang <xi.wang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

There are multiple integer overflows that may lead to buffer overflows
in drivers/infiniband/core/uverbs_cmd.c.  I will explain how an exploit
might work and suggest some patches.  Thanks for reviewing.

Possible exploit
================

Consider ib_uverbs_unmarshall_recv().  The function is called from
ib_uverbs_post_recv() and ib_uverbs_post_srq_recv().  In both cases,
its parameters wr_count, sge_count, and wqe_size are directly from
userspace via copy_from_user() and thus they can be any values.

Let's choose the following values, and see how to bypass the existing
checks and reach "next = kmalloc(...)".  Assume 32-bit systems.

        wr_count = 1
        sge_count = 0x80000000
        wqe_size = 16

1. NOT in_len < wqe_size * wr_count + sge_count * 16

        if (in_len < wqe_size * wr_count +
            sge_count * sizeof (struct ib_uverbs_sge))
                return ERR_PTR(-EINVAL);

Here struct ib_uverbs_sge is 16 bytes.

Since the second multiplication 0x80000000 * 16 overflows and becomes
0, the check is basically in_len < 16, which can be easily bypassed.

2. NOT wqe_size < 16

        if (wqe_size < sizeof (struct ib_uverbs_recv_wr))
                return ERR_PTR(-EINVAL);

Here struct ib_uverbs_recv_wr is 16 bytes.

Since we choose wqe_size = 16, the check will be bypassed.

3. wqe_size <= KMALLOC_MAX_SIZE

        user_wr = kmalloc(wqe_size, GFP_KERNEL);
        if (!user_wr)
                return ERR_PTR(-ENOMEM);

To make kmalloc() succeed, wqe_size shouldn't be large.  Again,
since we choose wqe_size = 16, the check will be bypassed.

4. wr_count > 0 

        for (i = 0; i < wr_count; ++i) { ... }

Since we choose wr_count = 1, the loop will run once.

5. NOT num_sge + sg_ind > sge_count

        if (user_wr->num_sge + sg_ind > sge_count) {
                ret = -EINVAL;
                goto err;
        }

Here sg_ind is 0.  Note that num_sge is also from userspace via
copy_from_user().  Let's choose num_sge = sge_count = 0x80000000,
so as to bypass the check.

Now we come to the allocation call.

        next = kmalloc(ALIGN(sizeof *next, sizeof (struct ib_sge)) +
                       user_wr->num_sge * sizeof (struct ib_sge),
                       GFP_KERNEL);

The allocation size is basically 32 + num_sge * 16 = 32, which is
smaller than expected.

Also note that in

	next->num_sg = user_wr->num_sge;

next->num_sge (ib_recv_wr::num_sge) is signed.

        next->sg_list = (void *) next +
                ALIGN(sizeof *next, sizeof (struct ib_sge));

Now next->sg_list points to the end of the allocated memory.  Any
access to sg_list[i] would be out of bounds.

The subsequent copy_from_user(next->sg_list, ...) is a no-op, since
the size next->num_sge * sizeof (struct ib_sge) evaluates to 0.

Now ib_uverbs_unmarshall_recv() returns to its caller with a negative
wr->num_sge = 0x80000000 and wr->sg_list that points to a bad location.

Let's look at one of the callers, ib_uverbs_post_recv().  The function
then calls into a specific ->post_recv().

        qp->device->post_recv(qp->real_qp, wr, &bad_wr);

We use iwch_post_receive() in drivers/infiniband/hw/cxgb3/iwch_qp.c as
an example.

        if (wr->num_sge > T3_MAX_SGE) {
                err = -EINVAL;
                break;
        }
        ...
        if (num_wrs)
                if (wr->sg_list[0].lkey)
                        err = build_rdma_recv(qhp, wqe, wr);
                else
                        err = build_zero_stag_recv(qhp, wqe, wr);
        else
                err = -ENOMEM;

The check "wr->num_sge > T3_MAX_SGE" will be bypassed since wr->num_sge
is negative 0x80000000.

The access "wr->sg_list[0].lkey" is out of bounds.  Not sure what value
it gets.  We could have bigger trouble in build_rdma_recv(), because it
calls iwch_sgl2pbl_map() with wr->num_sge.

        for (i = 0; i < num_sgle; i++) {
                ...
                pbl_addr[i] = ...;
                page_size[i] = ...;
        }

This time num_sgle = 0x80000000 is interpreted as unsigned (u32), and
the loop may overwrite a lot of places.

Other overflows
===============

ib_uverbs_post_send() has similar code.

Suggested patches
=================

1. Change the types of the following struct fields to unsigned.

        ib_recv_wr::num_sge
        ib_send_wr::num_sge

This ensures that driver-specific checks like wr->num_sge > T3_MAX_SGE
won't be bypassed.

2. Fix ib_uverbs_unmarshall_recv() and ib_uverbs_post_send().

I am not sure if there's any well-known or reasonable constant limit
for every value from userspace:

        wr_count
        sge_count
        wqe_size
        num_sge

If we know such limits, define them as something like WR_COUNT_MAX
for checking.

If the limits do not exist, then it might be boring to fix the code.
For example, in addition to

        if (in_len < wqe_size * wr_count +
            sge_count * sizeof (struct ib_uverbs_sge))
                return ERR_PTR(-EINVAL);

We might have to write many more overflow checks:

        if (wr_count && wqe_size > UINT_MAX / wr_count)
            return ERR_PTR(-EINVAL);

        if (sge_count > (UINT_MAX - wqe_size * wr_count)
                        / sizeof (struct ib_uverbs_sge))
            return ERR_PTR(-EINVAL);

- xi
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
