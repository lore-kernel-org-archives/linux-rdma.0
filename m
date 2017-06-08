From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: iSER Connection via LIO not working
Date: Thu, 8 Jun 2017 16:23:15 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC3431F8F1@fmsmsx120.amr.corp.intel.com>
References: <2E68B5D1-49CF-4F2C-B7F3-DA20E05503B8@creamfinance.com>
 <CAANLjFraKgxAC09VH8u72SbQZs8WhXnnk87VQB0ywoVavC2hSg@mail.gmail.com>
 <2E0A092F-9530-44FB-8A6F-D76D8E94ABE0@creamfinance.com>
 <CAANLjFqg1ked1Ls0W=BRRw5o5vheHKnUw5C_5OVciFQd0H8djg@mail.gmail.com>
 <827EC8DD-86E7-4011-8F68-B29396B2034D@creamfinance.com>
 <CAANLjFqt_RqU6UFPCcZJ5Mec-ku__YErFb-VLrV4Qx9G7ArAZA@mail.gmail.com>
 <1790271E-1A6B-492D-B4B6-701873B23A01@creamfinance.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1790271E-1A6B-492D-B4B6-701873B23A01-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Rosenstein <thomas.rosenstein-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: Re: iSER Connection via LIO not working
> 
> Hi,
> 
> after a bit of digging and adding about 100 logs I found the following
> commit which screws with the qib implementation.
> 
> https://gitlab-
> beta.engr.illinois.edu/ejclark2/linux/commit/df749cdc45d9f97cb0a5e6ceab80
> e2e00ee9bf85
> 
> If you check, qib never sets the max_fast_reg_page_list_len (I assume,
> haven't found it in the code, it's there for mellanox)
> 
> therefore in iser_calc_scsi_params, the scsi_max_sectors is always set
> to 0.
> 
> Maybe someone that has experience there could figure out what exactly is
> going on?
> 
> Adding
> 
> sup_sg_tablesize = ISCSI_ISER_MAX_SG_TABLESIZE;
> 
> directly under the sup_sg_tablesize calculation at least fixes the iser
> connection for QLogic Adapters (~800 - 900 MB/s direct IO vs. ~200 MB/s
> via iscsi and no more errors)
> 

Good job tracking this down.   Thanks!

static void
iser_calc_scsi_params(struct iser_conn *iser_conn,
                      unsigned int max_sectors)
{
        struct iser_device *device = iser_conn->ib_conn.device;
        unsigned short sg_tablesize, sup_sg_tablesize;

        sg_tablesize = DIV_ROUND_UP(max_sectors * 512, SIZE_4K);
        sup_sg_tablesize = min_t(unsigned, ISCSI_ISER_MAX_SG_TABLESIZE,
                                 device->ib_device->attrs.max_fast_reg_page_list_len);

        iser_conn->scsi_sg_tablesize = min(sg_tablesize, sup_sg_tablesize);
}

The bug is that device->ib_device->attrs.max_fast_reg_page_list_len should only be considered valid IFF IB_DEVICE_MEM_MGT_EXTENSIONS is set in
device->ib_device->device_cap_flags.  The assignment you suggest should be an else on an if test of the device_cap_flags bit. 

This appears to be the only storage ULP that reads this field exported from drivers.

Mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
