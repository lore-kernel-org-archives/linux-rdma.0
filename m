From: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/1] mthca: Modify to support embedded PowerPC platforms
Date: Sat, 08 Jan 2011 23:56:30 -0500
Message-ID: <4D293FFE.7000901@cadence.com>
References: <ig5usq$tgi$1@dough.gmane.org> <adalj2xb6h0.fsf@cisco.com>	<ada4o9lb42k.fsf@cisco.com> <ig6m82$k8i$1@dough.gmane.org> <adazkrcabt7.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050600020108050403090904"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adazkrcabt7.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------050600020108050403090904
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

> One thing to try would be to load the ib_mthca module with fw_cmd_doorbell=1
> That won't fix anything, but if it fails in a different way that might
> give a clue as to what's wrong.

I tried this and it *does* fail in a different way:

NOP command failed to generate interrupt (IRQ 18), aborting.
BIOS or ACPI interrupt routing problem?

I reviewed the two methods used (fw_cmd_doorbell set to 0 vs. 1).  The 
default uses mthca_cmd_post_hcr and the hcr area to write command 
parameters.  Setting the option to 1, uses mthca_cmd_post_dbell and the 
doorbell area to write command parameters.

When I compared some of these fields in my GDB dump of module areas, I 
see that the doorbell offsets on my system are all 0x000C.  That is, all 
8 elements of the dev->cmd.dbell_offsets array are 0x000C.

I added some traces and rmb() calls in the code setting up dbell_offsets 
but this did not change anything.

Is it normal for all doorbell offsets to have the same value?

I do see that mthca_cmd_post_dbell does seem to follow each write to a 
doorbell offset with a wmb() call.  This is unlike mthca_cmd_post_hcr 
which only issues a wmb() call after a number of writes to the hcr area 
have been performed.

I'm guessing that the need for a wmb() after every write in 
mthca_cmd_post_dbell is because it is indeed normal for all doorbell 
offsets to be the same.  The code needs to explicitly "flush" each 
write, as it is targeting the same address.  Without the wmb(), the CPU 
might combine some of these writes.

If so, then I'm not sure I know what is wrong here.

To my knowledge, only the outgoing (CPU->device) addresses are 36-bit. 
Those should be accommodated by the ioremap calls.  The incoming 
(device->CPU) addresses (e.g. dma_addr_t) are still 32-bit.

I earlier had wondered if there needed to be any adjustments to any CPU 
addresses passed to the card firmware (i.e. DMA targets).  But I believe 
there shouldn't be anything unusual about these.  The system has 2GB of 
memory and I believe it is addressed from a PCI device as 0x0-0x7FFFFFFF.

Tonight, I added traces in mthca_cmd_post_dbell and saw what I think are 
reasonable values:

FW supports commands through doorbells
mailbox->buf = ff104000, mailbox->dma = 2fb3f000
Doorbell 0 (QUERY_FW_CMD_DB_OFFSET=50): 000C
Doorbell 1 (QUERY_FW_CMD_DB_OFFSET=52): 000C
Doorbell 2 (QUERY_FW_CMD_DB_OFFSET=54): 000C
Doorbell 3 (QUERY_FW_CMD_DB_OFFSET=56): 000C
Doorbell 4 (QUERY_FW_CMD_DB_OFFSET=58): 000C
Doorbell 5 (QUERY_FW_CMD_DB_OFFSET=5A): 000C
Doorbell 6 (QUERY_FW_CMD_DB_OFFSET=5C): 000C
Doorbell 7 (QUERY_FW_CMD_DB_OFFSET=5E): 000C
Mapped doorbell page for posting FW commands

I believe the card firmware would target 0x2FB3F000 to write to the 
doorbell area.  I need to try to verify this is indeed mapped in the 
hardware properly (e.g. incoming memory window for the PCIe root 
complex).  But I think it must, as our FC stuff works OK.

The fact that I don't get any interrupts after the driver is loaded, 
makes me suspicious that some needed card firmware initialization has 
not occurred.  That's why I was thinking I needed to somehow dump areas 
from the card / firmware to be able to see if it was properly set-up.

But I obviously don't know enough about the card to be able to proceed here.

I'll attach my GDB dump of the live driver's struct_mthca_dev from 
December.  It shows the dbell_offsets values, etc.  I've spaced it and 
split lines on semi-meaningful boundaries for near-readability.  Maybe 
something will look wrong to more experienced eyes.

