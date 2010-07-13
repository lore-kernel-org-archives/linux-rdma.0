From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: OpenMPI over RoCEE
Date: Tue, 13 Jul 2010 19:56:31 -0400
Message-ID: <48CED3A4-25F4-4D43-9948-881C0856225B@cisco.com>
References: <4C3B794E.7010701@opengridcomputing.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C3B794E.7010701-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Does it work with Open MPI v1.4.2?


On Jul 12, 2010, at 4:21 PM, Steve Wise wrote:

> I'm running OFED-1.5.1 with the RoCEE mlx4 drivers.  I can run low level
> verbs programs ok, but when running open mpi, I'm getting this error. 
> Anybody seen this?
> 
> -----
> 
> [ompi@escher ~]$ mpirun -np 2 -host 10.192.176.111,10.192.176.112 --mca
> btl openib,sm,self /usr/mpi/gcc/openmpi-1.4.1/tests/IMB-3.2/IMB-MPI1
> -msglen msglen.txt -iter 1000000 pingpong
> [escher][[36356,1],1][connect/btl_openib_connect_oob.c:325:qp_connect_all]
> error modifing QP to RTR errno says Invalid argument
> [escher][[36356,1],1][connect/btl_openib_connect_oob.c:809:rml_recv_cb]
> error in endpoint reply start connect
> --------------------------------------------------------------------------
> mpirun has exited due to process rank 1 with PID 4894 on
> node escher exiting without calling "finalize". This may
> have caused other processes in the application to be
> terminated by signals sent by mpirun (as reported here).
> --------------------------------------------------------------------------
> 
> 


-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
