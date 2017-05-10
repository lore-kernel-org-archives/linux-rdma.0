From: ahmad omary <ahmad151084-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC] libibverbs IB Device Memory support
Date: Wed, 10 May 2017 14:25:23 +0300
Message-ID: <CADWppnpd9Up7wUTxRgSinhgx3kt3+0bKwgt6P_d3CV1oA90isQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ahmad Omary <ahmad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ariel Levkovich <lariel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Introduction
-------------------------------------------------------------------------------

Many types of user space application can get a real performance gain by using
the internal memory of an IB device. This can be useful to decrease latency of
a trading operation where data is already allocated in the device memory, to
save the PCI round trip when doing atomic operations on semaphores remotely
and also to save the PCI round trip when performing modification by the device
on received traffic that should be transmitted directly after this modification.

The problem
-------------------------------------------------------------------------------

Today there is no API in libibverbs that allow user space application to manage
internal memory of IB devices.

We have considered using mmap(), but As the size of device memory may be limited
,the way to access it from host cpu may differ from vendor to vendor, due to
the 4K (page) aligment limitation of mmap() and the need not to directly
allow user to access the device memory, there is a need for a wrapper access
methods API that allows allocating and managing chunks that are smaller than
4KB and not necessarily aligned to 4KB (page size).

Suggested Solution
-------------------------------------------------------------------------------

In order for user space applications to use the internal device memory, we
suggest to update libibverbs so it provides these applications access to
allocate, free, register and memcopy operations from/to host memory.
After the device memory is allocated for a process, it can be registered
using ibv_reg_mr_ex. The registered memory can be used to process any operation
like if it was registered on host memory mkey. It can be used for post_send,
post_receive, RDMA WRITE/READ and atomic operations.

New suggested verbs:

ibv_alloc_dm: allocates device memory and returns an identifier structure that
identify and define the allocated device memory

ibv_free_dm: free device memory.

ibv_memcpy_dm: Copy from device memory to host memory and from host memory
to device memory.

ibv_reg_mr_ex: Extended to ibv_reg_mr that allow registering device memory.



API changes
-------------------------------------------------------------------------------

/*New verb for allocation*/

struct ibv_dm *ibv_alloc_dm(struct ibv_context *context,
   struct ibv_alloc_dm_attr *dm_attr);

struct ibv_alloc_dm_attr{
size_t length;
uint32_t comp_mask; /*enable future extensions*/
}


struct ibv_dm{
struct ibv_context *context;
uint32 handle;
uint32_t comp_mask; /*enable future extensions*/
};



/*New verb for free*/

int ibv_free_dm(struct ibv_dm *dm);

/*New verb for mem-copy*/

int ibv_memcpy_dm(struct ibv_dm *dm, struct ibv_memcpy_dm_attr *
memcpy_dm_attr);

struct ibv_memcpy_dm_attr{
enum ibv_dev_memcpy_type memcpy_type;
void *host_addr; /*The VA of host memory we need to copy from/to.
uint64_t dm_offset; /*offset based to ibv_dm that need to copy from/to.
size_t length;
uint32_t comp_mask; /*enable future extensions*/
}

enum ibv_dev_memcpy_type{ /*for memcpy_type*/
IBV_DM_CPY_HOST_TO_DEVICE,
        IBV_DM_CPY_DEVICE_TO_HOST;
};

/*new verb for memory registration ibv_reg_mr_ex*/

struct ibv_mr *ibv_reg_mr_ex(struct ibv_pd *pd ,ibv_mr_attr *mr_attr);

struct ibv_mr_attr {
enum ibv_mem_type type; /*memory type*/
size_t length;
int access;
union {
        struct {
Void *addr;
            }host_mem;
            struct{
                  struct ibv_dm *dm;
                  uint64_t offset; /*start offset in ibv_dm
}dev_mem;
      }mem_type
uint32_t comp_mask; /*enable future extensions*/
};

enum ibv_mem_type{
      IBV_HOST_MEM,
      IBV_DEV_MEM
};




/*Update ibv_query_device_ex*/

struct ibv_device_attr_ex{
/*The maximum size of supported device memory supported*/
uint64_t    max_dm_size;
}

Example
-------------------------------------------------------------------------------
/*pseudo code example:  HPC application that allocates a 64 Byte counting
/*semaphore on DM, distributes the mkey to all peers which will do a couple*/
/*of atomic RDMA increase operation on that DM.

/*Assuming application already have:*/
struct ibv_context ctx;
struct ibv_pd pd;
struct ibv_qp qp;
struct ibv_cq cq;
struct ibv_sge sge[1]; /*local memory registered for RDMA READ operations*/

/* The application allocates a DM range */
struct ibv_alloc_dm_attr dm_attr = {/*length*/64, /*comp_mask*/0};
dm = ibv_alloc_dm(ctx, &dm_attr)

/* Clear counting sem */
char sem_value[64] = {0};

struct ibv_memcpy_dm_attr memcpy_dm_attr =
{/*memcpy_type*/ IBV_DM_CPY_HOST_TO_DEVICE, /*host_addr*/&dummy,
/*dm_offset*/ 0, /*length*/ 64, /*comp_mask*/0};

ibv_memcpy_dm(dm, struct &memcpy_dm_attr);

/* Register for remote access MR */
struct ibv_mr_attr mr_attr = {/*type*/IBV_DEV_MEM, /*length*/64,
/*access*/IBV_ACCESS_REMOTE_ATOMIC, {dm, 0}, /*comp_mask*/0 };

mr = ibv_reg_mr_ex(pd, &mr_attr);

/* Distribute to peers: Send the DM <addr,rkey> to peer OOB */
send_sem_to_all_peers(mr->rkey, mr->addr);

/* All peers will do remote multiple RDMA atomic operation to increase the*/
/*   sem that we created on DM */

/* wait for peers to complete sem updates */
block_notify_from_all_peers();

/* Read counting sem via RDMA READ*/
struct ibv_send_wr *bad_wr=NULL;

struct ibv_send_wr wr = {/*wr_id*/0,/*next*/NULL,/*sg_list*/sge,/*num_sge*/1,
/*opcode*/IBV_WR_RDMA_READ,/*send_flags*/IBV_SEND_SIGNAL, /*imm_data*/0,
/*wr.rdma*/{/*remote_addr*/mr->addr,/*rkey*/,mr->rkey}}

ibv_post_send(qp,&wr,&bad_wr)

/* wait for CQ on RDMA operation*/
wait_for_completion(cq);


/* free resources */
ibv_dereg_mr(mr);
ibv_free_dm(dm);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