John



--------------050600020108050403090904
Content-Type: text/plain;
 name="gdb-format"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="gdb-format"

(gdb) print (*(struct mthca_dev *)0xee352000)

$18 = {ib_dev = {dma_device = 0xee055050, name = "mthca0", '\000' <repeats 57 times>,
      event_handler_list = {next = 0xee352064, prev = 0xefbd9ad8},
      event_handler_lock = {raw_lock = {<No data fields>}},

      core_list = {next = 0xf3f0cd78, prev = 0xf3f0cd78},
      client_data_list = {next = 0xefaf7520, prev = 0xee1a0c40},
      client_data_lock = {raw_lock = {<No data fields>}},

      cache = {lock = {raw_lock = {<No data fields>}},

      event_handler = {device = 0xee352000, handler = 0xf3f057ac,
      list = {next = 0xef8c9530, prev = 0xee352044}},

      pkey_cache = 0xee1a0c60, gid_cache = 0xee1a0d40, lmc_cache = 0xee1a0d60 ""},

    pkey_tbl_len = 0xef9c2ce0, gid_tbl_len = 0xef9c2bc0,
    num_comp_vectors = 1, iwcm = 0x0,

    query_device = 0xf4f920dc <mthca_query_device>,
    query_port = 0xf4f9233c <mthca_query_port>,
    query_gid = 0xf4f9275c <mthca_query_gid>,
    query_pkey = 0xf4f92660 <mthca_query_pkey>,
    modify_device = 0xf4f924f8 <mthca_modify_device>,
    modify_port = 0xf4f9257c <mthca_modify_port>,
    alloc_ucontext = 0xf4f937b8 <mthca_alloc_ucontext>,
    dealloc_ucontext = 0xf4f928d0 <mthca_dealloc_ucontext>,
    mmap = 0xf4f92058 <mthca_mmap_uar>,
    alloc_pd = 0xf4f92924 <mthca_alloc_pd>,
    dealloc_pd = 0xf4f92a5c <mthca_dealloc_pd>,
    create_ah = 0xf4f92a9c <mthca_ah_create>,
    modify_ah = 0, query_ah = 0xf4f90684 <mthca_ah_query>,
    destroy_ah = 0xf4f92b2c <mthca_ah_destroy>,
    create_srq = 0xf4f92b6c <mthca_create_srq>,
    modify_srq = 0xf4f9671c <mthca_modify_srq>,
    query_srq = 0xf4f967e8 <mthca_query_srq>,
    destroy_srq = 0xf4f92d38 <mthca_destroy_srq>,
    post_srq_recv = 0xf4f96370 <mthca_arbel_post_srq_recv>,
    create_qp = 0xf4f92d9c <mthca_create_qp>,
    modify_qp = 0xf4f8e85c <mthca_modify_qp>,
    query_qp = 0xf4f8da18 <mthca_query_qp>,
    destroy_qp = 0xf4f93060 <mthca_destroy_qp>,
    post_send = 0xf4f8f978 <mthca_arbel_post_send>,
    post_recv = 0xf4f8d620 <mthca_arbel_post_receive>,
    create_cq = 0xf4f930e0 <mthca_create_cq>,
    modify_cq = 0, destroy_cq = 0xf4f9361c <mthca_destroy_cq>,
    resize_cq = 0xf4f9333c <mthca_resize_cq>,
    poll_cq = 0xf4f8a058 <mthca_poll_cq>,
    peek_cq = 0,
    req_notify_cq = 0xf4f89e0c <mthca_arbel_arm_cq>,
    req_ncomp_notif = 0,
    get_dma_mr = 0xf4f93f3c <mthca_get_dma_mr>,
    reg_phys_mr = 0xf4f93fec <mthca_reg_phys_mr>,
    reg_user_mr = 0xf4f944bc <mthca_reg_user_mr>,
    query_mr = 0,
    dereg_mr = 0xf4f9369c <mthca_dereg_mr>,
    rereg_phys_mr = 0,
    alloc_mw = 0,
    bind_mw = 0,
    dealloc_mw = 0,
    alloc_fmr = 0xf4f936ec <mthca_alloc_fmr>,
    map_phys_fmr = 0xf4f8b804 <mthca_arbel_map_phys_fmr>,
    unmap_fmr = 0xf4f9392c <mthca_unmap_fmr>,
    dealloc_fmr = 0xf4f91e08 <mthca_dealloc_fmr>,
    attach_mcast = 0xf4f91308 <mthca_multicast_attach>,
    detach_mcast = 0xf4f90f74 <mthca_multicast_detach>,
    process_mad = 0xf4f919cc <mthca_process_mad>,

    dma_ops = 0x0,

    owner = 0xf4fa0c60,

    dev = {klist_children = {k_lock = {raw_lock = {<No data fields>}},
      k_list = {next = 0xee352158, prev = 0xee352158},
      get = 0xc0171988 <klist_children_get>, put = 0xc01719bc <klist_children_put>},

      knode_parent = {n_klist = 0xee055050, n_node = {next = 0xee340414, prev = 0xee055050},
      n_ref = {refcount = {counter = 1}}, n_removed = {done = 0,
      wait = {lock = {raw_lock = {<No data fields>}}, task_list = {next = 0xee35217c, prev = 0xee35217c}}}},

      knode_driver = {n_klist = 0x0, n_node = {next = 0x0, prev = 0x0},
      n_ref = {refcount = {counter = 0}}, n_removed = {done = 0,
      wait = {lock = {raw_lock = {<No data fields>}}, task_list = {next = 0x0, prev = 0x0}}}},

      knode_bus = {n_klist = 0x0, n_node = {next = 0x0, prev = 0x0},
      n_ref = {refcount = {counter = 0}}, n_removed = {done = 0,
      wait = {lock = {raw_lock = {<No data fields>}}, task_list = {next = 0x0, prev = 0x0}}}},

      parent = 0xee055050, kobj = {name = 0xef9c2240 "mthca0", kref = {refcount = {counter = 4}},
      entry = {next = 0xee340470, prev = 0xee1af670},
      parent = 0xf3f0c948, kset = 0xee00aae0, ktype = 0xc0328fc4,
      sd = 0xefbab878, state_initialized = 1, state_in_sysfs = 1, state_add_uevent_sent = 1,
      state_remove_uevent_sent = 0}, bus_id = "mthca0", '\000' <repeats 13 times>,
      type = 0x0, uevent_suppress = 0,
      sem = {lock = {raw_lock = {<No data fields>}}, count = 1,
      wait_list = {next = 0xee352204, prev = 0xee352204}},
      bus = 0x0, driver = 0x0, driver_data = 0xee352000, platform_data = 0x0,
      power = {power_state = {event = 0},
      can_wakeup = 0, should_wakeup = 0, sleeping = false},
      dma_mask = 0x0, coherent_dma_mask = 0, dma_parms = 0x0,
      dma_pools = {next = 0xee352234, prev = 0xee352234}, dma_mem = 0x0,
      archdata = {of_node = 0x0, dma_ops = 0x0, dma_data = 0x0, numa_node = 0},
      devres_lock = {raw_lock = {<No data fields>}},
      devres_head = {next = 0xee352250, prev = 0xee352250},
      node = {next = 0xf3f0c970, prev = 0xf3f0c970},
      class = 0xf3f0c938, devt = 0, groups = 0x0, release = 0},

    ports_parent = 0xee3beca0,

    port_list = {next = 0xee3ef868, prev = 0xee3ef868},

    reg_state = IB_DEV_REGISTERED,

    uverbs_cmd_mask = 67899367967,
    uverbs_abi_ver = 1,

    node_desc = "MT25204 InfiniHostLx Mellanox Technologies", '\000' <repeats 21 times>,
    node_guid = 783960383308564,
    node_type = 1 '\001',
    phys_port_cnt = 1 '\001'},

    pdev = 0xee055000,

    hca_type = 3,

    mthca_flags = 502,

    device_cap_flags = 7286,

    rev_id = 160,

    board_id = "MT_03F0110001", '\000' <repeats 50 times>,

    fw_ver = 4295098368,

    fw = {
      tavor = {fw_start = 2163146968, fw_end = 2162562888},
      arbel = {clr_int_base = 2163146968, eq_arm_base = 2162562888,
               eq_set_ci_base = 2162630656, fw_icm = 0xefba48a0,
               aux_icm = 0xefba4920, fw_pages = 1284}},

    ddr_start = 0,
    ddr_end = 0,

    doorbell_lock = {raw_lock = {<No data fields>}},

    cap_mask_mutex = {count = {counter = 1},
      wait_lock = {raw_lock = {<No data fields>}},
      wait_list = {next = 0xee35237c, prev = 0xee35237c}},

    hcr = 0xf3f34680,
    kar = 0xf4fa2000,
    clr_base = 0xf4fa40d8,
    eq_regs = {tavor = {ecr_base = 0xf4fa674c},
               arbel = {eq_arm = 0xf4fa674c, eq_set_ci_base = 0xf4fa8000}},

    cmd = {pool = 0xee3ef500, hcr_mutex = {count = {counter = 1},
      wait_lock = {raw_lock = {<No data fields>}},
      wait_list = {next = 0xee3523a0, prev = 0xee3523a0}},
      poll_sem = {lock = {raw_lock = {<No data fields>}}, count = 0,
      wait_list = {next = 0xee3523ac, prev = 0xee3523ac}},
      event_sem = {lock = {raw_lock = {<No data fields>}}, count = 16,
      wait_list = {next = 0xee3523b8, prev = 0xee3523b8}},
      max_cmds = 16,
      context_lock = {raw_lock = {<No data fields>}}, free_head = 0,
      context = 0xefba5c00, token_mask = 15, flags = 3,
      dbell_map = 0xf3f36000, dbell_offsets = {12, 12, 12, 12, 12, 12, 12, 12}},

    limits = {num_ports = 1, vl_cap = 4, mtu_cap = 4, gid_table_len = 32, pkey_table_len = 64,
      local_ca_ack_delay = 15, num_uars = 2048, max_sg = 27, num_qps = 65536, max_wqes = 16384,
      max_desc_sz = 496, max_qp_init_rdma = 128, reserved_qps = 1024, num_srqs = 1024,
      max_srq_wqes = 16384, max_srq_sge = 27, reserved_srqs = 64, num_eecs = 0, reserved_eecs = 16,
      num_cqs = 4096, max_cqes = 131071, reserved_cqs = 128, num_eqs = 32, reserved_eqs = 1,
      num_mpts = 131072, num_mtt_segs = 1048576, fmr_reserved_mtts = 0, reserved_mtts = 2,
      reserved_mrws = 16, reserved_uars = 1, num_mgms = 4096, num_amgms = 4096, reserved_mcgs = 0,
      num_pds = 32768, reserved_pds = 4, page_size_cap = 4294963200, flags = 3605319,
      stat_rate_support = 15, port_width_cap = 3 '\003'},

    uar_table = {alloc = {last = 0, top = 0,
      max = 2048, mask = 2047, lock = {raw_lock = {<No data fields>}}, table = 0xef9c03c0}, uarc_base = 0,
      uarc_size = 262144},

    pd_table = {alloc = {last = 0, top = 0, max = 32768, mask = 16777215, lock = {
      raw_lock = {<No data fields>}}, table = 0xee396000}},

    mr_table = {mpt_alloc = {last = 0, top = 0, max = 131072, mask = 4294967295,
      lock = {raw_lock = {<No data fields>}}, table = 0xefb5c000},
      mtt_buddy = {bits = 0xee3efbc0, num_free = 0xee3ef800, max_order = 20,
      lock = {raw_lock = {<No data fields>}}},
      fmr_mtt_buddy = 0xee3524d4,
      mtt_base = 536870912, mpt_base = 629145600,
      mtt_table = 0xef9fb000, mpt_table = 0xefbad380,
      tavor_fmr = {mpt_base = 0x0, mtt_base = 0x0,
      mtt_buddy = {bits = 0x0, num_free = 0x0, max_order = 0,
      lock = {raw_lock = {<No data fields>}}}}},

    eq_table = {alloc = {last = 0, top = 0, max = 32, mask = 31,
      lock = {raw_lock = {<No data fields>}}, table = 0xef9c21e0},
      clr_int = 0xf4fa40d8, clr_mask = 128, arm_mask = 234881024,

      eq = {{dev = 0xee352000, eqn = 3, eqn_mask = 134217728, cons_index = 177,
      msi_x_vector = 0, msi_x_entry = 0, have_irq = 0, nent = 256, page_list = 0xef9272c0,

      mr = {ibmr = {device = 0x0, pd = 0x0, uobject = 0x0, lkey = 4864, rkey = 4864,
      usecnt = {counter = 0}}, umem = 0x0, mtt = 0xef9278c0}},
      {dev = 0xee352000, eqn = 2, eqn_mask = 67108864, cons_index = 0,
      msi_x_vector = 0, msi_x_entry = 0, have_irq = 0, nent = 256, page_list = 0xef9c2b80,

      mr = {ibmr = {device = 0x0, pd = 0x0, uobject = 0x0, lkey = 4608, rkey = 4608,
      usecnt = {counter = 0}}, umem = 0x0, mtt = 0xef927260}},
      {dev = 0xee352000, eqn = 1, eqn_mask = 33554432, cons_index = 0,
      msi_x_vector = 0, msi_x_entry = 0, have_irq = 0, nent = 8192, page_list = 0xee1afe00,

      mr = {ibmr = {device = 0x0, pd = 0x0, uobject = 0x0, lkey = 4352, rkey = 4352,
      usecnt = {counter = 0}}, umem = 0x0, mtt = 0xef927980}}},

      icm_virt = 644194304, icm_page = 0xc169d6a0, icm_dma = 2038124544,
      have_irq = 1, inta_pin = 63 '?'},

    cq_table = {alloc = {last = 0, top = 0, max = 4096, mask = 16777215, lock = {
      raw_lock = {<No data fields>}}, table = 0xee1afc00}, lock = {raw_lock = {<No data fields>}},
      cq = {page_list = 0xef927960}, table = 0xee3be860},

    srq_table = {alloc = {last = 0, top = 0, max = 1024, mask = 1023,
      lock = {raw_lock = {<No data fields>}}, table = 0xee36d4c0}, lock = {raw_lock = {<No data fields>}},
      srq = {page_list = 0xef9278e0}, table = 0xef8c97e0},

    qp_table = {alloc = {last = 0, top = 0, max = 65536, mask = 16777215,
      lock = {raw_lock = {<No data fields>}}, table = 0xee3b0000},
      rdb_base = 620756992, rdb_shift = 2, sqp_start = 1024,
      lock = {raw_lock = {<No data fields>}},
      qp = {page_list = 0xefaf5a00}, qp_table = 0xee1af400,
      eqp_table = 0xee36d7c0, rdb_table = 0xefbad2c0},

    av_table = {pool = 0x0, num_ddr_avs = 0, ddr_av_base = 644198400, av_map = 0x0, alloc = {
      last = 0, top = 0, max = 0, mask = 0, lock = {raw_lock = {<No data fields>}}, table = 0x0}},

    mcg_table = {mutex = {
      count = {counter = 1}, wait_lock = {raw_lock = {<No data fields>}},
      wait_list = {next = 0xee3526a4, prev = 0xee3526a4}},
      alloc = {last = 0, top = 0, max = 8192, mask = 8191,
      lock = {raw_lock = {<No data fields>}}, table = 0xefba5400}, table = 0xee3efc20},

    catas_err = {addr = 2162698832, map = 0xf4faea50, stop = 0, size = 16,
      timer = {entry = {next = 0xc0321890, prev = 0xc032df80}, e
      xpires = 2629758, function = 0xf4f97720 <poll_catas>,
      data = 3996459008, base = 0xc037fca0},
      list = {next = 0xee3526f4, prev = 0xee3526f4}},

    driver_uar = {pfn = 14680066, index = 2},

    db_tab = 0xefba4280,

    driver_pd = {ibpd = {device = 0x0, uobject = 0x0, usecnt = {counter = 0}},
      pd_num = 4, sqp_count = {counter = 0},
      ntmr = {ibmr = {device = 0x0, pd = 0x0, uobject = 0x0, lkey = 4096, rkey = 4096,
      usecnt = {counter = 0}},
      umem = 0x0, mtt = 0x0}, privileged = 1},

    driver_mr = {ibmr = {device = 0x0, pd = 0x0,
      uobject = 0x0, lkey = 0, rkey = 0, usecnt = {counter = 0}}, umem = 0x0, mtt = 0x0},

    send_agent = {{0xef9de7a8, 0xef9de628}, {0x0, 0x0}},

    sm_ah = {0x0, 0x0},

    sm_lock = {raw_lock = {<No data fields>}},

    rate = "\004"



--------------050600020108050403090904--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
