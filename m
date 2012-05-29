From: =?iso-8859-1?Q?=22Xavier_R=2E_Gu=E9rin=22?= <guerinx-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: HCA concurrency
Date: Tue, 29 May 2012 14:02:17 -0400
Message-ID: <117D8742-93E9-4877-AEF3-6440888317E3@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi List,

I am running some test cases to assess operation concurrency with Infiniband, meaning how many actual outstanding operations my HCA (ConnectX-3 QDR) can handle.

In my test case to evaluate fetch-and-add, I spawn multiple threads, each owning its own QP inside the same PD and context and sending fetch-and-add requests without any inner contention (no lock, etc.). I quickly reach a ceiling of about 900KOPS with 5/6 threads, and I have a hard time figuring out why.

In addition, the latency linearly increases with the # of threads after 4 threads, which leads me to believe that the actual number of concurrent operation of my setup is 4, which seems a little low.

So, questions :) : 

- I played with the # of local and remote resources for atomic operations in my QPs, without success. Is there any knob to tune on the QP/EEC side?
- I am using a single remote MR: can this be a blocking factor (eg. if the remote fencing is done at the MR granularity)?

Im a more general sense, is there any good information source summarizing such concurrency performance for IB HCAs ?

Thanks for your help,
Xavier--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
