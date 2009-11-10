From: Pradeep Satyanarayana <pradeeps-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH RDMA] Fixup IPv6 support and IPv4 routing corner cases
 for RDMA CM
Date: Tue, 10 Nov 2009 13:05:37 -0800
Message-ID: <4AF9D5A1.6030309@linux.vnet.ibm.com>
References: <20091028054253.GA22882@obsidianresearch.com> <1256846162.12957.27.camel@wilder.ibm.com> <20091029202106.GF1966@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091029202106.GF1966-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> On Thu, Oct 29, 2009 at 12:56:01PM -0700, David J. Wilder wrote:
>> On Tue, 2009-10-27 at 23:42 -0600, Jason Gunthorpe wrote:
>>
>>> I left the network namespace stuff alone and kept with the init_net
>>> situation..
>> Another possible solution ;)
>>
>>  if (rt->idev->dev->flags & IFF_LOOPBACK){
> 
> Oh! That is probbly much better
> 
>>> -static int addr_resolve_remote(struct sockaddr *src_in,
>>> -				struct sockaddr *dst_in,
>>> -				struct rdma_dev_addr *addr)
>>> +static int addr_resolve(struct sockaddr *src_in,
>>> +			struct sockaddr *dst_in,
>>> +			struct rdma_dev_addr *addr)
>>>  {
>> A problem here, if a source address has not been specified then this
>> test is invalid.  I had to change it to use dst_in->sa_family. But as
>> you said, we should have validated sa_family before this point.    
> 
> Yes, that should have been dst, dst is not optional, src is at this
> point.
> 
> The sa_family validation of src should only be to check that if it is
> specified it is is the same..

Sean,

I know Jason and David came up with different sets of patches. Is it possible that
we can come to some agreement, so that this can be pushed to OFED-1.5? 

I am concerned that if we miss the OFED-1.5 boat, this feature (IPv6 support for RDMA CM)
may be available in the various distributions only in late 2010 or maybe even 2011.

We got side tracked with some higher priority stuff, but now should be able to help
with patches and testing them too. How can we make progress? What are your thoughts?

Pradeep


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
