From: Konstantin Boyanov <konstantin.boyanov-T5F83Mi6MZE@public.gmane.org>
Subject: Segmentation Fault when accessing QPN of a RC Queue pair
Date: Wed, 23 Mar 2011 13:55:32 +0100
Message-ID: <4D89EDC4.4050309@desy.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello list,

I have a very peculiar problem with a simple code of mine. In the last 
week I am trying to bring up a simple RC-based programm to run and 
exchange a single message between two peers, but right now I am stuck 
with a segmentation fault when accessing one of the QPs QPN. It is a 
peculiar problem because I create two identical QPs (one on the sending 
peer and one on the receiving peer), and when I access the fields of the 
one queue pair structure I got no problems, but when I do this on the 
other I get a segmentation fault.

I am trying to create a reliable connection between two QPs residing on 
the same HCA and the send messages via the loopback mechanism.

I first open the HCA and init the corresponding context with it:


<CODE>
static void gpeIBopenDev(ib_thread_info *ibthr, int verbose){

    struct ibv_device **infband_dev_list;
    struct ibv_device_attr ibdev_attr;
    int ret;

    infband_dev_list = ibv_get_device_list(NULL);
    if(!infband_dev_list)
        perror("ibv_get_device_list");

    if(infband_dev_list[0] != NULL){
        ibthr->ibdev = infband_dev_list[0];
    }else
        printf("Error: No IB device found!\n");

    ibthr->ibctx = ibv_open_device(ibthr->ibdev);
    if(!ibthr->ibctx)
        perror("ibv_open_device");
}
</CODE>


Then I allocate memory buffers and create protection domains, create a 
protection domain to be associated with the QPs an at last create the 
memory regions which the QPs will be using:


<CODE>
static void gpeIBinitMemory(ib_thread_info *ibthr, bench_args_t *barg){

      static long int pg_sz;
      pg_sz = sysconf(_SC_PAGESIZE);

      if (barg->conn_type_arg==CONN_TYPE_UD) {
        ibthr->buf = memalign(pg_sz, ( barg->tx_byte_sz_arg + 40 ) * 2);
        if (!ibthr->buf) {
          printf("Could not allocate buffer.\n");
          perror("memalign");
          exit(1);
        }
        memset(ibthr->buf, 0, ( barg->tx_byte_sz_arg + 40 ) * 2);
      } else {
        ibthr->buf = memalign(pg_sz, barg->tx_byte_sz_arg*2);
        if (!ibthr->buf) {
          printf("Could not allocate buffer.\n");
          perror("memalign");
          exit(1);
        }
        memset(ibthr->buf, 0, barg->tx_byte_sz_arg*2);
      }

      ibthr->ib_prot_domain =  ibv_alloc_pd(ibthr->ibctx);
      if(!ibthr->ib_prot_domain){
          perror("ibv_alloc_pd");
          exit(1);
      }

      if(barg->verbose == 1)
          printf("Initialize the inbound and outbound context buffers \n");

      ibthr->out_data = (char *)ibthr->buf + (barg->tx_byte_sz_arg-1);
      ibthr->in_data  = (char *)ibthr->buf + (barg->tx_byte_sz_arg-1)*2;

      if(barg->verbose == 1)
          printf("initialize memory region (MR)\n");

      if (barg->conn_type_arg==CONN_TYPE_UD) {
        ibthr->mr = ibv_reg_mr(ibthr->ib_prot_domain, ibthr->buf, 
(barg->tx_byte_sz_arg+40)*2,
                      IBV_ACCESS_REMOTE_WRITE | IBV_ACCESS_LOCAL_WRITE);
      }else{
        ibthr->mr = ibv_reg_mr(ibthr->ib_prot_domain, ibthr->buf, 
(barg->tx_byte_sz_arg)*2,
                      IBV_ACCESS_REMOTE_WRITE | IBV_ACCESS_LOCAL_WRITE);
      }
      if(!ibthr->mr)
        perror("ibv_reg_mr");
}
</CODE>


After this being successfully done,  I create and initialize the 
completition channels for this QP context's Queue Pair, create the 
uninitialized Queue Pairs themselves.


