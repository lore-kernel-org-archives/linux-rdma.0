From: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC rdma-core 1/2] Registering non-contiguous memory
Date: Thu,  4 Jan 2018 19:47:25 +0200
Message-ID: <1515088046-26605-1-git-send-email-alexma@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Numerous applications communicate buffers with a non-contiguous memory layout.
For example, HPC applications often work on a matrix, and require sending a row or a column: 

```
               M
          -----------
         | |X| | | | |
          -----------
         | |X| | | | |
          -----------   N
         | |X| | | | |
          -----------
         | |X| | | | |
          -----------
```

There are two alternatives to send the cells marked with an 'X' using contiguous buffers:

1. Create a list of N scatter-gather entries, each with the length of a single cell, and pass those inside an ibv_send_wr to ibv_post_send().
2. Create a temporary contiguous buffer to hold all N marked cells, copy each cell to it's respective location in this buffer and pass this buffer to ibv_post_send().

Both alternatives requires additional memory resources, linear with respect to N, in order to send the desired memory layout. Non-contiguous memory registration addresses this issue - to allow passing a compact description of a memory layout for send/recv operations. In this example, the registered memory description would include the base pointer to the first cell, the matrix dimensions (M and N) and the size of a single cell.
Another use-case for non-contiguous memory access is when more than one memory region holds the data and the request may span across multiple MRs:

```
                     ----------
                    |          |
                    |          |
                    | Memory   |
                   /| region #1|
     "Composite   / |          |
       region"   /  |          |
     ---------- /  -|          |
    |          |  / |          |
    |          | /   ----------
     ---------- <
    |          | \   ---------- 
    |          |  --|          |
    |          |    | Memory   |
    |          | ___| region #2|
     ---------- <   |          |
    |          | \   ----------
     ----------\  \_ ----------
                \   |          |
                 \  | Memory   |
                  \-| region #N|
                    |          |
                    |          |
                     ----------
```

Similarly, sending such a layout would require specifying all N memory keys in every ibv_post_send() invocation, while the alternative could be listing those once in advance, and each operation only includes a base pointer and length.

The key for dealing with non-contiguous memory layouts at a low latency is the ability to describe it in the data path. This means the API has to allow user-level registration of such layouts. For this end, this API is an extension to the Memory Regions API, where the user can dynamically assign non-contiguous layout description to an MR.


Alex Margolin (1):
  verbs: Introduce non-contiguous memory registration

 libibverbs/man/ibv_rereg_mr.3             |   2 +
 libibverbs/man/ibv_rereg_mr_interleaved.3 | 260 ++++++++++++++++++++++++++++++
 libibverbs/man/ibv_rereg_mr_sg.3          | 181 +++++++++++++++++++++
 libibverbs/verbs.h                        |  75 ++++++++-
 4 files changed, 517 insertions(+), 1 deletion(-)
 create mode 100644 libibverbs/man/ibv_rereg_mr_interleaved.3
 create mode 100644 libibverbs/man/ibv_rereg_mr_sg.3

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
