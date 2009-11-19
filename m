From: Martin Siegert <siegert-z1KUqvL5UUQ@public.gmane.org>
Subject: LOCAL LENGTH ERROR when sending large messages
Date: Thu, 19 Nov 2009 13:09:06 -0800
Message-ID: <20091119210906.GA12787@stikine.its.sfu.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="x+6KMIRAuhnl3hBn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I am running into problems whe sending large messages
(trivial program attached) using OpenMPI 1.3.3 over Infiniband.
This happens when I send more than 134217728 doubles (1GB).
For count = 134217728 the program works fine. The program
also works fine when using TCP instead of IB. The two nodes
both have 16GB of memory and ulimit is set to unlimited for
everything that has to do with memory. This is running under
RedHat 5.3 (actually Scientific Linux 5.3, which is identical
as far as kernel, ib drivers, etc. is concerned). The two nodes
are blade servers with Mellanox ConnectX MT25418 adapters
(firmware 2.3.0) that use the mlx4 driver.
Output when running with count = 134217729:

# mpiexec -machinefile m2 -n 2 ./a.out
id=1: calling irecv ...
id=0: calling isend ...
[[51231,1],1][btl_openib_component.c:2951:handle_wc] from b1 to: b2 error polling LP CQ with status LOCAL LENGTH ERROR status number 1 for wr_id 78676848 opcode 128  vendor error 105 qp_idx 3

error 105 appears to be "No buffer space available".
What can be done to solve this problem? E.g., is there a way to increase
these buffers?
(sorry, I am not an expert - any advice would be appreciated - thanks!)

Cheers,
Martin

-- 
Martin Siegert
Head, Research Computing
WestGrid Site Lead
IT Services                                phone: 778 782-4691
Simon Fraser University                    fax:   778 782-4242
Burnaby, British Columbia                  email: siegert-z1KUqvL5UUQ@public.gmane.org
Canada  V5A 1S6

--x+6KMIRAuhnl3hBn
Content-Type: text/x-c++src; charset=us-ascii
Content-Disposition: attachment; filename="sendrecv.c"

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
int count, i, myid, numprocs;
double *buf, wt, wt0;
MPI_Request req;
MPI_Status stat;

   MPI_Init(NULL, NULL);
   MPI_Comm_rank(MPI_COMM_WORLD, &myid);
   MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
   
   count = 134217729;
   buf = (double *)malloc(count*sizeof(double));
   if (buf == NULL) {
      fprintf(stderr, "id=%i: error - buffer allocation failed.\n", myid);
      MPI_Abort(MPI_COMM_WORLD, -1);
      exit(-1);
   }
   if (myid == 0) {
      for (i = 0; i < count; i++) {
         buf[i] = (double)i;
      }
      fprintf(stderr, "id=%i: calling isend ...\n", myid);
      wt0 = MPI_Wtime();
      MPI_Isend(buf, count, MPI_DOUBLE, 1, 1, MPI_COMM_WORLD, &req);
   } else if (myid == 1) {
      fprintf(stderr, "id=%i: calling irecv ...\n", myid);
      wt0 = MPI_Wtime();
      MPI_Irecv(buf, count, MPI_DOUBLE, 0, 1, MPI_COMM_WORLD, &req);
   }
   MPI_Wait(&req, &stat);
   wt = MPI_Wtime();
   printf("id=%i: isend/irecv completed %f\n", myid, wt - wt0);
   MPI_Finalize();
}

--x+6KMIRAuhnl3hBn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