<CODE>
static void gpeIBcreateQP(ib_thread_info *ibthr, bench_args_t *barg){

    struct ibv_qp_init_attr qp_init_attr;
    memset(&qp_init_attr, 0, sizeof(struct ibv_qp_init_attr));

    // fill ibqp_ini_attr with needed values
    qp_init_attr.cap.max_send_sge = 0;
    qp_init_attr.cap.max_recv_sge = 0;
    qp_init_attr.cap.max_send_wr = barg->tx_dpth_arg;
    qp_init_attr.cap.max_recv_wr = barg->tx_dpth_arg;

    qp_init_attr.sq_sig_all = 0;

    switch (barg->conn_type_arg) {
      case CONN_TYPE_RC :
          qp_init_attr.qp_type = IBV_QPT_RC;
          break;
      case CONN_TYPE_UC :
          qp_init_attr.qp_type = IBV_QPT_UC;
          break;
      case CONN_TYPE_UD :
          qp_init_attr.qp_type = IBV_QPT_UD;
          break;
      default:
          printf("Unknown connection type %d \n",barg->conn_type_arg);
          exit(1);
    }

    // First create an uninitialized instance of the Queue Pairs
    if(barg->verbose == 1)
        printf(" Initialize completion channel \n");

    ibthr->ibcompl_ch = ibv_create_comp_channel(ibthr->ibctx);
    if(!ibthr->ibcompl_ch)
      perror("ibv_create_comp_channel");

    if(barg->verbose == 1)
      printf(" Create the Completiotion Queues (CQs) \n");

    ibthr->send_cq = ibv_create_cq(ibthr->ibctx, barg->tx_dpth_arg, 
NULL, ibthr->ibcompl_ch, 0);
    if(!ibthr->send_cq)
      perror("ibv_create_cq");

    qp_init_attr.send_cq = ibthr->send_cq;

    ibthr->recv_cq = ibv_create_cq(ibthr->ibctx, barg->tx_dpth_arg, 
NULL, ibthr->ibcompl_ch, 0);
    if(!ibthr->recv_cq )
      perror("ibv_create_cq");

    qp_init_attr.recv_cq = ibthr->recv_cq;


    ibthr->qp = ibv_create_qp(ibthr->ib_prot_domain, &qp_init_attr);
    if (!ibthr->qp) {
        perror("ibv_create_qp");
        fprintf(stderr, "Couldn't create QP, %p\n", ibthr->qp);
        exit(1);
    }

    printf("%d\n",ibthr->qp->handle);
    printf("%d\n",ibthr->qp->qp_num);
    printf("%d\n",ibthr->qp->qp_type);

}
</CODE>


Note the last three printf's. here I can access the fields of the QP 
without a problem. After altering the QPs to the INIT state however 
(which finishes OK without errors) I get a segmentation fault on the 
following invocation (snippet from main() ):


<CODE>
  ib_thread_info ping_ib_thread;
  ib_thread_info pong_ib_thread;

  // Get the list of available devices and open the first one found
  gpeIBopenDev(&pong_ib_thread, optVerbose);
  gpeIBopenDev(&ping_ib_thread, optVerbose);
 
  // Initialize send and receive buffers, Memory regions and protection 
domains
  gpeIBinitMemory(&pong_ib_thread, &barg);
  gpeIBinitMemory(&ping_ib_thread, &barg);

  // Create and initial empty queue pair
  gpeIBcreateQP(&pong_ib_thread, &barg);
  gpeIBcreateQP(&ping_ib_thread, &barg);

  // Then, alter the state of the Queue Pairs to the INIT state
  //  ib_ping_qp_attr.pkey_index      = 1;
  //  ib_pong_qp_attr.pkey_index      = 1;
  gpeIBinitQP(&ib_pong_qp_attr, &pong_ib_thread, &barg);
  gpeIBinitQP(&ib_ping_qp_attr, &ping_ib_thread, &barg);

dest.qpn = ping_ib_thread.qp->qp_num;  <<-- RESULTS IN SEGMENTATION 
FAULT !!!
rem_dest.qpn = pong_ib_thread.qp->qp_num; << THIS DOES NOT RESULT IN 
SEGMENTATION FAULT !!!
</CODE>


I have little to no idea why the one causes a SEGFAULT and the other 
not, after all I have created and initialized them in the same way. I am 
really getting frustrated by this, I spend the past 3 days looking for 
some cause but to no avail. If I ommit the line where the SEGFAULT 
occurs I get another later when trying to get the QP to the RTS state, 
so sonething is definetly wrong, but right now I don't have the 
slightest clue what. So please, if someone has some idea what I might be 
doing wrong, share it with me. I am really starting to hate this code, 
as there is no comprehensible description as to what are the 
requirements to create a QP for the different transport types, and also 
no examples (at least I didn't found any).


Hope my mail didn't get too long, boring and confusing.
Any help will be appreciated!



Best Regards,
Konstantin Boyanov

P.S.
The whole code is available here:
http://www.ifh.de/~boyanov/ibpipo/
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
