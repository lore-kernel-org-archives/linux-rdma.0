From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: RFC: CQ pools and implicit CQ resource allocation
Date: Wed, 14 Sep 2016 05:29:14 +0200
Message-ID: <ad6a3f58-cf55-2cb0-b716-222654de8e28@acm.org>
References: <1473424587-13818-1-git-send-email-hch@lst.de>
 <d0c645eb-3674-2841-bdb7-8b9e6fd46473@grimberg.me>
 <00e001d20d03$ea891100$bf9b3300$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00e001d20d03$ea891100$bf9b3300$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 09/12/2016 04:42 PM, Steve Wise wrote:
> One concern I have is that cxgb4 CQs require contiguous memory,  So a scheme
> like CQ pooling might cause resource problems on large core systems.

Hello Steve,

Had you already noticed the following code in the first patch of this 
series? I think this code guarantees that never more than 
dev->num_comp_vectors CQs are allocated at once:

     nr_cqs = min_t(int, dev->num_comp_vectors, num_possible_cpus())

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
