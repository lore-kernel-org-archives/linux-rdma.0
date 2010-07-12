From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: OpenMPI over RoCEE
Date: Mon, 12 Jul 2010 13:21:34 -0700
Message-ID: <4C3B794E.7010701@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I'm running OFED-1.5.1 with the RoCEE mlx4 drivers.  I can run low level 
verbs programs ok, but when running open mpi, I'm getting this error.  
Anybody seen this?

-----

[ompi@escher ~]$ mpirun -np 2 -host 10.192.176.111,10.192.176.112 --mca 
btl openib,sm,self /usr/mpi/gcc/openmpi-1.4.1/tests/IMB-3.2/IMB-MPI1 
-msglen msglen.txt -iter 1000000 pingpong
[escher][[36356,1],1][connect/btl_openib_connect_oob.c:325:qp_connect_all] 
error modifing QP to RTR errno says Invalid argument
[escher][[36356,1],1][connect/btl_openib_connect_oob.c:809:rml_recv_cb] 
error in endpoint reply start connect
--------------------------------------------------------------------------
mpirun has exited due to process rank 1 with PID 4894 on
node escher exiting without calling "finalize". This may
have caused other processes in the application to be
terminated by signals sent by mpirun (as reported here).
--------------------------------------------------------------------------

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
