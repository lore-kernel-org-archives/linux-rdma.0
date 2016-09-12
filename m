From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: RFC: CQ pools and implicit CQ resource allocation
Date: Mon, 12 Sep 2016 11:03:43 -0400
Message-ID: <BCF7E723-FC50-4497-9E0B-1157CF2D4185@oracle.com>
References: <1473424587-13818-1-git-send-email-hch@lst.de> <d0c645eb-3674-2841-bdb7-8b9e6fd46473@grimberg.me>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d0c645eb-3674-2841-bdb7-8b9e6fd46473-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> On Sep 11, 2016, at 2:44 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> 
> 
>> This series adds support to the RDMA core to implicitly allocate the required
>> CQEs when creating a QP.  The primary driver for that was to implement a
>> common scheme for CQ pooling, which helps with better resource usage for
>> server / target style drivers that have many outstanding connections.  In
>> fact the first version of this code from Sagi did just that: add a CQ pool
>> API, and convert drivers that were using some form of pooling (iSER initiator
>> & target, NVMe target) to that API.  But looking at the API I felt that
>> there was still way too much logic in the individual ULPs, and looked into a
>> way to make that boilerplate code go away.  It turns out that we can simply
>> create CQs underneath if we know the poll context that the ULP requires, so
>> this series shows an approach that makes CQs mostly invisible to ULPs.
> 
> One other note that I wanted to raise for the folks interested in this
> is that with the RDMA core owning the completion queue pools, different
> ULPs can easily share the same completion queue (given that it uses
> the same poll context). For example, nvme-rdma host, iser and srp
> initiators can end up using the same completion queues (if running
> simultaneously on the same machine).

I've browsed the patches a little. Do you have a sense of how much
lock / memory contention this sharing scheme introduces on multi-socket
machines using multiple protocols and multiple QPs?

Would it make sense for a ULP to indicate that it wants an unshared set
of resources?


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
