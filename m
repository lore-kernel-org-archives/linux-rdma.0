From: "brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Fwd: Re: [PATCH] libibmad: Fixes for failures when not all ports
 of HCA are connected]
Date: Tue, 26 Mar 2013 23:22:36 +0000
Message-ID: <51522DBC.8070101@oracle.com>
References: <20130320222422.GA30100@obsidianresearch.com> <514A3BDF.2090105@oracle.com> <20130320231923.GA32300@obsidianresearch.com> <514A5C07.3080308@oracle.com> <20130321052122.GB20882@obsidianresearch.com> <514B6F74.9020707@oracle.com> <20130321212703.GA8431@obsidianresearch.com> <2807E5FD2F6FDA4886F6618EAC48510EBB4AF5@CRSMSX102.amr.corp.intel.com> <20130321220751.GG8431@obsidianresearch.com> <2807E5FD2F6FDA4886F6618EAC48510EBB4B49@CRSMSX102.amr.corp.intel.com> <20130321225018.GA9749@obsidianresearch.com> <2807E5FD2F6FDA4886F6618EAC48510EBB4B7E@CRSMSX102.amr.corp.intel.com> <514B9215.2000106@oracle.com> <2807E5FD2F6FDA4886F6618EAC48510EBB4BBF@CRSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510EBB4BBF-8k97q/ur5Z1cIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pramod Gunjikar <pramod.gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

OK Got home safely, thanks, made some changes, I've ask Boris to pick 
these up,
rebuild the patch, test and resubmit, so expect something later in the week.


On 03/21/13 11:06 PM, Weiny, Ira wrote:
>> -----Original Message-----
>> From: brendan doyle [mailto:brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
>>
>>
>> On 21/03/2013 22:53, Weiny, Ira wrote:
>>>> -----Original Message-----
>>>> From: Jason Gunthorpe [mailto:jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org]
>>>>
>>>> On Thu, Mar 21, 2013 at 10:46:06PM +0000, Weiny, Ira wrote:
>>>>
>>>>> have to follow different idioms.  However having 2 or 3 in the same
>>>>> library is even worse!!!
>>>> Agreed, I think you made a compelling case that the new POSIX method
>>>> is not appropriate for this library, so standardizing on the old
>>>> method is the least bad option..
>>>>
>>> Wait what did I do?
>>>
>>> You think using errno is the "right" thing to do now?
>> I agree that it is the least bad option, I don't want to fix the int return APIs, as
>> I think that will break infiniband-diags and who knows what else, and as you
>> say we then end up with two or 3 idioms within the same library. I think it's
>> too much of a stretch, at least for me to go redo the whole lib, so the best we
>> can do is at least be consistent.
>>
>> I'm going to be traveling shortly I'll take another look at the patch next week.
>>
> Sounds good, travel safe,
> Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
