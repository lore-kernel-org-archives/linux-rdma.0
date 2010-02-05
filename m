From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: bug 1918 - openmpi broken due to rdma-cm changes
Date: Fri, 05 Feb 2010 15:53:45 -0600
Message-ID: <4B6C9369.1070208@opengridcomputing.com>
References: <ada4olvefl4.fsf@roland-alpha.cisco.com> <324EFA68-12F6-46E9-B876-7F4847B53224@cisco.com> <4B6C6453.9090706@opengridcomputing.com> <20100205185616.GS16490@obsidianresearch.com> <E8FF8BD1-80AC-4AA7-BC2A-CE7547FB9ABA@cisco.com> <20100205211455.GT16490@obsidianresearch.com> <697C6107-13A9-48E3-B451-02529305100D@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <697C6107-13A9-48E3-B451-02529305100D-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Jeff Squyres wrote:
> On Feb 5, 2010, at 4:14 PM, Jason Gunthorpe wrote:
>
>   
>> Well, I think you are right. This kind of change seems appropriate to
>> me for mainline, but OFED/RHEL should carry a responsibility to manage
>> an identified incompatibility, either patch their kernel, patch their
>> OMPI, or publish an errata. That is the role of a distribution.
>>     
>
> RHEL has said, multiple times, that they rely on OpenFabrics to do the Right Thing.  They don't do a lot of testing, validating, etc.
>
>   
>> Sounds like this is taken care for now anyhow, Sean's patch to remove
>> it for iwarp since it doesn't work today with any iwarp drivers does
>> obscure the problem.. But it does seem like rdma_cm mode for IB
>> networks will still be broken in OMPI with the new kernels.
>>     
>
> Correct.
>
> So why not back off putting this in the kernel that's coming out now now now?  Why not put it in *next* kernel?  (or even better, the one after that)
>
> Is there a rush / need to have this in *now*?
>
>   

There is still some inconsistency here.   Sean, you claimed binds to 
127.0.0.1 succeed in ofed-1.4 for IB devices.  If so, then folks running 
IB/openmpi/rdmacm should be seeing issues.  We need to dig a little more...


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
