From: floaterions <floaterions-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: RDMA =?utf-8?b?RkVUQ0hfQU5EX0FERA==?= and =?utf-8?b?Q01QX0FORF9TV0FQ?= fail
Date: Wed, 3 Dec 2014 21:56:26 +0000 (UTC)
Message-ID: <loom.20141203T225347-18@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello All,

I can successfully send RDMA READ/WRITE,
but I can't get RDMA atomic operations to work.
I get an error when calling ibv_post_send function in the client,
and the errno will be set to "Invalid Arguments."
Below I pasted important parts of my code.
Could you please check my code and let me know if I'm missing anything?


*********** client side *****************:
-- Registering the memory regions --
mr = ibv_reg_mr(pd, buff, size, IBV_ACCESS_LOCAL_WRITE);
// and the size is 8

if (!mr){
   fprintf(stderr, "Error, memory registration failed\n");
   return -1;
}

-- Preparing RDMA ATOMIC FETCH AND 
struct ibv_send_wr wr, *bad_wr = NULL;
struct ibv_sge sge;
	
memset(&sge, 0, sizeof(sge));
sge.addr 		= buff;
sge.length 	= 8;
sge.lkey 		= mr->lkey;
	
memset(&wr, 0, sizeof(wr));
wr.wr_id     = 0;
wr.opcode  = IBV_WR_ATOMIC_FETCH_AND_ADD;
wr.sg_list 			= &sge;
wr.num_sge 		= 1;
wr.send_flags 		= IBV_SEND_SIGNALED;

wr.wr.atomic.remote_addr	= remote_buffer;
wr.wr.atomic.rkey        	= peer_mr->rkey;
wr.wr.atomic.compare_add	= 1ULL; 

if (ibv_post_send(qp, &wr, &bad_wr)) {
    fprintf(stderr, "Error, ibv_post_send() failed\n");
    return -1;
}
********* End of Client side *******

****** Server side ****************
-- Registering the memory regions --
mr = ibv_reg_mr(pd,  rdma_region_timestamp_oracle,
         sizeof(TimestampOracle), 
         IBV_ACCESS_LOCAL_WRITE | IBV_ACCESS_REMOTE_WRITE
         | IBV_ACCESS_REMOTE_READ | IBV_ACCESS_REMOTE_ATOMIC ));

if (!mr){
   fprintf(stderr, "Error, memory registration() failed\n");
   return -1;
}


NOTE: TimestampOracle is a class with two int members,
so its size is 8 bytes (satisfies 64-bit condition for RDMA ATOMIC operations)

Thank you for your helps

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
