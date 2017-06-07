From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: iSER Connection via LIO not working
Date: Wed, 7 Jun 2017 13:46:55 -0600
Message-ID: <CAANLjFqt_RqU6UFPCcZJ5Mec-ku__YErFb-VLrV4Qx9G7ArAZA@mail.gmail.com>
References: <2E68B5D1-49CF-4F2C-B7F3-DA20E05503B8@creamfinance.com>
 <CAANLjFraKgxAC09VH8u72SbQZs8WhXnnk87VQB0ywoVavC2hSg@mail.gmail.com>
 <2E0A092F-9530-44FB-8A6F-D76D8E94ABE0@creamfinance.com> <CAANLjFqg1ked1Ls0W=BRRw5o5vheHKnUw5C_5OVciFQd0H8djg@mail.gmail.com>
 <827EC8DD-86E7-4011-8F68-B29396B2034D@creamfinance.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <827EC8DD-86E7-4011-8F68-B29396B2034D-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Rosenstein <thomas.rosenstein-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 7, 2017 at 1:26 PM, Thomas Rosenstein
<thomas.rosenstein-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org> wrote:
> Okay, just did that:
>
> printk(KERN_WARNING PFX "Debug pool %d - %d\n", list_len, pool->max_pages);
>
> result is:
>
> fmr_pool: Debug pool 1 - 0
>
> means that the max_pages is set to 0
>
> any idea how why and how to solve that?
>

Again, this is out of my wheelhouse and I'm having trouble tracing all
the callbacks (I usually have to do a ton of print statements to
figure out the callbacks). I do think that the pool_handle is being
set further down in drivers/infiniband/ulp/iser/iser_memory.c in the
iser_reg_rdma_mem() funtion as part of the "struct iser_fr_desc *desc"
component. I think it is probably being set in this code:

        if (!use_dma_key) {
                desc = device->reg_ops->reg_desc_get(ib_conn);
                reg->mem_h = desc;
        }

Now it could be set by reg_desc_get (which I think is an iSER
callback) or more likely as part of ib_conn which I think the driver
sets up. Hopefully someone smarter than I can chime in and give you
some help as to why the pool->max_pages is zero.

Good luck!

----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Wed, Jun 7, 2017 at 1:26 PM, Thomas Rosenstein
<thomas.rosenstein-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org> wrote:
> Okay, just did that:
>
> printk(KERN_WARNING PFX "Debug pool %d - %d\n", list_len, pool->max_pages);
>
> result is:
>
> fmr_pool: Debug pool 1 - 0
>
> means that the max_pages is set to 0
>
> any idea how why and how to solve that?
>
> On 7 Jun 2017, at 21:05, Robert LeBlanc wrote:
>
> On Wed, Jun 7, 2017 at 12:46 PM, Thomas Rosenstein
> <thomas.rosenstein-+32LHaKS/h5VtLMLtJdGzA@public.gmane.org> wrote:
>
> Hi,
>
> lio config (extract - .json file attached)
>
> o- iscsi
> ...........................................................................................
> [1-way disc auth, Targets: 1]
> | o- iqn.2017-01.at.cf-it.at-storage-01
> ................................................................................
> [TPGs: 1]
> | o- tpg1
> ..........................................................................................
> [no-gen-acls, auth per-acl]
> | o- acls
> ..........................................................................................................
> [ACLs: 1]
> | | o- iqn.2017-01.at.cf-it.kubernetes.db-1
> ..................................................... [1-way auth, Mapped
> LUNs: 1]
> | | o- mapped_lun0
> ...................................................................... [lun0
> fileio/kubernetes_db_1 (rw)]
> | o- luns
> ..........................................................................................................
> [LUNs: 1]
> | | o- lun0 ..........................................
> [fileio/kubernetes_db_1 (/data/kubernetes_storage/kubernetes_db_1.img)]
> | o- portals
> ....................................................................................................
> [Portals: 1]
> | o- 0.0.0.0:3260
> ...................................................................................................
> [iser]
>
> at-storage-01 modules:
>
> ib_isert 49152 4
> iscsi_target_mod 294912 8 ib_isert
> ib_iser 49152 0
> libiscsi 57344 1 ib_iser
> scsi_transport_iscsi 98304 2 ib_iser,libiscsi
> target_core_mod 352256 43
> iscsi_target_mod,ib_isert,target_core_iblock,ib_srpt,target_core_user,target_core_file,target_core_pscsi
> rdma_cm 53248 4 ib_iser,ib_isert,rpcrdma,rdma_ucm
> ib_core 208896 15
> ib_iser,ib_cm,rdma_cm,ib_umad,ib_srp,ib_isert,ib_uverbs,rpcrdma,ib_ipoib,iw_cm,ib_srpt,ib_ucm,rdmavt,ib_qib,rdma_ucm
>
> at-host-18 modules:
>
> ib_isert 49152 0
> iscsi_target_mod 299008 1 ib_isert
> ib_iser 49152 0
> libiscsi 57344 1 ib_iser
> scsi_transport_iscsi 98304 3 ib_iser,libiscsi
> target_core_mod 352256 3 iscsi_target_mod,ib_isert,ib_srpt
> rdma_cm 53248 4 ib_iser,ib_isert,rpcrdma,rdma_ucm
> ib_core 208896 15
> ib_iser,ib_cm,rdma_cm,ib_umad,ib_srp,ib_isert,ib_uverbs,rpcrdma,ib_ipoib,iw_cm,ib_srpt,ib_ucm,rdmavt,ib_qib,rdma_ucm
>
>
> Commands to initialize iscsiadm:
>
> iscsiadm -m discovery -t st -p 10.0.13.3:3260 -I iser
>
> iscsiadm -m node -P 1
> Target: iqn.2017-01.at.cf-it.at-storage-01
> Portal: 10.0.13.3:3260,1
> Iface Name: iser
>
> iscsiadm -m node -l
>
> ->> creates the logs
>
>
> @deleted and recreated, multiple times
> ib_isert and ib_iser are loaded on both servers
>
> BR
> Thomas
>
> The config looks good to me. I did have a similar problem with a RoCE
> card where I could not get iSER working although RDMA did work.
> Looking at the code, it seems that maybe the QLogic driver is not
> properly allocating some memory that iSER is trying to use. I'm not an
> expert in this so I could be completely off base here, just trying to
> help out.
>
> If you are adventerious, you can add some print statements in
> drivers/infiniband/core/fmr_pool.c in the ib_fmr_pool_map_phys
> function to see what may be going on. I think you are hitting this
> line:
>
> if (list_len < 1 || list_len > pool->max_pages)
> return ERR_PTR(-EINVAL);
>
> I would check the values of list_len and pool->max_pages before that.
>
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904 C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
