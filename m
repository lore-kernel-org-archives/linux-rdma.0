From: Tom Talpey <tom@talpey.com>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Thu, 7 Feb 2019 10:28:05 -0500
Message-ID: <6b260348-966a-bc95-162b-44ae8265cf03@talpey.com>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
 <20190206095000.GA12006@quack2.suse.cz> <20190206173114.GB12227@ziepe.ca>
 <20190206175233.GN21860@bombadil.infradead.org>
 <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
 <20190206210356.GZ6173@dastard> <20190206220828.GJ12227@ziepe.ca>
 <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
 <20190207035258.GD6173@dastard> <20190207052310.GA22726@ziepe.ca>
 <CC414509-F046-49E3-9D0C-F66FD488AC64@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CC414509-F046-49E3-9D0C-F66FD488AC64@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Chuck Lever <chuck.lever@oracle.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dave Chinner <david@fromorbit.com>, Doug Ledford <dledford@redhat.com>, Christopher Lameter <cl@linux.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Ira Weiny <ira.weiny@intel.com>, lsf-pc@lists.linux-foundation.org, linux-rdma <linux-rdma@vger.kernel.org>, linux-mm@kvack.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Michal Hocko <mhocko@kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 2/7/2019 10:04 AM, Chuck Lever wrote:
> 
> 
>> On Feb 7, 2019, at 12:23 AM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>>
>> On Thu, Feb 07, 2019 at 02:52:58PM +1100, Dave Chinner wrote:
>>
>>> Requiring ODP capable hardware and applications that control RDMA
>>> access to use file leases and be able to cancel/recall client side
>>> delegations (like NFS is already able to do!) seems like a pretty
>>
>> So, what happens on NFS if the revoke takes too long?
> 
> NFS distinguishes between "recall" and "revoke". Dave used "recall"
> here, it means that the server recalls the client's delegation. If
> the client doesn't respond, the server revokes the delegation
> unilaterally and other users are allowed to proceed.

The SMB3 protocol has a similar "lease break" mechanism, btw.

SMB3 "push mode" has long-expected to allow DAX mapping of files
only when an exclusive lease is held by the requesting client.
The server may recall the lease if the DAX mapping needs to change.

Once local (MMU) and remote (RDMA) mappings are dropped, the
client may re-request that the server reestablish them. No
connection or process is terminated, and no data is silently lost.

Tom.
