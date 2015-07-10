From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Kernel fast memory registration API proposal [RFC]
Date: Fri, 10 Jul 2015 12:09:37 +0300
Message-ID: <559F8BD1.9080308@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Given the last discussions on our in-kernel memory registration API I
thought I'd propose another approach to address this.

As I said before, I think the stack needs to consolidate on a single
memory registration scheme. That scheme is the standard FRWR.

As you know, MRs have a consumers representation (e.g. ib_mr) and a
provider private context. In order to support generic kernel consumers
registration without enforcing the HW way of registering the memory we
keep the HW specifics in the provider private context.

struct provider_mr {
	u64		*page_list; // or what ever the HW uses
	... <more private stuff> ...
	struct ib_mr	ibmr;
};

And then provide helpers to populate the MR with generic kernel
structures such as struct scatterlist (for scsi and other ULPs),
struct page (for NFS) or struct bio_vec (for block ULPs later on).

/**
   * ib_mr_set_sg() - populate memory region buffers
   *     array from a SG list
   * @mr:          memory region
   * @sg:          sg list
   * @sg_nents:    number of elements in the sg
   *
   * Can fail if the HW is not able to register this
   * sg list. In case of failure - caller is responsible
   * to handle it (bounce-buffer, multiple registrations...)
   */
int ib_mr_set_sg(struct ib_mr *mr,
                  struct scatterlist *sg,
                  unsigned short sg_nents);

/**
   * ib_mr_set_pages() - populate memory region buffers
   *     array from a pages array
   * @mr:          memory region
   * @pages:       struct page array
   * @npages:      number of pages in the page array
   */
int ib_mr_set_pages(struct ib_mr *mr,
                     struct page **pages,
                     unsigned int npages);

In the future we can easily add biovec helper (if needed):
/**
   * ib_mr_set_biovec() - populate memory region buffers
   *     array from a bio_vec
   * @mr:          memory region
   * @bio_vec:     bio vector
   * @bi_vcnt:     number of elements in the bio_vec
   *
   * Can fail if the HW is not able to register this
   * sg list. In case of failure - caller is responsible
   * to handle it (bounce-buffer, multiple registrations...)
   */
int ib_mr_set_biovec(struct ib_mr *mr,
                      struct bio_vec *bio_vec,
                      unsigned short bi_vcnt);

These helpers allows the driver to hide the mechanics of the specific
HW implementation details of memory registration.

We *keep* the FRWR work request interface so the consumers can keep
track of what happens on their queue-pair when registering/invalidating
memory regions. However, the API is dramatically simpler.

struct ib_send_wr {
          ...
          union {
                  ...
                  struct {
                          struct ib_mr    *mr;
                          u64             iova;
                          u32             length;
                          int             access_flags;
                  } fast_reg;
                  ...
          } wr;
          ...
};

We can consider moving the iova and length to the population helpers.
Wasn't sure what is better...


Here is an example of how would a ULP use this:

int my_driver_register_sg(struct scatterlist *sg,
                            unsigned short sg_nents)
{
          struct ib_send_wr frwr, *bad_wr;
          struct ib_mr *mr;
          struct ib_mr_init_attr mr_attr = {
                  .mr_type = IB_MR_TYPE_FAST_REG,
                  .max_reg_descs = sg_nents,
          };

          /*
           * Allocate MR
           * With the MR the driver will allocate a page list
           * in its private context
           */
          mr = ib_create_mr(my_pd, &mr_attr);

          /*
           * Set the SG list in the MR, fail if the sg
	  * list is not well aligned (caller should handle
	  * it) or mr does not have enough room to fit the sg.
           */
          rc = ib_mr_set_sg(mr, sg, sg_nents);
	 if (rc)
		/* HW does not support - Need to handle it */

          /* register the MR */
          frwr.opcode = IB_WR_FAST_REG_MR;
          frwr.wrid = my_wrid;
          frwr.wr.fast_reg.mr = mr;
          frwr.wr.fast_reg.iova = ib_sg_dma_adress(&sg[0]);
          frwr.wr.fast_reg.length = length;
          frwr.wr.fast_reg.access_flags = my_flags;

          ib_post_send(my_qp, &frwr, &bad_wr);

          /* do SEND/RDMA/RECV ... */

          /* Do local invalidate if needed */

          /* Free the MR */
          ib_dereg_mr(mr);
}

This generic approach allows for example to add arbitrary sg list
support just by adding a flag to the mr allocation (which will fail
if the device does not support):

int my_driver_register_arb_sg(struct scatterlist *sg,
                                unsigned short sg_nents)
{
          struct ib_send_wr frwr, *bad_wr;
          struct ib_mr *mr;
          struct ib_mr_init_attr mr_attr = {
                  .mr_type = IB_MR_TYPE_FAST_REG,
                  .create_flags = *IB_MR_REG_ARB_SG*,
                  .max_reg_descs = sg_nents,
          };

	 /* The rest is exactly the same... */
}



That is the general direction,

Thoughts? Comments?

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
