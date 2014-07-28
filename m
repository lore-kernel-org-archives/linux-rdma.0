From: lokesh agarwal <lokesh.agarwal1986-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Setting IB path manually using rdma_set_option
Date: Mon, 28 Jul 2014 12:59:32 -0700
Message-ID: <CABqF1pb9HRr8exHX10iPLwtYQuTHE8ZaCEVk=trBw6nekJi9cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi All,
I am trying to use the rdma_set_option to manually set the IB route
for the rdma cm ID. As far as I can see there are a couple of
discrepancies between
the actual code as per the librdmacm git, and what the header file suggests..

For example, according to the header file:
/* Option details */
643 enum {
644         RDMA_OPTION_ID_TOS       = 0,   /* uint8_t: RFC 2474 */
645         RDMA_OPTION_ID_REUSEADDR = 1,   /* int: ~SO_REUSEADDR */
646         RDMA_OPTION_ID_AFONLY    = 2,   /* int: ~IPV6_V6ONLY */
647         RDMA_OPTION_IB_PATH      = 1    /* struct ibv_path_data[] */
648 };

We should be using an array of ibv_path_data[] to pass in the path records..

But according to driver code (drivers/infiniband/core/ucma.c)

static int ucma_set_ib_path(struct ucma_context *ctx,
817                             struct ib_path_rec_data *path_data,
size_t optlen)
818 {
819         struct ib_sa_path_rec sa_path;
820         struct rdma_cm_event event;
821         int ret;
822
823         if (optlen % sizeof(*path_data))
824                 return -EINVAL;
825
826         for (; optlen; optlen -= sizeof(*path_data), path_data++) {
827                 if (path_data->flags == (IB_PATH_GMP | IB_PATH_PRIMARY |
828                                          IB_PATH_BIDIRECTIONAL))
829                         break;
830         }
                /*......*/
                rdma_set_ib_paths(..... &sa_path_rec, 1);
                ........
        }

Here we see that the expected argument is of type "struct ib_path_rec_data"
These 2 structures are similar... but their sizes are still very
different.... (ib_path_rec_data vs ibv_path_data).

Also ibv_path_data, internally embeds the path record in the form of
"ibv_path_record", I dont see "ibv_path_record" being used anywhere in
the driver code to extract the path record.

Also, struct rdma_route is supposed to contain a pointer to type
struct ibv_sa_path_rec,
but according to (drivers/infiniband/core/cma.c), we pass in the path
record as pointer to struct ib_sa_path_rec....(rdma_set_ib_paths)  and
we directly copy out this incompatible pointer into the
cmid->route->path_rec field.....

rdma_set_ib_paths(struct rdma_cm_id *id,
                                     struct ib_sa_path_rec *path_rec,
                                    int num_paths))
{
                /*....*/
                  id->route.path_rec = kmalloc(sizeof *path_rec *
num_paths, GFP_KERNEL);
1681         if (!id->route.path_rec) {
1682                 ret = -ENOMEM;
1683                 goto err;
1684         }
1685
1686         memcpy(id->route.path_rec, path_rec, sizeof *path_rec * num_paths);
1687         id->route.num_paths = num_paths;
}
So I dont understand why this other structure is being
used(ib_sa_path_rec vs ibv_sa_path_rec)...? And how is all this code
even working correctly...?

Can you throw some light on how this is supposed to be used..? Are we
expected to pack/unpack the path record in the form of ibv_sa_path_rec
type to ibv_path_record structure.. or ib_path_rec_data..? What are
the meaning of each of the IB_PATH_* flags...

I have tried both ways, and keep getting EINVAL (I set the
IB_PATH_PRIMARY flag) and am unsure how to debug this...

Any help is appreciated...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
