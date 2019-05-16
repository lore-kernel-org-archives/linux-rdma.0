From: Kamal Heib <kheib@redhat.com>
Subject: Re: CFP: 4th RDMA Mini-Summit at LPC 2019
Date: Thu, 16 May 2019 10:08:32 +0300
Message-ID: <df639315-e13c-9a20-caf5-a66b009a8aa1@redhat.com>
References: <20190514122321.GH6425@mtr-leonro.mtl.com>
 <20190515153050.GB2356@lap1> <20190515163626.GO5225@mtr-leonro.mtl.com>
 <20190515181537.GA5720@lap1>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190515181537.GA5720@lap1>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Yuval Shaia <yuval.shaia@oracle.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, linux-netdev <netdev@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
List-Id: linux-rdma@vger.kernel.org



On 5/15/19 9:15 PM, Yuval Shaia wrote:
> On Wed, May 15, 2019 at 07:36:26PM +0300, Leon Romanovsky wrote:
>> On Wed, May 15, 2019 at 06:30:51PM +0300, Yuval Shaia wrote:
>>> On Tue, May 14, 2019 at 03:23:21PM +0300, Leon Romanovsky wrote:
>>>> This is a call for proposals for the 4th RDMA mini-summit at the Linux
>>>> Plumbers Conference in Lisbon, Portugal, which will be happening on
>>>> September 9-11h, 2019.
>>>>
>>>> We are looking for topics with focus on active audience discussions
>>>> and problem solving. The preferable topic is up to 30 minutes with
>>>> 3-5 slides maximum.
>>>
>>> Abstract: Expand the virtio portfolio with RDMA
>>>
>>> Description:
>>> Data center backends use more and more RDMA or RoCE devices and more and
>>> more software runs in virtualized environment.
>>> There is a need for a standard to enable RDMA/RoCE on Virtual Machines.
>>> Virtio is the optimal solution since is the de-facto para-virtualizaton
>>> technology and also because the Virtio specification allows Hardware
>>> Vendors to support Virtio protocol natively in order to achieve bare metal
>>> performance.
>>> This talk addresses challenges in defining the RDMA/RoCE Virtio
>>> Specification and a look forward on possible implementation techniques.
>>
>> Yuval,
>>
>> Who is going to implement it?
>>
>> Thanks
> 
> It is going to be an open source effort by an open source contributors.
> Probably as with qemu-pvrdma it would be me and Marcel and i have an
> unofficial approval from extra person that gave promise to join (can't say
> his name but since he is also on this list then he welcome to raise a
> hand).

That person is me.
Leon: Is Mellanox willing to join too?

> I also recall once someone from Mellanox wanted to join but not sure about
> his availability now.
> 
>>
>>>
>>>>
>>>> This year, the LPC will include netdev track too and it is
>>>> collocated with Kernel Summit, such timing makes an excellent
>>>> opportunity to drive cross-tree solutions.
>>>>
>>>> BTW, RDMA is not accepted yet as a track in LPC, but let's think
>>>> positive and start collect topics.
>>>>
>>>> Thanks
