From: Rohit Zambre <rzambre-sXc7qaQca9o@public.gmane.org>
Subject: Re: 2x difference between multi-thread and multi-process for same
 number of CTXs
Date: Tue, 6 Feb 2018 18:02:12 -0600
Message-ID: <CAJ84Q-agb-9jiW6Q+K+8q__yrsjOgxHkyMFU-AbNhWTCfjLA8g@mail.gmail.com>
References: <CAJ84Q-aFfcXxaJS5rApcoow6SBjfZAvt71_OKo1ORorXAOZKbw@mail.gmail.com>
 <20180124170830.GD16845@ziepe.ca> <CAJ84Q-aMW7PXFFuODm6RN=SO342=tJ4_eSJ2TB0b8DLrxgwtGQ@mail.gmail.com>
 <CADPSxAg62gpCTdD9rqVfz+hznVpa_yHig1PRvMeHs2SWc1fvsw@mail.gmail.com>
 <CAJ84Q-ZnXwgyM76RJQWpwhZvx_3R3CqU_qwfY6pH5OV27fe0Dg@mail.gmail.com>
 <CADPSxAj1wbNUqCpwigorpoQgGMVCAJ1TiQ5CuCxvSkVWd6LThQ@mail.gmail.com>
 <CAJ84Q-avu53954aECPKBHv2RR3KeH3ra4S+duLsFQeb3pp2+ww@mail.gmail.com> <CADPSxAgMeCdFsnrCAKLtGZp_aJp78LMB2VUObsr3_s-p6vu-MA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADPSxAgMeCdFsnrCAKLtGZp_aJp78LMB2VUObsr3_s-p6vu-MA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Balaji, Pavan" <balaji-uKDnm65ik8M@public.gmane.org>, Aparna Chandramowlishwaran <amowli-sXc7qaQca9o@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi everyone,

The issue of performance difference between my multi-thread and
multi-process has been solved. Couple of things (1) I wasn't using any
features/optimizations such as inlining, postlist and unsignaled
completions that efficient/rdma_bench was using (2) there was bug in
my program which crept in only when I didn't use the postlist feature:
I was sharing a variable for error-checking between threads causing
store misses.

With all the optimizations in, I am able to achieve ~140M messages/s
on the ConnectX-4 card with both multi-thread and multi-proc, the same
as efficient/rdma_bench.

Thank you for your help!

-Rohit Zambre

