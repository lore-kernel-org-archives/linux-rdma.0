From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 2x difference between multi-thread and multi-process for same
 number of CTXs
Date: Wed, 24 Jan 2018 17:00:12 -0500
Message-ID: <CADPSxAg62gpCTdD9rqVfz+hznVpa_yHig1PRvMeHs2SWc1fvsw@mail.gmail.com>
References: <CAJ84Q-aFfcXxaJS5rApcoow6SBjfZAvt71_OKo1ORorXAOZKbw@mail.gmail.com>
 <20180124170830.GD16845@ziepe.ca> <CAJ84Q-aMW7PXFFuODm6RN=SO342=tJ4_eSJ2TB0b8DLrxgwtGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ84Q-aMW7PXFFuODm6RN=SO342=tJ4_eSJ2TB0b8DLrxgwtGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rohit Zambre <rzambre-sXc7qaQca9o@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

IMO this is probably an implementation issue in the benchmarking code,
and I'm curious to know the issue if you find it.

It's possible to achieve 150+ million writes per second with a
multi-threaded process. See Figure 12 in our paper:
http://www.cs.cmu.edu/~akalia/doc/atc16/rdma_bench_atc.pdf. Our
benchmark code is available:
https://github.com/efficient/rdma_bench/tree/master/rw-tput-sender.

--Anuj

On Wed, Jan 24, 2018 at 3:53 PM, Rohit Zambre <rzambre-sXc7qaQca9o@public.gmane.org> wrote:
> On Wed, Jan 24, 2018 at 11:08 AM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
>> On Wed, Jan 24, 2018 at 10:22:53AM -0600, Rohit Zambre wrote:
>>
>>> (1) First, is this a surprising result or is the 2x difference
>>> actually expected behavior?
>>
>> Maybe, there are lots of locks in one process, for instance glibc's
>> malloc has locking - so any memory allocation anywhere in the
>> applications processing path will cause lock contention. The issue may
>> have nothing to do with RDMA.
>
> There are no mallocs in the critical path of the benchmark. In the 1
> process multi-threaded case, the mallocs for resource creation are all
> before creating the OpenMP parallel region. Here's a snapshot of the
> parallel region that contains the critical path:
>
> #pragma omp parallel
>         {
>             int i = omp_get_thread_num(), k;
>             int cqe_count = 0;
>             int post_count = 0;
>             int comp_count = 0;
>             int posts = 0;
>
>             struct ibv_send_wr *bad_send_wqe;
>             struct ibv_wc *WC = (struct ibv_wc*) malloc(qp_depth *
> sizeof(struct ibv_wc) ); // qp_depth is 128 (adopted from perftest)
>
>             #pragma omp single
>             { // only one thread will execute this
>                 MPI_Barrier(MPI_COMM_WORLD);
>             } // implicit barrier for the threads
>             if (i == 0)
>                 t_start = MPI_Wtime();
>
>             /* Critical Path Start */
>             while (post_count < posts_per_qp || comp_count <
> posts_per_qp) { // posts_per_qp = num_of_msgs / num_qps
>                 /* Post */
>                 posts = min( (posts_per_qp - post_count), (qp_depth -
> (post_count - comp_count) ) );
>                 for (k = 0; k < posts; k++)
>                     ret = ibv_post_send(qp[i], &send_wqe[i], &bad_send_wqe);
>                 post_count += posts;
>                 /* Poll */
>                 if (comp_count < posts_per_qp) {
>                      cqe_count = ibv_poll_cq(cq[i], num_comps, WC); //
> num_comps = qp_depth
>                      comp_count += cqe_count;
>                  }
>              } /* Critical Path End */
>              if (i == 0)
>                  t_end = MPI_Wtime();
>          }
>
>> There is also some locking inside the userspace mlx5 driver that may
>> contend depending on how your process has set things up.
>
> I missed mentioning this but I collected the numbers with
> MLX5_SINGLE_THREADED set since none of the resources were being shared
> between the threads. So, the userspace driver wasn't taking any locks.
>
>> The entire send path is in user space so there is no kernel component
>> here.
>
> Yes, that's correct. My concern was that during resource creation, the
> kernel was maybe sharing some resource for a process or that some sort
> of multiplexing was occurring to hardware contexts through control
> groups. Is it safe for me to conclude that separate, independent
> contexts/bfregs are being assigned when a process calls
> ibv_open_device multiple times?
>
>> Jason
>
> Thanks,
> Rohit Zambre
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
