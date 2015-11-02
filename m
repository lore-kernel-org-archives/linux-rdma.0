From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] RDMA verbs transport design notes
Date: Mon, 2 Nov 2015 11:34:32 -0500
Message-ID: <20151102163431.GA15228@phlsvsds.ph.intel.com>
References: <20151029194129.GE26235@phlsvsds.ph.intel.com> <CAG9sBKOEs_u-YVTwS=Gk2sxRCqV+Wsdh1PyNy+baf3EBSCSbTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKOEs_u-YVTwS=Gk2sxRCqV+Wsdh1PyNy+baf3EBSCSbTA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 02, 2015 at 03:46:52PM +0200, Moni Shoua wrote:
>> get_lid()
>>         Provides the LID
>>
>LID is a special case of L2 address (MAC is another special case)
>Maybe change this to het_l2()?

I'm not particularly tied to the name, we can certainly change it to 
something else. I assume that's a typo and should be "get_l2()"?

>> qp_mtu()
>>         Using the SL determines the MTU (this varies per VL in OPA)
>>
>Again, this is too tied to the InfiniBand protocol.
>Also, It doesn't make sense to me that a driver won't know how to
>create a QP (this is done by the rvt) but will know how to answer
>about QP mtu. Does it?

Perhaps that should have been written as "validate_mtu()", to take the user 
supplied MTU and ensure that it is valid. Keep in mind that OPA can have an 
MTU that varies across VLs. For those drivers which do not support this the 
function basically becomes a no-op.

>> flush_qp()
>>         Flush out all pending operations for a QP that have not made it the
>> wire, and wait for that flush to finish.
>Again, needs generalization

Sure, we can work on that.

>> do_send()
>>         Take a fully constructed packet and place on the wire
>>
>The hardest operation of all IMO.
>Should  be efficient but yet general

We are on the same page here.

>> Next steps
>> ----------
>> We will continue posting code to GitHub [2] while we field feedback. Note
>> the repo has been moved from my previous announcement [1]. I have placed it
>> under my GitHub. Once there is more significant development and folks are
>> generally happy with the design we will begin posting to this mailing list
>> (linux-rdma).
>What's the minimal progress in the rvt and the drivers before you
>think it's ready for posting to the list?

I don't think we have a hard set minimal state before we are ready to post 
to the list. Let's see how things shape up over the next couple of weeks and 
if we as a community like the direction of the code and think its ready to 
post we can surely do so.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