On Fri, Jan 26, 2018 at 4:34 PM, Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> rdma_bench can do 70+ million writes/sec with one port (CX5 though). I
> don't think that's the issue.
>
> sudo is needed only for hugepages via shmget, unless I'm missing
> something. It seems I don't use hugepages in rw_tput_sender, so it
> might just work without sudo.
>
> --Anuj
>
> On Fri, Jan 26, 2018 at 3:14 PM, Rohit Zambre <rzambre-sXc7qaQca9o@public.gmane.org> wrote:
>> On Fri, Jan 26, 2018 at 12:13 PM, Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> ConnectX-4 is closer to Connect-IB. There was a 4x jump in message rate from
>>> ConnectX-3 to Connect-IB, way less from CIB to CX4. 35 M/s is the maximum
>>> that CX3 can do, so it's not a CPU bottleneck.
>>
>> The fact that the Connect-IB card on NetApp's cluster is dual-port
>> would also contribute to higher message rates?
>>
>>> I'll take a look at your code but it might be a while. If you can run our
>>> benchmark code I can be more helpful.
>>
>> I see you are using sudo in run-servers.sh to run your benchmark code.
>> What is sudo needed for so I can workaround what is needed? Don't have
>> sudo access on the cluster that I am running on.
>>
>>> --Anuj
>>>
>>>
>>> On Jan 26, 2018 11:44 AM, "Rohit Zambre" <rzambre-sXc7qaQca9o@public.gmane.org> wrote:
>>>
>>> On Wed, Jan 24, 2018 at 4:00 PM, Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>> IMO this is probably an implementation issue in the benchmarking code,
>>>> and I'm curious to know the issue if you find it.
>>>>
>>>> It's possible to achieve 150+ million writes per second with a
>>>> multi-threaded process. See Figure 12 in our paper:
>>>> http://www.cs.cmu.edu/~akalia/doc/atc16/rdma_bench_atc.pdf. Our
>>>> benchmark code is available:
>>>> https://github.com/efficient/rdma_bench/tree/master/rw-tput-sender.
>>>
>>> I read through your paper and code (great work!) but I don't think it
>>> is an implementation issue. I am comparing my numbers against Figure
>>> 12b of your paper since the CX3 cluster is the closest to my testbed
>>> which is a single-port ConnectX-4 card. Hugepages is the only
>>> optimization we use; we don't use doorbell batching, unsignaled
>>> completions, inlining, etc. However, the numbers are comparable: ~27M
>>> writes/second from our benchmark without your optimizations VS ~35M
>>> writes/second from your benchmark with all the optimizations. The 150M
>>> writes/s on the CIB cluster is on a dual-port card. More importantly,
>>> the ~35M writes/s on the CX3 cluster is >1.5x lower than the ~55M
>>> writes/s that we see with multi processes benchmark without
>>> optimizations.
>>>
>>>> --Anuj
>>>>
>>>> On Wed, Jan 24, 2018 at 3:53 PM, Rohit Zambre <rzambre-sXc7qaQca9o@public.gmane.org> wrote:
>>>>> On Wed, Jan 24, 2018 at 11:08 AM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
>>>>>> On Wed, Jan 24, 2018 at 10:22:53AM -0600, Rohit Zambre wrote:
>>>>>>
>>>>>>> (1) First, is this a surprising result or is the 2x difference
>>>>>>> actually expected behavior?
>>>>>>
>>>>>> Maybe, there are lots of locks in one process, for instance glibc's
>>>>>> malloc has locking - so any memory allocation anywhere in the
>>>>>> applications processing path will cause lock contention. The issue may
>>>>>> have nothing to do with RDMA.
>>>>>
>>>>> There are no mallocs in the critical path of the benchmark. In the 1
>>>>> process multi-threaded case, the mallocs for resource creation are all
>>>>> before creating the OpenMP parallel region. Here's a snapshot of the
>>>>> parallel region that contains the critical path:
>>>>>
>>>>> #pragma omp parallel
>>>>>         {
>>>>>             int i = omp_get_thread_num(), k;
>>>>>             int cqe_count = 0;
>>>>>             int post_count = 0;
>>>>>             int comp_count = 0;
>>>>>             int posts = 0;
>>>>>
>>>>>             struct ibv_send_wr *bad_send_wqe;
>>>>>             struct ibv_wc *WC = (struct ibv_wc*) malloc(qp_depth *
>>>>> sizeof(struct ibv_wc) ); // qp_depth is 128 (adopted from perftest)
>>>>>
>>>>>             #pragma omp single
>>>>>             { // only one thread will execute this
>>>>>                 MPI_Barrier(MPI_COMM_WORLD);
>>>>>             } // implicit barrier for the threads
>>>>>             if (i == 0)
>>>>>                 t_start = MPI_Wtime();
>>>>>
>>>>>             /* Critical Path Start */
>>>>>             while (post_count < posts_per_qp || comp_count <
>>>>> posts_per_qp) { // posts_per_qp = num_of_msgs / num_qps
>>>>>                 /* Post */
>>>>>                 posts = min( (posts_per_qp - post_count), (qp_depth -
>>>>> (post_count - comp_count) ) );
>>>>>                 for (k = 0; k < posts; k++)
>>>>>                     ret = ibv_post_send(qp[i], &send_wqe[i],
>>>>> &bad_send_wqe);
>>>>>                 post_count += posts;
>>>>>                 /* Poll */
>>>>>                 if (comp_count < posts_per_qp) {
>>>>>                      cqe_count = ibv_poll_cq(cq[i], num_comps, WC); //
>>>>> num_comps = qp_depth
>>>>>                      comp_count += cqe_count;
>>>>>                  }
>>>>>              } /* Critical Path End */
>>>>>              if (i == 0)
>>>>>                  t_end = MPI_Wtime();
>>>>>          }
>>>>>
>>>>>> There is also some locking inside the userspace mlx5 driver that may
>>>>>> contend depending on how your process has set things up.
>>>>>
>>>>> I missed mentioning this but I collected the numbers with
>>>>> MLX5_SINGLE_THREADED set since none of the resources were being shared
>>>>> between the threads. So, the userspace driver wasn't taking any locks.
>>>>>
>>>>>> The entire send path is in user space so there is no kernel component
>>>>>> here.
>>>>>
>>>>> Yes, that's correct. My concern was that during resource creation, the
>>>>> kernel was maybe sharing some resource for a process or that some sort
>>>>> of multiplexing was occurring to hardware contexts through control
>>>>> groups. Is it safe for me to conclude that separate, independent
>>>>> contexts/bfregs are being assigned when a process calls
>>>>> ibv_open_device multiple times?
>>>>>
>>>>>> Jason
>>>>>
>>>>> Thanks,
>>>>> Rohit Zambre
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
